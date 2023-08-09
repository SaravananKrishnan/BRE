"""
    This is class stores the brown boxes that we draw. It is responsible for actions that are 
    going to happen on it. It stores AUs and PCs, and it's related information as it's components.
"""
import sys
sys.path.append('.')
from baseRuleBox import baseRuleBox

class subRuleBox(baseRuleBox):
    def __ini__(self):
        super.__init__(self)
