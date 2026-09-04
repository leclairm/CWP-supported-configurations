# Temporary space to store some of the future CWP supported configurations

No official support, just giving access to early users.

## Sirocco uenv

Current sirocco uenv

``` shell
uenv image pull build::sirocco/v0.1.0:2819584994
```

## Usage

Clone this repo and adapt the configuration. Then use some of the following. 
``` shell
uenv start sirocco
sirocco --help
sirocco start /path/to/sirocco.yaml
sirocco stop /path/to/sirocco.yaml
sirocco restart /path/to/sirocco.yaml
tail -f sirocco.log
```
