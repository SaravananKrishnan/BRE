
class Unit():

    __slots__ = ["uniqueID","fileName","startLine","endLine","value","properties","variables"]

    def __init__(self,fileName):
        self.uniqueID = ""
        self.fileName = fileName
        self.startLine = {
            'ID': "",
            'Number': 0
        }
        self.endLine = {
            'ID': "",
            'Number': 0
        }
        self.value = ""
        self.properties = {
            'name': set(),
            'children': [],
            'parents': [],
            'source_variables': [],
            'target_variables': [],
            'conditional_variables': []
        }

    def setStartLine(self,ID,num):
        self.startLine['ID'] = ID
        self.startLine['Number'] = num

    def setEndLine(self,ID,num):
        self.endLine['ID'] = ID
        self.endLine['Number'] = num

    def setAttr(self,node):
        '''
            Function / Method used to set the attributes for the very first time
        '''
        # Here the input is the CFG Node and we need to set all the required attributes
        self.setStartLine(node['properties']['uniqueId'],node['properties']['stmtStartLineNumber'])
        self.setEndLine(node['properties']['uniqueId'],node['properties']['stmtEndLineNumber'])
        self.value = node['properties']['stmtText']
        self.properties['name'].add(node['name'])
        self.properties['source_variables'] = node['properties']['source_variables']
        self.properties['target_variables'] = node['properties']['target_variables']
        self.properties['conditional_variables'] = node['properties']['conditional_variables']
        return
    
    def exchangeParent(self,outNode,InNode):
        self.properties['parents'].remove(outNode)
        self.properties['parents'].append(InNode)
        return

    def copyUnit(self,ir_node):
        self.startLine = ir_node.startLine
        self.endLine = ir_node.endLine
        self.value = ir_node.value
        self.properties['name'] = ir_node.properties['name']
        self.properties['source_variables'] = ir_node.properties['source_variables']
        self.properties['target_variables'] = ir_node.properties['target_variables']
        self.properties['conditional_variables'] = ir_node.properties['conditional_variables']
        return