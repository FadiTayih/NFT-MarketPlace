// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721MetaData {

    // A descriptive Name of the NFT collection
    function name() external view returns(string memory _name);


    // A Abbreviated name for the NFT
    function symbol() external view returns(string memory _symbol);


}