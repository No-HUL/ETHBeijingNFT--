//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Raffle {

    error Raffle__PrizePoolCantBeZero();
    error Raffle__MustBurnNft();
    error Raffle__RaffleNotOpen();
    error Raffle__MustCheckIn();
    error Raffle__MustBeOwner();

    enum RaffleState {
        OPEN,
        CALCULATING_WINNER
    }

    address[] private s_players; //持有足够数量SNFT的玩家
    mapping(address => bool) private s_nftToBurn;//所有登记过并添加过奖池的NFT

    mapping(address => uint256) private s_count; //需要的SNFT数量
    address public immutable owner;
    mapping(address nftToBurn => mapping(address user => bool burned)) isBurned;

    uint256 private s_lastTimeStamp;
    RaffleState private s_raffleState;

    event NftChecked(address indexed nftAddress, address indexed owner);
    event EnterRaffle(address indexed player);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this contract");
        _;
    }

    constructor(address _owner){
        owner = _owner;
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
    }

    function nftCheckIn(address nftAddress) external {
        bool isApproved = IERC721(nftAddress).isApprovedForAll(msg.sender, address(this));
        if(!isApproved){
            IERC721(nftAddress).setApprovalForAll(address(this), true);
        }

        s_nftToBurn[nftAddress] = true;
        emit NftChecked(nftAddress, msg.sender);
    }

    function burnNft(address nftAddress, uint256 tokenId) external {
        // 检查NFT是否已经登记
        if(!s_nftToBurn[nftAddress]){
            revert Raffle__MustCheckIn();
        }

        // 获取NFT的所有者
        address nftOwner = IERC721(nftAddress).ownerOf(tokenId);

        // 检查调用者是否是NFT的所有者
        if(nftOwner == msg.sender){
            revert Raffle__MustBeOwner();
        }

        // 将NFT从所有者转移到合约
        IERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);
    }

    function enterRaffle() external payable {
        if(s_count[msg.sender] == 0){
            revert Raffle__MustBurnNft();
        }
        if(s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }
        s_players.push(payable(msg.sender));
        emit EnterRaffle(msg.sender);
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

    

}