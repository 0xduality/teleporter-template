// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ITeleporterReceiver} from "./interfaces/ITeleporterReceiver.sol";
import {ITeleporterRegistry} from "./interfaces/ITeleporterRegistry.sol";

/**
 * @dev Contract for receiving latest block hashes from another chain.
 */
contract SampleReceiver is ITeleporterReceiver {
    // Source chain information
    bytes32 public immutable sourceBlockchain;
    address public immutable sourceAddress;

    ITeleporterRegistry public immutable teleporterRegistry;

    // Latest received block information
    uint256 public latestBlockHeight;
    bytes32 public latestBlockHash;

    /**
     * @dev Emitted when a new block hash is received.
     */
    event ReceiveBlockHash(
        bytes32 indexed sourceBlockchainID,
        address indexed originSenderAddress,
        uint256 indexed blockHeight,
        bytes32 blockHash
    );

    constructor(
        address teleporterRegistryAddress,
        bytes32 publisherBlockchainID,
        address publisherContractAddress
    ) {
        require(teleporterRegistryAddress != address(0), "zero registry address");
        teleporterRegistry = ITeleporterRegistry(teleporterRegistryAddress);
        require(publisherContractAddress != address(0), "zero publisher address");
        sourceBlockchain = publisherBlockchainID;
        sourceAddress = publisherContractAddress;
    }

    /**
     * @dev Gets the latest received block height and hash.
     * @return Returns the latest block height and hash.
     */
    function getLatestBlockInfo() external view returns (uint256, bytes32) {
        return (latestBlockHeight, latestBlockHash);
    }

    /**
     * Receives the latest block hash from another chain
     *
     * Requirements:
     *
     * - Sender must be the Teleporter contract.
     * - Origin sender address and source blockchain must those specified during contract deployment.
     */
    function receiveTeleporterMessage(
        bytes32 sourceBlockchainID,
        address originSenderAddress,
        bytes calldata message
    ) external {
        require(msg.sender == address(teleporterRegistry.getLatestTeleporter()), "msg.sender!=teleporter");
        require(sourceBlockchain == sourceBlockchainID, "invalid source chain");
        require(originSenderAddress == sourceAddress, "invalid source contract");

        (uint256 blockHeight, bytes32 blockHash) = abi.decode(message, (uint256, bytes32));

        if (blockHeight > latestBlockHeight) {
            latestBlockHeight = blockHeight;
            latestBlockHash = blockHash;
            emit ReceiveBlockHash(sourceBlockchainID, originSenderAddress, blockHeight, blockHash);
        }
    }
}
