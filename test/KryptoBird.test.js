const {assert} = require('chai')

const KryptoBird = artifacts.require('./KryptoBird');

require('chai')
.use(require('chai-as-promised'))
.should()


contract('KryptoBird', (accounts) =>{

    let contract 

    before(async () =>{
        contract = await KryptoBird.deployed()
    })

    describe('deployment', async () =>{

        it('deployes succcessfully', async() =>{
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, undefined);
            assert.notEqual(address, null);
            assert.notEqual(address, 0x0);
        });

        it('has a name', async() =>{
            const name = await contract.name()
            assert.equal(name, 'KryptoBird')
        })

        it('has a symbol', async() =>{
            const symbol = await contract.symbol()
            assert.equal(symbol, 'KBIRDZ')
        })

    })

    describe('minting', async () =>{
        it('creates a new token', async () =>{
            const result = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()
             
            // success
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 
                'from the contract'
            )
            assert.equal(event._to, accounts[0], 'to is the message.sender')

            // failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async () =>{
        it('lists KryptoBirdz', async () =>{

            // Mint the remaining tokens (https...1 already minted in minting test)
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            const totalSupply = await contract.totalSupply()

            // Loop through the list and grab KBirdz
            let result = []
            for(i = 0; i < totalSupply; i++){
                let bird = await contract.kryptoBirdz(i)
                result.push(bird)
            }

            // assert that the new array result will equal the expected result
            let expected = ['https...1','https...2','https...3','https...4']
            assert.equal(result.join(','), expected.join(','))
        })
    })
})
