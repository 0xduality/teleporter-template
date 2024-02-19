// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IWarpMessenger {
    function getBlockchainID() external view returns (bytes32 blockchainID);

    function getVerifiedWarpBlockHash(uint32 index)
        external
        view
        returns (WarpBlockHash memory warpBlockHash, bool valid);

    function getVerifiedWarpMessage(uint32 index) external view returns (WarpMessage memory message, bool valid);

    function sendWarpMessage(bytes memory payload) external returns (bytes32 messageID);

    event SendWarpMessage(address indexed sender, bytes32 indexed messageID, bytes message);
}

struct WarpBlockHash {
    bytes32 sourceChainID;
    bytes32 blockHash;
}

struct WarpMessage {
    bytes32 sourceChainID;
    address originSenderAddress;
    bytes payload;
}
