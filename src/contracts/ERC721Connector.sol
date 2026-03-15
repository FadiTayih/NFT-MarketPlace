// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721MetaData.sol';
import './ERC721Eumerable.sol';


contract ERC721Connector is ERC721MetaData, ERC721Eumerable {

    // We deploy the constructor right away and carry the Meta data over

    constructor(string memory name, string memory symbol)  ERC721MetaData(name,symbol) {

    }

}