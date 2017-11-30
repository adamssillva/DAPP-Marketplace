pragma solidity ^0.4.11;

contract Owned{
  //State variables
  address owner;

  //Modifier
  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }

  //constructor
  function Owned(){
    owner = msg.sender;
  }
}
