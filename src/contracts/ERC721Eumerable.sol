// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

import './interfaces/IERC721Emuerable.sol';


contract ERC721Eumerable is IERC721Emuerable, ERC721 {

    uint256 [] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private __allTokensIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from tokenID to index of the owner token list 
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
    _registerInterface(
        bytes4(keccak256('totalSupply(bytes4)')) ^
        bytes4(keccak256('tokenByIndexx(bytes4)')) ^
        bytes4(keccak256('tokenOfOwnerByIndex(bytes4)'))
    );
}


    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to,tokenId);

        // Add token to the owner
        // Add token to our totalSupply of allTokens

        _addTokensToAllTokenEumeration(tokenId);
        _addTokensToOwnerEumeration(to,tokenId);

    }

    // add tokens to the _allToken array and set the postion of the tokens indexs
    function _addTokensToAllTokenEumeration(uint256 tokenId) private {

        __allTokensIndex[tokenId] = _allTokens.length;

        _allTokens.push(tokenId);
    }


    function _addTokensToOwnerEumeration(address to,uint256 tokenId) private {
        
        // 1. add address and token id to the _ownedTokens
        // 2. ownedTokensIndex tokenId set to address of ownedTokens postion 
        // 3. execute the function with minting 
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
    } 

    // two functions - one that returns tokenbyIndex 
    // the second function return the tokenOfOwnerIndex
    function tokenByIndex(uint256 index) public override view returns(uint256){
        // make sure that index is not out of bounds of the total supply
        require(index < totalSupply(),'Global index is out of bound');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public override view returns(uint256){
        require(index < balanceOf(owner), 'Owner index is out of bound');
        return _ownedTokens[owner][index];

    }


    // return the total supply of _allToken array
    function totalSupply() public override view returns(uint256) {
        return _allTokens.length;
    }




}