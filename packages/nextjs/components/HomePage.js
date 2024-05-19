// components/HomePage.js
'use client';

import React, { useState } from "react";
import { handleBurnNft } from "./scaffold-eth/handleBurnNft.js";

const HomePage = () => {
  const [burningInProgress, setBurningInProgress] = useState(false);
  const [nftAddress, setNftAddress] = useState("");
  const [tokenId, setTokenId] = useState("");
  const cardClass = "flex justify-center items-center bg-blue-500 w-64 h-64 cursor-pointer";

  const handleClick = async () => {
    setBurningInProgress(true);

    try {
      const result = await handleBurnNft(nftAddress, tokenId);
      console.log(result);
    } catch (error) {
      console.error("Error:", error);
    } finally {
      setBurningInProgress(false);
    }
  };

  return (
    <div className="flex flex-col items-center">
      <div className="mb-4">
        <input
          type="text"
          placeholder="Enter NFT Address"
          value={nftAddress}
          onChange={(e) => setNftAddress(e.target.value)}
          className="p-2 border border-gray-400 rounded"
        />
      </div>
      <div className="mb-4">
        <input
          type="text"
          placeholder="Enter Token ID"
          value={tokenId}
          onChange={(e) => setTokenId(e.target.value)}
          className="p-2 border border-gray-400 rounded"
        />
      </div>
      <div className={cardClass} onClick={handleClick}>
        <p>{burningInProgress ? "Burning in progress..." : "Click to burn NFT"}</p>
      </div>
    </div>
  );
};

export default HomePage;
