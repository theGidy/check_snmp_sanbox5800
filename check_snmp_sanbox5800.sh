#!/bin/sh

# 2014-07-03
# Author: Philipp Posovszk <Philipp.Posovszky@dlr.de/Ph.Posovszky@gmail.com>
#
# Version: v1.0.0

BASEOID=.1.3.6.1

# Status OID
statusOID=$BASEOID.3.94.1.8.1.6

# Overall Status MIB
locationOID=$BASEOID.2.1.1.6.0
uptimeOID=$BASEOID.2.1.1.3.0

Warning=40
Critical=50

usage()
{
	echo "Usage: $0 -H host [-U username -P password]|[-C community] -T status|power|temperatureX (X=1,2,3,4)|uptime|location -w warningValue -c criticalValue"
	echo "		If username and password is supplied, SNMPv3 is used";
	echo "		If community supplied, SNMPv1 is used";
	echo "		";
	echo "		Example:";
	echo "			/check_snmp_sanbox5800.sh -H 10.28.11.12 -T temperature1 -C public -w 40 -c 50 ";
	echo "			/check_snmp_sanbox5800.sh -H 10.28.11.12 -U user -P secret -T temperature1 -w 40 -c 50 ";
	exit 0
}

get_integer()
{
        echo "$INT"|/bin/grep "^$2.*$1 = "|/bin/sed -e 's,^.*: ,,'|/usr/bin/tr -d '"' 
}

get_timeticks()
{
        echo "$TIME"|/bin/grep "^$2.*$1 = "| /bin/sed -e 's,^.*: (,,'| /bin/sed -e 's,).*,,'|/usr/bin/tr -d '"'
}

get_days()
{
        echo "$TIME"|/bin/grep "^$2.*$1 = "| /bin/sed -e 's,^.*: ([0-9]*) ,,'
}

check_temp()
{
	Temp=`get_integer|/bin/sed 's/ degrees C//'`
	if test "$Temp" -ge "$Critical"; then
		RESULT="Fatal temperature $Temp"
		STATUS=2
	elif test "$Temp" -ge "$Warning"; then
		RESULT="Warning temperature $Temp"
		STATUS=1
	else
		RESULT="Temperature $Temp C"
	fi
	PERFDATA="${PERFDATA}Temperature=$Temp'C';$Warning;$Critical;; "

}

if test "$1" = -h; then
	usage
fi

while getopts "H:U:P:C:T:w:c:n" o; do
	case "$o" in
	H )
		HOST="$OPTARG"
		;;
	P )
		PASSWORD="$OPTARG"
		;;
	U )
		USERNAME="$OPTARG"
		;;
	T )
		TEST="$OPTARG"
		;;
	C )
		COMMUNITY="$OPTARG"
		;;
	w )
		Warning="$OPTARG"
		;;
	c )
		Critical="$OPTARG"
		;;
	* )
		usage
		;;
	esac
done

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
	SNMP="/usr/bin/snmpwalk -t 15 -r 4 -v 3 -l authNoPriv -u $USERNAME -A $PASSWORD -On $HOST"
elif [ -n "$COMMUNITY" ]; then
	SNMP="/usr/bin/snmpwalk -t 15 -r 4 -v 1 -c $COMMUNITY -On $HOST"
else
	usage
fi	


RESULT=
STATUS=0	# OK

case "$TEST" in
uptime )
        TIME=`$SNMP $uptimeOID`
        UPTIME=`get_days`
        RESULT=$UPTIME;
        ;;
location )
        INT=`$SNMP $locationOID`
        LOCATION=`get_integer`
        RESULT=$LOCATION
        ;;

power )
	INT=`$SNMP $statusOID|/bin/sed -n 1p`
	Power=`get_integer`
	if test "$Power" = "Good"; then
		RESULT="Power $Power"
	else
		RESULT="Power $Power"
		STATUS=2
	fi
	;;
status )
	INT=`$SNMP $statusOID|/bin/sed -n 2p`
	Temp=`get_integer`
	if test "$Temp" = "Normal"; then
		RESULT="Temperature $Temp"
	else
		RESULT="Temperature $Temp"
		STATUS=2
	fi
	;;
temperature1 )
	INT=`$SNMP $statusOID|/bin/sed -n 3p`
	check_temp
	;;
temperature2 )
	INT=`$SNMP $statusOID|/bin/sed -n 4p`
	check_temp
	;;
temperature3 )
	INT=`$SNMP $statusOID|/bin/sed -n 5p`
	check_temp
	;;
temperature4 )
	INT=`$SNMP $statusOID|/bin/sed -n 6p`
	check_temp
	;;
* )
	STATUS=3
	RESULT="No valide parameter -T $TEST"
esac

echo "$RESULT|$PERFDATA"
exit $STATUS 
