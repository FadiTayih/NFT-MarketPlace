A fully on-chain NFT marketplace built from scratch on Ethereum.
Mint, own, and display unique KryptoBird NFTs — powered by a hand-rolled ERC-721 implementation.
Overview · Features · Architecture · Getting Started · Smart Contracts · Testing · NFT Collection
</div>

📖 Overview
KryptoBirdz is a decentralized NFT marketplace where users can mint and collect uniquely generated bird NFTs directly on the Ethereum blockchain. Unlike most NFT projects that rely on OpenZeppelin, every ERC-721 contract in this project is written from scratch, including all interfaces, base contracts, and enumeration logic — making it an excellent reference for understanding how the standard works at a fundamental level.
The frontend is a React dApp that connects to MetaMask, reads from and writes to the deployed smart contract, and renders a live gallery of all minted NFTs.

✨ Features

🔨 Mint NFTs on-chain by submitting any image URL via the UI
🦊 MetaMask integration using @metamask/detect-provider
🚫 Duplicate prevention — the same URI can never be minted twice
📋 Full ERC-721 compliance including enumeration and metadata extensions
🖼️ Live NFT gallery that loads all minted tokens on page load
🔍 EIP-165 interface introspection registered across all contracts
📦 Hand-rolled contracts — no OpenZeppelin inheritance


🏗️ Architecture
User (Browser)
    │
    ├── MetaMask Wallet  ←──────────────────────────────────┐
    │                                                        │
    └── React Frontend (App.js + Web3.js)                   │
             │                                              │
             ├── Reads KryptoBird.json (ABI + Address)      │
             │                                              │
             └── Ethereum Network (Ganache / Mainnet)       │
                      │                                     │
                      └── KryptoBird.sol (ERC-721) ─────────┘
Contract Inheritance Chain
IERC165   IERC721   IERC721Emuerable   IERC721MetaData
   │          │             │                  │
   └──────────┴─────────────┴──────────────────┘
                       implements
                           │
          ERC165  ERC721  ERC721Eumerable  ERC721MetaData
                       inherits
                           │
                   ERC721Connector
                       extends
                           │
                  ⭐ KryptoBird.sol
Project Structure
nft-marketplace/
├── src/
│   ├── abis/                        # Compiled ABI + deployed addresses
│   │   └── KryptoBird.json
│   ├── components/
│   │   ├── App.js                   # Main React dApp component
│   │   └── App.css
│   ├── contracts/
│   │   ├── KryptoBird.sol           # ⭐ Main NFT contract
│   │   ├── ERC721Connector.sol      # Composition bridge
│   │   ├── ERC721Eumerable.sol      # Enumeration extension
│   │   ├── ERC721MetaData.sol       # Name & symbol storage
│   │   ├── ERC721.sol               # Core token logic
│   │   ├── ERC165.sol               # Interface registry
│   │   ├── Migrations.sol           # Truffle migrations helper
│   │   └── interfaces/
│   │       ├── IERC165.sol
│   │       ├── IERC721.sol
│   │       ├── IERC721Emuerable.sol
│   │       └── IERC721MetaData.sol
│   ├── index.js                     # React entry point
│   └── serviceWorker.js
├── migrations/
│   ├── 1_initial_migration.js
│   └── 2_deploy_contracts.js
├── test/
│   └── KryptoBird.test.js
├── truffle-config.js
└── package.json

🚀 Getting Started
Prerequisites
ToolVersionPurposeNode.js≥ 12.xJavaScript runtimenpm≥ 6.xPackage managerGanache2.xLocal Ethereum blockchainMetaMaskLatestBrowser walletTruffle5.0.5Contract framework
Installation
1. Clone the repository
bashgit clone https://github.com/your-username/nft-marketplace.git
cd nft-marketplace
2. Install dependencies
bashnpm install
3. Start Ganache
Launch the Ganache GUI and create a new workspace, or use the CLI:
bashganache-cli --port 7545

Make sure Ganache is running on 127.0.0.1:7545 as configured in truffle-config.js.

4. Connect MetaMask to Ganache
In MetaMask, add a custom network:
FieldValueNetwork NameGanache LocalRPC URLhttp://127.0.0.1:7545Chain ID1337Currency SymbolETH
Then import one of the Ganache accounts using its private key.
5. Compile and deploy the contracts
bashtruffle compile
truffle migrate --reset
This compiles all Solidity contracts and deploys them to Ganache, generating src/abis/KryptoBird.json with the ABI and deployed address.
6. Start the frontend
bashnpm start
Visit http://localhost:3000. MetaMask will prompt you to connect. Paste any image URL into the mint form and click MINT to create your first NFT.

