"""
    This class is the base box class, it contains the structure that 
    has to store the IR units' PCs and AUs.
"""

import sys
sys.path.append("..businessRulesExtractor.IRUnitGenerator.")
from atomicUnit import AtomicUnit
from preconditionUnit import preCondition

class baseRuleBox():
    def __init__(self):
        self.uid = ""
        self.primarySet = set()
        self.secondarySet = set()
        # head to store a tree
        self.head = None
        self.parent = []
        self.children = []
        self.properties = {
            'source_variables': set(),
            'target_variables': set(),
            'conditional_variables': set(),
            # It would bee found in only sub-rules and rules
            'child_to_head': {}
        }
    
    def fetch_value(self,ir_node,primary,secondary):
        vars = ir_node.properties['source_variables'] + ir_node.properties['target_variables'] + ir_node.properties['conditional_variables']
        for v in vars:
            if v in primary:
                self.primarySet.add(v)
            elif v in secondary:
                self.secondarySet.add(v)
        # Need to make a new IR Node here instead
        if str(ir_node)[:2] == 'AU':
            self.head = AtomicUnit(ir_node.fileName)
        else:
            self.head = preCondition(ir_node.fileName)
        self.head.copyUnit(ir_node)
        self.properties['source_variables'] = set(ir_node.properties['source_variables'])
        self.properties['target_variables'] = set(ir_node.properties['target_variables'])
        self.properties['conditional_variables'] = set(ir_node.properties['conditional_variables'])
        return
    
    def getUID(self):
        if self.uid == "":
            self.uid = self.head.getUID()
        return self.uid