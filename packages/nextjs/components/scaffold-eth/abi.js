// burnNft.js

import { getContract } from "./contract.js";

export const burnNft = async (nftAddress, tokenId) => {
  try {
    const contract = getContract();
    const transaction = await contract.burnNft(nftAddress, tokenId);
    await transaction.wait();
    console.log("NFT burned successfully.");
  } catch (error) {
    console.error("Error burning NFT:", error);
  }
};
