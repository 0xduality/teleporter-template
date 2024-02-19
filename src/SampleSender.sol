// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ITeleporterMessenger, TeleporterMessageInput, TeleporterFeeInfo} from "./interfaces/ITeleporterMessenger.sol";
import {ITeleporterRegistry} from "./interfaces/ITeleporterRegistry.sol";

/**
 * @dev Contract that publishes the latest block hash of current chain to another chain.
 */
contract SampleSender {
    // The gas limit required to receive a block hash on the destination chain.
    uint256 public constant RECEIVE_BLOCK_HASH_REQUIRED_GAS_LIMIT = 150_000;

    // The Teleporter registry contract manages different Teleporter contract versions.
    ITeleporterRegistry public immutable teleporterRegistry;

    /**
     * @dev Emitted when a block hash is submitted to be published to another chain.
     */
    event PublishBlockHash(
        bytes32 indexed destinationBlockchainID,
        address indexed destinationAddress,
        uint256 indexed blockHeight,
        bytes32 blockHash
    );

    constructor(address teleporterRegistryAddress) {
        require(
            teleporterRegistryAddress != address(0),
            "BlockHashPublisher: zero teleporter registry address"
        );

        teleporterRegistry = ITeleporterRegistry(teleporterRegistryAddress);
    }

    /**
     * @dev Publishes the latest block hash to another chain.
     * @return The hash of the message sent.
     */
    function publishLatestBlockHash(
        bytes32 destinationBlockchainID,
        address destinationAddress
    ) external returns (bytes32) {
        // Get the latest block info. Note it must the previous block
        // because the current block hash is not available during execution.
        uint256 blockHeight = block.number - 1;
        bytes32 blockHash = blockhash(blockHeight);

        // ABI encode the function arguments to be called on the destination.
        bytes memory messageData = abi.encode(blockHeight, blockHash);

        emit PublishBlockHash(destinationBlockchainID, destinationAddress, blockHeight, blockHash);

        return ITeleporterMessenger(teleporterRegistry.getLatestTeleporter()).sendCrossChainMessage(
            TeleporterMessageInput({
                destinationBlockchainID: destinationBlockchainID,
                destinationAddress: destinationAddress,
                feeInfo: TeleporterFeeInfo({feeTokenAddress: address(0), amount: 0}),
                requiredGasLimit: RECEIVE_BLOCK_HASH_REQUIRED_GAS_LIMIT,
                allowedRelayerAddresses: new address[](0),
                message: messageData
            })
        );
    }
}