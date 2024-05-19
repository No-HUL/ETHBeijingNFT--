import { ethers } from "ethers";

// 定义合约 ABI
const contractABI = [{
    "inputs": [],
    "name": "enterRaffle",
    "outputs": [],
    "stateMutability": "payable",
    "type": "function"
  },]; // 从您的合约 ABI 中复制

// 定义一个函数，用于调用 enterRaffle 函数
export const enterRaffle = async () => {
  try {
    // 连接到以太坊网络
    await window.ethereum.enable();
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    // 获取当前账户地址
    const accounts = await provider.listAccounts();
    const userAddress = accounts[0]; // 假设用户只有一个账户
    // 获取用户选择的网络
    const network = await provider.getNetwork();
    const contractAddress = YOUR_CONTRACT_ADDRESSES[network.chainId]; // 根据用户选择的网络获取合约地址

    // 实例化合约
    const contract = new ethers.Contract(contractAddress, contractABI, provider.getSigner(userAddress));
    
    // 调用 enterRaffle 函数
    const tx = await contract.enterRaffle({ value: ethers.utils.parseEther("0.1") }); // 假设下注 0.1 ETH
    await tx.wait(); // 等待交易确认

    return { success: true, message: "下注成功！" };
  } catch (error) {
    console.error("下注失败:", error);
    return { success: false, message: "下注失败：" + error.message };
  }
};
