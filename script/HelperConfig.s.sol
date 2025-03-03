// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract HelperConfig is Script {
    NetworkConfig public activeConfig;

    struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if(block.chainid == 11155111){
            activeConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1){
            activeConfig = getMainnetEthConfig();
        } else if (block.chainid == 324){
            activeConfig = getZKSyncEthConfig();
        }else{
            activeConfig = getAnvilEthConfig();
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

    function getAnvilEthConfig() public pure returns(NetworkConfig memory){
        return NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);        
    }
}