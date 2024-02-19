// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {stdJson} from "forge-std/Script.sol";
import {SampleSender} from "src/SampleSender.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {SampleSender} from "src/SampleSender.sol";

contract PostDeployScript is Script {
    using stdJson for string;

    bytes32 cChainId = hex"7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5";
    bytes32 echoChainId = hex"1278d1be4b987e847be3465940eb5066c4604a7fbd6e086900823597d81af4c1";

    constructor() {}

    function run() public {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
        address receiver = vm.envAddress("RECEIVER");
        SampleSender sender = SampleSender(vm.envAddress("SENDER"));

        vm.startBroadcast(deployerPrivateKey);
        sender.publishLatestBlockHash(echoChainId, receiver);
        vm.stopBroadcast();
    }
}
