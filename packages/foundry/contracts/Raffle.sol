//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {console} from "../lib/forge-std/src/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Raffle {

    error Raffle__PrizePoolCantBeZero();
    error Raffle__NoBalanceToWithdraw();
    error Raffle__BurnNftNotEnough();
    error Raffle__RaffleNotOpen();
    error Raffle__MustCheckIn();
    error Raffle__MustBeOwner();
    error Raffle__NoPlayer();

    enum RaffleState {
        OPEN,
        CALCULATING_WINNER
    }

    uint256 private constant AMOUNT_BURN_TO_ENTER = 1;
    address[] private s_players; //持有足够数量SNFT的玩家
    mapping(address => bool) private s_nftToBurn;//所有登记过并添加过奖池的NFT

    mapping(address => uint256) private s_count; //需要的SNFT数量
    address public immutable owner;

    RaffleState private s_raffleState;

    event NftChecked(address indexed nftAddress, address indexed owner);
    event NewEntry(address indexed player);
    event RaffleStarted();
    event RaffleEnded();
    event WinnerSelected(address indexed winner);
    event BalanceWithdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this contract");
        _;
    }

    constructor(address _owner){
        _owner = msg.sender;
        s_raffleState = RaffleState.OPEN;
    }

    function nftCheckIn(address nftAddress) external payable{
        if(s_raffleState != RaffleState.OPEN){
            revert Raffle__RaffleNotOpen();
        }
        if(msg.value == 0){
            revert Raffle__PrizePoolCantBeZero();
        }

        bool isApproved = IERC721(nftAddress).isApprovedForAll(msg.sender, address(this));
        if(!isApproved){
            IERC721(nftAddress).setApprovalForAll(address(this), true);
        }

        s_nftToBurn[nftAddress] = true;//设置nft已登记
        emit NftChecked(nftAddress, msg.sender);
    }

    function burnNft(address nftAddress, uint256 tokenId) external {
        // 检查NFT是否已经登记
        if(!s_nftToBurn[nftAddress]){
            revert Raffle__MustCheckIn();
        }

        // 检查调用者是否是NFT的所有者
        if( IERC721(nftAddress).ownerOf(tokenId) != msg.sender){
            revert Raffle__MustBeOwner();
        }

        // 将NFT从所有者转移到合约
        IERC721(nftAddress).approve(address(this), tokenId);
        IERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);
        s_count[msg.sender]++;//玩家销毁NFT+1
    }

    function enterRaffle() external {
        if(s_count[msg.sender] < AMOUNT_BURN_TO_ENTER){
            revert Raffle__BurnNftNotEnough();
        }
        if(s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }
        s_players.push(payable(msg.sender));
        emit NewEntry(msg.sender);
    }

    //计算随机数
    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        blockhash(block.number - 1),
                        block.timestamp,
                        s_players.length
                    )
                )
            );
    }

    function resetPlayers() private {
        for(uint256 i = 0; i < s_players.length; i++){
            delete s_players[i];
        }
    }

    function selectWinner() external onlyOwner {
        if(s_raffleState != RaffleState.OPEN){
            revert Raffle__RaffleNotOpen();
        }
        if(s_players.length == 0){
            revert Raffle__NoPlayer();
        }
        s_raffleState = RaffleState.CALCULATING_WINNER;
        uint256 winnerIndex = random() % s_players.length;
        address winner = s_players[winnerIndex];
        payable(winner).transfer(address(this).balance);
        emit WinnerSelected(winner);

        resetPlayers();
        delete s_players;
        s_raffleState = RaffleState.OPEN;
    }

    function getPlayer() public view returns(address[] memory){
        return s_players;
    }

    function getRaffleState() public view returns(RaffleState){
        return s_raffleState;
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function getNftToBurn(address nftAddress) public view returns(bool){
        return s_nftToBurn[nftAddress];
    }

    function getCount(address player) public view returns(uint256){
        return s_count[player];
    }

    function getPlayersByIndex(uint256 index) public view returns(address){
        return s_players[index];
    }

}