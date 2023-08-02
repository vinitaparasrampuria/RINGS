
::: {.cell .markdown}
# Reserve and configure FABRIC resources for "setting a network of Autonomous systems"

In the experiment setup, we try to emulate the real world network by designing a network of various autonomous systems spread across different sites available on FABRIC testbed.

## Set up your FABRIC environment

This assumes that you have already configured your FABRIC account and your Jupyter environment as described in [Hello, FABRIC](https://teaching-on-testbeds.github.io/blog/hello-fabric).
:::


::: {.cell .code}
```python
from fabrictestbed_extensions.fablib.fablib import FablibManager as fablib_manager
fablib = fablib_manager() 
fablib.show_config()
```
:::


::: {.cell .code}
```python
!chmod 600 {fablib.get_bastion_key_filename()}
!chmod 600 {fablib.get_default_slice_private_key_file()}
```
:::

::: {.cell .markdown}
## Create and submit a slice
:::

::: {.cell .code}
```python
slice_name="network-"+ fablib.get_bastion_username()
slice = fablib.new_slice(name=slice_name)
```
:::


