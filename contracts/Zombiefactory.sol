// SPDX-License-Identifier: MIT
pragma solidity >=0.5.2 <= 0.8.21;

import "./ownable.sol";
import "./safemath.sol";
contract ZombieFactory is Ownable {
// ke thua Ownable
   
   using SafeMath for uint256;
   using SafeMath32 for uint32;
   using SafeMath16 for uint16;
    event NewZombie(uint zombieId, string name, uint dna);
    // 

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;
    // tạo mảng zombies
   

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;
    // luu tru theo kiểu key value

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime),0,0));
        uint256 id = zombies.length.sub(1);
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
        // emit: phát ra event giúp bên thứ 3 bên ngoài bắt được event blockchain
    }
    
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
