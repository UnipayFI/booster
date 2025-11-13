import { ZeroAddress } from "ethers";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { WithdrawVault, Vault, StakedToken } from "../typechain-types";

import { boostConfig, BoostMiscConfig, BoostTokenConfig } from "./config";

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

  const withdrawVaultDeploymentName = `BoosterWithdrawVault_${hre.network.name}`;
  const withdrawVault = (await ethers.getContract(withdrawVaultDeploymentName)) as WithdrawVault;
  const withdrawVaultAddress = await withdrawVault.getAddress();
  const vaultDeploymentName = `BoosterVault_${hre.network.name}`;

  /// 处理 stakedToken
  const stakedAddresses = [];
  for (const tokenConfig of networkConfig.tokens) {
    if (networkName === "bsc_testnet") {
      const stakedTokenDeploymentName = `StakedToken_${tokenConfig.stakedTokenSymbol}_${hre.network.name}`;
      const deployedResult = await deploy(stakedTokenDeploymentName, {
        contract: "StakedToken",
        from: deployer,
        log: true,
        args: [tokenConfig.stakedTokenName, tokenConfig.stakedTokenSymbol, admin],
      });
      stakedAddresses.push({
        address: deployedResult.address,
        symbol: tokenConfig.stakedTokenSymbol,
      });
      console.log(`${stakedTokenDeploymentName} deployed to`, deployedResult.address);
    }
  }

  const vaultDeployedResult = await deploy(vaultDeploymentName, {
    contract: "Vault",
    from: deployer,
    args: [
      networkConfig.tokens.map((token) => token.underlying),
      stakedAddresses.map((item) => item.address),
      networkConfig.tokens.map((token) => token.rewardRate),
      networkConfig.tokens.map((token) => token.minStake),
      networkConfig.tokens.map((token) => token.maxStake),
      admin,
      bot,
      ceffu,
      networkConfig.waitingTime,
      withdrawVaultAddress,
      distributor,
    ],
  });
  if (vaultDeployedResult.newlyDeployed) {
    await withdrawVault.setVault(vaultDeployedResult.address);
    console.log(`Vault deployed to ${vaultDeployedResult.address}`);
    const vault = await ethers.getContract<Vault>(vaultDeploymentName);
    const tx0 = await vault.unpause();
    await tx0.wait();
    const tx1 = await vault.setFlashEnable(false);
    await tx1.wait();
    const tx2 = await vault.setCancelEnable(false);
    await tx2.wait();
    for (const item of stakedAddresses) {
      const stakedTokenDeploymentName = `StakedToken_${item.symbol}_${hre.network.name}`;
      const stakedToken = (await ethers.getContract(stakedTokenDeploymentName)) as StakedToken;
      const tx = await stakedToken.setMinter(
        vaultDeployedResult.address,
        vaultDeployedResult.address,
      );
      await tx.wait();
    }
  }
};

func.id = "booster_vault";
func.tags = ["BoosterVault"];
func.dependencies = ["BoosterWithdrawVault"];
export default func;
