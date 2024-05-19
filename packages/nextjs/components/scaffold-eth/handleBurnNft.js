// components/handleBurnNft.js
import { ethers } from "ethers";
//import raffleABI from "./raffleABI.json";

export const handleBurnNft = async (nftAddress, tokenId) => {
  try {
    if (!window.ethereum) {
      throw new Error("MetaMask is not installed.");
    }

    await window.ethereum.request({ method: "eth_requestAccounts" });

    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();

    const raffleContract = new ethers.Contract("YOUR_RAFFLE_CONTRACT_ADDRESS", raffleABI, signer);

    const transaction = await raffleContract.burnNft(nftAddress, tokenId);
    await transaction.wait();

    return "Burn successful";
  } catch (error) {
    console.error("Error burning NFT:", error);
    throw error;
  }
};
