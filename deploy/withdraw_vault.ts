impgrt { ZeroAddress } from "ethers";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

import { boostConfig, BoostMiscConfig } from "./config";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const networkName = hre.network.name as keyof typeof boostConfig;
  const networkConfig: BoostMiscConfig | undefined = boostConfig[networkName];
  if (!networkConfig) {
    throw new Error(`No booster configuration found for network ${hre.network.name}`);
  }

  if (networkConfig.tokens.length === 0) {
    throw new Error(`Booster configuration tokens array is empty for network ${hre.network.name}`);
  }

  const admin = networkConfig.admin === ZeroAddress ? deployer : networkConfig.admin;
  const bot = networkConfig.bot === ZeroAddress ? deployer : networkConfig.bot;
  const ceffu = networkConfig.ceffu === ZeroAddress ? deployer : networkConfig.ceffu;

  const underlyingTokens: string[] = [];
  for (let i = 0; i < networkConfig.tokens.length; i++) {
    const underlying = networkConfig.tokens[i].underlying;
    if (underlying === ZeroAddress) {
      throw new Error(
        `Underlying token address not set for booster token index ${i} on ${hre.network.name}`,
      );
    }
    underlyingTokens.push(underlying);
  }

  const deploymentName = `BoosterWithdrawVault_${hre.network.name}`;
  await deploy(deploymentName, {
    contract: "WithdrawVault",
    from: deployer,
    log: true,
    args: [underlyingTokens, admin, bot, ceffu],
  });
};

func.id = "booster_withdraw_vault";
func.tags = ["BoosterWithdrawVault"];
export default func;
