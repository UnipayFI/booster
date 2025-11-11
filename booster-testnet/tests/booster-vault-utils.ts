import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt, Bytes } from "@graphprotocol/graph-ts"
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
  UpdateVaultLedger,
  UpdateWaitingTime
} from "../generated/BoosterVault/BoosterVault"

export function createAddSupportedTokenEvent(
  _token: Address,
  _minAmount: BigInt,
  _maxAmount: BigInt
): AddSupportedToken {
  let addSupportedTokenEvent = changetype<AddSupportedToken>(newMockEvent())

  addSupportedTokenEvent.parameters = new Array()

  addSupportedTokenEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  addSupportedTokenEvent.parameters.push(
    new ethereum.EventParam(
      "_minAmount",
      ethereum.Value.fromUnsignedBigInt(_minAmount)
    )
  )
  addSupportedTokenEvent.parameters.push(
    new ethereum.EventParam(
      "_maxAmount",
      ethereum.Value.fromUnsignedBigInt(_maxAmount)
    )
  )

  return addSupportedTokenEvent
}

export function createCancelClaimEvent(
  user: Address,
  _token: Address,
  _amount: BigInt,
  _id: BigInt
): CancelClaim {
  let cancelClaimEvent = changetype<CancelClaim>(newMockEvent())

  cancelClaimEvent.parameters = new Array()

  cancelClaimEvent.parameters.push(
    new ethereum.EventParam("user", ethereum.Value.fromAddress(user))
  )
  cancelClaimEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  cancelClaimEvent.parameters.push(
    new ethereum.EventParam(
      "_amount",
      ethereum.Value.fromUnsignedBigInt(_amount)
    )
  )
  cancelClaimEvent.parameters.push(
    new ethereum.EventParam("_id", ethereum.Value.fromUnsignedBigInt(_id))
  )

  return cancelClaimEvent
}

export function createCancelStatusChangedEvent(
  oldStatus: boolean,
  newStatus: boolean
): CancelStatusChanged {
  let cancelStatusChangedEvent = changetype<CancelStatusChanged>(newMockEvent())

  cancelStatusChangedEvent.parameters = new Array()

  cancelStatusChangedEvent.parameters.push(
    new ethereum.EventParam("oldStatus", ethereum.Value.fromBoolean(oldStatus))
  )
  cancelStatusChangedEvent.parameters.push(
    new ethereum.EventParam("newStatus", ethereum.Value.fromBoolean(newStatus))
  )

  return cancelStatusChangedEvent
}

export function createCeffuReceiveEvent(
  _token: Address,
  _ceffu: Address,
  _amount: BigInt
): CeffuReceive {
  let ceffuReceiveEvent = changetype<CeffuReceive>(newMockEvent())

  ceffuReceiveEvent.parameters = new Array()

  ceffuReceiveEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  ceffuReceiveEvent.parameters.push(
    new ethereum.EventParam("_ceffu", ethereum.Value.fromAddress(_ceffu))
  )
  ceffuReceiveEvent.parameters.push(
    new ethereum.EventParam(
      "_amount",
      ethereum.Value.fromUnsignedBigInt(_amount)
    )
  )

  return ceffuReceiveEvent
}

export function createClaimAssetsEvent(
  _user: Address,
  _token: Address,
  _amount: BigInt,
  _id: BigInt
): ClaimAssets {
  let claimAssetsEvent = changetype<ClaimAssets>(newMockEvent())

  claimAssetsEvent.parameters = new Array()

  claimAssetsEvent.parameters.push(
    new ethereum.EventParam("_user", ethereum.Value.fromAddress(_user))
  )
  claimAssetsEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  claimAssetsEvent.parameters.push(
    new ethereum.EventParam(
      "_amount",
      ethereum.Value.fromUnsignedBigInt(_amount)
    )
  )
  claimAssetsEvent.parameters.push(
    new ethereum.EventParam("_id", ethereum.Value.fromUnsignedBigInt(_id))
  )

  return claimAssetsEvent
}

export function createEmergencyWithdrawalEvent(
  _token: Address,
  _receiver: Address
): EmergencyWithdrawal {
  let emergencyWithdrawalEvent = changetype<EmergencyWithdrawal>(newMockEvent())

  emergencyWithdrawalEvent.parameters = new Array()

  emergencyWithdrawalEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  emergencyWithdrawalEvent.parameters.push(
    new ethereum.EventParam("_receiver", ethereum.Value.fromAddress(_receiver))
  )

  return emergencyWithdrawalEvent
}