📜 Smart Contracts
KryptoBird.sol ⭐
The main contract. Inherits the full ERC-721 stack and adds minting logic.
solidityfunction mint(string memory _kryptoBird) public {
    require(!_kryptoBirdzExists[_kryptoBird], 'Error- KryptoBird already exists');

    kryptoBirdz.push(_kryptoBird);
    uint _id = kryptoBirdz.length - 1;
    _mint(msg.sender, _id);
    _kryptoBirdzExists[_kryptoBird] = true;
}
PropertyValueCollection NameKryptoBirdToken SymbolKBIRDZToken StandardERC-721Duplicate Guard✅ URI-based mappingEnumerable✅ Full per-owner + global index
Contract Summary
ContractRoleDescriptionIERC165InterfacesupportsInterface() for EIP-165 detectionIERC721InterfacebalanceOf, ownerOf, transferFrom, Transfer eventIERC721EmuerableInterfacetotalSupply, tokenByIndex, tokenOfOwnerByIndexIERC721MetaDataInterfacename(), symbol()ERC165BaseInterface registry via _supportedInterfaces mappingERC721BaseToken ownership mappings and mint/transfer logicERC721EumerableExtensionGlobal + per-owner token index arraysERC721MetaDataExtensionStores and exposes name and symbolERC721ConnectorBridgeCombines MetaData + Enumerable into one baseKryptoBirdMainMint function, duplicate guard, URI storageMigrationsUtilityTruffle deployment tracker

🧪 Testing
Run the full test suite with:
bashtruffle test
Test Coverage
Contract: KryptoBird
  deployment
    ✓ deploys successfully
    ✓ has a name
    ✓ has a symbol
  minting
    ✓ creates a new token
  indexing
    ✓ lists KryptoBirdz
What's Tested
Deployment

Contract deploys to a valid non-zero address
name() returns 'KryptoBird'
symbol() returns 'KBIRDZ'

Minting

totalSupply increments correctly after mint
Transfer event emits from address(0) to msg.sender
Duplicate URI minting is rejected with chai-as-promised

Indexing

Multiple tokens are accessible by index via kryptoBirdz(i)
Order is preserved across all minted tokens


🖼️ NFT Collection
The KryptoBirdz collection contains 11 uniquely generated bird NFTs. Use any of the URLs below in the mint form:
Token IDNameURL0K1https://i.ibb.co/9kzVtQy2/K1.png1K2https://i.ibb.co/84mY5WLT/K2.png2K3https://i.ibb.co/PZ3w82tJ/K3.png3K4https://i.ibb.co/1gt4bjG/K4.png4K5https://i.ibb.co/VWL8ZMYX/K5.png5K6https://i.ibb.co/Zpt5B4BP/K6.png6K7https://i.ibb.co/gbDhPH6F/K7.png7K8https://i.ibb.co/vxgYzSW5/K8.png8K9https://i.ibb.co/rKzthRGz/K9.png9K10https://i.ibb.co/xv11Rx5/K10.png10K11https://i.ibb.co/3mQYFbq7/K11.png

⚠️ Note: For production use, consider hosting assets on IPFS via Pinata or nft.storage for permanent, decentralized storage.


⚙️ Configuration
truffle-config.js
javascriptmodule.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,           // Ganache default
      network_id: "*",
    },
  },
  contracts_directory:       './src/contracts/',
  contracts_build_directory: './src/abis',
  compilers: {
    solc: {
      version:    '^0.8.0',
      optimizer:  { enabled: true, runs: 200 },
      evmVersion: 'london',
    },
  },
};
Available Scripts
CommandDescriptionnpm startStart the React dev server at localhost:3000npm run buildCreate a production build in /buildnpm testRun Jest tests in watch modetruffle compileCompile all Solidity contractstruffle migrate --resetDeploy contracts to the configured networktruffle testRun the full Mocha smart contract test suite

📦 Dependencies
Core
PackageVersionPurposeweb31.0.0-beta.55Ethereum JavaScript API@metamask/detect-provider^1.2.0Wallet detectiontruffle5.0.5Contract frameworkreact16.8.4UI libraryreact-dom16.8.4DOM renderingmdb-react-ui-kit^1.3.0UI components (MDBCard etc.)bootstrap4.3.1CSS utilities
Testing
PackageVersionPurposechai4.2.0BDD assertion librarychai-as-promised7.1.1Async rejection assertionschai-bignumber3.0.0BigNumber comparisonsbabel-*variousES6+ support in Truffle tests

🔐 Security Notes

The mint function is public — any address can mint a token as long as the URI is unique.
Token IDs are derived from array position (kryptoBirdz.length - 1), making them strictly sequential.
There is currently no burn function; tokens are permanent once minted.
For mainnet deployment, consider adding access controls, a minting fee, and a supply cap.


🗺️ Roadmap

 Add minting fee (payable mint function)
 Add maximum supply cap
 Implement approve and setApprovalForAll for marketplace transfers
 Migrate token URIs to IPFS
 Add a resale / auction mechanism
 Deploy to Ethereum testnet (Sepolia)


📄 License
This project is licensed under the MIT License — see the LICENSE file for details.