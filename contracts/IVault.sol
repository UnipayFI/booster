// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Main information: stake and claim
struct AssetsInfo {
  uint256 stakedAmount;
  uint256 accumulatedReward;
  uint256 lastRewardUpdateTime;
  uint256[] pendingClaimQueueIDs;
  StakeItem[] stakeHistory;
  ClaimItem[] claimHistory;
}

struct StakeItem {
  address token;
  address user;
  uint256 amount;
  uint256 stakeTimestamp;
}

struct ClaimItem {
  bool isDone;
  bool isStakedTokenWithdraw;
  address token;
  address user;
  uint256 totalAmount;
  uint256 principalAmount;
  uint256 rewardAmount;
  uint256 requestTime;
  uint256 claimTime;
}

interface IVault {
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///                                             events                                                ///
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  event Stake(address indexed _user, address indexed _token, uint256 indexed _amount);
  event RequestClaim(
    address _user,
    address indexed _token,
    uint256 indexed _amount,
    uint256 indexed _id,
    bool _isStakedTokenWithdraw
  );
  event ClaimAssets(address indexed _user, address indexed _token, uint256 indexed _amount, uint256 _id);
  event UpdateRewardRate(address _token, uint256 _oldRewardRate, uint256 _newRewardRate);
  event UpdateCeffu(address _oldCeffu, address _newCeffu);
  event UpdateStakeLimit(
    address indexed _token,
    uint256 _oldMinAmount,
    uint256 _oldMaxAmount,
    uint256 _newMinAmount,
    uint256 _newMaxAmount
  );
  event CeffuReceive(address indexed _token, address _ceffu, uint256 indexed _amount);
  event AddSupportedToken(address indexed _token, uint256 _minAmount, uint256 _maxAmount);
  event EmergencyWithdrawal(address indexed _token, address indexed _receiver);
  event UpdateWaitingTime(uint256 _oldWaitingTime, uint256 _newWaitingTIme);
  event StakedTokenRegistered(address indexed stakedToken, address indexed underlyingToken);
  event StakedDistributed(
    address indexed token,
    address indexed recipient,
    uint256 amount,
    bool historicalRewardsEnabled
  );
  event FlashWithdraw(address indexed _user, address indexed _token, uint256 indexed _amount, uint256 _fee);
  event UpdatePenaltyRate(uint256 indexed oldRate, uint256 indexed newRate);
  event CancelClaim(address indexed user, address indexed _token, uint256 indexed _amount, uint256 _id);
  event UpdateVaultLedger(address indexed oldVaultLedger, address indexed newVaultLedger);
  event FlashStatusChanged(bool indexed oldStatus, bool indexed newStatus);
  event CancelStatusChanged(bool indexed oldStatus, bool indexed newStatus);

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///                                             write                                                 ///
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  function stake_66380860(address _token, uint256 _stakedAmount) external;

  function requestClaim_8135334(
    address _token,
    uint256 _amount,
    bool _isStakedTokenWithdraw
  ) external returns (uint256);

  function cancelClaim(uint256 _queueId, address _token) external;

  function claim_41202704(uint256 _queueID, address token) external;

  function flashWithdrawWithPenalty(address _token, uint256 _amount) external;

  function distributeStaked(address token, address to, uint256 amount, bool enableHistoricalRewards) external;

  function transferToCeffu(address _token, uint256 _amount) external;

  function emergencyWithdraw(address _token, address _receiver) external;

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///                                        configuration                                              ///
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  function addSupportedToken(
    address _token,
    uint256 _minAmount,
    uint256 _maxAmount,
    address _stakedToken,
    uint256 _newRewardRate
  ) external;

  function setRewardRate(address _token, uint256 _newRewardRate) external;

  function setPenaltyRate(uint256 _newRate) external;

  function setDistributorAddr(address newDistributorAddr) external;

  function setVaultLedger(address newVaultLedger) external;

  function setStakeLimit(address _token, uint256 _minAmount, uint256 _maxAmount) external;

  function setCeffu(address _newCeffu) external;

  function setWaitingTime(uint256 _newWaitingTIme) external;

  function pause() external;

  function unpause() external;

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///                                          view / pure                                              ///
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  function convertToShares(uint256 tokenAmount, address _token) external view returns (uint256);

  function convertToAssets(uint256 staked, address _token) external view returns (uint256);

  function getClaimableRewardsWithTargetTime(
    address _user,
    address _token,
    uint256 _targetTime
  ) external view returns (uint256);

  function getClaimableAssets(address _user, address _token) external view returns (uint256);

  function getClaimableRewards(address _user, address _token) external view returns (uint256);

  function getTotalRewards(address _user, address _token) external view returns (uint256);

  function getStakedAmount(address _user, address _token) external view returns (uint256);

  function getContractBalance(address _token) external view returns (uint256);

  function getStakeHistory(address _user, address _token, uint256 _index) external view returns (StakeItem memory);

  function getClaimHistory(address _user, address _token, uint256 _index) external view returns (ClaimItem memory);

  function getStakeHistoryLength(address _user, address _token) external view returns (uint256);

  function getClaimHistoryLength(address _user, address _token) external view returns (uint256);

  function getCurrentRewardRate(address _token) external view returns (uint256, uint256);

  function getClaimQueueInfo(uint256 _index) external view returns (ClaimItem memory);

  function getClaimQueueIDs(address _user, address _token) external view returns (uint256[] memory);

  function getTVL(address _token) external view returns (uint256);

  function getStakedBalance(address _user, address _token) external view returns (uint256);

  function lastClaimQueueID() external view returns (uint256);

  function getVaultLedgerAddress() external view returns (address);
}
