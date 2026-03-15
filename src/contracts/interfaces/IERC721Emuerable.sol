// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IERC721Emuerable {

    // Counts the NFTs tracked by this contract
    function totalSupply() external view returns(uint256);

    // Enumerate Valid NFts
    function tokenByIndex(uint256 _index) external view returns(uint256);

    // Enumerate NTFs assigned to an owner
    function tokenOfOwnerByIndex(address _owner,uint256 _index) external view returns(uint256);
}