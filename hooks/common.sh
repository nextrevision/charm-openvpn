#!/bin/bash
# Set static variables
EASY_RSA=/etc/openvpn/easy-rsa
PKITOOL=$EASY_RSA/pkitool
SERVER_CONF=/etc/openvpn/server.conf
CLIENT_CONF=/etc/openvpn/client.conf

# Convert a CIDR notation to netmask
# Adapted from:
#   https://www.linuxquestions.org/questions/programming-9/bash-cidr-calculator-646701/#post3433298
#
function convert_cidr {
  local i netmask=""
  local cidr=$1
  local abs=$(($cidr/8))
  for ((i=0;i<4;i+=1)); do
    if [ $i -lt $abs ]; then
      netmask+="255"
    elif [ $i -eq $abs ]; then
      netmask+=$((256 - 2**(8-$(($cidr%8)))))
    else
      netmask+=0
    fi
    test $i -lt 3 && netmask+="."
  done
  echo $netmask
}

function parse_network {
  local full_net=$1
  local network=`echo ${full_net} | cut -d'/' -f1`
  local cidr=`echo ${full_net} | cut -d'/' -f2`
  cidr=`convert_cidr ${cidr}`
  echo "${network} ${cidr}"
}
