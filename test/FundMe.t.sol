// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external{
        fundMe = new FundMe();
    }

    function testMinUSD() public view{
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwner() public view{
        assertEq(fundMe.i_owner(), address(this));
    }

    function testVersion() public view{
        assertEq(fundMe.getVersion(), 4);
    }

}