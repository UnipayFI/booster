import { ZeroAddress } from "ethers";
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

  await deploy(`BoosterVaultEscrow_${hre.network.name}`, {
    contract: "VaultEscrow",
    from: deployer,
    log: true,
    args: [admin],
  });
};

func.id = "booster_vault_escrow";
func.tags = ["BoosterVaultEscrow"];
export default func;
