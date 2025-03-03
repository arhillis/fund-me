// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    HelperConfig helperConfig = new HelperConfig();
    address ethUSDpriceFeed = helperConfig.activeConfig();

    FundMe fundMe;

    function run() external returns (FundMe) {
        vm.startBroadcast();
        fundMe = new FundMe(ethUSDpriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}