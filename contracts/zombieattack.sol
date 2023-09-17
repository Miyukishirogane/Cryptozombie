// SPDX-License-Identifier: MIT
pragma solidity >=0.5.2 <= 0.8.21;
import "./zombiehelper.sol";
contract ZombieAttack is ZombieHelper {
   uint randNonce = 0;
   uint attackVictoryProbability = 70 % 100 ;
   function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce++;
    return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus ;
    // *now: tranh 2 ham hash cung 1 luc, *ranNonce: tranh dung cung 1 so de tao hash
   }
   // ham tra ve so random tu ham hash keccak256
  
   function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
       Zombie storage myZombie = zombies[_zombieId];
       Zombie storage enemyZombie = zombies[_targetId];
       uint rand = randMod(100);
       if( rand <= attackVictoryProbability) {
        myZombie.winCount = myZombie.winCount++;
        myZombie.level = myZombie.level++;
        enemyZombie.lossCount = enemyZombie.lossCount++;
        feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
       }
       //thang
       else{
         myZombie.lossCount = myZombie.lossCount++;
        enemyZombie.winCount = enemyZombie.winCount++;
        _triggerCooldown(myZombie);
        //chi dat cuoc toi da 1 lan 1 ngay, ham nam trong feedAndMultipy nen thang hay thua van chay
       }
       //thua
   }

}