// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {

    /*
    Building out the minting function:

    1. Nft to point out to address
    2. Keep track of the token IDs
    3. Keep track of the token owner address to token Ids
    4. keep track of how many tokens an owner address has
    5. Create an event that emit transfer log - 
    contract address, where is it minted for , the id

    */

   // mapping from token IDs to owner
   mapping(uint => address) private _tokenOwner;

   // mapping from owner to number of owned tokens
   mapping(address => uint) private _OwnedTokensCount;

   // mapping from token ID  to approved addresses
   mapping(uint256 => address) private _tokenApprovals;


   // Register the interface for the ERC721 contract so it include the following
   // functions: balanceOf, ownerOf, transferFrom

   // Register the interface for the ERC721Eumerable contract so it includes the following:
   // totalSupply, tokenByIndexx, tokenOfOwnerByIndex functions

   // Register the interface for the ERC721MetaData contract so it includes the following:
   // name and symbol functions 





   constructor() {
    _registerInterface(
        bytes4(keccak256('balanceOf(bytes4)')) ^
        bytes4(keccak256('ownerOf(bytes4)')) ^
        bytes4(keccak256('transferFrom(bytes4)'))
    );
}

   // Count all the NFTs assigned to the owner
    function balanceOf(address _owner) public view override returns(uint256){

        require(_owner != address(0), 'owner query for non-existent token');

        return _OwnedTokensCount[_owner];

    }

    // Find the owner of an NFT
    function ownerOf(uint256 _tokenId) public view override returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token');
        return owner;
    }

   function _exists(uint256 tokenId) internal view returns(bool) {
    // setting the address of the nft owner 
    address owner = _tokenOwner[tokenId];
    // return truthness and address not zero 
    return owner != address(0);

   }


   function _mint(address to, uint256 tokenId) internal virtual {
    // requires that the address is not zero
    require(to != address(0), 'ERC721: minting to non zero address');
    // require that the token does not already exists
    require(!_exists(tokenId), 'ERC721: token already minted');

    // we are adding a new address with token id for minting
    _tokenOwner[tokenId] = to;

    // keeping track of each address that is minting and adding one to the count
    _OwnedTokensCount[to] += 1;

    emit Transfer(address(0), to, tokenId);

   }


   // Transfer the ownership of an NFT - The Caller is responsible
   // to confirm that the _to is capable of receiving the NFT else it is permanently lost
   function _transferFrom(address _from, address _to, uint256 _tokenId) internal {

   require(_to != address(0), 'Error- ERC721 Transfer to zero address');
   require(ownerOf(_tokenId) == _from, 'Trying to transfer a token from an address that does not own it');

    _OwnedTokensCount[_from] -= 1;
    _OwnedTokensCount[_to] += 1;
    _tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);

   }

   function transferFrom(address _from, address _to, uint256 _tokenId) override public {

    _transferFrom(_from, _to, _tokenId);

   }
}