// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script{
    function run() external returns (FundMe){
        vm.startBroadcast();
        address priceFeedAddress = 0x1AE6Fb04d94369F4C19D6F4349be5E937f5BA8D0;
        FundMe fundMe = new FundMe(priceFeedAddress);
        vm.stopBroadcast();
        return fundMe;
    }
}