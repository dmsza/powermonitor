# powermonitor
OpenWrt Power Outage Monitor Script

This script monitors power outages by pinging a network device that is not connected to a UPS. If the ping fails, it triggers a backup of the RRD (collectd) and vnStat databases.

This script can be set to start automatically via `rc.local`. The OpenWrt device must be connected to a UPS, making it useful for basic UPS units that lack USB or Ethernet ports for power outage detection.
