// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {ArcPay} from "../src/ArcPay.sol";

contract Deploy is Script {
    function run() external returns (ArcPay pay) {
        vm.startBroadcast();
        pay = new ArcPay();
        vm.stopBroadcast();
        console.log("ArcPay deployed at", address(pay));
    }
}
