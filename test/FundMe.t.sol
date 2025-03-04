// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("USER");
    uint256 constant ethAmount = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinUSD() public view{
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwner() public view{
        uint256 balance = fundMe.getOwner().balance;
        console.log("Balance: ", balance);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public view{
        uint256 correctVersion = 4;
        if(block.chainid == 1){
            correctVersion = 6;
        }
        assertEq(fundMe.getVersion(), correctVersion);
    }

    function testFundFailsWithoutMinEth() public{
        vm.expectRevert();
        fundMe.fund();
    }

    modifier fundUser(){
        vm.prank(USER);
        fundMe.fund{value: ethAmount}();
        _;
    }

    function testFundUpdatesFundedDataStructure() public fundUser{
        uint256 amtFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amtFunded, ethAmount);
        
        //assertEq(, ethAmount);
        //assertEq(fundMe.funders(0), msg.sender);
    }

    function testAddsFunderToArrayOfFunders() public fundUser{
        assertEq(fundMe.s_funders(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public fundUser{
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }    

    function testWithdrawlWithSingleFunder() public fundUser{
        //Arrange
        uint256 balanceBefore = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log("Gas used: ", gasUsed);

        //Assert
        uint256 balanceAfter = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(balanceAfter, balanceBefore + startingFundMeBalance);
    }

    function testWithdrawlWithMultipleFunders() public fundUser(){
        uint160 numFunders = 10;
        uint160 startingFunderIndex = 2;

        for(uint160 i = startingFunderIndex; i < numFunders; i++){
            hoax(address(i), ethAmount);
            fundMe.fund{value: ethAmount}();
        }

        uint256 balanceBefore = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, balanceBefore + startingFundMeBalance);

    }
}