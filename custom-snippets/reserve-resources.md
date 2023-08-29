
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
        site_name = fablib.get_random_site(avoid=[''] + as_sites)
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
     for n in r[1]: # iterate over the nodes_conf for this AS
        slice.add_node(name=n['name'], site=as_sites[i], 
                       cores=n['cores'], 
                       ram=n['ram'], 
                       disk=n['disk'], 
                       image=n['image'])
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
for n in net_conf:
    ifaces = [slice.get_node(node["name"]).add_component(model="NIC_Basic", 
                                                 name=n["name"]).get_interfaces()[0] for node in n['nodes'] ]
    slice.add_l2network(name=n["name"], interfaces=ifaces)
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
