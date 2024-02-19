#!/bin/bash
set -u -e -x

# compute sender address
forge script script/DeploySender.s.sol -f primary --json
SENDER_ADDRESS=$(jq -r '.returns.deployed.value' broadcast/DeploySender.s.sol/43113/dry-run/run-latest.json)
# deploy sender
forge script script/DeploySender.s.sol -f primary --json --broadcast --skip-simulation
# verify sender
forge verify-contract --watch --chain 43113 ${SENDER_ADDRESS} src/SampleSender.sol:SampleSender --constructor-args 0xEeeAA8e0e25802A3748Cd7FbFA96b851E76DFF9b

# compute receiver address
SENDER=${SENDER_ADDRESS} forge script script/DeployReceiver.s.sol -f echo --json
RECEIVER_ADDRESS=$(jq -r '.returns.deployed.value' broadcast/DeployReceiver.s.sol/173750/dry-run/run-latest.json)
# deploy receiver
SENDER=${SENDER_ADDRESS} forge script script/DeployReceiver.s.sol -f echo --json --broadcast --skip-simulation

# send transaction
source .env && cast send -r primary ${SENDER_ADDRESS} 'publishLatestBlockHash(bytes32,address)' 1278d1be4b987e847be3465940eb5066c4604a7fbd6e086900823597d81af4c1 ${RECEIVER_ADDRESS} --private-key=$PRIVATE_KEY

# Ensure that the destination has been updated before reading it
sleep 4

# read info at destination
cast call -r echo ${RECEIVER_ADDRESS} 'getLatestBlockInfo() (uint256, bytes32)'
