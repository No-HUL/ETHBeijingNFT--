//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MockERC721} from "forge-std/mocks/MockERC721.sol";

contract MockNft is MockERC721 {
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function mint(address to, uint256 tokenId) external {
        _ownerOf[tokenId] = to;
        _balanceOf[to]++;
    }

}