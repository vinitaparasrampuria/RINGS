
::: {.cell .markdown}
### Set up the routers and networks

First we will create a function that will generate an autonomous system along with the node configuration, net configuration, resource requirement data.
:::


::: {.cell .code}
```python

def create_AS(as_num, n_hops, r):
    routers=[1]*min(r, n_hops) + [random.randint(2,3) for i in range(max(0, n_hops - r - 1))] + [1 for i in range(0,1) if n_hops!=r]
    node_conf = [ {'name': "as" + str(as_num) + '-r-' + str(j) + '-' + str(i) ,
        'cores': 8, 'ram': 16, 'disk': 25, 'image': 'default_ubuntu_22', 'packages': ['net-tools']}
         for j,level in enumerate(routers) for i in range(level)]
    r_mul=[0]+[routers[i-1]*routers[i] for i in range(1,len(routers))]
    net_conf = [
     {"name": "as"+str(as_num)+"-net"+str(j)+str(i)+"-"+str(j+1)+str(k), "subnet": "10."+str(as_num)+"."+str(sum(r_mul[:j+1])+(routers[j+1]*i)+k+1)+".0/24", 
      "nodes": [{"name": "as"+str(as_num)+'-r-' + str(j) + '-' + str(i),   "addr": "10."+str(as_num)+"."+str(sum(r_mul[:j+1])+(routers[j+1]*i)+k+1)+"."+str(1)} ]+ 
      [{"name": "as"+str(as_num)+'-r-' + str(j+1) + '-' + str(k),   "addr": "10."+str(as_num)+"."+str(sum(r_mul[:j+1])+(routers[j+1]*i)+k+1)+"."+str(2)}]}
            for j,level in enumerate(routers[:-1]) for i in range(level) for k in range(routers[j+1])]
    exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes'])+2 for n in net_conf]) }
    return [routers, node_conf, net_conf, exp_conf]

```
:::

::: {.cell .markdown}

Next, we will call create_AS() function to generate the number of autonomous systems which was defined in one of the previous cell.
:::

::: {.cell .code}
```python
if cdn:
    number_of_AS=number_of_AS_cdn
    hops_final_AS=hops_final_AS_cdn
    max_hops_intermediate=max_hops_intermediate_cdn
    
else:    
    number_of_AS=number_of_AS_not_cdn
    hops_final_AS=hops_final_AS_not_cdn
    max_hops_intermediate=max_hops_intermediate_not_cdn


# set up the number of routers in first AS

data_routers=[create_AS(0, hops_AS_1, redundancy_AS_1)]

  
# set up the number of routers in intermediate AS
# hops in intermediate AS is randomly selected between 1 and max_hops_intermediate value
# redundant path can start at any value between 2nd hop and hops_intermediate-1 in the intermediate AS

for i in range(1, number_of_AS-1):
    hops_intermediate=random.randint(1,max_hops_intermediate)
    print(hops_intermediate)
    data_routers+=[create_AS(i, hops_intermediate, r=random.randint(1,hops_intermediate))]

# set up the number of routers in Destination AS
# redundant path can start at any value between 2nd hop and hops_final_AS-1 in the destination AS
data_routers+=[create_AS(number_of_AS-1, hops_final_AS, random.randint(1,hops_final_AS))]

```
:::

::: {.cell .code}
```python
node_conf = [node for as_conf in data_routers for node in as_conf[1]]
node_conf
```
:::



::: {.cell .code}
```python
net_conf = [net for as_conf in data_routers for net in as_conf[2]]
net_conf
```
:::


::: {.cell .code}
```python
# as_net_conf=[{"net-name":"ext-net"+str(i)+"-"+str(i+1), "subnet": "100."+str(i)+"."+str(i+1)+".0/24",
#               "nodes": [{"name":r[1][-1]['name'], "addr":"100."+str(i)+"."+str(i+1)+".1"}]+
#               [{"name":data_routers[i+1][1][0]['name'], "addr":"100."+str(i)+"."+str(i+1)+".2"}]}
#               for i, r in enumerate(data_routers[:-1])]


as_net_conf=[{"net-name":"ext-net"+str(i)+"-"+str(i+1), "subnet": "192.168."+str(i+1)+str(i)+".0/24",
              "nodes": [{"name":r[1][-1]['name'], "addr":"192.168."+str(i+1)+str(i)+".1"}]+
              [{"name":data_routers[i+1][1][0]['name'], "addr":"192.168."+str(i+1)+str(i)+".2"}]}
              for i, r in enumerate(data_routers[:-1])]

```
:::

::: {.cell .code}go
```python
as_net_conf
```
:::
