def makeLineMap(file_path,cobol_file_name,statements):

    line_number_map = {}
    with open(file_path, 'r') as f:
        Plines = f.readlines()
        lines = [line.strip() for line in Plines]

    for i in range(len(lines)):
        # print(lines[i])
        lines[i] = lines[i].replace(" ","")

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