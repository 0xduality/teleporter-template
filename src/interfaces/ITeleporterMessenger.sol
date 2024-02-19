// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface ITeleporterMessenger {
    function addFeeAmount(bytes32 messageID, address feeTokenAddress, uint256 additionalFeeAmount) external;

    function checkRelayerRewardAmount(address relayer, address feeTokenAddress) external view returns (uint256);

    function getFeeInfo(bytes32 messageID) external view returns (address, uint256);

    function getMessageHash(bytes32 messageID) external view returns (bytes32);

    function getNextMessageID(bytes32 destinationBlockchainID) external view returns (bytes32);

    function getReceiptAtIndex(bytes32 sourceBlockchainID, uint256 index)
        external
        view
        returns (TeleporterMessageReceipt memory);

    function getReceiptQueueSize(bytes32 sourceBlockchainID) external view returns (uint256);

    function getRelayerRewardAddress(bytes32 messageID) external view returns (address);

    function messageReceived(bytes32 messageID) external view returns (bool);

    function receiveCrossChainMessage(uint32 messageIndex, address relayerRewardAddress) external;

    function redeemRelayerRewards(address feeTokenAddress) external;

    function retryMessageExecution(bytes32 sourceBlockchainID, TeleporterMessage memory message) external;

    function retrySendCrossChainMessage(TeleporterMessage memory message) external;

    function sendCrossChainMessage(TeleporterMessageInput memory messageInput) external returns (bytes32);

    function sendSpecifiedReceipts(
        bytes32 sourceBlockchainID,
        bytes32[] memory messageIDs,
        TeleporterFeeInfo memory feeInfo,
        address[] memory allowedRelayerAddresses
    ) external returns (bytes32);

    event AddFeeAmount(bytes32 indexed messageID, TeleporterFeeInfo updatedFeeInfo);
    event BlockchainIDInitialized(bytes32 indexed blockchainID);
    event MessageExecuted(bytes32 indexed messageID, bytes32 indexed sourceBlockchainID);
    event MessageExecutionFailed(
        bytes32 indexed messageID, bytes32 indexed sourceBlockchainID, TeleporterMessage message
    );
    event ReceiptReceived(
        bytes32 indexed messageID,
        bytes32 indexed destinationBlockchainID,
        address indexed relayerRewardAddress,
        TeleporterFeeInfo feeInfo
    );
    event ReceiveCrossChainMessage(
        bytes32 indexed messageID,
        bytes32 indexed sourceBlockchainID,
        address indexed deliverer,
        address rewardRedeemer,
        TeleporterMessage message
    );
    event RelayerRewardsRedeemed(address indexed redeemer, address indexed asset, uint256 amount);
    event SendCrossChainMessage(
        bytes32 indexed messageID,
        bytes32 indexed destinationBlockchainID,
        TeleporterMessage message,
        TeleporterFeeInfo feeInfo
    );
}

struct TeleporterMessageReceipt {
    uint256 receivedMessageNonce;
    address relayerRewardAddress;
}

struct TeleporterMessage {
    uint256 messageNonce;
    address originSenderAddress;
    bytes32 destinationBlockchainID;
    address destinationAddress;
    uint256 requiredGasLimit;
    address[] allowedRelayerAddresses;
    TeleporterMessageReceipt[] receipts;
    bytes message;
}

struct TeleporterFeeInfo {
    address feeTokenAddress;
    uint256 amount;
}

struct TeleporterMessageInput {
    bytes32 destinationBlockchainID;
    address destinationAddress;
    TeleporterFeeInfo feeInfo;
    uint256 requiredGasLimit;
    address[] allowedRelayerAddresses;
    bytes message;
}
