"""
    This module contains the main method "extractor" used for extracting
    Business Rules from the input COBOL program
"""

import sys, os, json
import antlr4
from .procedure_visitor import ProcedureVisitor
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

    # Make a map here for line number with statements
    makeLineMap(actual_file_path, cobol_file_name,cobol_analyzer.statements)

    cobol_analyzer.cfg.build_visual(os.path.join(output_directory, 'CFG_'+cobol_file_name), format='pdf', calls=False)
    cfg_json,cyclomatic_complexity = cobol_analyzer.cfg.build_cfg_json(cobol_file_name)

    with open(os.path.join(output_directory, 'CFG_'+cobol_file_name+'.json'), "w") as outfile:
        json.dump(cfg_json, outfile)

    # return  cfg_json, br_json
    return cfg_json,cyclomatic_complexity





if __name__ == "__main__":
    try:
        file_name = sys.argv[1]
    except:
        file_name = "./tests/cfg.cbl"

    extractor(file_name)
