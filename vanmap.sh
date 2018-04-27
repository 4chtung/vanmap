#!/bin/bash
#VANMAP - A silly script to use in VA's to do all the nMap stuff.

clear

echo
echo
echo "██╗   ██╗ █████╗ ███╗   ██╗███╗   ███╗ █████╗ ██████╗ ██╗"
echo "██║   ██║██╔══██╗████╗  ██║████╗ ████║██╔══██╗██╔══██╗██║"
echo "██║   ██║███████║██╔██╗ ██║██╔████╔██║███████║██████╔╝██║"
echo "╚██╗ ██╔╝██╔══██║██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝ ╚═╝"
echo " ╚████╔╝ ██║  ██║██║ ╚████║██║ ╚═╝ ██║██║  ██║██║     ██╗"
echo "  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝"
echo "====================== TOOT! TOOT! ======================"
echo "====================== @4chtung ========================="
echo "=============== https://github.com/4chtung =============="
echo

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--targets)
    TARGETS="$2"
    shift # past arguement
    shift # past value
    ;;
    -e|--extended)
    EXT="Y"
    shift
    shift
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
esac
done

set -- "${POSITIONAL[@]}" #Restore Positional Parameters (Whatever that means, I stole this from StackOverflow)

echo TARGET FILE = "${TARGETS}"
if [[ "${EXT}" = "Y" ]]
then
    echo "EXTENDED MODE ON"
fi
sleep 5

######## BASIC NMAP SCANS ########

#SCAN ALL THE PORTS
nmap -v -T5 -Pn -sV -p- -iL ${TARGETS} -oA FullPortScan

#SCAN THE TOP 1000 PORTS WITH SCRIPTS
nmap -v -T5 -Pn -sV --script vuln --top-ports 1000 -iL ${TARGETS} -oA Top1000ScriptScan

#SCAN THE UDP PORTS
nmap -v -T5 -Pn -sU --top-ports 100 -iL ${TARGETS} -oA UDPScan

######## NESSUS RESULT BOLSTERS ########
#In future these will be a flag that chooses to run these tests to differenciate between scans and evidence.
#OH SNAP ITS THE FUTURE

if [[ "${EXT}" = "Y" ]]
then

#SCAN FOR ANONYMOUS FTP RESULTS
nmap -T5 -p 21 --script ftp-anon -iL ${TARGETS} -oA AnonFTP

#SCAN FOR RDP CIPHERS AND CONNECTION DETAILS
nmap -T5 -p 3389 --script rdp-enum-encryption -iL ${TARGETS} -oA RDPEnum

#SCAN FOR SMB SIGNING AS NESSUS NEVER DOES IT. I HATE IT SO MUCH.
nmap -T5 -p 445 --script smb-security-mode -iL ${TARGETS} -oA SMBSigning

fi

