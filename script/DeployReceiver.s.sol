// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {DeployScriptBase} from "./utils/DeployScriptBase.sol";
import {stdJson} from "forge-std/Script.sol";
import {SampleReceiver} from "src/SampleReceiver.sol";

contract DeployReceiver is DeployScriptBase {
    using stdJson for string;

    bytes32 cChainId = hex"7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5";
    bytes32 echoChainId = hex"1278d1be4b987e847be3465940eb5066c4604a7fbd6e086900823597d81af4c1";

    constructor() DeployScriptBase() {}

    function run() public returns (SampleReceiver deployed) {
        address sender = vm.envAddress("SENDER");

        vm.startBroadcast(deployerPrivateKey);

        deployed = new SampleReceiver(0xEeeAA8e0e25802A3748Cd7FbFA96b851E76DFF9b, cChainId, sender);

        vm.stopBroadcast();
    }
}
