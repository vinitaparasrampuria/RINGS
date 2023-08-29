::: {.cell .markdown}
### Set up the routes

We will then install FRR routing software on all of the routers, and then configure to use OSPF as their internal routing protocol.
:::


::: {.cell .code}
```python
router_nodes=[slice.get_node(name=r['name']) for r in node_conf]

```
:::

::: {.cell .code}
```python

for n in router_nodes:
    n.execute("curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -")
    n.execute("echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable | sudo tee -a /etc/apt/sources.list.d/frr.list")
    n.execute("sudo apt update")
    n.execute("sudo apt -y install frr frr-pythontools nload")
    n.execute("sudo sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons")
    n.execute("sudo sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons")
    n.execute("sudo systemctl restart frr.service")    
```
:::


::: {.cell .code}
```python

for n in router_nodes:
    n.execute("sudo vtysh -E -c'configure terminal\nrouter ospf\nnetwork 10."+n.get_name()[2]+".0.0/16 area 0.0.0.0\n exit\n exit\n exit'  ")    
```
:::



::: {.cell .code}
```python

for n in router_nodes:
    n.execute("sudo vtysh -E -c 'show ip route\nexit'")   
```
:::

::: {.cell .markdown}

Validate internal routing by running ping across the network within an Autonomous system:
:::



::: {.cell .code}
```python
for r in data_routers:
    if r[2]:
        [(slice.get_node(name=r[1][0]['name']).execute("ping -c 5 "+i['addr'] +" | grep rtt")) for i in r[2][-1]['nodes']]
```
:::

::: {.cell .markdown}
Setup BGP as the exterior routing protocol:
:::

::: {.cell .code}
```python
import re
for i, as_net in enumerate(out_as_net_conf):
    nodes=[slice.get_node(name=r['name']) for r in as_net['nodes']]
    print(as_net['nodes'][0])
    print(as_net['nodes'][1])
    for node_num, n in enumerate(nodes):
        as_no=int(re.search(r'as(\d+)-',n.get_name()).group(1))+1
        neighbor=as_net['nodes'][(node_num+1)%2]['addr']
        neighbor_as=int(as_net['nodes'][(1+node_num)%2]['name'][2])+1
        n.execute("sudo vtysh -E -c'configure terminal\nrouter bgp "+str(as_no)+ "00\nno bgp ebgp-requires-policy\nno bgp network import-check\nneighbor "+ neighbor + " remote-as " + str(neighbor_as) +"00\nredistribute ospf \nredistribute connected \nexit\nrouter ospf \nredistribute bgp \nredistribute connected \nexit\n exit'  ")  
 
        
```
:::


::: {.cell .markdown}

Validate the external routing by running ping across the network from first AS to last AS:
:::

::: {.cell .code}
```python
[(slice.get_node(name=net_conf[0]['nodes'][0]['name']).execute("ping -c 5 "+i['addr'])) for i in as_net_conf[-1]['nodes']]
```
:::
