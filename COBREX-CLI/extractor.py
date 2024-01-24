"""
    This module contains functions used by flask server to extract business rules,
    convert json to dot format, and generating graph file
"""
import os
import pandas as pd
from preprocessor import preprocess
from ParsingUnit.main import extractor
import graphviz as gv
import shutil
from pathlib import Path
import sys
sys.path.append('./IRUnitGenerator/')
from IRBuilder import runIR 




def extract_business_rules(file_path):
    """
    Function to extract business rules from the COBOL file
    """

    file_name = file_path.stem


    try:
        print('STAGE: Parsing stage intialised.')
        preprocess(file_path)

        # subprocess.run(['cp', './preprocessor_proleap/output/preprocessed.cbl', './preprocessed_files/'+sub_directory+'/'+file_name])
        preprocessed_file_path = os.path.join('clean_output.cbl')

        with open('clean_output.cbl','r') as f:
            lines = f.readlines()
        total_lines = len(lines)

        # return total_lines
        if not os.path.isdir('./output/COBOL_{}'.format(file_name)):
            cmd = 'mkdir ./output/COBOL_{}'.format(file_name)
            os.system(cmd)

        cfg_json,cyclomatic_complexity = extractor(preprocessed_file_path,file_name,file_path, 'output')
        os.remove("clean_output.cbl")
        print('STAGE: Parsing stage successfully executed.')
        print('OUTPUT-Parsing: COBREX-CLI/output/COBOL_{}/CFG\n'.format(file_name))
    except Exception as e:
        print('ERROR: Parsing stage Failed.')
        print('Cause of error: ',e)
        sys.exit(1)
    

    allConstructs,constructs_addressed,indirectly_addressed,num_subrules,num_rules,num_RBBs = runIR(file_name)

    print('\n###############################################################')
    print('SUMMARY')
    print('###############################################################')
    print('\nCyclomatic complexity: {}\n'.format(cyclomatic_complexity))
    print('Number of extracted Rule Building Blocks from {}: {}'.format(file_name,num_subrules))
    print('Number of extracted Rules from {}: {}\n'.format(file_name,num_rules))
    print('# of unique constructs in {}: {}'.format(file_name,len(set(allConstructs))))
    print('# of total constructs in {}: {}'.format(file_name,len(allConstructs)))
    print('Constructs contributing to atleast one rule: {}'.format(constructs_addressed.union(indirectly_addressed) - set(['rule','end-if','end-evaluate'])))
    print('Constructs not contributing to any of the rule: {}'.format(set(allConstructs)-constructs_addressed-indirectly_addressed))
    
    return [cyclomatic_complexity,num_subrules,num_rules,constructs_addressed,set(allConstructs)-constructs_addressed,len(set(allConstructs)),len(allConstructs),indirectly_addressed,num_RBBs,total_lines]



# def graph_json_to_dot(graph_json, format):
#     """
#     Function to convert graph in json format to dot format
#     """

#     graph = gv.Digraph(name='cluster', format=format)

#     for node in graph_json['nodes']:

#         if 'type' in node.keys() and node['type'] == 'input':
#             graph.attr('node', shape='diamond', style='filled', color='lightgrey')
#             graph.node(node['id'], label=node['data']['label'])
#         else:
#             graph.attr('node', shape='box', style='filled', color='lightblue')
#             graph.node(node['id'], label=node['data']['label'])

#     for edge in graph_json['edges']:
#         graph.edge(edge['source'], edge['target'], edge['label'])


#     return graph


# def generate_graph_file(graph_json, format, filepath, export_path):
#     """
#     Function to generate graph visualized files for the input graph present in json format
#     """

#     if not os.path.isdir(export_path):

#         os.mkdir(export_path)
#     else:

#         shutil.rmtree(export_path) #done so that all previous files are deleted
#         os.mkdir(export_path)

#     graph = graph_json_to_dot(graph_json, format)

#     graph.render(filename=filepath, view=False, cleanup=True)







if __name__ == '__main__':
    
    if len(sys.argv) != 2:
        print('ERROR: File path not specified.')
        print('Supported Format :: python3 extractor.py <input-file-path>')
    else:
        file_path = Path(sys.argv[1])

        if not file_path.exists():
            print("ERROR: File does not exists!")
        else:
            ans = extract_business_rules(file_path)