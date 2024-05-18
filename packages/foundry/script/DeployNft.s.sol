//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ScaffoldETHDeploy} from "./Deploy.s.sol";
import {MockNft} from "../contracts/MockNft.sol";

contract DeployNft is ScaffoldETHDeploy {
    function run() external returns (MockNft){
        vm.startBroadcast();
        MockNft nft = new MockNft("NFT","NFT");
        vm.stopBroadcast();
        return nft;
    }
}