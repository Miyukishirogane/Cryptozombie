pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId){
    require(zombies[_zombieId].level >= _level);
    _;
    // dieu kien
  }
  function withdraw() external onlyOwner{
    address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);
  }
  // ham rut tien 
  function setLevelUpFee(uint _fee) external onlyOwner(){
   levelUpFee = _fee;
  }
  // ham
  function levelUp(uint _zombieID) external payable { // gui Ether len hop dong
    require( msg.value == levelUpFee);
    zombies[_zombieID].level++;
  }
  function changeName(uint _zombieId, string calldata _newName ) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) { 
    //kiem tra ten cua zombie
    //tao ten cho kitty-zombie
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId){
    //kiem tra ten dna
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }
  function getZombiesByOwner(address _owner) external view returns(uint[] memory)  { //view giup khach hang xem giao dich khong mat phi
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for(uint i = 0; i < zombies.length; i++) {
        if (zombieToOwner[i] == _owner) {
           result[counter] = i;
           counter++;
        }        
    }
    // tra ve tat ca giao dich cua chu so huu ma khong mat phi gas
    return result;
   }
}
