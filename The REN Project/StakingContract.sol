pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';

/* SHWETA :: stake ctrct  */


contract StakeContract {
using SafeMath for uint;
  constructor() public { }
   event NotifyWithdraw( address sender, uint startBal, uint finalBal, uint request);
  function withdraw(uint withdrawal) public {
    uint strtBal = address(this).balance;
    uint finBal = address(this).balance.sub(withdrawal);
    msg.sender.transfer(withdrawal);
    emit NotifyWithdraw(msg.sender,strtBal,finBal,withdrawal );
  }
  

}