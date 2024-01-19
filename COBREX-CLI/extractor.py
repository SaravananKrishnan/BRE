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
    except Exception as e:
        print('ERROR: Parsing stage Failed.')
        print('Cause of error: ',e)
        system.exit(1)
    

    allConstructs,constructs_addressed,construct_logic_map,num_subrules,num_rules,num_RBBs = runIR(file_name)

    f = open('./output/COBOL_{}/summary.txt'.format(file_name),"w")
    f.write('Cyclomatic complexity: {}\n'.format(cyclomatic_complexity))
    f.write('Number of Subrules: {}\n'.format(num_subrules))
    f.write('Number of Rules: {}\n'.format(num_rules))
    f.write('Constructs Addressed: {}\n'.format(constructs_addressed))
    f.write('Constructs UnAddressed: {}\n'.format(set(allConstructs)-constructs_addressed))
    f.write('# of unique constructs: {}\n'.format(len(set(allConstructs))))
    f.write('# of constructs: {}\n'.format(len(allConstructs)))
    # f.write('Construct-Logic Mapping: {}\n'.format(construct_logic_map))
    f.close()
    return [cyclomatic_complexity,num_subrules,num_rules,constructs_addressed,set(allConstructs)-constructs_addressed,len(set(allConstructs)),len(allConstructs),construct_logic_map,num_RBBs,total_lines]



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
    else:
        file_path = Path(sys.argv[1])

        if not file_path.exists():
            print("ERROR: File does not exists!")
        else:
            ans = extract_business_rules(file_path)