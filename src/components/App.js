import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
import { MDBCard, MDBCardBody,MDBCardTitle, MDBCardImage, MDBCardText, MDBBtn } from "mdb-react-ui-kit";
import './App.css';

class App extends Component {

    constructor(props) {
        super(props);
        this.state = {
            account: '',       
            contract: null,
            totalSupply: 0,
            kryptoBirdz: []    
        }
    }

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    // Detect Ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();

        if (provider) {
            console.log('ethereum wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            console.log('no ethereum wallet detected')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const accounts = await web3.eth.getAccounts();
        this.setState({ account: accounts[0] })  

        // NetworkId variable set to blockchain network Id
        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]

        if (networkData) {

            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address)
            this.setState({ contract })
            

            // Call the total supply of KryptoBirdz
            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({ totalSupply })
    

            // Load the KryptoBirdz into state array
            for (let i = 0; i < totalSupply; i++) {
                const kryptoBird = await contract.methods.kryptoBirdz(i).call()
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]  
                })
            }


        } else {
            window.alert('Smart contract not deployed')
        }
    }

    // with minting we are sending information and we need to specify the amount

    mint = (kryptoBird) =>{
        this.state.contract.methods.mint(kryptoBird).send({from: this.state.account})
        .once('receipt', (receipt) =>{
             this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]  
                })
        })
    }

    render() {
        return (
            <div className="container-filled">
                {console.log(this.state.kryptoBirdz)}
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
                    <div
                        className="navbar-brand col-sm-3 col-md-3 mr-0"
                        style={{ color: 'white' }}
                    >
                        KryptoBirdz NFTs (Non Fungible Tokens)
                    </div>
                    <ul className="navbar-nav px-3">
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className="text-white">
                                {this.state.account}  
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className="container-fluid mt-1">
                    <div className="row">
                        <main role="main"
                        className="col-lg-12 d-flex text-center">
                            <div className="content mr-auto ml-auto" style={{opacity:'0.8'}}>
                                <h1 style={{color:'black'}}>KryptoBirdz - NFT MarketPlace</h1>
                                <form onSubmit={(event) => {
                                    event.preventDefault()
                                    const kryptoBird = this.kryptoBird.value
                                    this.mint(kryptoBird)
                                }}>
                                    <input 
                                    type="text"
                                    placeholder="Add a file location"
                                    className="form-control mb-1"
                                    ref={(input) => this.kryptoBird = input}/>
                                    <input
                                    style={{margin:'6px'}}
                                    type="submit"
                                    className="btn btn-primary btn-black"
                                    value='MINT' />

                                </form>

                            </div>

                        </main>

                    </div>
                    <hr></hr>
                    <div className="row textCenter">
                        {this.state.kryptoBirdz.map((kryptoBird, key) =>{
                            return(
                                <div>
                                   <div>
                                    <MDBCard className="token imge" style={{maxWidth:'22rem'}}>
                                    <MDBCardImage src={kryptoBird} position="top" height='250rem' style={{marginRight: '4px'}} />
                                    <MDBCardBody>
                                        <MDBCardTitle> KryptoBirdz </MDBCardTitle >
                                        <MDBCardText> The KryptoBirdz are 20 uniquely generated NFTs</MDBCardText>
                                        <MDBBtn href={kryptoBird}>Download</MDBBtn>
                                    </MDBCardBody>
                                    </MDBCard>

                                   </div>
                                </div>
                            )

                        })}

                    </div>
                </div>
            </div>
        )
    }
}

export default App;