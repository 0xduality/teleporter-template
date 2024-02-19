// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
pragma experimental ABIEncoderV2;

interface ITeleporterRegistry {
    function MAX_VERSION_INCREMENT() external view returns (uint256);

    function VALIDATORS_SOURCE_ADDRESS() external view returns (address);

    function WARP_MESSENGER() external view returns (address);

    function addProtocolVersion(uint32 messageIndex) external;

    function blockchainID() external view returns (bytes32);

    function getAddressFromVersion(uint256 version) external view returns (address);

    function getLatestTeleporter() external view returns (address);

    function getTeleporterFromVersion(uint256 version) external view returns (address);

    function getVersionFromAddress(address protocolAddress) external view returns (uint256);

    function latestVersion() external view returns (uint256);

    event AddProtocolVersion(uint256 indexed version, address indexed protocolAddress);
    event LatestVersionUpdated(uint256 indexed oldVersion, uint256 indexed newVersion);
}

struct ProtocolRegistryEntry {
    uint256 version;
    address protocolAddress;
}
