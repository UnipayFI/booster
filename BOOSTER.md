# Booster Evm Contract

## BSC_TESTNET

## Booster 合约

### BSC Testnet 地址

| 合约 | 地址 | 说明 |
|------|------|------|
| BoosterVault | [0xEEC2630f52a7D6436542699cb5A962De0c364C71](https://testnet.bscscan.com/address/0xEEC2630f52a7D6436542699cb5A962De0c364C71) | 主仓库合约，处理质押/赎回逻辑 |
| BoosterWithdrawVault | [0x0a21dbd4c36c8f07Eed8F76a5b8d21a0721a427F](https://testnet.bscscan.com/address/0x0a21dbd4c36c8f07Eed8F76a5b8d21a0721a427F) | 提现缓冲仓，负责实际打款 |
| mBnUSDu | [0x18eC822Bf73F58E1aB522D122027592690fFa1E2](https://testnet.bscscan.com/address/0x18eC822Bf73F58E1aB522D122027592690fFa1E2) | bnStaked Token |
| sUSDu | [0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1](https://testnet.bscscan.com/address/0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1) | sUSDu Token |
| mUSDT | [0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142](https://testnet.bscscan.com/address/0x42e3D7f4cfE3B94BCeF3EBaEa832326AcB40C142) | mUSDT Token |

### Vault接口

- `stake_66380860(address _token, uint256 _stakedAmount)`
- 用户质押 `_token` 的底层资产，换取对应的 staked token

- `requestClaim_8135334(address _token, uint256 _amount, bool _isStakedTokenWithdraw) returns (uint256 queueId)`
- 发起赎回请求，按先奖励后本金的顺序划扣。`_amount` 可传 `type(uint256).max` 代表全部赎回
- 返回的 `queueId` 用于后续查询、取消或提现。

- `cancelClaim(uint256 _queueId, address _token)`
- 在等待期内撤销赎回请求，将本金和奖励重新记回用户资产信息并铸回 staked token。需要在取消开关开启后才能调用。

- `claim_41202704(uint256 _queueId, address _token)`
- 等待时间到期后领取赎回的本金和奖励。本金通过 `BoosterWithdrawVault` 发出，奖励会转入 `BoosterVaultEscrow` 记账并等待统一发放

- `flashWithdrawWithPenalty(address _token, uint256 _amount)`
- 立即赎回功能，对本金和奖励分别收取罚金后立即到账。本金直接发给用户，奖励会进入奖励托管合约

- `getClaimableAssets(address user, address token) → uint256`
- 返回用户当前可赎回的资产总额（本金 + 奖励）
- `getClaimableRewards(address user, address token) → uint256`
- 返回当前累积但尚未领取的奖励金额
- `getTotalRewards(address user, address token) → uint256`
- 返回历史已领取奖励与当前累积奖励之和，便于展示收益总额
- `getStakeHistory(address user, address token, uint256 index) → StakeItem`
- 按索引查询用户的质押记录，包含金额、时间戳等信息
- `getClaimHistory(address user, address token, uint256 index) → ClaimItem`
- 按索引查询用户的赎回记录，了解每笔赎回的本金和奖励
- `getStakeHistoryLength(address user, address token) → uint256`
- 查询用户质押记录的条数，搭配 `getStakeHistory` 遍历
- `getClaimHistoryLength(address user, address token) → uint256`
- 查询用户赎回记录的条数，搭配 `getClaimHistory` 遍历
- `getClaimQueueIDs(address user, address token) → uint256[]`
- 返回用户当前仍在排队的赎回请求 ID 列表，便于前端轮询
- `getClaimQueueInfo(uint256 queueId) → ClaimItem`
- 通过队列 ID 查看具体的赎回请求状态（请求时间、可领取时间等）
- `getTVL(address token) → uint256`
- 返回指定底层资产在 Vault 中的当前总锁仓量
