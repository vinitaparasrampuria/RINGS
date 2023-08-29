
::: {.cell .markdown}
####  Draw the network topology
:::

::: {.cell .markdown}
The following cell will draw the network topology, for your reference.
:::

::: {.cell .code}
```python
colors=['bisque', 'aquamarine', 'lightblue', 'lightsalmon', 'lightgreen', 'pink', 'cyan', 'yellow', 'peachpuff', 'gold', 'plum' , 'lightskyblue',  ]
color_dict=dict(zip(as_sites,colors[:len(as_sites)]))
```
:::

::: {.cell .code}
```python
l2_nets = [(n.get_name(), {'color': 'lavender'}) for n in slice.get_l2networks() ]
l3_nets = [(n.get_name(), {'color': 'pink'}) for n in slice.get_l3networks() ]
hosts   =   [(n.get_name(), {'color': color_dict[n.get_site()]}) for n in slice.get_nodes()]
nodes = l2_nets + l3_nets + hosts
ifaces = [iface.toDict() for iface in slice.get_interfaces()]
edges = [(iface['network'], iface['node']) for iface in ifaces]
```
:::


::: {.cell .code}
```python
import networkx as nx
import matplotlib.pyplot as plt
plt.figure(figsize=(len(nodes),len(nodes)))
G = nx.Graph()
G.add_nodes_from(nodes)
G.add_edges_from(edges)
pos = nx.spring_layout(G)
nx.draw(G, pos, node_shape='s',  
        node_color=[n[1]['color'] for n in nodes], 
        node_size=[len(n[0])*400 for n in nodes],  
        with_labels=True);
```
:::
