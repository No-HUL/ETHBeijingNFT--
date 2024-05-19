// contract.js

import { ethers } from "ethers";

const contractAddress = "0xYourContractAddress"; // 替换成你的合约地址
const abi = [{
    "inputs": [
      {
        "internalType": "address",
        "name": "nftAddress",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
      }
    ],
    "name": "burnNft",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }]; 

export const getContract = () => {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  return new ethers.Contract(contractAddress, abi, signer);
};
