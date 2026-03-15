// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface  IERC165 {

    // Query if a contract implments an interface


    function supportsInterface(bytes4 interfaceID) external view returns(bool);


    
}