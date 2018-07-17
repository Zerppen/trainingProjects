#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

echo "POST request Enroll on jywy  ..."
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Jim&orgName=jywy')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "JYWY token is $ORG1_TOKEN"
echo
echo "POST request Enroll on yh ..."
echo
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Barry&orgName=yh')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "YH token is $ORG2_TOKEN"
echo
echo "POST request Enroll on zfjg ..."
echo
ORG3_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Mike&orgName=zfjg')
echo $ORG2_TOKEN
ORG3_TOKEN=$(echo $ORG3_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ZFJG token is $ORG3_TOKEN"
echo
echo
echo "POST request Create channel  ..."
echo

curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"yhchannel",
	"channelConfigPath":"../yhartifacts/channel/channel.tx"
}'
echo
echo
sleep 5
echo "POST request Join channel on jywy"
echo
curl -s -X POST \
  http://localhost:4000/channels/yhchannel/peers \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo

echo "POST request Join channel on yh"
echo
curl -s -X POST \
  http://localhost:4000/channels/yhchannel/peers \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo

echo "POST request Join channel on zfjg"
echo
curl -s -X POST \
  http://localhost:4000/channels/yhchannel/peers \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
        "peers": ["peer1","peer2"]
}'
echo
echo

echo "POST Install chaincode on jywy"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"turbot",
	"chaincodePath":"github.com/chaincode",
	"chaincodeVersion":"v0"
}'
echo
echo


echo "POST Install chaincode on yh"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"turbot",
	"chaincodePath":"github.com/chaincode",
	"chaincodeVersion":"v0"
}'
echo
echo

echo "POST Install chaincode on zfjg"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
        "peers": ["peer1","peer2"],
        "chaincodeName":"turbot",
        "chaincodePath":"github.com/chaincode",
        "chaincodeVersion":"v0"
}'
echo
echo

echo "POST instantiate chaincode on peer1 of jywy"
echo
curl -s -X POST \
  http://localhost:4000/channels/yhchannel/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"turbot",
	"chaincodeVersion":"v0",
	"args":[]
}'
echo
echo

#echo "POST invoke chaincode on peers of Org1 and Org2"
#echo
#TRX_ID=$(curl -s -X POST \
#  http://localhost:4000/channels/mychannel/chaincodes/mycc \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json" \
#  -d '{
#	"fcn":"move",
#	"args":["a","b","10"]
#}')
#echo "Transacton ID is $TRX_ID"
#echo
#echo
#
#echo "GET query chaincode on peer1 of Org1"
#echo
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo
#
#echo "GET query Block by blockNumber"
#echo
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel/blocks/1?peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo
#
#echo "GET query Transaction by TransactionID"
#echo
#curl -s -X GET http://localhost:4000/channels/mychannel/transactions/$TRX_ID?peer=peer1 \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo

############################################################################
### TODO: What to pass to fetch the Block information
############################################################################
#echo "GET query Block by Hash"
#echo
#hash=????
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel/blocks?hash=$hash&peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "cache-control: no-cache" \
#  -H "content-type: application/json" \
#  -H "x-access-token: $ORG1_TOKEN"
#echo
#echo

#echo "GET query ChainInfo"
#echo
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel?peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo
#
#echo "GET query Installed chaincodes"
#echo
#curl -s -X GET \
#  "http://localhost:4000/chaincodes?peer=peer1&type=installed" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo
#
#echo "GET query Instantiated chaincodes"
#echo
#curl -s -X GET \
#  "http://localhost:4000/chaincodes?peer=peer1&type=instantiated" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo
#
#echo "GET query Channels"
#echo
#curl -s -X GET \
#  "http://localhost:4000/channels?peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "content-type: application/json"
#echo
#echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