export function createFlashStatusChangedEvent(
  oldStatus: boolean,
  newStatus: boolean
): FlashStatusChanged {
  let flashStatusChangedEvent = changetype<FlashStatusChanged>(newMockEvent())

  flashStatusChangedEvent.parameters = new Array()

  flashStatusChangedEvent.parameters.push(
    new ethereum.EventParam("oldStatus", ethereum.Value.fromBoolean(oldStatus))
  )
  flashStatusChangedEvent.parameters.push(
    new ethereum.EventParam("newStatus", ethereum.Value.fromBoolean(newStatus))
  )

  return flashStatusChangedEvent
}

export function createFlashWithdrawEvent(
  _user: Address,
  _token: Address,
  _amount: BigInt,
  _fee: BigInt
): FlashWithdraw {
  let flashWithdrawEvent = changetype<FlashWithdraw>(newMockEvent())

  flashWithdrawEvent.parameters = new Array()

  flashWithdrawEvent.parameters.push(
    new ethereum.EventParam("_user", ethereum.Value.fromAddress(_user))
  )
  flashWithdrawEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  flashWithdrawEvent.parameters.push(
    new ethereum.EventParam(
      "_amount",
      ethereum.Value.fromUnsignedBigInt(_amount)
    )
  )
  flashWithdrawEvent.parameters.push(
    new ethereum.EventParam("_fee", ethereum.Value.fromUnsignedBigInt(_fee))
  )

  return flashWithdrawEvent
}

export function createPausedEvent(account: Address): Paused {
  let pausedEvent = changetype<Paused>(newMockEvent())

  pausedEvent.parameters = new Array()

  pausedEvent.parameters.push(
    new ethereum.EventParam("account", ethereum.Value.fromAddress(account))
  )

  return pausedEvent
}

export function createRequestClaimEvent(
  _user: Address,
  _token: Address,
  _amount: BigInt,
  _id: BigInt,
  _isStakedTokenWithdraw: boolean
): RequestClaim {
  let requestClaimEvent = changetype<RequestClaim>(newMockEvent())

  requestClaimEvent.parameters = new Array()

  requestClaimEvent.parameters.push(
    new ethereum.EventParam("_user", ethereum.Value.fromAddress(_user))
  )
  requestClaimEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  requestClaimEvent.parameters.push(
    new ethereum.EventParam(
      "_amount",
      ethereum.Value.fromUnsignedBigInt(_amount)
    )
  )
  requestClaimEvent.parameters.push(
    new ethereum.EventParam("_id", ethereum.Value.fromUnsignedBigInt(_id))
  )
  requestClaimEvent.parameters.push(
    new ethereum.EventParam(
      "_isStakedTokenWithdraw",
      ethereum.Value.fromBoolean(_isStakedTokenWithdraw)
    )
  )

  return requestClaimEvent
}

export function createRoleAdminChangedEvent(
  role: Bytes,
  previousAdminRole: Bytes,
  newAdminRole: Bytes
): RoleAdminChanged {
  let roleAdminChangedEvent = changetype<RoleAdminChanged>(newMockEvent())

  roleAdminChangedEvent.parameters = new Array()

  roleAdminChangedEvent.parameters.push(
    new ethereum.EventParam("role", ethereum.Value.fromFixedBytes(role))
  )
  roleAdminChangedEvent.parameters.push(
    new ethereum.EventParam(
      "previousAdminRole",
      ethereum.Value.fromFixedBytes(previousAdminRole)
    )
  )
  roleAdminChangedEvent.parameters.push(
    new ethereum.EventParam(
      "newAdminRole",
      ethereum.Value.fromFixedBytes(newAdminRole)
    )
  )

  return roleAdminChangedEvent
}

