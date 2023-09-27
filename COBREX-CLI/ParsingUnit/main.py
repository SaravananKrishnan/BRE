"""
    This module contains the main method "extractor" used for extracting
    Business Rules from the input COBOL program
"""

import sys, os, json
import antlr4
from .procedure_visitor import ProcedureVisitor
from .business_rules_extractor import BusinessRulesExtractor
from .antlr_py.Cobol85Lexer import Cobol85Lexer
from .antlr_py.Cobol85Parser import Cobol85Parser
from .cobol_analyzer import COBOLAnalyzer
from .lineMap import makeLineMap


def extractor(file_path, cobol_file_name,actual_file_path, output_directory):
    """
    This method is used for extracting
    Business Rules from the input COBOL program

    Args:
        file_path: the filepath of the input COBOL program
        cobol_file_name: file name of the COBOL program
        output_directory: the directory to store output files
    """
    output_directory += '/COBOL_{}/CFG'.format(cobol_file_name)
    if not os.path.isdir(output_directory):
        cmd = 'mkdir ./output/COBOL_{}/CFG'.format(cobol_file_name)
        os.system(cmd)


    input_stream = antlr4.FileStream(file_path)
    lexer = Cobol85Lexer(input_stream)
    stream = antlr4.CommonTokenStream(lexer)
    parser = Cobol85Parser(stream)
    tree = parser.startRule()

    procedures, paragraph_list, section_list  = ProcedureVisitor().get_procedures(tree)


    cobol_analyzer = COBOLAnalyzer(procedures, paragraph_list, section_list)


    cobol_analyzer.build(tree)

    # This is the snippet to verify that the parse tree is storing the detail of end-if
    # ls = []
    # ls.append(tree)
    # while len(ls) != 0:
    #     node = ls[0]
    #     ls.pop(0)
    #     if type(node) is antlr4.tree.Tree.TerminalNodeImpl:
    #         print(node.getPayload())
    #     else:
    #         ls += node.children

    # print(dir(tree))
    # print(dir(tree.children[0]))
    # c = tree.children[0].children[0].children[2].children[3].children[0].children[2].children[0].children[0].children[4]
    # print(type(c))

    # Make a map here for line number with statements
    makeLineMap(actual_file_path, cobol_file_name,cobol_analyzer.statements)

    cobol_analyzer.cfg.build_visual(os.path.join(output_directory, 'CFG_'+cobol_file_name), format='pdf', calls=False)
    cfg_json,cyclomatic_complexity = cobol_analyzer.cfg.build_cfg_json(cobol_file_name)

    # business_rules_extractor = BusinessRulesExtractor(cobol_analyzer.cfg,
    #  cobol_analyzer.business_variables)
    # business_rules_extractor.extract_all_business_rules()
    # business_rules_extractor.build_business_rule_visual(os.path.join(output_directory, cobol_file_name+'_BRs'), 'pdf')
    # br_json = business_rules_extractor.build_business_rules_json()



    with open(os.path.join(output_directory, 'CFG_'+cobol_file_name+'.json'), "w") as outfile:
        json.dump(cfg_json, outfile)

    # with open(os.path.join(output_directory, cobol_file_name+'_BRs.json'), "w") as outfile:
    #     json.dump(br_json, outfile)

    # return  cfg_json, br_json
    return cfg_json,cyclomatic_complexity





if __name__ == "__main__":
    try:
        file_name = sys.argv[1]
    except:
        file_name = "./tests/cfg.cbl"

    extractor(file_name)
