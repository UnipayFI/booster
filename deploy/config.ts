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
        underlying: getAddress("0x337610d27c682e347c9cd60bd4b3b107c9d34ddd"),
        stakedAddress: getAddress("0x4ADD9a64d4a553533ef68edcc392d96Ac733fE92"),
        rewardRate: 776n,
        minStake: parseEther("10"),
        maxStake: parseEther(
          "115792089237316195423570985008687907853269984665640564039457.584007913129639935",
        ),
      },
      {
        underlying: getAddress("0x7166A5e1Af969342068DeF6A7BD26DbA036AED75"),
        stakedAddress: getAddress("0x4ADD9a64d4a553533ef68edcc392d96Ac733fE92"),
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
