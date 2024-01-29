from baseUnit import Unit

count = 0

class preCondition(Unit):
    def __init__(self, fileName):
        super().__init__(fileName)
        # Attributes and methods specific to PC should be here

    def __str__(self):
        return 'PC {}'.format(self.getUID())
    
    def getUID(self):
        global count
        if self.uniqueID == "":
            self.uniqueID = '{} PC {} {} {}'.format(self.fileName,self.startLine['Number'],self.endLine['Number'],count)
            count += 1
        return self.uniqueID