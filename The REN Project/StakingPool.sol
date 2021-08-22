pragma solidity 0.4.24;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import './StakeContract.sol';

contract StakePool is Pausable {
  using SafeMath for uint;
  address private stakeContract;
  StakeContract private scObj;
  uint private netStaked;
  uint private netDeposited;
  mapping(address => uint) private deposited;
  mapping(address => uint) private staked;
  mapping(address => uint) private requestStake;
  mapping(address => uint) private requestUnStake;
  mapping(address => uint) private userIndex;
  address[] private users;

  event NotifyDeposit(address sender, uint amount, uint balance);
  event NotifyStaked(address sender, uint amount);
  event NotifyWithdrawal(address sender, uint startBal, uint finalBal, uint request);

  constructor(address stctrct) public {
    require(stctrct != address(0));
    stakeContract = stctrct;
    scObj = StakeContract(stakeContract);
    users.push(owner);
  }

  function isExistingUser(address _user) internal view returns (bool) {
    if ( userIndex[_user] == 0) {
      return false;
    }
    return true;
  }

  function removeUser(address _user) internal {
    if (_user == owner ) return;
    uint index = userIndex[_user];
    if (index < users.length.sub(1)) {
      address lastUser = users[users.length.sub(1)];
      users[index] = lastUser;
      userIndex[lastUser] = index;
    }
    users.length = users.length.sub(1);
  }

  function addUser(address _user) internal {
    if (_user == owner ) return;
    if (isExistingUser(_user)) return;
    users.push(_user);
    userIndex[_user] = users.length.sub(1);
  }

  function setStakeContract(address _stakeContract) external onlyOwner {
    require(_stakeContract != address(0));
    stakeContract = _stakeContract;
    scObj = StakeContract(stakeContract);
  }

  function stake() payable external onlyOwner {
    uint toStake;
    for (uint i = 0; i < users.length; i++) {
      uint amount = requestStake[users[i]];
      toStake = toStake.add(amount);
      staked[users[i]] = staked[users[i]].add(amount);
      requestStake[users[i]] = 0;
    }
    netStaked = netStaked.add(toStake);
    address(scObj).transfer(toStake);
    emit NotifyStaked(msg.sender, toStake);
  }

  function unstake() external onlyOwner {
    uint unStake;
    for (uint i = 0; i < users.length; i++) {
      uint amount = requestUnStake[users[i]];
      unStake = unStake.add(amount);
      staked[users[i]] = staked[users[i]].sub(amount);
      deposited[users[i]] = deposited[users[i]].add(amount);
      requestUnStake[users[i]] = 0;
    }
    netStaked = netStaked.sub(unStake);
    scObj.withdraw(unStake);
    emit NotifyStaked(msg.sender, -unStake);
  }

  function deposit() external payable whenNotPaused {
    deposited[msg.sender] = deposited[msg.sender].add(msg.value);
    emit NotifyDeposit(msg.sender, msg.value, deposited[msg.sender]);
  }

  function withdraw(uint wdValue) external whenNotPaused {
    require(wdValue > 0);
    require(deposited[msg.sender] >= wdValue);
    uint startBalance = deposited[msg.sender];
    deposited[msg.sender] = deposited[msg.sender].sub(wdValue);
    msg.sender.transfer(wdValue);
    emit NotifyWithdrawal(
      msg.sender,
      startBalance,
      deposited[msg.sender],
      wdValue
    );
  }

  function getState() external view returns (uint[]) {
    uint[] memory state = new uint[](4);
    state[0] = deposited[msg.sender];
    state[1] = requestStake[msg.sender];
    state[2] = requestUnStake[msg.sender];
    state[3] = staked[msg.sender];
    return state;
  }
}