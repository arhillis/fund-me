// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000E8;

    struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if(block.chainid == 11155111){
            activeConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1){
            activeConfig = getMainnetEthConfig();
        } else if (block.chainid == 300){
            activeConfig = getZKSyncEthConfig();
        }else{
            activeConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;        
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory mainnetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetConfig;        
    }

    function getZKSyncEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory zkSyncConfig = NetworkConfig(0x6D41d1dc818112880b40e26BD6FD347E41008eDA);   
        return zkSyncConfig;     
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){
        if(activeConfig.priceFeed != address(0)){
            return activeConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockAggregator = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();      

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockAggregator)});
        return anvilConfig;
    }
}