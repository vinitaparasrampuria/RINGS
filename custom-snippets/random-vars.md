
::: {.cell .markdown}
### Set up the variables

Next, we will set up the variables- number of autonomous sytems in the network, number of routers in each autonomous system, whether a system in CDN or not and the hops at which redundancy can be seen.
:::


::: {.cell .code}
```python
import random
#number of routers in access network similar irrespective of cdn or not
#redundancy_AS_1 parameter sets the hop at which redundant paths will be set
hops_AS_1=random.randint(3,6)
redundancy_AS_1=3

# For cdn, define
# number of autonomous systems including source and target AS (ranges between 2-4)
# hops seen in destination network (ranges between 3-4)
# hops seen in intermediate network (ranges bewteen 1-2)

number_of_AS_cdn=random.randint(2,4)
hops_final_AS_cdn=random.randint(3,4)
max_hops_intermediate_cdn=3

# For non CDN, define
# number of autonomous systems including source and target AS (ranges between 3-5)
# hops seen in destination network (ranges between 5-8)
# hops seen in intermediate network (ranges bewteen 1-4)

number_of_AS_not_cdn=random.randint(3,5)
hops_final_AS_not_cdn=random.randint(5,8)
max_hops_intermediate_not_cdn=4

# Set cdn=True if CDN type opf network is required else False
cdn=True
sites=['NCSA', 'GATECH', 'WASH', 'GPN', 'INDI', 'SALT', 'CERN', 'MICH', 'DALL', 'STAR', 'EDC', 'PSC']
```
:::

::: {.cell .markdown}
Print all the parameters that were setup randomly.
:::


::: {.cell .code}
```python
# Print all the parameters:
print("Hops in first AS: ", hops_AS_1)
print("Number of AS: ", number_of_AS_cdn if cdn else number_of_AS_not_cdn)
print("Hops in final AS: ", hops_final_AS_cdn if cdn else hops_final_AS_not_cdn )
```
:::


