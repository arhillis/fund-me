// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{
    FundMe fundMe;

    function setUp() external{
        fundMe = new FundMe();
    }

    function testMinUSDisFive() public view{
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public view{
        assertEq(fundMe.getOwner(), address(this));
    }
}