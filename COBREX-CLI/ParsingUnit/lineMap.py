def makeLineMap(file_path,cobol_file_name,statements):

    line_number_map = {}
    with open(file_path, 'r') as f:
        Plines = f.readlines()
        lines = [line.strip() for line in Plines]

    for i in range(len(lines)):
        # print(lines[i])
        lines[i] = lines[i].replace(" ","")

    # Algo 1

    # j = 0
    # for l in lines:
    #     print(l)
    # for stmt in statements:
    #     # print(stmt.text)
    #     print(stmt.text.replace(" ","").replace("\n",""))
    
    # for i in range(len(lines)):
    #     for k in range(len(statements)):
    #         s = statements[k].text.replace(" ","").replace("\n","")
    #         if lines[i] in s:
    #             if lines[i] == s or (statements[k].tag == "paragraphName" and lines[i][:-1] == s):
    #                 statements[k].StartLine = (i+1)
    #                 statements[k].EndLine = (i+1)
    #             elif statements[k].StartLine != 0:
    #                 statements[k].EndLine = (i+1)
    #             else:
    #                 statements[k].StartLine = (i+1)


    # Algo 2

    # i = 0
    # j = 0
    # while i<len(lines) and j < len(statements):
    #     if lines[i] == "":
    #         i+=1
    #         continue
            
    #     stmt = statements[j].text.replace(" ","").replace("\n","")
    #     s = lines[i]

    #     if s[len(s)-1] != '.':
    #         s+="."
        
    #     if stmt[len(stmt)-1] != '.':
    #         stmt += "."

    #     if stmt in s:
    #         print("H: ",s,stmt)
    #         if statements[j].StartLine != 0:
    #             statements[j].EndLine = (i+1)
    #         else:
    #             statements[j].StartLine = (i+1)
    #             statements[j].EndLine = (i+1)
    #         i += 1
    #     else:
    #         if statements[j].StartLine != 0:
    #             print("INC J")
    #             j += 1
    #         else:
    #             print("INC I")
    #             i += 1


    # Basic Approach Let's atleast have the starting line correct
    # This might work for some time but not too accurate

    for stmt in statements:
        s = stmt.text.replace(" ","").replace("\n","")
        for i in range(len(lines)):
            if s in lines[i]:
                stmt.StartLine = (i+1)
                stmt.EndLine = (i+1)
                lines[i] = "$$$$$"
                break
        if stmt.StartLine == 0:
            x = len(s)
            if x>=15:
                x = 15
            p = s[-x]
            s = s[:x]
            for i in range(len(lines)):
                if s in lines[i]:
                    stmt.StartLine = (i+1)
                    lines[i] = "$$$$$"
                    break
            # Here instead of this what if we do the reverse one?
            # Think and lemme know
            for i in range(len(lines)):
                if p in lines[i]:
                    stmt.EndLine = (i+1)
                    lines[i] = "$$$$$"
                    break
    
    return