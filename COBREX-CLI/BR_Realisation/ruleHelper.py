"""
    This class contains all the rules that are to be checked for merging both sequential and nested.
"""

import os
import graphviz as gv

class ruleHelper():
    def __init__(self,file_name):
        self.rules = []
        self.file_name = file_name

    def if_mergable_both_goto(self,left,right,parent):
        '''
            Here the rule will come when both the L and R child are gotos
        '''
        return True
    
    def if_mergable_one_goto(self,withGoto,withoutGoto,parent):
        '''
            Rule to check merging when one is mergable and other is not
        '''
        X = parent.secondarySet
        Y = withoutGoto.secondarySet
        if len(X)>0 and len(Y)>0:
            return not X.isdisjoint(Y)
        return True
    
    def if_mergable_none_goto(self,left,right,parent):
        '''
            Rule to check if mergable in case none of them are encountering goto
        '''
        X = left.primarySet
        Y = right.primarySet
        P = left.secondarySet
        Q = right.secondarySet
        if (X.isdisjoint(Y) and len(Y)>0 and len(X)>0) or (P.isdisjoint(Q) and len(P)>0 and len(Q)>0):
            return False
        return True
    
    def merge_both_goto(self,node,left,right):
        print("Both goto rule :: ",node.head.value)
        
        if left in self.rules:
            self.rules.remove(left)
        if right in self.rules:
            self.rules.remove(right)
        
        node.children = []
        
        node.head.properties['children'].append((left[0].head,left[1]))
        left[0].head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(left[0].head.properties['name'])
        for child,_ in left[0].children:
            node.children.append((child,_))
            child.parent.remove(left[0])
            child.parent.append(node)
            try:
                node.properties['child_to_head'][child] = left[0].properties['child_to_head'][child]
            except:
                node.properties['child_to_head'][child] = left[0].head
        
        node.head.properties['children'].append((right[0].head,right[1]))
        right[0].head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(right[0].head.properties['name'])
        for child,_ in right[0].children:
            node.children.append((child,_))
            child.parent.remove(right[0])
            child.parent.append(node)
            try:
                node.properties['child_to_head'][child] = right[0].properties['child_to_head'][child]
            except:
                node.properties['child_to_head'][child] = right[0].head
        
        node.primarySet = node.primarySet.union(left[0].primarySet)
        node.secondarySet = node.secondarySet.union(left[0].secondarySet)
        node.primarySet = node.primarySet.union(right[0].primarySet)
        node.secondarySet = node.secondarySet.union(right[0].secondarySet)
        
        node.properties['source_variables'] = node.properties['source_variables'].union(left[0].properties['source_variables'])        
        node.properties['target_variables'] = node.properties['target_variables'].union(left[0].properties['target_variables'])        
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(left[0].properties['conditional_variables'])
        node.properties['source_variables'] = node.properties['source_variables'].union(right[0].properties['source_variables'])
        node.properties['target_variables'] = node.properties['target_variables'].union(right[0].properties['target_variables'])
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(right[0].properties['conditional_variables'])
        
        self.rules.append(node)
        node.head.properties['name'].add('rule')
        
        l,r = left[0],right[0]
        del l
        del r

    def merge_one_goto(self,node,withGoto,withoutGoto):
        print("One Goto rule :: ",node.head.value)

        if withGoto in self.rules:
            self.rules.remove(withGoto)
        if withoutGoto in self.rules:
            self.rules.remove(withoutGoto)

        node.children = []
        withGoto,_ = withGoto
        withoutGoto,__ = withoutGoto

        node.head.properties['children'].append((withGoto.head,_))
        withGoto.head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(withGoto.head.properties['name'])
        for child in withGoto.children:
            node.children.append(child)
            child[0].parent.remove(withGoto)
            child[0].parent.append(node)
            try:
                node.properties['child_to_head'][child] = withGoto.properties['child_to_head'][child]
            except:
                node.properties['child_to_head'][child] = withGoto.head

        node.head.properties['children'].append((withoutGoto.head,__))
        withoutGoto.head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(withoutGoto.head.properties['name'])

        # Adding End-if in it
        leaf = getLeaf(withoutGoto.head)
        leaf.properties['children'].append((withoutGoto.children[0][0].head,withoutGoto.children[0][1]))
        withoutGoto.children[0][0].head.properties['parents'].append(leaf)

        # Pushing End-if's child as one of it's children
        node.children.append(withoutGoto.children[0][0].children[0])
        withoutGoto.children[0][0].children[0][0].parent.remove(withoutGoto.children[0][0])
        withoutGoto.children[0][0].children[0][0].parent.append(node)
        node.properties['child_to_head'][withoutGoto.children[0][0].children[0][0]] = withoutGoto.children[0][0].head

        node.primarySet = node.primarySet.union(withGoto.primarySet)
        node.secondarySet = node.secondarySet.union(withGoto.secondarySet)
        node.primarySet = node.primarySet.union(withoutGoto.primarySet)
        node.secondarySet = node.secondarySet.union(withoutGoto.secondarySet)

        node.properties['source_variables'] = node.properties['source_variables'].union(withGoto.properties['source_variables'])        
        node.properties['target_variables'] = node.properties['target_variables'].union(withGoto.properties['target_variables'])        
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(withGoto.properties['conditional_variables'])
        node.properties['source_variables'] = node.properties['source_variables'].union(withoutGoto.properties['source_variables'])
        node.properties['target_variables'] = node.properties['target_variables'].union(withoutGoto.properties['target_variables'])
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(withoutGoto.properties['conditional_variables'])

        self.rules.append(node)
        node.head.properties['name'].add('rule')

    def merge_none_goto(self,node,left,right):
        
        print("None Goto rule :: ",node.head.value)
        
        left,l1 = left
        right,r1 = right
        
        if left in self.rules:
            self.rules.remove(left)
        if right in self.rules:
            self.rules.remove(right)
        
        node.children = []
        
        node.head.properties['children'].append((left.head,l1))
        left.head.properties['parents'].append(node.head)
        node.head.properties['name'] =  node.head.properties['name'].union(left.head.properties['name'])
        
        node.head.properties['children'].append((right.head,r1))
        right.head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(right.head.properties['name'])
        
        leaf = getLeaf(left.head)
        leaf.properties['children'].append((left.children[0][0].head,left.children[0][1]))
        left.children[0][0].head.properties['parents'].append(leaf)
        
        node.children = left.children[0][0].children
        node.properties['child_to_head'][left.children[0][0].children[0][0]] = left.children[0][0].head
        
        node.primarySet = node.primarySet.union(left.primarySet)
        node.secondarySet = node.secondarySet.union(left.secondarySet)
        node.primarySet = node.primarySet.union(right.primarySet)
        node.secondarySet = node.secondarySet.union(right.secondarySet)
        
        node.properties['source_variables'] = node.properties['source_variables'].union(left.properties['source_variables'])        
        node.properties['target_variables'] = node.properties['target_variables'].union(left.properties['target_variables'])        
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(left.properties['conditional_variables'])
        node.properties['source_variables'] = node.properties['source_variables'].union(right.properties['source_variables'])
        node.properties['target_variables'] = node.properties['target_variables'].union(right.properties['target_variables'])
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(right.properties['conditional_variables'])

        self.rules.append(node)
        node.head.properties['name'].add('rule')

    def merge_simple_if(self,node,withRule,outChild):
        print('simple-if rule :: ',node.head.value)

        if withRule in self.rules:
            self.rules.remove(withRule)

        node.children = []

        node.head.properties['children'].append((withRule[0].head,withRule[1]))
        withRule[0].head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(withRule[0].head.properties['name'])
        for child,_ in withRule[0].children:
            if child != outChild[0]:
                node.children.append((child,_))
                child.parent.remove(withRule[0])
                child.parent.append(node)
                try:
                    node.properties['child_to_head'][child] = withRule[0].properties['child_to_head'][child]
                except:
                    node.properties['child_to_head'][child] = withRule[0].head

        node.head.properties['children'].append((outChild[0].head,outChild[1]))
        outChild[0].head.properties['parents'].append(node.head)
        node.head.properties['name'] = node.head.properties['name'].union(outChild[0].head.properties['name'])
        for child,_ in outChild[0].children:
            node.children.append((child,_))
            child.parent.remove(outChild[0])
            child.parent.append(node)
            try:
                node.properties['child_to_head'][child] = outChild[0].properties['child_to_head'][child]
            except:
                node.properties['child_to_head'][child] = outChild[0].head

        node.primarySet = node.primarySet.union(withRule[0].primarySet)
        node.secondarySet = node.secondarySet.union(withRule[0].secondarySet)

        node.properties['source_variables'] = node.properties['source_variables'].union(withRule[0].properties['source_variables'])
        node.properties['target_variables'] = node.properties['target_variables'].union(withRule[0].properties['target_variables'])
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(withRule[0].properties['conditional_variables'])

        self.rules.append(node)
        node.head.properties['name'].add('rule')

    def _get_graph(self,node,visited,graph):
        if node in visited:
            return
        visited.append(node)
        graph.node(name=str(node),label=node.value)
        for child,label in node.properties['children']:
            self._get_graph(child,visited,graph)
            graph.edge(str(node),str(child),label=label)

    def get_graph_rules(self):
        for i in range(len(self.rules)):
            path = 'output/COBOL_{}/Rules/Rule_{}'.format(self.file_name,i+1)
            name = 'cluster'+str(i)
            graph = gv.Digraph(name=name,format='pdf')
            self._get_graph(self.rules[i].head,[],graph)
            graph.render(path)
    
    def can_form_rule(self,node):
        '''
            This method shall tell you if the given rules can be merged or not.
            At this point we have taken some assumptions:
                - It would merge if the L_rule and R_rule are after one sub-rule box leading to either end-if or is a ctrl jump
            Also it should follow the set rule
        '''
        l_rule = node.children[0]
        r_rule = node.children[1]

        # Simple if statements have to be dealt in a completely separate manner
        if l_rule[0].head.properties['name'] == set(['end-if']):
            if self.if_mergable_one_goto(l_rule[0],r_rule[0],node):
                self.merge_simple_if(node,r_rule,l_rule)
                return True
            else:
                return False
        elif r_rule[0].head.properties['name'] == set(['end-if']):
            if self.if_mergable_one_goto(r_rule[0],l_rule[0],node):
                self.merge_simple_if(node,l_rule,r_rule)
                return True
            else:
                return False        

        # These are the cases that shall cover else-if ladder and normal if-else statemtent
        if "goto" in l_rule[0].head.properties['name'] and "goto" in r_rule[0].head.properties['name']:
            if self.if_mergable_both_goto(l_rule[0],r_rule[0],node):
                self.merge_both_goto(node,l_rule,r_rule)
                return True
        elif "end-if" in l_rule[0].children[0][0].head.properties['name'] and "goto" in r_rule[0].head.properties['name']:
            # Left is encountering end-if while right is a goto, so check with the rule 2
            if self.if_mergable_one_goto(r_rule[0],l_rule[0],node):
                self.merge_one_goto(node,r_rule,l_rule)
                return True
        elif "end-if" in r_rule[0].children[0][0].head.properties['name'] and "goto" in l_rule[0].head.properties['name']:
            # Right is encountering an end-if while left is a goto so check with rule 2
            if self.if_mergable_one_goto(l_rule[0],r_rule[0],node):
                self.merge_one_goto(node,l_rule,r_rule)
                return True
        elif "end-if" in r_rule[0].children[0][0].head.properties['name'] and len(r_rule[0].children) == 1 and "end-if" in l_rule[0].children[0][0].head.properties['name'] and len(l_rule[0].children) == 1:
            # Both the sub-rules are encountering end-if so apply the rule1
            if self.if_mergable_none_goto(l_rule[0],r_rule[0],node):
                self.merge_none_goto(node,l_rule,r_rule)
                return True
        return False
        
    def is_candidate_rule_merge(self,node):
        '''
            Checks whether or not given node is a candidate for merging as a rule. 
        '''
        if 'if' in node.head.properties['name'] and 'rule' not in node.head.properties['name']:
            return True
        return False
    
    def is_candidate_rule_merge_when(self,node):
        '''
            Checks whether or not given node is a candidate for merging as a rule. 
        '''
        if 'evaluate' in node.head.properties['name'] and 'ruled' not in node.head.properties['name']:
            return True
        return False
    
    def is_candidate_perform_merge(self,node,visited):
        if len(node.children) == 0 or (len(node.children)!=0 and node.children[0][0] in visited) or 'rule' in node.head.properties['name']:
            return False
        child,_ = node.children[0]
        if _ != "iteration" and len(node.children) > 1:
            child,_ = node.children[1]
        p_safe = set(['perform'])
        if node.head.properties['name'].issubset(p_safe) and _ == "iteration":
            while child != node:
                if len(set(child.children))>1 or len(child.children) == 0:
                    return False
                child,_ = child.children[0]
            return True
        return False
    
    def perform_loop_merge(self,node):
        print("Loop rule :: ",node.head.value)

        child,_ = node.children[0]
        if _ != "iteration":
            child,_ = node.children[1]
        
        self.rules.append(node)
        node.head.properties['name'].add('rule')
        
        prev = node.head.properties['children']
        
        while child != node:
            
            if child in self.rules:
                self.rules.remove(child)
            
            node.children.remove((child,_))
            
            for ch in child.children:
                node.children.append((ch[0],ch[1]))
                ch[0].parent.remove(child)
                ch[0].parent.append(node)
                try:
                    node.properties['child_to_head'][ch[0]] = child.properties['child_to_head'][ch[0]]
                except:
                    node.properties['child_to_head'][ch[0]] = child.head

            prev.append((child.head,_))
            child.head.properties['parents'].append(node.head)

            node.head.properties['name'] = node.head.properties['name'].union(child.head.properties['name'])

            node.primarySet = node.primarySet.union(child.primarySet)
            node.secondarySet = node.secondarySet.union(child.secondarySet)
            
            node.properties['source_variables'] = node.properties['source_variables'].union(child.properties['source_variables'])        
            node.properties['target_variables'] = node.properties['target_variables'].union(child.properties['target_variables'])        
            node.properties['conditional_variables'] = node.properties['conditional_variables'].union(child.properties['conditional_variables'])
            
            # prev = getLeaf(prev[0][0]).properties['children']
            prev = node.properties['child_to_head'][child.children[0][0]].properties['children']
            
            if child.children[0][0] == node:
                prev.append((node.head,child.children[0][1]))
                node.children.remove((node,child.children[0][1]))
                if node in node.parent:
                    node.parent.remove(node)
            child,_ = child.children[0]
        return True

    def _check_multiple_branching_(self,node):
        for child,_ in node.children:
            child = child.children[0][0]
            # We need to see that every child should have exactly one children
            while child.head.value != 'END-EVALUATE':
                if len(child.children) != 1:
                    return True
                child = child.children[0][0]
        return False

    def ___Merge_two___(self,node):
        child,label = node.children[0]
        if(child.head.value == 'END-EVALUATE'):
            return False
        node.children.remove((child,label))
        node.children += child.children
        if node in self.rules:
            self.rules.remove(node)
        if child in self.rules:
            self.rules.remove(child)
        node.head.properties['name'].add('rule')
        temp = node.head
        visited = []
        while len(temp.properties['children']) > 0 and temp not in visited:
            visited.append(temp)
            temp = temp.properties['children'][0][0]
        temp.properties['children'].append((child.head,label))
        node.head.properties['name'] = node.head.properties['name'].union(child.head.properties['name'])
        node.primarySet = node.primarySet.union(child.primarySet)
        node.secondarySet = node.secondarySet.union(child.secondarySet)
        node.properties['source_variables'] = node.properties['source_variables'].union(child.properties['source_variables'])        
        node.properties['target_variables'] = node.properties['target_variables'].union(child.properties['target_variables'])        
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(child.properties['conditional_variables'])
        return True

    def __make_one_in_branch__(self,node):
        while(self.___Merge_two___(node)):
            continue

    def __make_parallel_sequential_when__(self,nodes):
        node = nodes[0]
        nodes.remove(node)
        if(len(nodes)>0):
            print('Parallel Whens merged: ',node.head.value)
            self.rules.append(node)
        for child,label in nodes:
            if(child.head.value == 'END-EVALUATE'):
                continue
            # node.children.remove((child,label))
            # node.children += child.children
            # if node in self.rules:
            #     self.rules.remove(node)
            if child in self.rules:
                self.rules.remove(child)
            node.head.properties['name'].add('rule')
            temp = node.head
            visited = []
            while len(temp.properties['children']) > 0 and temp not in visited:
                visited.append(temp)
                temp = temp.properties['children'][0][0]
            temp.properties['children'].append((child.head,label))
            node.head.properties['name'] = node.head.properties['name'].union(child.head.properties['name'])
            node.primarySet = node.primarySet.union(child.primarySet)
            node.secondarySet = node.secondarySet.union(child.secondarySet)
            node.properties['source_variables'] = node.properties['source_variables'].union(child.properties['source_variables'])        
            node.properties['target_variables'] = node.properties['target_variables'].union(child.properties['target_variables'])        
            node.properties['conditional_variables'] = node.properties['conditional_variables'].union(child.properties['conditional_variables'])
        return node

    def _when_variable_based_merging_(self,node):
        var = set()
        new_children = []
        vec = []
        for child,_ in node.children:
            # Making child to be the statement just after the when
            ch = child.children[0][0]

            while ch.head.value != 'END-EVALUATE':
                ch_vars = ch.primarySet.union(ch.secondarySet)
                ch = ch.children[0][0]
            
            self.__make_one_in_branch__(child)
            var = var.intersection(ch_vars)
            vec.append(child)

            if len(var) == 0:
                new_children.append(vec)
                vec = []
        
        if(len(node.children) == len(new_children)):
            return False
        node.children = []
        for CH in new_children:
            node.children.append((self.__make_parallel_sequential_when__(CH),'when'))
        return True

    def _make_one_when_rule(self,node):
        end_eval = None
        for child,label in node.children:
            node.head.properties['children'].append((child.head,label))
            child.head.properties['parents'].append(node.head)
            end_eval = child.children
        node.children = end_eval[0][0].children
    
    def can_form_rule_when(self,node):
        '''
            Here the evaluate would come which is going to have multiple children and now we need to work on those branches but before we move we need to make sure when the
            when block gets over, for which I think I need to go to main of CFG.
        '''
        if(self._check_multiple_branching_(node)):
            print('Evaluate - when separate trigger: ',node.head.value)
        elif (self._when_variable_based_merging_(node)):
            print()
        else:
            self._make_one_when_rule(node)
            print('Entire when one rule: ',node.head.value)
            self.rules.append(node)
        node.head.properties['name'].add('ruled')
    
    def is_candidate_sequential_merge(self,node):
        if len(node.children) != 1 or len(node.children[0][0].parent) != 1 or ('if' in node.head.properties['name'] and 'rule' not in node.head.properties['name']):
            return False
        return True
    
    def can_form_sequential_rule(self,node):
        child,_ = node.children[0]
        if ('if' in child.head.properties['name'] and 'rule' not in child.head.properties['name']) or 'evaluate' in child.head.properties['name'] or 'when' in node.head.properties['name'] or 'end-evaluate' in node.head.properties['name']:
            return False
        w_1 = node.properties['target_variables']
        r_1 = node.properties['source_variables']
        c_1 = node.properties['conditional_variables']
        w_2 = child.properties['target_variables']
        r_2 = child.properties['source_variables']
        c_2 = child.properties['conditional_variables']
        if len(w_1) == 0 and len(w_2) == 0 and len(r_1) == 0 and len(r_2) == 0 and len(c_1) == 0 and len(c_2) == 0:
            return False
        elif (w_1.intersection(r_2) or w_1.intersection(c_2)):
            # Written and then it is read for condition or similar
            self.merge_sequential_rules(node)
            return True
        elif len(c_1)>0 and len(c_2)>0 and c_1.isdisjoint(c_2):
            # c_1 intersection c_2 = phi
            return False
        elif c_1 == c_2 and (w_1 == w_2 or r_1 == r_2):
            self.merge_sequential_rules(node)
            return True
        elif len(w_1) == 0 and len(w_2) == 0 and (r_1.issubset(r_2) or r_2.issubset(r_1)):
            self.merge_sequential_rules(node)
            return True
        else:
            return False
        # There is one more rule but we will see it later based on how much is it feasible

    def merge_sequential_rules(self,node):
        print('Seq rule :: ',node.head.value)
        child,label = node.children[0]
        node.children.remove((child,label))
        node.children += child.children
        if node in self.rules:
            self.rules.remove(node)
        if child in self.rules:
            self.rules.remove(child)
        node.head.properties['name'].add('rule')
        temp = node.head
        visited = []
        while len(temp.properties['children']) > 0 and temp not in visited:
            visited.append(temp)
            temp = temp.properties['children'][0][0]
        temp.properties['children'].append((child.head,label))
        node.head.properties['name'] = node.head.properties['name'].union(child.head.properties['name'])
        node.primarySet = node.primarySet.union(child.primarySet)
        node.secondarySet = node.secondarySet.union(child.secondarySet)
        node.properties['source_variables'] = node.properties['source_variables'].union(child.properties['source_variables'])        
        node.properties['target_variables'] = node.properties['target_variables'].union(child.properties['target_variables'])        
        node.properties['conditional_variables'] = node.properties['conditional_variables'].union(child.properties['conditional_variables'])
        self.rules.append(node)

def getLeaf(node):
    # TODO: Think what to do for nested loops which is failing to get a leaf node
    q = []
    while len(node.properties['children']) != 0:
        for ch,_ in node.properties['children']:
                q.append(ch)
        node = q[0]
        q.remove(node)
    return node