import { getAddress, ZeroAddress } from "ethers";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const deployedResult = await deploy("MockToken", {
    from: deployer,
    log: true,
    args: ["MockUSDT", "mUSDT", 18, deployer],
  });
  console.log("MockToken deployed to", deployedResult.address);
};

func.id = "mock_token";
func.tags = ["MockToken"];
export default func;
