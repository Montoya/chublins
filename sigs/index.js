const { ethers } = require("ethers");
const fs = require("fs")

const key = '0xE0C056dEac70626D4036C0406B420da8Cc414fC8'; 
const pKey = '34027b92e48c1867b6cc590e3fe10ad6317d38c60aaf19a6d4f7da94e81b20b4'; 
const signer = new ethers.Wallet(pKey);

// Intitializing the readFileLines with the file
const readFileLines = filename =>
   fs.readFileSync(filename)
   .toString('UTF8')
   .split('\n');

async function getSignature(address) { 
  let messageHash = ethers.utils.id(address); 
  // Sign the message hash
  let messageBytes = ethers.utils.arrayify(messageHash);
  let signature = await signer.signMessage(messageBytes);
  return signature; 
}

const main = async () => { 
  const allowlist = readFileLines('allowlist.txt');
  let selectedAddress, signature; 
  for(let i=0;i<allowlist.length;i++) { 
    selectedAddress = allowlist[i]; 
    // Get signature
    signature = await getSignature(selectedAddress); 
    console.log(signature); 
  }
}

main(); 