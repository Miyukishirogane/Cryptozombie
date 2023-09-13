pragma solidity >=0.5.0 <0.6.0;

import "./Zombiefactory.sol";
contract KittyInterface{
    function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
);
}
contract ZombieFeeding is ZombieFactory {
    //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; remove
    //khởi tạo contract kitty bằng địa chỉ trên
    //KittyInterface kittyContract = KittyInterface(ckAddress);
    KittyInterface kittyContract;// chi dung de khai bao
  function setKittyContractAddress( address _address) external onlyOwner { // khong ai ben ngoai thay doi duoc kittyContract
    kittyContract = KittyInterface(_address);
  }
  function _triggerCooldown(Zombie storage _zombie) internal {
      _zombie.readyTime = uint32(now + cooldownTime);
  }
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return(_zombie.readyTime <= now);
  }
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal { // thay tu public sang
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    require (_isReady(myZombie)); // kiem tra _isReady va pass ham myZombie 
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
     if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}

