import {
  AddSupportedToken as AddSupportedTokenEvent,
  CancelClaim as CancelClaimEvent,
  CancelStatusChanged as CancelStatusChangedEvent,
  CeffuReceive as CeffuReceiveEvent,
  ClaimAssets as ClaimAssetsEvent,
  EmergencyWithdrawal as EmergencyWithdrawalEvent,
  FlashStatusChanged as FlashStatusChangedEvent,
  FlashWithdraw as FlashWithdrawEvent,
  Paused as PausedEvent,
  RequestClaim as RequestClaimEvent,
  RoleAdminChanged as RoleAdminChangedEvent,
  RoleGranted as RoleGrantedEvent,
  RoleRevoked as RoleRevokedEvent,
  Stake as StakeEvent,
  StakedDistributed as StakedDistributedEvent,
  StakedTokenRegistered as StakedTokenRegisteredEvent,
  Unpaused as UnpausedEvent,
  UpdateCeffu as UpdateCeffuEvent,
  UpdatePenaltyRate as UpdatePenaltyRateEvent,
  UpdateRewardRate as UpdateRewardRateEvent,
  UpdateStakeLimit as UpdateStakeLimitEvent,
  UpdateWaitingTime as UpdateWaitingTimeEvent
} from "../generated/BoosterVault/BoosterVault"
import {
  AddSupportedToken,
  CancelClaim,
  CancelStatusChanged,
  CeffuReceive,
  ClaimAssets,
  EmergencyWithdrawal,
  FlashStatusChanged,
  FlashWithdraw,
  Paused,
  RequestClaim,
  RoleAdminChanged,
  RoleGranted,
  RoleRevoked,
  Stake,
  StakedDistributed,
  StakedTokenRegistered,
  Unpaused,
  UpdateCeffu,
  UpdatePenaltyRate,
  UpdateRewardRate,
  UpdateStakeLimit,
  UpdateWaitingTime
} from "../generated/schema"

export function handleAddSupportedToken(event: AddSupportedTokenEvent): void {
  let entity = new AddSupportedToken(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._token = event.params._token
  entity._minAmount = event.params._minAmount
  entity._maxAmount = event.params._maxAmount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleCancelClaim(event: CancelClaimEvent): void {
  let entity = new CancelClaim(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.user = event.params.user
  entity._token = event.params._token
  entity._amount = event.params._amount
  entity.internal__id = event.params._id

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleCancelStatusChanged(
  event: CancelStatusChangedEvent
): void {
  let entity = new CancelStatusChanged(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.oldStatus = event.params.oldStatus
  entity.newStatus = event.params.newStatus

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleCeffuReceive(event: CeffuReceiveEvent): void {
  let entity = new CeffuReceive(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._token = event.params._token
  entity._ceffu = event.params._ceffu
  entity._amount = event.params._amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleClaimAssets(event: ClaimAssetsEvent): void {
  let entity = new ClaimAssets(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._user = event.params._user
  entity._token = event.params._token
  entity._amount = event.params._amount
  entity.internal__id = event.params._id

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleEmergencyWithdrawal(
  event: EmergencyWithdrawalEvent
): void {
  let entity = new EmergencyWithdrawal(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._token = event.params._token
  entity._receiver = event.params._receiver

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleFlashStatusChanged(event: FlashStatusChangedEvent): void {
  let entity = new FlashStatusChanged(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.oldStatus = event.params.oldStatus
  entity.newStatus = event.params.newStatus

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleFlashWithdraw(event: FlashWithdrawEvent): void {
  let entity = new FlashWithdraw(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._user = event.params._user
  entity._token = event.params._token
  entity._amount = event.params._amount
  entity._fee = event.params._fee

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handlePaused(event: PausedEvent): void {
  let entity = new Paused(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.account = event.params.account

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRequestClaim(event: RequestClaimEvent): void {
  let entity = new RequestClaim(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._user = event.params._user
  entity._token = event.params._token
  entity._amount = event.params._amount
  entity.internal__id = event.params._id
  entity._isSusduTokenWithdraw = event.params._isSusduTokenWithdraw

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRoleAdminChanged(event: RoleAdminChangedEvent): void {
  let entity = new RoleAdminChanged(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.role = event.params.role
  entity.previousAdminRole = event.params.previousAdminRole
  entity.newAdminRole = event.params.newAdminRole

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRoleGranted(event: RoleGrantedEvent): void {
  let entity = new RoleGranted(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.role = event.params.role
  entity.account = event.params.account
  entity.sender = event.params.sender

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRoleRevoked(event: RoleRevokedEvent): void {
  let entity = new RoleRevoked(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.role = event.params.role
  entity.account = event.params.account
  entity.sender = event.params.sender

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleStake(event: StakeEvent): void {
  let entity = new Stake(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._user = event.params._user
  entity._token = event.params._token
  entity._amount = event.params._amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleStakedDistributed(event: StakedDistributedEvent): void {
  let entity = new StakedDistributed(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = event.params.token
  entity.recipient = event.params.recipient
  entity.amount = event.params.amount
  entity.historicalRewardsEnabled = event.params.historicalRewardsEnabled

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleStakedTokenRegistered(
  event: StakedTokenRegisteredEvent
): void {
  let entity = new StakedTokenRegistered(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.stakedToken = event.params.stakedToken
  entity.underlyingToken = event.params.underlyingToken

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUnpaused(event: UnpausedEvent): void {
  let entity = new Unpaused(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.account = event.params.account

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUpdateCeffu(event: UpdateCeffuEvent): void {
  let entity = new UpdateCeffu(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._oldCeffu = event.params._oldCeffu
  entity._newCeffu = event.params._newCeffu

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUpdatePenaltyRate(event: UpdatePenaltyRateEvent): void {
  let entity = new UpdatePenaltyRate(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.oldRate = event.params.oldRate
  entity.newRate = event.params.newRate

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUpdateRewardRate(event: UpdateRewardRateEvent): void {
  let entity = new UpdateRewardRate(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._token = event.params._token
  entity._oldRewardRate = event.params._oldRewardRate
  entity._newRewardRate = event.params._newRewardRate

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUpdateStakeLimit(event: UpdateStakeLimitEvent): void {
  let entity = new UpdateStakeLimit(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._token = event.params._token
  entity._oldMinAmount = event.params._oldMinAmount
  entity._oldMaxAmount = event.params._oldMaxAmount
  entity._newMinAmount = event.params._newMinAmount
  entity._newMaxAmount = event.params._newMaxAmount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUpdateWaitingTime(event: UpdateWaitingTimeEvent): void {
  let entity = new UpdateWaitingTime(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity._oldWaitingTime = event.params._oldWaitingTime
  entity._newWaitingTIme = event.params._newWaitingTIme

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
