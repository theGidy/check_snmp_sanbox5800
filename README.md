# check_snmp_sanbox5800
Plugin to monitor several things on the SanBox 5800 (QLogic) switch. 

# OpenSoruce Release on
https://github.com/theGidy/check_snmp_sanbox5800

## Setup
Install the packags snmpwalk on your system and copy the script to your icinga plugin folder

## Configuration
Enable SNMP on your devive. It's recommende to use at lease SNMPv2. You should grant the SNMPv2 user read permissions and no write permissions. 

__Note:__ With SNMPv2 there is no password encryption! 

## Default Values

* __Warning:__ 40
* __Ciritcal:__ 50

## Usage

```bash
Usage: ./check_snmp_sanbox5800.sh -H host [-U username -P password]|[-C community] -T status|power|temperatureX (X=1,2,3,4)|uptime|location -w warningValue -c criticalValue
                If username and password is supplied, SNMPv3 is used
                If community supplied, SNMPv1 is used

                Example:
                        /check_snmp_sanbox5800.sh -H 10.28.11.12 -T temperature1 -C public -w 40 -c 50
                        /check_snmp_sanbox5800.sh -H 10.28.11.12 -U test -P secret -T status
```


# Note

Forked from https://exchange.nagios.org/directory/Plugins/Hardware/Network-Gear/HP/check_snmp_hpv1910/details 
