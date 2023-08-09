from baseUnit import Unit

class preCondition(Unit):
    def __init__(self, fileName):
        super().__init__(fileName)
        # Attributes and methods specific to PC should be here

    def __str__(self):
        return 'PC {}'.format(self.getUID())
    
    def getUID(self):
        if self.uniqueID == "":
            self.uniqueID = '{} PC {} {}'.format(self.fileName,self.startLine['Number'],self.endLine['Number'])
        return self.uniqueID