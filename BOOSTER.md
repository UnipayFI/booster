# Booster Evm Contract

## BSC_TESTNET

## Booster 合约

### BSC Testnet 地址

| 合约 | 地址 | 说明 |
|------|------|------|
| BoosterVault | [0xa36eD436cF6551711775BfF958a1225BEa84e0A0](https://testnet.bscscan.com/address/0xa36eD436cF6551711775BfF958a1225BEa84e0A0) | 主仓库合约，处理质押/赎回逻辑 |
| BoosterVaultLedger | [0x3B082664E73A9cb777DbAeb72d07d26c052E6A1A](https://testnet.bscscan.com/address/0x3B082664E73A9cb777DbAeb72d07d26c052E6A1A) | 奖励托管合约，记录并发放奖励 |
| BoosterWithdrawVault | [0x8d00d928076D8A34F631fe55DB20afdEDeC6815E](https://testnet.bscscan.com/address/0x8d00d928076D8A34F631fe55DB20afdEDeC6815E) | 提现缓冲仓，负责实际打款 |
| mBnUSDu | [0xF8F9900Da972d7F5964994E709D8D03C917caBE4](https://testnet.bscscan.com/address/0xF8F9900Da972d7F5964994E709D8D03C917caBE4) | bnStaked Token |
| sUSDu | [0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1](https://testnet.bscscan.com/address/0xfaf2A0372742A305817f5a634cA8E1C75a3Cf3E1) | sUSDu Token |

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
