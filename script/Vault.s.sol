// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/Script.sol";
import { Vault } from "../contracts/Vault.sol";
import { MockToken } from "../contracts/mock/MockToken.sol";

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
    _vault = Vault(payable(0xb4f13Dba6C342CE07b5a203cBc66cDfA63d25384));
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
    _vault = Vault(payable(0xb4f13Dba6C342CE07b5a203cBc66cDfA63d25384));
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

contract VaultRequestClaimScript is Script {
  Vault internal _vault;
  MockToken internal _underlying;

  address internal lucas;

  function setUp() public {
    uint256 forkId = vm.createFork(
      "https://rpc.ankr.com/bsc_testnet_chapel/9c05cbd66971c4f4279faa4e285ac086cc93601060343afe4d8c27464fe18c8d"
    );
    vm.selectFork(forkId);

    _underlying = MockToken(0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142);
    _vault = Vault(payable(0xb4f13Dba6C342CE07b5a203cBc66cDfA63d25384));
    lucas = 0xdA5506c8578652205A28BDF3739C0dD4809F2C8e;
  }

  function run() public {
    setUp();
    vm.startPrank(lucas);
    _vault.requestClaim_8135334(address(_underlying), 10 ether, true);
    vm.stopPrank();
  }
}
