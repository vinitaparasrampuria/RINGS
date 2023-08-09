
::: {.cell .markdown}
### Reserve resources

Now we will get a list of sites that has sufficient resources for the experiment.
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

::: {.cell .markdown}

Then we will add hosts and network segments
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

for i,r in enumerate(as_net_conf):
    iface1 = slice.get_node(r['nodes'][0]['name']).add_component(model='NIC_Basic', name=r['net-name']).get_interfaces()[0]
    iface2 = slice.get_node(r['nodes'][1]['name']).add_component(model='NIC_Basic', name=r['net-name']).get_interfaces()[0]
    slice.add_l2network(name=r['net-name'], interfaces=[iface1, iface2])
```
:::


::: {.cell .markdown}

The following cell submits our request to the FABRIC site. The output of this cell will update automatically as the status of our request changes.
While it is being prepared, the "State" of the slice will appear as "Configuring".
When it is ready, the "State" of the slice will change to "StableOK".
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
