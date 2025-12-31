import { getAddress, parseEther, ZeroAddress } from "ethers";

export type BoostTokenConfig = {
  underlying: string;
  stakedTokenSymbol: string;
  stakedTokenName: string;
  rewardRate: bigint;
  minStake: bigint;
  maxStake: bigint;
  stakedAdmin?: string;
};

export type BoostMiscConfig = {
  admin: string;
  bot: string;
  ceffu: string;
  distributor: string;
  waitingTime: number;
  tokens: BoostTokenConfig[];
};

export type BoosterUnitasProxyConfig = {
  admin: string;
  usdu: string;
  minting: string;
  staked: string;
};

export const boosterUnitasProxyConfig: Record<string, BoosterUnitasProxyConfig> = {
  bsc_testnet: {
    admin: ZeroAddress,
    usdu: getAddress("0x029544a6ef165c84A6E30862C85B996A2BF0f9dE"),
    minting: getAddress("0x84E5D5009ab4EE5eCf42eeA5f1B950d39eEFb648"),
    staked: getAddress("0x3E7fF623C4Db0128657567D583df71E0297dfcc3"),
  },
};

export const boostConfig: Record<string, BoostMiscConfig> = {
  bsc_testnet: {
    admin: ZeroAddress,
    bot: ZeroAddress,
    ceffu: ZeroAddress,
    distributor: ZeroAddress,
    waitingTime: 30 * 60, // 30 minutes
    tokens: [
      {
        underlying: getAddress("0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142"),
        stakedTokenSymbol: "mBnUSDu",
        stakedTokenName: "mBnUSDu",
        rewardRate: 776n,
        minStake: parseEther("10"),
        maxStake: parseEther(
          "115792089237316195423570985008687907853269984665640564039457.584007913129639935",
        ),
      },
    ],
  },
  bsc_mainnet: {
    admin: getAddress("0x25f9f26F954ED5F8907dF2a5f69776aD8564792C"),
    bot: getAddress("0x29980fd30951B7f8B767555FE0b21cf98C814336"),
    ceffu: getAddress("0xc3e666a71b38b258e6517d5d6eafaa30e46eb5ec"),
    distributor: getAddress("0x29980fd30951B7f8B767555FE0b21cf98C814336"),
    waitingTime: 7 * 24 * 60 * 60,
    tokens: [
      {
        underlying: getAddress("0x55d398326f99059fF775485246999027B3197955"),
        stakedTokenSymbol: "bnUSDu",
        stakedTokenName: "Binance Booster USDu",
        rewardRate: 776n,
        minStake: parseEther("10"),
        maxStake: parseEther(
          "115792089237316195423570985008687907853269984665640564039457.584007913129639935",
        ),
      },
    ],
  },
  eth_sepolia: {
    admin: ZeroAddress,
    bot: ZeroAddress,
    ceffu: ZeroAddress,
    distributor: ZeroAddress,
    waitingTime: 3 * 24 * 60 * 60,
    tokens: [],
  },
};
