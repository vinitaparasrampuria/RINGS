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

        
