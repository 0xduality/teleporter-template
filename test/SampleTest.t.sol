// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";

import {SampleSender} from "src/SampleSender.sol";
import {SampleReceiver} from "src/SampleReceiver.sol";

contract SampleTest is Test {
    SampleSender sender;
    SampleReceiver receiver;
    bytes32 cChainId = hex"7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5";
    bytes32 echoChainId = hex"1278d1be4b987e847be3465940eb5066c4604a7fbd6e086900823597d81af4c1";
    uint256 primaryForkId;
    uint256 echoForkId;

    function setUp() public {
        primaryForkId = vm.createFork("primary");
        echoForkId = vm.createFork("echo");

        vm.selectFork(primaryForkId);
        sender = new SampleSender(0xEeeAA8e0e25802A3748Cd7FbFA96b851E76DFF9b);
        vm.selectFork(echoForkId);
        receiver = new SampleReceiver(0xEeeAA8e0e25802A3748Cd7FbFA96b851E76DFF9b, cChainId, address(sender));
    }

    function testSend() public {
        vm.selectFork(primaryForkId);
        //Keep this line until foundry is aware of the warp precompile
        vm.expectRevert();
        sender.publishLatestBlockHash(echoChainId, address(receiver));
    }
}
