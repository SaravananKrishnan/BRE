import graphviz as gv

cluster = 0

def make_graph(node):
    g = gv.Digraph(format='pdf')
    dfs(node,[],g)
    g.attr('node', shape='circle',filled='lightblue')
    g.attr('edge', color='black')
    g.render('output/COBOL_{}/BRR_{}'.format(node.head.fileName,node.head.fileName))
    return

def dfs(node,visited,g):
    if node in visited:
        return
    visited.append(node)
    populate_cluster(node.head,g)

    for child,_ in node.children:
        g.edge(str(node.head),str(child.head),label=_)
        dfs(child,visited,g)

def populate_cluster(node,g):
    visited = set()
    stack = [node]
    global cluster
    with g.subgraph(name='Node {}'.format(cluster)) as c1:
        cluster+=1
        while stack:
            current_node = stack.pop()
            if current_node not in visited:
                visited.add(current_node)
                g.node(str(current_node),label=current_node.value)
                for neighbor,_ in current_node.properties['children']:
                    g.edge(str(current_node),str(neighbor),label=_)
                    if neighbor not in visited:
                        stack.append(neighbor)