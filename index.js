const express = require('express');
const {readFileSync} = require('fs');
const Web3 = require("web3");
const ContractKit = require("@celo/contractkit");
const web3 = new Web3("https://alfajores-forno.celo-testnet.org");
const privateKeyToAddress =
  require("@celo/utils/lib/address").privateKeyToAddress;
const kit = ContractKit.newKitFromWeb3(web3);
require("dotenv").config();
//const PRIVATE_KEY = "1759b69a2c21c8dc097982a1bbadab9c337a961a4b0db64d56b054d8bf120a77";
const CONTRACT_ADDRESS = "0xc277D564D8D29323e9CDf83d80d5Be81308117b1";
const democontract = require("./contract/x.json");

const app = express();
// Serve the files in /assets at the URI /assets.
app.use('/assets', express.static('assets'));

// The template values are stored in global state for reuse.

//SEND REQUEST?celoid='bratandronik'&qr='03fb6544c5b0ce594eb007416f5b6d3c'

async function awaitWrapper() {
  kit.connection.addAccount(PRIVATE_KEY); // this account must have a CELO balance to pay transaction fees

  // This account must have a CELO balance to pay tx fees
  // get some testnet funds at https://celo.org/build/faucet
  const address = privateKeyToAddress(PRIVATE_KEY);
  console.log(address);

  initContract();
  //let tx = await kit.connection.sendTransaction({
    //from: address,
    // change to Inga??
    //data: HelloWorld.bytecode,
  //});

  //const receipt = await tx.waitReceipt();
  //console.log(receipt);
}

async function initContract() {
  // Check the Celo network ID
  const networkId = await web3.eth.net.getId();

  // Get the contract associated with the current network
  const deployedNetwork = democontract.networks[networkId];

  // Create a new contract instance with the HelloWorld contract info
  let instance = new kit.web3.eth.Contract(
    democontract.abi,
    deployedNetwork && deployedNetwork.address
  );

  getName(instance);
  setName(instance, "hello world!");
}

app.get('/', async (req, res) => {
  // can replace this code with my Celo contarct call
  // check if it works & enough fee
  awaitWrapper();
  //const username = req.query.celoid.slice(1, -1);
  //res.json(username);
  res.json();
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(
    `Hello from Cloud Run! The container started successfully and is listening for HTTP requests on ${PORT}`
  );
});
