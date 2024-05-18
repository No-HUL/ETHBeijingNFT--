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
    uint256 constant POOL_STARTING_BALANCE = 5 ether;
    uint256 constant TOKEN_ID = 1;
    address public PROJECT = makeAddr("project");
    address public PLAYER = makeAddr("player");

    event NftChecked(address indexed nftAddress, address indexed owner);
    event NewEntry(address indexed player);
    event RaffleStarted();
    event RaffleEnded();
    event WinnerSelected(address indexed winner);
    event BalanceWithdrawn(uint256 amount);

    function setUp() public {
        DeployScript deployer = new DeployScript();
        (raffle, nft) = deployer.run();
        vm.deal(PROJECT, PROJECT_STARTING_BALANCE);
        nft.mint(PLAYER, TOKEN_ID);
    }

////////test setUp 
function testPlayerIsOwnerOfTokenId() public view{
    assertEq(nft.ownerOf(TOKEN_ID), PLAYER);
}

////////test nftCheckIn
    function testRaffleInitializesInOpenState() public view{
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRevertIfSendZeroToContract() public {
        vm.prank(PROJECT);
        vm.expectRevert(Raffle.Raffle__PrizePoolCantBeZero.selector);
        raffle.nftCheckIn{value: 0}(address(nft));
    }

    function testEmitsNftCheckedEvent() public {
        vm.prank(PROJECT);
        vm.expectEmit(true, true, false, false);
        emit NftChecked(address(nft), PROJECT);
        raffle.nftCheckIn{value: POOL_STARTING_BALANCE}(address(nft));
    }

////////test burnNft
        function testSetNftToBurn() public {
        vm.prank(PROJECT);
        raffle.nftCheckIn{value: POOL_STARTING_BALANCE}(address(nft));
        assertEq(raffle.getNftToBurn(address(nft)),  true);
    }
    
    function testRevertMustCheckIn() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__MustCheckIn.selector);
        raffle.burnNft(address(nft), TOKEN_ID);
        assertEq(raffle.getNftToBurn(address(nft)),  false);
    }

    function testRevertMustBeOwner() public {
        vm.prank(PROJECT);
        raffle.nftCheckIn{value: POOL_STARTING_BALANCE}(address(nft));
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__MustBeOwner.selector);
        raffle.burnNft(address(nft), TOKEN_ID);
    }

    function testCountPlayerBurnNft() public {
        vm.prank(PROJECT);
        raffle.nftCheckIn{value: POOL_STARTING_BALANCE}(address(nft));

        vm.prank(PLAYER);
        raffle.burnNft(address(nft), TOKEN_ID);
        assertEq(raffle.getCount(PLAYER), 1);
        console.log(msg.sender);
    }
///////test enterRaffle
    function testRevertIfBurnNftNotEnough() public {
        vm.prank(PROJECT);
        raffle.nftCheckIn{value: POOL_STARTING_BALANCE}(address(nft));

        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__BurnNftNotEnough.selector);
        raffle.enterRaffle();
    }

    function testUpdatePlayersArray() public {
        vm.prank(PROJECT);
        raffle.nftCheckIn{value: POOL_STARTING_BALANCE}(address(nft));

        vm.prank(PLAYER);
        raffle.burnNft(address(nft), TOKEN_ID);
        raffle.enterRaffle();
        assertEq(raffle.getPlayersByIndex(0), payable(PLAYER));
    }
///////test selectWinner

}
