from atomicUnit import AtomicUnit as AU
from preconditionUnit import preCondition as PC
import json
import os
import graphviz as gv
import sys
sys.path.append('BR_Realisation/')
from main import doBRR

class IR():

    def __init__(self):
        self.fileName = ""
        self.rootNode = None
        self.allConstructs = []

    def addConstruct(self,s):
        if s == "when" or s == "end-if" or s == "end-evaluate" or s == "exit":
            return
        self.allConstructs.append(s); 
        return
    
    def makeNodes(self,nodes):
        id_to_obj = {}
        for node in nodes:
            self.addConstruct(node['name'])
            if node['name'] == "if" or node['name'] == "when" or node['name'] == "evaluate"  :
                # Make a PC
                pc = PC(self.fileName)
                pc.setAttr(node)
                id_to_obj[node['id']] = pc
            else:
                # Make an AU
                au = AU(self.fileName)
                au.setAttr(node)
                id_to_obj[node['id']] = au
                if node['name'] == "start":
                    self.rootNode = au
        return id_to_obj
    
    def fillChild(self,id_to_obj,edges):
        for e in edges:
            n1 = id_to_obj[e['sourceUniqueId']]
            n2 = id_to_obj[e['targetUniqueId']]
            label = e['label']
            n1.properties['children'].append((n2,label))
            n2.properties['parents'].append(n1)
    
    def checkMergable(self,parentNode,childNode):
        if len(parentNode.properties['children']) == 1 and len(childNode.properties['parents']) == 1 and "end-if" not in parentNode.properties['name'] and "end-evaluate" not in parentNode.properties['name']:
            if "paragraphName" not in childNode.properties['name'] and "end-if" not in childNode.properties['name'] and "end-evaluate" not in childNode.properties['name'] and str(childNode)[:2] != "PC" and str(parentNode)[:2] != "PC":
                return True
        return False
    
    def merge(self,parentNode,childNode):
        parentNode.mergeNode(childNode)

        for gChild,_ in childNode.properties['children']:
            gChild.exchangeParent(childNode,parentNode)

        del childNode
        return

    def dfs_run(self, node, visited=[]):
        if node in visited:
            return
        
        visited.append(node)

        while True:
            flag = False
            for n,_ in node.properties['children']:
                if self.checkMergable(node,n) and node.value != 'Begin':
                    self.merge(node,n)
                    flag = True
                    break
                else:
                    self.dfs_run(n,visited)
            if flag == False:
                break
        return

    def buildIR(self,cfg,fileName):
        '''
            Function to build IR out of the given CFG
        '''
        self.fileName = fileName

        # Step1: Make All nodes as corresponding AUs and/or PCs respectively
        id_to_obj = self.makeNodes(cfg['nodes'])
        # Step2: Fillup children values
        self.fillChild(id_to_obj,cfg['edges'])
        # Step3: Iterate over the tree and verify if nodes are mergable
        self.dfs_run(self.rootNode,[])
        return
    
    def getRelationName(self,parentNode,childNode):
        pName = parentNode.properties['name']
        cName = childNode.properties['name']
        if 'if' in pName or 'when' in pName or 'evaluate' in pName:
            return '{}_HAS_{}'.format(str(parentNode)[:2],str(childNode)[:2])
        elif 'perform' in pName:
            return '{}_HAS_{}'.format(str(parentNode)[:2],str(childNode)[:2])
        else:
            return '{}_SUCCESSOR_{}'.format(str(parentNode)[:2],str(childNode)[:2])

    def _build_json(self,node,ir_json,visited=[]):
        if node in visited:
            return
        
        visited.append(node)
        # print(node)

        # Design decision to keep it here or make it a method for BU
        ir_json['nodes'].append({
            'id': node.getUID(),
            'type': str(node)[:2],
            'label': '{}:{}:{}'.format(str(node)[:2],node.startLine['Number'],node.endLine['Number']),
            'properties':{
                'stmtText': node.value,
                'startLineNumber': node.startLine['Number'],
                'endLineNumber': node.endLine['Number'],
                'fileName': node.fileName
            }
        })

        for child,label in node.properties['children']:
            self._build_json(child,ir_json,visited)
            ir_json['edges'].append({
                'id':'Link: {} : {}'.format(node.getUID(),child.getUID()),
                'sourceUID': node.getUID(),
                'targetUID': child.getUID(),
                'relationName': self.getRelationName(node,child),
                'properties' : {
                    'label' : label
                }
            })

        return

    def getJSON(self,path):
        if self.rootNode == None:
            print("Please run buildIR function before this to see the required output.")
            return

        ir_json = {
            'nodes':[],
            'edges': []
        }

        self._build_json(self.rootNode,ir_json,[])
        filename = self.fileName + "_IR.json"
        with open(path, 'w') as f:
            json.dump(ir_json, f)
        return ir_json
    
    def getPDF(self,filepath,ir_json,format):

        graph = gv.Digraph(name='cluster',format=format)
        for node in ir_json['nodes']:
            graph.node(name=str(node['id']),label=str(node['properties']['stmtText']),style='filled',fillcolor='lightblue')
        
        for edge in ir_json['edges']:
            graph.edge(str(edge['sourceUID']),str(edge['targetUID']),label=str(edge['properties']['label']))


        # Need to think about the fix I did i.e. would it always generate a unique ID
        graph.render(filepath)
        return

def runIR(fileName):
    ir = IR()
    with open('output/COBOL_{}/CFG/CFG_{}.json'.format(fileName,fileName)) as f:
        cfg = json.load(f)
    ir.buildIR(cfg,fileName)
    output_directory = './output/COBOL_{}/IR'.format(fileName)
    if not os.path.isdir(output_directory):
        cmd = 'mkdir ./output/COBOL_{}/IR'.format(fileName)
        os.system(cmd)
    ir_json = ir.getJSON(os.path.join('output/COBOL_{}/IR/'.format(fileName),'IR_{}.json'.format(fileName)))
    ir.getPDF(os.path.join('output/COBOL_{}/IR/'.format(fileName),'IR_{}'.format(fileName)),ir_json,'pdf')
    constructs_addressed,construct_logic_map,num_subrules,num_rules,num_RBBs = doBRR(ir.rootNode)
    # print("All the addressed constructs",constructs_addressed)
    # print("All the constructs present",ir.allConstructs)
    # print("Construct to logic map: ",construct_logic_map)
    return ir.allConstructs,constructs_addressed,construct_logic_map,num_subrules,num_rules,num_RBBs

if __name__ == '__main__':
    try:
        fileName = sys.argv[1]
    except:
        fileName = "test9"
    runIR(fileName)