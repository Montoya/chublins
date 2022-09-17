const { ethers } = require("ethers");
const fs = require("fs")

const key = ''; // breaking this for now
const pKey = ''; 
const signer = new ethers.Wallet(pKey);

// Intitializing the readFileLines with the file
const readFileLines = filename =>
   fs.readFileSync(filename)
   .toString('UTF8')
   .split('\n');

const main = async () => { 
  const allowlist = readFileLines('allowlist.txt');
  let selectedAddress, messageHash, messageBytes, signature; 
  for(let i=0;i<allowlist.length;i++) { 
    selectedAddress = allowlist[i]; 
    // Get signature
    messageHash = ethers.utils.id(selectedAddress); 
    console.log(messageHash); 
    // Sign the message hash
    messageBytes = ethers.utils.arrayify(messageHash);
    signature = await signer.signMessage(messageBytes);
    console.log(signature); 
  }
}

main(); 