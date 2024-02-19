// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {DeployScriptBase} from "./utils/DeployScriptBase.sol";
import {stdJson} from "forge-std/Script.sol";
import {SampleSender} from "src/SampleSender.sol";
import {console} from "forge-std/console.sol";

contract DeplySender is DeployScriptBase {
    using stdJson for string;

    constructor() DeployScriptBase() {}

    function run() public returns (SampleSender deployed) {
        vm.startBroadcast(deployerPrivateKey);

        deployed = new SampleSender(0xEeeAA8e0e25802A3748Cd7FbFA96b851E76DFF9b);

        vm.stopBroadcast();
    }
}
