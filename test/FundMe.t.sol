// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinUSD() public view{
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwner() public view{
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public view{
        uint256 correctVersion = 4;
        if(block.chainid == 1){
            correctVersion = 6;
        }
        assertEq(fundMe.getVersion(), correctVersion);
    }

}