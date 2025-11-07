import { getAddress, parseEther, ZeroAddress } from "ethers";

export type BoostTokenConfig = {
  underlying: string;
  stakedAddress: string;
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
        stakedAddress: getAddress("0x4bf62B89DF3b3D1C3A9352aC1aC86C1428312eE6"),
        rewardRate: 776n,
        minStake: parseEther("10"),
        maxStake: parseEther(
          "115792089237316195423570985008687907853269984665640564039457.584007913129639935",
        ),
      },
    ],
  },
  bsc_mainnet: {
    admin: ZeroAddress,
    bot: ZeroAddress,
    ceffu: ZeroAddress,
    distributor: ZeroAddress,
    waitingTime: 3 * 24 * 60 * 60,
    tokens: [],
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
