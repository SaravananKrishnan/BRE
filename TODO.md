1. Modify the console to make it meaningful for the user running it.
    - Should state what is the o/p
        (processing file at x state -> when state is initialised)
        (successfully processed x state -> end of state)
    - Where is the o/p
    - Summary
    [DONE]
2. Log at the end of each stage, and after it's execution {Report or Summary}[DONE]
3. Add try-catch for each stage (Boundary conditions)
    - Try adding them at sub-stages as well
    [DONE](more can be added)
4. Make sure:
    - Successful run + summary
    - Unsuccessful run + issues
    - Abrubt end (Should not happen)
    [DONE]
5. SubRule -> BuildingBlock (RBBs)
6. Mention the .gv file's existence and significance (purpose) in the final summary

BUG:
1. In the evaluate-when results, it is not overwriting an existing file, make sure it does so.
2. Capture the when rules in the summary, they need to be counted. [BIG-BUG]
    > Solved just need to confirm with sarkris which way to present.

--

1. Add the format for the file path [DONE]
2. when-result -> Log file [DONE]
3. Manually verify the cyclomatic complexity or other ways
4. 'ruled' showing in the directly addressed constructs that needs to be removed
5. Unaddressed constructs' code
6. Per stage where is the output available (ADD SUMMARY OF THE OUTPUT -> add near the stage completion part)
7. See if something is missing in try-catch