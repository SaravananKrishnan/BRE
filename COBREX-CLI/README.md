# A Tool for Identifying Business Rules in COBOL Programs

## Working of the Tool
The tool takes COBOL source code and the set of primary and secondary variables that are present in the source code as input. The source code parser generates the CFG from the source code. This CFG is passed to the Rule Building Block(RBB) graph generator which will form Atomic Units and Condition Units out of CFG while retaining the control flow information. The output of this graph generator is a RBB graph. This RBB graph is passed to the Business Rule Realisation (BRR) unit to extract business rules and activation graph.

![Overview](./media/overview.png)

Kindly refer to the ![demo](www.youtube.com) video for further explaination.

## What's inside the COBREX-CLI repository?
<!-- Just keep what is in the root directory, we shall have separate readme for each of the individual folders -->
In the root directory,

"extractor.py" is the starting point of execution.
"preprocessor.py" contains functions for preprocessing the COBOL program.
"issueTracker.xlsx" consists of the xcel sheet storing the evaluation details for iteration 1 and post implementation on iteration 1 results.

Inside the ProleapPreprocessor directory,

We have copied this directory as it is from the COBREX[1] code and need to confirm the usecase of the same.

Inside the ParsingUnit directory,

"main.py" contains the main method "extractor" used for generating CFG from the source code.
"cobol_analyzer.py" contains a class used to perform static analysis
on the input COBOL program. It is used to construct CFG.
"cobol_cfg.py" contains classes used for building the Control Flow Graph (CFG) of the COBOL code.
"procedure_visitor.py" contains classes used to extract information on procedures(paragraphs/sections) present in the COBOL program.
"data_division.py"  contains classes and code used to identify and store the variables present in the data division of the input COBOL program.
"model.py" contains support classes for building Control Flow Graph(CFG).
"business_rules_extractor.py: contains classes used to extract and visualize business  rules using the CFG and the business variables.
[We have taken this unit from COBREX[1] and modified it to the level we needed for the appropriate schema generation of CFG.]

Inside the IRUnitGenerator directory,

"baseUnit.py" base structure for the Atomic unit and precondition unit
"AtomicUnit.py" contains specific methods for the atomic unit definition
"PreconditionUnit.py" contains specific methods for precondition unit definitions
"IRBuilder.py" It contains the core logic for the formation of IR generation

Inside the BR_Realisation directory,

"baseRuleBox.py" abstract class for storing rule related various information.
"ruleHelper.py" contains the logic to form rule
"subruleHelper.py" contains the logic to form sub rules
"subRuleBox.py" class to store various sub rules
"utils.py" contains normal utility methods
"main.py" Maintains the flow of the BRR unit

## Output
The tool provides the following outputs for each of the input COBOL program.
<!-- Explain all the output over here -->

## Execution of the tool:

1. Give information about the primary and secondary variables in the businessVariables.txt file in below mentioned format:
```text
<# of primary variables>
<!-- All primary variables one per line -->
<# of secondary variables>
<!-- All secondary variables one per line -->
```

2. Run extractor.py along with the input COBOL program file path:
```bash
python3 extractor.py input_cobol_file_path
```

3. Final output will be obtained in the ![output](./output/) directory.