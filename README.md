# check_snmp_sanbox5800
Plugin to monitor several things on the SanBox 5800 (QLogic) switch. 

## Setup

1. First you have to enable SNMP on your device to make a snmp request possible
2. Install the packags snmpwalk on your system
3. Have fun with the plugin

##Info 

Default warnig level is 40 and default critical level is 50.

##Usage

```bash
Usage: ./check_snmp_sanbox5800.sh -H host [-U username -P password]|[-C community] -T status|power|temperatureX (X=1,2,3,4)|uptime|location -w warningValue -c criticalValue
                If username and password is supplied, SNMPv3 is used
                If community supplied, SNMPv1 is used

                Example:
                        /check_snmp_sanbox5800.sh -H 10.28.11.12 -T temperature1 -C public -w 40 -c 50
                        /check_snmp_sanbox5800.sh -H 10.28.11.12 -U test -P secret -T status
```


#Note

Forked from https://exchange.nagios.org/directory/Plugins/Hardware/Network-Gear/HP/check_snmp_hpv1910/details 
