pragma solidity >= 0.5.0  <= 0.6.0;
import "./zombiehelper.sol";
contract ZombieAttack is ZombieHelper {
   uint randNonce = 0;
   uint attackVictoryProbability = 70 % 100 ;
   function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now,msg.sender,randNonce))) % _modulus ;
    // *now: tranh 2 ham hash cung 1 luc, *ranNonce: tranh dung cung 1 so de tao hash
   }
   // ham tra ve so random tu ham hash keccak256
  
   function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
       Zombie storage myZombie = zombies[_zombieId];
       Zombie storage enemyZombie = zombies[_targetId];
       uint rand = randMod(100);
       if( rand <= attackVictoryProbability) {
        myZombie.winCount++;
        myZombie.level++;
        myZombie.lossCount++;
        feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
       }
       //thang
       else{
        myZombie.lossCount++;
        enemyZombie.winCount++;
        _triggerCooldown(myZombie);
        //chi dat cuoc toi da 1 lan 1 ngay, ham nam trong feedAndMultipy nen thang hay thua van chay
       }
       //thua
   }

}