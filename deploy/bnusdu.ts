import { getAddress, ZeroAddress } from "ethers";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  let name = "";
  let symbol = "";
  let admin = deployer;
  let deploymentName = "";
  if (network.name === "bsc_testnet") {
    deploymentName = "StakedToken_BNUSDu_Testnet";
    name = "mBnUSDu";
    symbol = "mBnUSDu";
  } else if (network.name === "bsc_mainnet") {
    deploymentName = "StakedToken_BNUSDu_Mainnet";
    name = "bnUSDu";
    symbol = "bnUSDu";
    // admin = getAddress("0x0000000000000000000000000000000000000000");
  } else {
    throw new Error("Unsupported network");
  }

  const deployedResult = await deploy(deploymentName, {
    contract: "StakedToken",
    from: deployer,
    log: true,
    args: [name, symbol, admin],
  });
  console.log("StakedToken deployed to", deployedResult.address);
};

func.id = "bnusdu";
func.tags = ["StakedToken_BNUSDu"];
export default func;
