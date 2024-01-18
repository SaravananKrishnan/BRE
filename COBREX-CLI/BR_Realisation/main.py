"""
    This is the driving class, which calls other function and make the program run in a systematic fashion.
"""

import sys
import json
import os
from pathlib import Path
sys.path.append('.')
from subRuleBox import subRuleBox
from ruleHelper import ruleHelper
from subRuleHelper import subRuleHelper
from utils import make_graph
import graphviz as gv

class BRDriver():
    def __init__(self,ir_root,primary,secondary):
        # IR we got as input
        self.ir_root = ir_root
        # Set of primary variables which the user gave
        self.primary = primary
        # Set of secondary variables which the user gave
        self.secondary = secondary
        # Head for the BR R Structure
        self.file_name = ir_root.fileName
        self.head = None
        self.rule = ruleHelper(self.file_name)
        self.sub_rule = subRuleHelper(self.file_name)
        self.ruleForm = True
        self.constructs_addressed = set()

    def countRBBs(self):
        count = 0
        visited = set()
        stack = [self.head]

        while stack:
            vertex = stack.pop()
            if vertex not in visited:
                visited.add(vertex)
                count += 1
                if set(['start']) == vertex.head.properties['name'] or set(['stop','close','exit','paragraphName','evaluate','sectionHeader']) & vertex.head.properties['name'] or set(['display']) == vertex.head.properties['name'] or set(['perform']) == vertex.head.properties['name'] or set(['end-if']) == vertex.head.properties['name'] or set(['end-evaluate']) == vertex.head.properties['name']:
                    count-=1
                # else:
                #     print(vertex.head.properties['name'])
                for neighbor,_ in vertex.children:
                    if neighbor not in visited:
                        stack.append(neighbor)
        return count

    def _make_same(self,ir_node,visited,ir_to_br):
        
        if ir_node in visited:
            br_node = ir_to_br[ir_node]
            return br_node
        
        br_node = subRuleBox()
        visited.append(ir_node)
        ir_to_br[ir_node] = br_node
        br_node.fetch_value(ir_node,self.primary,self.secondary)
        for ir_child,_ in ir_node.properties['children']:
            br_child = self._make_same(ir_child,visited,ir_to_br)
            br_child.parent.append(br_node)
            br_node.children.append((br_child,_))
        return br_node

    def _form_sub_rule(self,node,visited):
        if node in visited:
            return
        
        visited.append(node)

        if self.sub_rule.is_candidate(node) == True and self.sub_rule.is_mergable(node) == True:
            self.sub_rule.make_subrule(node)
        
        for child,_ in node.children:
            self._form_sub_rule(child,visited)

    def formSubRules(self):
        '''
            This method forms the subrules.
        '''
        # This dfs is just making everything of the same type, 
        # it is not related in any way to subrule formation.
        self.head = self._make_same(self.ir_root,[],{})
        self._form_sub_rule(self.head,[])
        self.sub_rule.get_graph_sub_rules()

    def _form_nested_rule_(self,node,visited):
        if node in visited:
            return
        visited.append(node)

        if self.rule.is_candidate_rule_merge(node):
            self.ruleForm = self.rule.can_form_rule(node)

        for child,_ in node.children:
            self._form_nested_rule_(child,visited)
        return
    
    def _trigger_when_rules_(self,node,visited):
        if node in visited:
            return
        
        visited.append(node)

        if self.rule.is_candidate_rule_merge_when(node):
            self.rule.can_form_rule_when(node)

        for child,label in node.children:
            self._trigger_when_rules_(child,visited)
        return

    def formRules(self):
        '''
            This function is responsible to form rules.
            Here the head consists of sub-rule formed tree and we need to form, rules out of it.
        '''

        while self.ruleForm:
            self.ruleForm = False
            self._form_nested_rule_(self.head,[])
            self._perform_merge_rule_(self.head,[])
            self._form_sequential_rule_(self.head,[])
        
        # Needs to be thought of later
        self._trigger_when_rules_(self.head,[])

        self.rule.get_graph_rules()

    def _form_sequential_rule_(self,node,visited):
        if node in visited:
            return
        
        visited.append(node)

        if self.rule.is_candidate_sequential_merge(node):
            b1 = self.rule.can_form_sequential_rule(node)
            self.ruleForm = self.ruleForm or b1

        for child,_ in node.children:
            self._form_sequential_rule_(child,visited)
        return

    def _perform_merge_rule_(self,node,visited):
        if node in visited:
            return
        
        visited.append(node)

        x = self.rule.is_candidate_perform_merge(node,visited)
        if x == 1:
            b1 = self.rule.perform_loop_merge(node)
            self.ruleForm = self.ruleForm or b1
        elif x == 2:
            b2 = self.rule.perform_para_merge(node)
            self.ruleForm = self.ruleForm or b2
        
        for child,_ in node.children:
            self._perform_merge_rule_(child,visited)

def getVarsfromUser():
    '''
        A function to get the user input of 1° and 2° variable
    '''
    
    primary = []
    secondary = []
    path1 = 'input.txt'
    with open(path1, 'r') as f:
        f = [line.strip() for line in f.readlines()]
    i = 0
    pv = int(f[i])
    i+=1
    for j in range(pv):
        primary.append(f[i])
        i+=1
    sv = int(f[i])
    i+=1
    for j in range(sv):
        secondary.append(f[i])
        i+=1
    return primary,secondary

def doBRR(rootNode):
    # Let's say somehow you got the root node of the IR part, somehow.
    p,s = getVarsfromUser()

    br = BRDriver(rootNode,p,s)
    # Form subRules
    br.formSubRules()

    # This is the place where we would try to realise the RBBs count
    num_RBB = br.countRBBs()

    # Merge subRules
    br.formRules()
    # print("Total Number of Subrules: ",len(br.sub_rule.subRules))
    # print("Total Number of Rules: ",len(br.rule.rules))
    for r in br.rule.rules:
        br.constructs_addressed = br.constructs_addressed.union(r.head.properties['name'])
    make_graph(br.head)
    # print("All the constructs to logic map: ",br.rule.construct_logic)
    return br.constructs_addressed,br.rule.construct_logic,len(br.sub_rule.subRules),len(br.rule.rules),num_RBB

if __name__ == '__main__':
    print('Hi there!')