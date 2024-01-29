# A Tool for Identifying Business Rules in COBOL Programs
## Abstract and Motivation
In order to cater to the current requirements, there is an explicit need to take advantage of the latest technologies like multi-cloud, which requires the modernization of these legacy applications written in mainframe COBOL language. Among several aspects of modernization, Business rule or logic extraction is one of its major aspects. In general, the extraction of business rules can help with some of the basics of the code base, such as maintenance, evolution, and reuse. Hence, there is a need for our tool that can identify and extract the business rules from a given code base.

## Features of Tool:
The tool takes Business variables as input and provides business rules as the major output. Along with that we also generate the Control flow graph (CFG) and the Rule Building Block (RBB) graph of the input COBOL program. We then Merge the RBBs that are relevant to business logic decisions/computations based on usage of business variables and co-dependencies amongst execution paths. This gives us business rules of varying granularity.

## Installation of Tool:
Follow the below 6 steps, to install and set-up the environment for the tool: 
1. Install [GnuCOBOL](https://gnucobol.sourceforge.io)

2. Install [Graphviz](https://graphviz.org/download/)

3. Clone or download this github repository.

4. Get into the main directory:
```bash
cd COBREX-CLI
```

5. Create and activate a new python3 virtual environment:
```bash
python(3) -m venv <path_to_env/env_name></path_to_env>
```

6. Install the requirements:
```bash
pip install -r requirements.txt
```

### In case of query contact us
<!-- We should provide our e-mail and name -->