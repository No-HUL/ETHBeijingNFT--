//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/Raffle.sol";
import "../contracts/MockNft.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external returns (Raffle, MockNft){
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);
        Raffle raffle =new Raffle(vm.addr(deployerPrivateKey));
        MockNft nft = new MockNft("NFT", "NFT");
        // console.logString(
        //     string.concat(
        //         "raffle contract deployed at: ", vm.toString(address(raffle))
        //     )
        // );
        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
        
        return (raffle, nft);
    }

    function test() public {}
}
