import os
import graphviz as gv

class subRuleHelper():
    def __init__(self,file_name):
        self.subRules = []
        self.file_name = file_name

    def is_candidate(self,node):
        '''
            Checks whether or not given node is a candidate for        
        '''
        if 'if' in node.head.properties['name'] :
            return True
        return False
    
    def _check_branch_mergable(self,node,safe,unsafe):
        temp = node
        while temp != None:
            x = len(safe.intersection(temp.head.properties['name']))
            y = len(unsafe.intersection(temp.head.properties['name']))
            if x>0:
                return True
            if y>0:
                return False
            if len(temp.children) > 1 or len(temp.parent) > 1:
                return False
            temp,_ = temp.children[0]
        return

    def is_mergable(self,node):
        '''
            To check whether it is safe to merge, from given node or not
        '''

        # ALERT: NEED TO INCREASE THE SAFE AND UNSAFE DEFINITIONS, TO MAKE IT COMPLETE 
        unsafe = {'perform','evaluate','if','when','paragraphName'}
        safe = {'goto','end-if'}

        # Iterate over both true and the false branch and see if it is falling in safe
        flag = True
        for child,_ in node.children:
            flag = flag and self._check_branch_mergable(child,safe,unsafe)
        return flag
    
    def make_subrule(self,node):
        '''
            This method merges all the possible, rules.
        '''
        print("subrule :: {}".format(node.head.value))
        self.subRules.append(node)
        node.head.properties['name'].add('rule')
        lchild = node.children[0]
        rchild = node.children[1]
        node.children = []
        visited = [node]
        for curr,_ in [lchild,rchild]:
            prev = node
            while True:
                x = curr.head.properties['name'].intersection({'goto','end-if'})
                prev.head.properties['children'].append((curr.head,_))
                curr.head.properties['parents'].append(prev.head)
                node.primarySet = node.primarySet.union(curr.primarySet)
                node.secondarySet = node.secondarySet.union(curr.secondarySet)
                node.head.properties['name'] = node.head.properties['name'].union(curr.head.properties['name'])
                node.properties['source_variables'] = node.properties['source_variables'].union(curr.properties['source_variables'])
                node.properties['target_variables'] = node.properties['target_variables'].union(curr.properties['target_variables'])
                node.properties['conditional_variables'] = node.properties['conditional_variables'].union(curr.properties['conditional_variables'])
                if len(x) > 0:
                    # It involves either go to or end-if
                    if curr not in visited:
                        node.children = node.children + curr.children
                        visited.append(curr)
                        for child,l in curr.children:
                            child.parent.remove(curr)
                            child.parent.append(node)
                            node.properties['child_to_head'][child] = curr.head
                    break
                else:
                    # It is a part of the unit nows
                    prev = curr
                    visited.append(curr)
                    curr,_ = curr.children[0]

    def _get_graph(self,node,visited,graph):
        if node in visited:
            return
        visited.append(node)
        graph.node(name=str(node),label=node.value)
        for child,label in node.properties['children']:
            self._get_graph(child,visited,graph)
            graph.edge(str(node),str(child),label=label)
        return

    def get_graph_sub_rules(self):
        for i in range(len(self.subRules)):
            path = 'output/COBOL_{}/subRules/sr_{}'.format(self.file_name,i+1)
            name = 'cluster'+str(i)
            graph = gv.Digraph(name=name,format='pdf')
            self._get_graph(self.subRules[i].head,[],graph)
            graph.render(path)
        return