export function createRoleGrantedEvent(
  role: Bytes,
  account: Address,
  sender: Address
): RoleGranted {
  let roleGrantedEvent = changetype<RoleGranted>(newMockEvent())

  roleGrantedEvent.parameters = new Array()

  roleGrantedEvent.parameters.push(
    new ethereum.EventParam("role", ethereum.Value.fromFixedBytes(role))
  )
  roleGrantedEvent.parameters.push(
    new ethereum.EventParam("account", ethereum.Value.fromAddress(account))
  )
  roleGrantedEvent.parameters.push(
    new ethereum.EventParam("sender", ethereum.Value.fromAddress(sender))
  )

  return roleGrantedEvent
}

export function createRoleRevokedEvent(
  role: Bytes,
  account: Address,
  sender: Address
): RoleRevoked {
  let roleRevokedEvent = changetype<RoleRevoked>(newMockEvent())

  roleRevokedEvent.parameters = new Array()

  roleRevokedEvent.parameters.push(
    new ethereum.EventParam("role", ethereum.Value.fromFixedBytes(role))
  )
  roleRevokedEvent.parameters.push(
    new ethereum.EventParam("account", ethereum.Value.fromAddress(account))
  )
  roleRevokedEvent.parameters.push(
    new ethereum.EventParam("sender", ethereum.Value.fromAddress(sender))
  )

  return roleRevokedEvent
}

export function createStakeEvent(
  _user: Address,
  _token: Address,
  _amount: BigInt
): Stake {
  let stakeEvent = changetype<Stake>(newMockEvent())

  stakeEvent.parameters = new Array()

  stakeEvent.parameters.push(
    new ethereum.EventParam("_user", ethereum.Value.fromAddress(_user))
  )
  stakeEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  stakeEvent.parameters.push(
    new ethereum.EventParam(
      "_amount",
      ethereum.Value.fromUnsignedBigInt(_amount)
    )
  )

  return stakeEvent
}

export function createStakedDistributedEvent(
  token: Address,
  recipient: Address,
  amount: BigInt,
  historicalRewardsEnabled: boolean
): StakedDistributed {
  let stakedDistributedEvent = changetype<StakedDistributed>(newMockEvent())

  stakedDistributedEvent.parameters = new Array()

  stakedDistributedEvent.parameters.push(
    new ethereum.EventParam("token", ethereum.Value.fromAddress(token))
  )
  stakedDistributedEvent.parameters.push(
    new ethereum.EventParam("recipient", ethereum.Value.fromAddress(recipient))
  )
  stakedDistributedEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  stakedDistributedEvent.parameters.push(
    new ethereum.EventParam(
      "historicalRewardsEnabled",
      ethereum.Value.fromBoolean(historicalRewardsEnabled)
    )
  )

  return stakedDistributedEvent
}

export function createStakedTokenRegisteredEvent(
  stakedToken: Address,
  underlyingToken: Address
): StakedTokenRegistered {
  let stakedTokenRegisteredEvent =
    changetype<StakedTokenRegistered>(newMockEvent())

  stakedTokenRegisteredEvent.parameters = new Array()

  stakedTokenRegisteredEvent.parameters.push(
    new ethereum.EventParam(
      "stakedToken",
      ethereum.Value.fromAddress(stakedToken)
    )
  )
  stakedTokenRegisteredEvent.parameters.push(
    new ethereum.EventParam(
      "underlyingToken",
      ethereum.Value.fromAddress(underlyingToken)
    )
  )

  return stakedTokenRegisteredEvent
}

export function createUnpausedEvent(account: Address): Unpaused {
  let unpausedEvent = changetype<Unpaused>(newMockEvent())

  unpausedEvent.parameters = new Array()

  unpausedEvent.parameters.push(
    new ethereum.EventParam("account", ethereum.Value.fromAddress(account))
  )

  return unpausedEvent
}

export function createUpdateCeffuEvent(
  _oldCeffu: Address,
  _newCeffu: Address
): UpdateCeffu {
  let updateCeffuEvent = changetype<UpdateCeffu>(newMockEvent())

  updateCeffuEvent.parameters = new Array()

  updateCeffuEvent.parameters.push(
    new ethereum.EventParam("_oldCeffu", ethereum.Value.fromAddress(_oldCeffu))
  )
  updateCeffuEvent.parameters.push(
    new ethereum.EventParam("_newCeffu", ethereum.Value.fromAddress(_newCeffu))
  )

  return updateCeffuEvent
}

