// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Raffle.sol";
import {DeployScript} from "../script/Deploy.s.sol";
import {MockNft} from "../contracts/MockNft.sol";

contract TestRaffle is Test {
    Raffle raffle;
    MockNft nft;
    uint256 constant PROJECT_STARTING_BALANCE = 10 ether;
    uint256 constant TOKEN_ID = 1;
    address public PROJECT = makeAddr("project");
    address public PLAYER = makeAddr("player");

    function setUp() public {
        DeployScript deployer = new DeployScript();
        (raffle, nft) = deployer.run();
        vm.deal(PROJECT, PROJECT_STARTING_BALANCE);
        nft.mint(PLAYER, TOKEN_ID);
    }

    function testRaffleInitializesInOpenState() public view{
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }
////////test nftCheckIn
    function testRevertWhenRaffleNotOpen() public {}
////////test burnNft

///////test enterRaffle

///////test selectWinner

}
