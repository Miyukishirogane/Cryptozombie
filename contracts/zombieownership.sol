pragma solidity >= 0.5.0 <= 0.6.0;
import "./zombieattack.sol";
import "./erc721.sol";
contract ZombieOwnership is ZombieAttack, ERC721 {
    mapping (uint => address) zombieApprovals;
    function balanceOf(address _owner) external view returns (uint256) {
        return ownerZombieCount[_owner];
    // 1. Return the number of zombies `_owner` has here
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
    // 2. Return the owner of `_tokenId` here
  }
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
     require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
     //chi nguoi so huu hoac da dong y dia chi duoc chuyen
    _transfer(_from, _to, _tokenId);
    // goi ham transfer
  }
  
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
  }
  // chap thuan gui token

}