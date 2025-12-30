// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../contracts/vault/Vault.sol";
import "../contracts/vault/WithdrawVault.sol";
import "../contracts/vault/StakedToken.sol";

struct DeployParams {
  address admin;
  address bot;
  address ceffu;
  address susduToken;
  address deployer;
  address distributor;
  uint256 deployPk;
}

contract DeploytBSC is Script {
  address USDT = 0x55d398326f99059fF775485246999027B3197955;
  address USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;

  function getParams() internal view returns (DeployParams memory) {
    DeployParams memory params;
    params.admin = vm.envAddress("BSC_ADMIN");
    params.bot = vm.envAddress("BSC_BOT");
    params.ceffu = vm.envAddress("BSC_CEFFU");
    params.susduToken = vm.envAddress("BSC_SUSDU_TOKEN");
    params.deployPk = vm.envUint("BSC_DEPLOYER_PRIVATE_KEY");
    params.deployer = vm.addr(params.deployPk);
    return params;
  }

  function getSupportedTokensAndRewardRates()
    internal
    view
    returns (address[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
  {
    //rewardRate & supportToken
    address[] memory supportedTokens = new address[](2);
    supportedTokens[0] = USDT;
    supportedTokens[1] = USDC;
    uint256[] memory rewardRates = new uint256[](2);
    rewardRates[0] = 700;
    rewardRates[1] = 700;
    uint256[] memory minStakeAmounts = new uint256[](2);
    minStakeAmounts[0] = 10 ether;
    minStakeAmounts[1] = 10 ether;
    uint256[] memory maxStakeAmounts = new uint256[](2);
    maxStakeAmounts[0] = type(uint256).max;
    maxStakeAmounts[1] = type(uint256).max;
    return (supportedTokens, rewardRates, minStakeAmounts, maxStakeAmounts);
  }

  function run() public {
    DeployParams memory params = getParams();
    vm.startBroadcast(params.deployPk);

    (
      address[] memory supportedTokens,
      uint256[] memory rewardRates,
      uint256[] memory minStakeAmounts,
      uint256[] memory maxStakeAmounts
    ) = getSupportedTokensAndRewardRates();

    WithdrawVault withdrawVault = new WithdrawVault(supportedTokens, params.deployer, params.bot, params.ceffu);

    StakedToken stakedUSDT = new StakedToken("bnUSDT", "bnUSDT", params.deployer);
    StakedToken stakedUSDC = new StakedToken("bnUSDC", "bnUSDC", params.deployer);
    address[] memory staked = new address[](2);
    staked[0] = address(stakedUSDT);
    staked[1] = address(stakedUSDC);

    Vault vault = new Vault(
      supportedTokens,
      staked,
      rewardRates,
      minStakeAmounts,
      maxStakeAmounts,
      params.admin,
      params.bot,
      params.ceffu,
      7 days,
      payable(address(withdrawVault)),
      params.distributor
    );

    withdrawVault.setVault(address(vault));
    withdrawVault.changeAdmin(params.admin);

    stakedUSDT.setMinter(address(vault), address(vault));
    stakedUSDC.setMinter(address(vault), address(vault));

    stakedUSDC.setAirdropper(params.distributor);
    stakedUSDT.setAirdropper(params.distributor);

    stakedUSDT.setAdmin(params.admin);
    stakedUSDC.setAdmin(params.admin);

    vm.stopBroadcast();
  }
}
