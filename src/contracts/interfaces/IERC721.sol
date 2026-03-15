// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {

    // This emits when ownership of any NFT changes by any mechanism 

    event Transfer(address indexed _from,address indexed _to,uint256 indexed _tokenId);


    // Counts all the NFTsn assigned to the owner 

    function balanceOf(address _owner) external view returns(uint256);

    // Find the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns(address);

    // Transfer the ownership of an NFT 
    function transferFrom(address _from,address _to,uint256 _tokenId) external;

 
}