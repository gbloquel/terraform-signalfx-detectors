# SYSTEM Nagios status check SignalFx detectors

## How to use this module

```hcl
module "signalfx-detectors-nagios-status-check" {
  source      = "github.com/claranet/terraform-signalfx-detectors.git//system/nagios-status-check?ref={revision}"

  environment = var.environment
  notifications = var.notifications
}

```

## Purpose

Creates SignalFx detectors with the following checks:

- Custom script status

This module has been designed to alert with the same behavior as [Nagios](https://nagios-plugins.org/doc/guidelines.html#AEN78), basically a gauge which is equal to 1 will trigger à `WARNING` and equal to 2 a `CRITICAL`. 

On the agent side, you need to send your metrics with a metric named `gauge.status` in SignalFx, the `plugin_instance` dimension will allow you to find which script is failing. The easiest way to do that is to use the [exec collectd plugin](https://docs.signalfx.com/en/latest/integrations/agent/monitors/collectd-custom.html).

Here is an example : 

```yaml
- type: collectd/custom
  intervalSeconds: 30
  template: |
    LoadPlugin exec
    <Plugin exec>
       Exec "signalfx-agent" "/usr/local/bin/check-generic-status-nagios-plugin.sh" "/usr/local/bin/scripts/custom-nagios-script.pl"
    </Plugin>
```

The following script (`check-generic-status-nagios-plugin.sh` in the example above) takes a script path as an argument, execute it, check the output and send the status in the collectd format.

```bash
#!/bin/bash

INTERVAL="${COLLECTD_INTERVAL:-10}"
HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"

declare -A STATUS
STATUS=( ["OK"]=0 ["WARNING"]=1 ["CRITICAL"]=2 ["UNKNOWN"]=3 )

while sleep "$INTERVAL"
do
	out=$(exec $@)
	if [[ $out =~ "OK" ]]; then
		value=${STATUS["OK"]}
	elif [[ $out =~ "WARNING" ]]; then
		value=${STATUS["WARNING"]}
	elif [[ $out =~ "CRITICAL" ]]; then
		value=${STATUS["CRITICAL"]}
	else 
		value=${STATUS["UNKNOWN"]}
	fi
	script=$(basename $1)
	echo "PUTVAL ${HOSTNAME}/nagios-${script%.*}/gauge-status interval=${INTERVAL} N:${value}"
done
```

## Related documentation

[Official documentation for the custom plugin](https://docs.signalfx.com/en/latest/integrations/agent/monitors/collectd-custom.html)
[Nagios documentation](https://nagios-plugins.org/doc/guidelines.html#AEN78)
[Collectd plain text protocol](https://collectd.org/wiki/index.php/Plain_text_protocol)
