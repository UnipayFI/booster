# Booster Evm Contract

## BSC_TESTNET

## Booster 合约

### BSC Testnet 地址

| 合约 | 地址 | 说明 |
|------|------|------|
| BoosterVault | [0xb4f13Dba6C342CE07b5a203cBc66cDfA63d25384](https://testnet.bscscan.com/address/0xb4f13Dba6C342CE07b5a203cBc66cDfA63d25384) | 主仓库合约，处理质押/赎回逻辑 |
| BoosterWithdrawVault | [0x0a21dbd4c36c8f07Eed8F76a5b8d21a0721a427F](https://testnet.bscscan.com/address/0x0a21dbd4c36c8f07Eed8F76a5b8d21a0721a427F) | 提现缓冲仓，负责实际打款 |
| mBnUSDu | [0x18eC822Bf73F58E1aB522D122027592690fFa1E2](https://testnet.bscscan.com/address/0x18eC822Bf73F58E1aB522D122027592690fFa1E2) | bnStaked Token |
| sUSDu | [0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1](https://testnet.bscscan.com/address/0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1) | sUSDu Token |
| mUSDT | [0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142](https://testnet.bscscan.com/address/0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142) | mUSDT Token |

## BSC_MAINNET

### BSC Mainnet 地址（ChainId 56）

| 合约 | 地址 | 说明 |
|------|------|------|
| BoosterVault | [0x57f0FE70A631614eB86Fce1212C6e3C17d81b63A](https://bscscan.com/address/0x57f0FE70A631614eB86Fce1212C6e3C17d81b63A) | 主仓库合约，处理质押/赎回逻辑 |
| BoosterWithdrawVault | [0x1946bC20466813ae2153c6E073DB677a529c4401](https://bscscan.com/address/0x1946bC20466813ae2153c6E073DB677a529c4401) | 提现缓冲仓，负责实际打款 |
| StakedToken_bnUSDu | [0x3c4b067622bF104FEc23463B0A4Cb912161D9319](https://bscscan.com/address/0x3c4b067622bF104FEc23463B0A4Cb912161D9319) | 主网 staked 资产代币 |

### Events（按合约分类）

#### BoosterVault

| 事件名 | 参数 |
|------|------|
| AddSupportedToken | address _token, uint256 _minAmount, uint256 _maxAmount |
| AdminTransferRequested | address oldAdmin, address newAdmin |
| AdminTransferred | address oldAdmin, address newAdmin |
| CancelClaim | address user, address _token, uint256 _amount, uint256 _id |
| CancelStatusChanged | bool oldStatus, bool newStatus |
| CeffuReceive | address _token, address _ceffu, uint256 _amount |
| ClaimAssets | address _user, address _token, uint256 _amount, uint256 _id |
| EmergencyWithdrawal | address _token, address _receiver |
| FlashStatusChanged | bool oldStatus, bool newStatus |
| FlashWithdraw | address _user, address _token, uint256 _amount, uint256 _fee |
| Paused | address account |
| RequestClaim | address _user, address _token, uint256 _amount, uint256 _id, bool _isSusduTokenWithdraw |
| RoleAdminChanged | bytes32 role, bytes32 previousAdminRole, bytes32 newAdminRole |
| RoleGranted | bytes32 role, address account, address sender |
| RoleRevoked | bytes32 role, address account, address sender |
| Stake | address _user, address _token, uint256 _amount |
| StakedDistributed | address token, address recipient, uint256 amount, bool historicalRewardsEnabled |
| StakedTokenRegistered | address stakedToken, address underlyingToken |
| Unpaused | address account |
| UpdateCeffu | address _oldCeffu, address _newCeffu |
| UpdatePenaltyRate | uint256 oldRate, uint256 newRate |
| UpdateRewardRate | address _token, uint256 _oldRewardRate, uint256 _newRewardRate |
| UpdateStakeLimit | address _token, uint256 _oldMinAmount, uint256 _oldMaxAmount, uint256 _newMinAmount, uint256 _newMaxAmount |
| UpdateWaitingTime | uint256 _oldWaitingTime, uint256 _newWaitingTIme |

#### BoosterWithdrawVault

| 事件名 | 参数 |
|------|------|
| AdminTransferRequested | address oldAdmin, address newAdmin |
| AdminTransferred | address oldAdmin, address newAdmin |
| CeffuReceive | address token, address to, uint256 amount |
| Paused | address account |
| RoleAdminChanged | bytes32 role, bytes32 previousAdminRole, bytes32 newAdminRole |
| RoleGranted | bytes32 role, address account, address sender |
| RoleRevoked | bytes32 role, address account, address sender |
| Unpaused | address account |

#### StakedToken_bnUSDu

| 事件名 | 参数 |
|------|------|
| Approval | address owner, address spender, uint256 value |
| Transfer | address from, address to, uint256 value |

### Vault 接口速查表

| 分类 | 函数 | 签名 | 参数说明 | 备注 |
|------|------|------|----------|------|
| 质押 / 赎回 | `stake_66380860` | `stake_66380860(address _token, uint256 _stakedAmount)` | `_token` 底层资产地址；`_stakedAmount` 质押数量 | 质押底层资产并领取 staked token |
|  | `requestClaim_8135334` | `requestClaim_8135334(address _token, uint256 _amount, bool _isSusduTokenWithdraw) returns (uint256 queueId)` | `_amount` 赎回额（`type(uint256).max` 表示全部），`_isSusduTokenWithdraw` 指定是否走 susdu 通道 | 发起赎回请求，先扣奖励再扣本金；返回队列 ID |
|  | `cancelClaim` | `cancelClaim(uint256 _queueId, address _token)` | `_queueId` 队列 ID，`_token` 底层资产地址 | 等待期间撤销赎回，需开启取消开关 |
|  | `claim_41202704` | `claim_41202704(uint256 _queueId, address _token)` | `_queueId` 队列 ID | 等待结束后领取本金和奖励 |
|  | `flashWithdrawWithPenalty` | `flashWithdrawWithPenalty(address _token, uint256 _amount)` | `_amount` 赎回金额 | 立即提款，按罚金比例扣减 |
| 查询余额 | `getClaimableAssets` | `getClaimableAssets(address user, address token) → uint256` | `user` 用户地址，`token` 底层资产 | 当前可赎回总额（本金 + 奖励） |
|  | `getClaimableRewards` | `getClaimableRewards(address user, address token) → uint256` | 同上 | 当前未领取奖励 |
|  | `getTotalRewards` | `getTotalRewards(address user, address token) → uint256` | 同上 | 历史已领 + 当前奖励 |
|  | `getTVL` | `getTVL(address token) → uint256` | `token` 底层资产地址 | 当前 Vault 锁仓量 |
| 历史记录 | `getStakeHistory` | `getStakeHistory(address user, address token, uint256 index) → StakeItem` | `index` 质押记录序号 | 查询指定质押记录 |
|  | `getStakeHistoryLength` | `getStakeHistoryLength(address user, address token) → uint256` | - | 质押记录条数 |
|  | `getClaimHistory` | `getClaimHistory(address user, address token, uint256 index) → ClaimItem` | `index` 赎回记录序号 | 查询指定赎回记录 |
|  | `getClaimHistoryLength` | `getClaimHistoryLength(address user, address token) → uint256` | - | 赎回记录条数 |
| 队列查询 | `getClaimQueueIDs` | `getClaimQueueIDs(address user, address token) → uint256[]` | 用户地址、底层资产地址 | 正在排队中的队列 ID 列表 |
|  | `getClaimQueueInfo` | `getClaimQueueInfo(uint256 queueId) → ClaimItem` | `queueId` 队列 ID | 查看具体排队请求状态 |

#### 查询流程

1. **获取赎回记录**
   - 调用 `getClaimQueueIDs(user, token)` 获取正在排队的赎回请求ID
   - 对每个 `queueId` 调用 `getClaimQueueInfo(queueId)`
   - 返回的 `ClaimItem` 中：
     - `isDone == false` 且 `block.timestamp < claimTime`：仍在等待领取
     - `isDone == false` 且 `block.timestamp >= claimTime`：已到可领取时间，可提示用户执行 `claim_41202704`

2. **获取历史记录**
   - 先调用 `getClaimHistoryLength(user, token)` 获取历史长度
   - 使用 `for (uint256 i = 0; i < length; i++)` 逐条调用 `getClaimHistory(user, token, i)`
   - 历史 `ClaimItem` 中 `isDone` 表示是否已经完成（包含 `flashWithdraw` 或 `_isSusduTokenWithdraw == true` 的即时赎回），`isStakedTokenWithdraw` 用于区分 susdu 通道的提现

3. **赎回后续**
   - 当用户调用 `claim_41202704` 成功后，同一个 `queueId` 会被设置 `isDone = true` 并被追加到历史记录中
   - `_isSusduTokenWithdraw == true` 或 `flashWithdrawWithPenalty` 会直接把 `ClaimItem` 写入历史，`getClaimQueueIDs` 中不会再看到这些 ID。通过比较历史记录的 `requestTime/claimTime` 与队列信息判断是否已完成

4. **状态**
   - “待处理” 列表：`getClaimQueueInfo` 返回 `isDone == false` 的记录
   - “已完成” 列表：`getClaimHistory` 返回的所有记录，可以按 `claimTime` 排序
   - 若需计算待发放金额，可结合 `getClaimableAssets`/`getClaimableRewards`

示例（TypeScript + Ethers.js）：

```ts
import { Vault } from "./typechain-types";

const vault = Vault.connect(vaultAddress, provider);

async function loadPendingClaims(user: string, token: string) {
  const queueIds = await vault.getClaimQueueIDs(user, token);
  const pending = [];
  for (const id of queueIds) {
    const item = await vault.getClaimQueueInfo(id);
    pending.push({
      queueId: id,
      totalAmount: item.totalAmount,
      claimTime: Number(item.claimTime),
      isReady: !item.isDone && Number(item.claimTime) <= Math.floor(Date.now() / 1000),
    });
  }
  return pending;
}

async function loadClaimHistory(user: string, token: string) {
  const length = Number(await vault.getClaimHistoryLength(user, token));
  const history = [];
  for (let i = 0; i < length; i++) {
    const item = await vault.getClaimHistory(user, token, i);
    history.push({
      principal: item.principalAmount,
      reward: item.rewardAmount,
      finishedAt: Number(item.claimTime),
      isSusdu: item.isSusduTokenWithdraw,
      isFlashWithdraw: item.requestTime === item.claimTime && !item.isSusduTokenWithdraw,
    });
  }
  return history;
}

export async function loadClaimData(user: string, token: string) {
  const [pending, history] = await Promise.all([
    loadPendingClaims(user, token),
    loadClaimHistory(user, token),
  ]);

  return {
    pending, // 待领取的排队请求
    history, // 已完成的赎回记录
  };
}
```
### Flash Withdraw & Instant Withdraw

- Diffs
  - `Vault` 的 `flashWithdrawWithPenalty` 为即时赎回，会按当前罚金比例扣减，不进入等待队列。
  - 罚金比例由管理员通过 `setPenaltyRate` 配置，更新会触发 `UpdatePenaltyRate` 事件；是否开放闪提由开关控制，变更会触发 `FlashStatusChanged`。
  - `WithdrawVault` 不参与罚金计算，仅负责资金的实际转账（如 `transfer`、`emergencyWithdraw`、`transferToCeffu`）；罚金逻辑与赎回金额计算在 `Vault` 内完成。
  - 闪提会触发 `FlashWithdraw` 事件，并直接写入历史记录（`getClaimHistory` 可见，`requestTime == claimTime`，不会出现在 `getClaimQueueIDs`）。

- Steps
  - 确认开关：监听 `FlashStatusChanged` 事件或按管理逻辑判断是否允许闪提。
  - 发起调用：`flashWithdrawWithPenalty(address _token, uint256 _amount)` 在 `BoosterVault` 上执行。
  - 结果查询：
    - 事件：`FlashWithdraw(_user, _token, _amount, _fee)` 可用于前端提示与审计。
    - 历史：通过 `getClaimHistory(user, token, index)` 查看该条记录（`isFlashWithdraw = true`）。
  - 资金划转：由 `WithdrawVault` 完成实际打款；如需向 Ceffu 划转由 `transferToCeffu` 处理。
