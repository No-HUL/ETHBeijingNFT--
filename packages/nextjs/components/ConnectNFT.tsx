import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import BugAntIcon from '@heroicons/react/24/outline/BugAntIcon';

const cardClass = "flex flex-col justify-center bg-base-100 w-60 h-40 px-10 py-4 pb-12  text-center items-center text-green-500 rounded-3xl";
const iconClass = "h-8 w-8 fill-secondary";

const NFTCard: React.FC<{ walletAddress: string }> = ({ walletAddress }) => {
  const [nftCount, setNFTCount] = useState<number>(0);

  useEffect(() => {
    const fetchNFTs = async () => {
      try {
        if (window.ethereum) {
          // 使用 MetaMask 提供的以太坊提供者
          const provider = new ethers.BrowserProvider(window.ethereum);
          const contract = new ethers.Contract('YOUR_NFT_CONTRACT_ADDRESS', ['YOUR_NFT_CONTRACT_ABI'], provider); // 替换成你的 NFT 合约地址和 ABI
          const balance = await contract.balanceOf(walletAddress);
          setNFTCount(balance.toNumber());
        } else {
          throw new Error('MetaMask provider not available');
        }
      } catch (error) {
        console.error('Error fetching NFT count:', error);
      }
    };

    if (walletAddress) {
      fetchNFTs();
    }
  }, [walletAddress]);

  return (
    <div className={cardClass}>
      <BugAntIcon className={iconClass} />
      <p>You have {nftCount} NFTs</p>
    </div>
  );
};

export default NFTCard;
