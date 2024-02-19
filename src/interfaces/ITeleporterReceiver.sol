// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ITeleporterReceiver {
    function receiveTeleporterMessage(
        bytes32 sourceBlockchainID,
        address originSenderAddress,
        bytes memory message
    ) external;
}
