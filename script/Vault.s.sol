// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Vault} from "../contracts/Vault.sol";
import {MockToken} from "../contracts/mock/MockToken.sol";

contract VaultStakeScript is Script {
  Vault internal _vault;
  MockToken internal _underlying;

  address internal vincent;
  uint256 internal vincentPk;

  function setUp() public {
    uint256 forkId = vm.createFork(
      "https://rpc.ankr.com/bsc_testnet_chapel/9c05cbd66971c4f4279faa4e285ac086cc93601060343afe4d8c27464fe18c8d"
    );
    vm.selectFork(forkId);

    _underlying = MockToken(0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142);
    _vault = Vault(payable(0xcE56FA9e9692Df22984A91628e1bD9206e487535));
    vincentPk = vm.envUint("TESTNET_PRIVATE_KEY");
    vincent = vm.addr(vincentPk);
  }

  function run() public {
    setUp();
    vm.startPrank(vincent);
    _underlying.approve(address(_vault), 1000 ether);
    _vault.stake_66380860(address(_underlying), 1000 ether);
    vm.stopPrank();
  }
}

contract VaultSetRewardRateScript is Script {
  Vault internal _vault;
  MockToken internal _underlying;

  address internal vincent;
  uint256 internal vincentPk;

  function setUp() public {
    uint256 forkId = vm.createFork(
      "https://rpc.ankr.com/bsc_testnet_chapel/9c05cbd66971c4f4279faa4e285ac086cc93601060343afe4d8c27464fe18c8d"
    );
    vm.selectFork(forkId);

    _underlying = MockToken(0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142);
    _vault = Vault(payable(0xcE56FA9e9692Df22984A91628e1bD9206e487535));
    vincentPk = vm.envUint("TESTNET_PRIVATE_KEY");
    vincent = vm.addr(vincentPk);
  }

  function run() public {
    setUp();
    vm.startPrank(vincent);
    _vault.setRewardRate(address(_underlying), 776);
    vm.stopPrank();
  }
}
