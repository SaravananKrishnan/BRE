# Evaluation Results

|S.No|ProgramName|#TotalGroundTruthRules(GTR)|#TotalLinesinGTR|#TotalExtractedRules(TER)|%TERwithsomematchinGTR|%TERwithgreaterthan50%matchingGTR|%TERwithexactlymatchingGTR|Recall1(%GTRextractedwithfuzzymatch)|Recall2(%GTRextractedwithexactmatch)|
|------|--------------|-------------------------|---------------------|-----------------------------|-------------------------------|-------------------------------------|------------------------------------|-----------------------------------------|-----------------------------------------|
|1|knuth-shuffle|1|7|1|100|100|100|100|100|
|2|PRIME|1|10|1|100|100|100|100|100|
|3|BMI|2|24|2|100|100|50|100|50|
|4|CARRENT|4|14|1|100|100|0|75|0|
|5|LUHN|1|32|2|50|50|50|100|100|
|6|didzorchcancelmovienight|1|24|2|0|0|0|0|0|
|7|AESXGET|0|0|3|N/A|N/A|N/A|N/A|N/A|
|8|testgen|0|0|6|N/A|N/A|N/A|N/A|N/A|
|9|worker|2|14|4|25|0|0|100|0|
|10|LOANPYMT|7|70|0|0|0|0|0|0|
|11|ATM|5|31|5|100|100|100|100|100|
|12|CALC|5|57|6|83.33|66.67|83.33|100|100|
|13|FAKERGEN|0|0|4|N/A|N/A|N/A|N/A|N/A|
|14|FAKBANK|3|80|6|66.67|50|50|100|100|
|15|HEATINDX|6|99|4|25|25|0|50|0|
|16|shop|5|55|7|71.43|71.43|71.43|100|100|
|17|TICTACTOBOL|5|54|9|55.56|55.56|33.33|80|60|
|18|POKER|12|58|9|88.89|88.89|33.33|100|25|
|19|FAKTXID|3|182|7|85.71|85.71|0|100|0|
|20|eleve|2|49|9|22.22|22.22|22.22|100|100|
|21|FAKCOMP|3|122|12|41.67|41.67|8.33|66.67|33.33|
|22|CWKTCOBX|4|62|10|20|10|10|25|25|
|23|AESMAIN|27|319|16|100|100|6.25|51.85|11.11|
|24|IB4OP01|5|248|24|54.17|54.17|0|60|0|
|25|CWBWCOBX|10|116|10|70|40|20|70|20|
|26|CTXTA3B|2|33|1|100|100|100|50|50|
|27|FAKERTST|2|30|3|33.33|0|0|50|0|
||Average|4.37|66.3|6.07|62.21|56.72|34.93|74.12|44.77|


All of the above mentioed programs can be found [here](https://github.com/Samveg-techie/BusinessRuleExtraction).

## Explanation of Columns

- **S.No:** Serial number of the program.
- **Program Name:** Name of the program being evaluated.
- **Ground Truth Rules (GTR):** Number of ground truth rules for the program.
- **Total Lines in GTR:** Total lines in the ground truth rules.
- **Total Extracted Rules (TER):** Total number of rules extracted from the program.
- **% TER with some match in GTR:** Percentage of extracted rules with some match in the ground truth.
- **% TER with greater than 50% matching GTR:** Percentage of extracted rules with greater than 50% match in the ground truth.
- **% TER with exactly matching GTR:** Percentage of extracted rules with exactly matching ground truth.
- **Recall1 (% GTR that were extracted with fuzzy match):** Recall percentage for fuzzy matches.
- **Recall2 (% GTR that were extracted with exact match):** Recall percentage for exact matches.
