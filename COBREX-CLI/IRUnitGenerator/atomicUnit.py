from baseUnit import Unit

class AtomicUnit(Unit):
    '''
        Atomic Unit by definition is that peice of code which does not have any
        control flow transfer while execution
    '''

    def __init__(self, fileName):
        super().__init__(fileName)
        # Any attributes specific to AU should be here and same for the methods

    def __str__(self):
        return 'AU {}'.format(self.getUID())
    
    def getUID(self):
        if self.uniqueID == "":
            self.uniqueID = '{} AU {} {}'.format(self.fileName,self.startLine['Number'],self.endLine['Number'])
        return self.uniqueID
    
    def mergeNode(self,node):
        self.uniqueID = ""
        self.setEndLine(node.endLine['ID'],node.endLine['Number'])
        self.value += '\n'
        self.value += node.value
        self.properties['name'] = self.properties['name'].union(node.properties['name'])
        self.properties['children'] = node.properties['children']
        self.properties['source_variables'] = list(set(self.properties['source_variables'] + node.properties['source_variables']))
        self.properties['target_variables'] = list(set(self.properties['target_variables'] + node.properties['target_variables']))
        self.properties['conditional_variables'] = list(set(self.properties['conditional_variables'] + node.properties['conditional_variables']))
        return