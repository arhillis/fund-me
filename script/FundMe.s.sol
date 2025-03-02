// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    FundMe fundMe;

    function run(address feedAddress) external returns (FundMe) {
        vm.startBroadcast();
        fundMe = new FundMe(feedAddress);
        vm.stopBroadcast();
        return fundMe;
    }
}