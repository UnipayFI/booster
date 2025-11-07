import { ZeroAddress } from "ethers";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { VaultLedger, WithdrawVault, Vault } from "../typechain-types";

import { boostConfig, BoostMiscConfig, BoostTokenConfig } from "./config";

type PreparedTokenConfig = BoostTokenConfig & {
  stakedDeploymentName: string;
  stakedAddress: string;
  stakedAdmin: string;
};

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, ethers } = hre;
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
  const distributor =
    networkConfig.distributor === ZeroAddress ? deployer : networkConfig.distributor;

  const vaultLedgerDeploymentName = `BoosterVaultLedger_${hre.network.name}`;
  const vaultLedger = (await ethers.getContract(vaultLedgerDeploymentName)) as VaultLedger;
  const withdrawVaultDeploymentName = `BoosterWithdrawVault_${hre.network.name}`;
  const withdrawVault = (await ethers.getContract(withdrawVaultDeploymentName)) as WithdrawVault;
  const withdrawVaultAddress = await withdrawVault.getAddress();
  const vaultLedgerAddress = await vaultLedger.getAddress();
  const vaultDeploymentName = `BoosterVault_${hre.network.name}`;
  const deployedResult = await deploy(vaultDeploymentName, {
    contract: "Vault",
    from: deployer,
    args: [
      networkConfig.tokens.map((token) => token.underlying),
      networkConfig.tokens.map((token) => token.stakedAddress),
      networkConfig.tokens.map((token) => token.rewardRate),
      networkConfig.tokens.map((token) => token.minStake),
      networkConfig.tokens.map((token) => token.maxStake),
      admin,
      bot,
      ceffu,
      networkConfig.waitingTime,
      withdrawVaultAddress,
      distributor,
      vaultLedgerAddress,
    ],
  });
  if (deployedResult.newlyDeployed) {
    await withdrawVault.setVault(deployedResult.address);
    await vaultLedger.setVault(deployedResult.address, true);
    await vaultLedger.setDistributor(distributor, true);
    await vaultLedger.addAllowToken("0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1"); // bsc-testnet susdu
  }
  console.log(`Vault deployed to ${deployedResult.address}`);
};

func.id = "booster_vault";
func.tags = ["BoosterVault"];
func.dependencies = ["BoosterWithdrawVault", "BoosterVaultLedger"];
export default func;
