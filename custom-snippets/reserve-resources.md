
::: {.cell .markdown}
### Set up the routers and networks

First we will create a function that will generate an autonomous system along with the node configuration, net configuration, resource requirement data.
:::


::: {.cell .code}
```python

# Get the sites
as_sites = []
for i,r in enumerate(data_routers):   
    while True:
        site_name = fablib.get_random_site(avoid=sites + as_sites)
        if ( (fablib.resources.get_core_available(site_name) > 1.2*r[3]['cores']) and
            (fablib.resources.get_component_available(site_name, 'SharedNIC-ConnectX-6') > 1.2**r[3]['nic']) ):
            break

    print(f"AS {i} will use {site_name}")
    #fablib.show_site(site_name)
    as_sites.append(site_name)

```
:::

::: {.cell .code}
```python
print(as_sites)
```
:::


::: {.cell .code}
```python
for i,r in enumerate(data_routers):
     for rtr in r[1]: # iterate over the nodes_conf for this AS
        slice.add_node(name=rtr['name'], site=as_sites[i], 
                       cores=rtr['cores'], 
                       ram=rtr['ram'], 
                       disk=rtr['disk'], 
                       image=rtr['image'])
```
:::




::: {.cell .code}
```python
print(slice.list_nodes())
```
:::


::: {.cell .code}
```python
# this cell sets up the network links 
for i,r in enumerate(data_routers):
     for net in r[2]: # iterate over net_conf for each AS
        ifaces = [slice.get_node(node["name"]).add_component(model="NIC_Basic", 
                                                     name=net["name"]).get_interfaces()[0] for node in net['nodes'] ]
        slice.add_l2network(name=net["name"], type='L2Bridge', interfaces=ifaces)
```
:::


::: {.cell .code}
```python
slice.submit()
```
:::


::: {.cell .code}
```python
slice.get_state()
slice.wait_ssh(progress=True)
```
:::
