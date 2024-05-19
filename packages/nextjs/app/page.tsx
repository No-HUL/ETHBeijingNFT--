'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import type { NextPage } from 'next';
import { useAccount } from 'wagmi';
import { ethers } from 'ethers';
import raffleABI from '~~/components/raffleABI.json';
import NFTCard from '~~/components/ConnectNFT';

const RAFFLE_CONTRACT_ADDRESS = '0xYourContractAddressHere';

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();
  const [winner, setWinner] = useState<string>('');
  const [winningAmount, setWinningAmount] = useState<number | null>(null);
  const [raffleState, setRaffleState] = useState<number | null>(null);

  const cardClass = 'flex flex-col justify-center bg-base-100 w-60 h-40 px-10 py-4 pb-12 text-center items-center text-green-500 rounded-3xl cursor-pointer';
  const iconClass = 'h-8 w-8 fill-secondary';

  const handleSelectWinner = async () => {
    try {
      if (!(window as any).ethereum) {
        console.error('MetaMask is not installed!');
        return;
      }

      const provider = new ethers.BrowserProvider((window as any).ethereum);
      await provider.send('eth_requestAccounts', []);
      const signer = provider.getSigner();
      const raffleContract = new ethers.Contract(RAFFLE_CONTRACT_ADDRESS, raffleABI, await signer);

      // 调用 selectWinner 函数
      const transaction = await raffleContract.selectWinner();
      await transaction.wait();

      // 获取成功者地址和金额
      const winnerAddress = await raffleContract.getLastWinner();
      const amount = await raffleContract.getWinningAmount();
      
      setWinner(winnerAddress);
      setWinningAmount(amount);
      
      // 更新抽奖状态
      const state = await raffleContract.getRaffleState();
      setRaffleState(state);
    } catch (error) {
      console.error('Error selecting winner:', error);
    }
  };

  return (
    <div className="min-h-screen flex flex-col justify-between">
      <div className="flex justify-center text-3xl md:justify-between px-12 py-8 space-x-8">
        <div className={cardClass}>
          <p>
            Project Party{' '}
            <Link href="/blockexplorer" passHref className="link">
              checkin
            </Link>{' '}
          </p>
        </div>
        {connectedAddress && <NFTCard walletAddress={connectedAddress} />}
      </div>

      {/* 中间的卡片 */}
      <div className="flex justify-center items-center">
        <div className={cardClass} onClick={handleSelectWinner}>
          <p>{winner ? `Winner: ${winner}` : 'Click to select winner'}</p>
          <p>{winningAmount !== null ? `Winning Amount: ${winningAmount} ETH` : ''}</p>
          <p>{raffleState !== null ? `Raffle State: ${raffleState === 0 ? 'Open' : 'Calculating Winner'}` : 'Loading raffle state...'}</p>
        </div>
      </div>

      {/* 下组卡片 */}
      <div className="flex flex-col justify-end">
        <div className="flex justify-center text-3xl md:justify-between px-12 pt-4">
          <div className={cardClass}>
            <p>Results show</p>
          </div>
          <div className={cardClass}>
            <p>Try to bet</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