export function createUpdatePenaltyRateEvent(
  oldRate: BigInt,
  newRate: BigInt
): UpdatePenaltyRate {
  let updatePenaltyRateEvent = changetype<UpdatePenaltyRate>(newMockEvent())

  updatePenaltyRateEvent.parameters = new Array()

  updatePenaltyRateEvent.parameters.push(
    new ethereum.EventParam(
      "oldRate",
      ethereum.Value.fromUnsignedBigInt(oldRate)
    )
  )
  updatePenaltyRateEvent.parameters.push(
    new ethereum.EventParam(
      "newRate",
      ethereum.Value.fromUnsignedBigInt(newRate)
    )
  )

  return updatePenaltyRateEvent
}

export function createUpdateRewardRateEvent(
  _token: Address,
  _oldRewardRate: BigInt,
  _newRewardRate: BigInt
): UpdateRewardRate {
  let updateRewardRateEvent = changetype<UpdateRewardRate>(newMockEvent())

  updateRewardRateEvent.parameters = new Array()

  updateRewardRateEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  updateRewardRateEvent.parameters.push(
    new ethereum.EventParam(
      "_oldRewardRate",
      ethereum.Value.fromUnsignedBigInt(_oldRewardRate)
    )
  )
  updateRewardRateEvent.parameters.push(
    new ethereum.EventParam(
      "_newRewardRate",
      ethereum.Value.fromUnsignedBigInt(_newRewardRate)
    )
  )

  return updateRewardRateEvent
}

export function createUpdateStakeLimitEvent(
  _token: Address,
  _oldMinAmount: BigInt,
  _oldMaxAmount: BigInt,
  _newMinAmount: BigInt,
  _newMaxAmount: BigInt
): UpdateStakeLimit {
  let updateStakeLimitEvent = changetype<UpdateStakeLimit>(newMockEvent())

  updateStakeLimitEvent.parameters = new Array()

  updateStakeLimitEvent.parameters.push(
    new ethereum.EventParam("_token", ethereum.Value.fromAddress(_token))
  )
  updateStakeLimitEvent.parameters.push(
    new ethereum.EventParam(
      "_oldMinAmount",
      ethereum.Value.fromUnsignedBigInt(_oldMinAmount)
    )
  )
  updateStakeLimitEvent.parameters.push(
    new ethereum.EventParam(
      "_oldMaxAmount",
      ethereum.Value.fromUnsignedBigInt(_oldMaxAmount)
    )
  )
  updateStakeLimitEvent.parameters.push(
    new ethereum.EventParam(
      "_newMinAmount",
      ethereum.Value.fromUnsignedBigInt(_newMinAmount)
    )
  )
  updateStakeLimitEvent.parameters.push(
    new ethereum.EventParam(
      "_newMaxAmount",
      ethereum.Value.fromUnsignedBigInt(_newMaxAmount)
    )
  )

  return updateStakeLimitEvent
}

export function createUpdateVaultLedgerEvent(
  oldVaultLedger: Address,
  newVaultLedger: Address
): UpdateVaultLedger {
  let updateVaultLedgerEvent = changetype<UpdateVaultLedger>(newMockEvent())

  updateVaultLedgerEvent.parameters = new Array()

  updateVaultLedgerEvent.parameters.push(
    new ethereum.EventParam(
      "oldVaultLedger",
      ethereum.Value.fromAddress(oldVaultLedger)
    )
  )
  updateVaultLedgerEvent.parameters.push(
    new ethereum.EventParam(
      "newVaultLedger",
      ethereum.Value.fromAddress(newVaultLedger)
    )
  )

  return updateVaultLedgerEvent
}

export function createUpdateWaitingTimeEvent(
  _oldWaitingTime: BigInt,
  _newWaitingTIme: BigInt
): UpdateWaitingTime {
  let updateWaitingTimeEvent = changetype<UpdateWaitingTime>(newMockEvent())

  updateWaitingTimeEvent.parameters = new Array()

  updateWaitingTimeEvent.parameters.push(
    new ethereum.EventParam(
      "_oldWaitingTime",
      ethereum.Value.fromUnsignedBigInt(_oldWaitingTime)
    )
  )
  updateWaitingTimeEvent.parameters.push(
    new ethereum.EventParam(
      "_newWaitingTIme",
      ethereum.Value.fromUnsignedBigInt(_newWaitingTIme)
    )
  )

  return updateWaitingTimeEvent
}
