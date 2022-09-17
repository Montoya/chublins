/*
  ___  _   _  __  __  ____  __    ____  _  _  ___
 / __)( )_( )(  )(  )(  _ \(  )  (_  _)( \( )/ __)
( (__  ) _ (  )(__)(  ) _ < )(__  _)(_  )  ( \__ \
 \___)(_) (_)(______)(____/(____)(____)(_)\_)(___/  ~ Reborn ~

By Christian Montoya
m0nt0y4.eth

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Base64.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; 
import "erc721a/contracts/ERC721A.sol";

// Chublins Reborn Contract v0.2
// Creator: Christian Montoya
contract ChublinsReborn is ERC721A, Ownable { 
    constructor() ERC721A("Chublins Reborn", "CHBR") {}
    
    uint256 private _basePrice = 0.01 ether; 
    uint256 private _maxSupply = 4444; 
    uint256 private _maxMintPerWallet = 2; 
    bytes32 public merkleRoot; 
    bool private _publicMintOpen; // enable after allowlist mint period
    bool private _pngsAvailable; // when true, PNGs exist for all Chublins
    string private _baseTokenURI = "https://chublins.xyz/pngs/"; // for NFTs rendered off-chain (to be compatible with Twitter, etc.)
    uint8[4444] private _chubFlags; // will track license status and whether to return PNG or SVG

    function openPublicMint() external onlyOwner {
        _publicMintOpen = true; 
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner { 
        merkleRoot = _merkleRoot; 
    }

    function setMaxMintPerWallet(uint256 max) external onlyOwner { 
        _maxMintPerWallet = max; 
    }

    function toBytes32(address addr) pure internal returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }

    function allowListMint(uint256 quantity, bytes32[] calldata merkleProof) external payable {
        require(_maxSupply >= (totalSupply() + quantity)); 
        require(_numberMinted(msg.sender) + quantity <= _maxMintPerWallet);
        require(msg.value == (_basePrice * quantity));
        require(MerkleProof.verify(merkleProof, merkleRoot, toBytes32(msg.sender)) == true);
        _mint(msg.sender, quantity);
    }

    function mint(uint256 quantity) external payable {
        require(_publicMintOpen && _maxSupply >= (totalSupply() + quantity)); 
        require(_numberMinted(msg.sender) + quantity <= _maxMintPerWallet); 
        require(msg.value == (_basePrice * quantity));
        require(msg.sender == tx.origin); 
        _mint(msg.sender, quantity);
    }

    // this is for raffles and for making secondary buyers from first collection whole 
    function ownerMint(uint256 quantity) external onlyOwner {
        require(_maxSupply >= (totalSupply() + quantity)); 
        _mint(msg.sender, quantity);
    }

    // traits

    string[8] private _bgColors = ["c0caff","ff6b6b","ffdd59","0be881","fd9644","a55eea","778ca3","f8a5c2"];
    string[8] private _bgColorIds = ["sky","tomato","lemon","jade","clementine","royal","slate","sakura"];

    string[3] private _ears = [
        '',
		'<path d="M-46 -140 -26 -170 -6 -140M124 -137 144 -167 164 -137" class="lnft"/>',
		'<path d="M-48,-142 a0.9,1 0 0,1 60,-8M116,-146 a0.9,1 0 0,1 60,12" class="lnft th"/>'
	];
    string[3] private _earIds = ["none","cat","bear"];

    string[4] private _hats = [
        '',
        '<ellipse cx="62" cy="-128" rx="50" ry="15"/><path d="M27,-130 a1,1 0 0,1 70,0"/><path d="M27,-130 a6,1 0 1,0 70,0" stroke="gray" stroke-width="2"/>',
        '<path d="M16 -112a1 1 0 0 1 100 0M16 -112a2.5 1.5 18 1 0 100 0"/><path d="M17-112h99" stroke="#000" stroke-width="2"/><path d="M16-112a50 6.25 0 1 0 100 0" stroke="#555" stroke-width="2" stroke-linecap="round"/><text x="52" y="-117" fill="#ddd">chub</text>',
        '<path d="m62-146 4-58-40-20" class="lnrt"/><circle cx="26" cy="-224" r="14"/>'
    ];
    string[4] private _hatIds = ["none","bowl","cap","antenna"];

    string[14] private _eyes = [
        '<circle cx="10" cy="10" r="10"/><circle cx="130" cy="10" r="10"/>',
        '<path id="eye" class="lnft" style="fill:#000;stroke-linejoin:round" d="M10.4-18v9.6V-18.1zm-17.7 7.7 6.2 7.3-6.2-7.3zm35.3 0-6.2 7.3 6.2-7.3zM10.4-3.8C.95-4.2-5.7 7.4-.65 15.3c4.3 8.4 17.7 8.4 22 0 4.6-7.2-.44-17.7-8.8-18.9-1.1-.15z"/><use xlink:href="#eye" transform="translate(120)"/>',
        '<g id="eye"><circle cx="10" cy="10" r="30"/><circle cx="25" cy="5" r="8" fill="#fff"/><circle cx="-8" cy="20" r="4" fill="#fff"/></g><use xlink:href="#eye" transform="translate(120)"/>',
        '<g id="eye"><circle cx="10" cy="10" r="30"/><circle cx="10" cy="10" r="24" class="wlrt"/></g><use xlink:href="#eye" transform="translate(120)"/>',
        '<rect x="24" y="-18" width="16" height="48" ry="8"/><rect x="100" y="-18" width="16" height="48" ry="8"/>', 
        '<path d="M40 10 A10 10 10 10 0 13 10" class="lnrt"/><path d="M140 11 A10 10 10 10 100 12 10" class="lnrt"/>',
        '<path class="lnrt" d="M-5 0h50M90 0h50"/><circle cx="28" cy="12" r="13"/><circle cx="123" cy="12" r="13"/>', 
        '<path class="lnrt" d="m-12 18 25-36m0 0 25 36m62 0 25-36m0 0 25 36"/>', 
        '<path d="m0-18 42 42M0 24l42-42m54 0 42 42m-42 0 42-42" class="lnrt"/>', 
        '<path stroke="#000" class="th" d="M-4-30 44-6m64 0 48-24"/><circle cx="23" cy="12" r="13"/><circle cx="128" cy="12" r="13"/>',
        '<path class="lnrt" d="m-6 -16 40 24m0 0 -40 24m152 0 -40 -24m0 0 40 -24"/>',
        '<path id="eye" d="M13.3 36.3C-1.7 38.4-13 19.4-4 7.2c5-8.9 21-12.4 25.7-1.3 3.7 7.4-3.6 17.9-11.9 15.7-4-1.6-2.8-8.1 1.4-8.3 5.4-1.3.38-8.7-3.5-4.9C1.1 10.8-.35 20.5 4.9 25c4 3.9 10.4 3.1 14.8.4C31.5 19.3 31.1-.1 18.4-5.2 3-12-14.9 3.7-12.7 19.7c.7 5.5-8.4 6.3-8.7.8-2.7-21.2 19.5-41.4 40.3-34.9C37.1-9.6 43.1 15.8 29.8 28.5c-4.3 4.5-10.2 7.3-16.4 7.8Z"/><use xlink:href="#eye" transform="rotate(180 70 10)"/>',
        '<path d="M10.2-17.8c-7.5-.17-14.8 2-21.4 5.6-6.8 3.4-12.6 8.8-16.1 15.6-1.6 3.1.7 6.3 1.8 9.2 2.8 5.2 5.7 10.7 10.6 14.3 2 .8-.9-3.5-1.2-4.7-2.4-4.9-4.3-10-5.6-15.2 3.8-5 7.8-10 13.3-13.2 1.5-1.3 4.4-2.4 2.9.7-3.1 11.2-2.5 24.2 4.3 34 .8 2 5.2 4.3 4 6.1-2.2.6-1.6 1.5.3 1.2 8.9-.2 17.7-.5 26.9-1.3 3.3-.8-2.9-.9-3.7-1.4 2.4-3.6 5.3-7 6.6-11.2 3.2-8.5 3.5-17.9 1.2-26.6 2.2-.3 5.2 2.8 7.5 4.1 1.7.6 4.7 4.8 5.7 3.2-3.4-9-12.2-14.5-22.8-17.7-5.1-2-10.7-2.5-16.1-2.5ZM4.8 6.6c-.5 5.4 1.8 12.1 7.4 13.8 4.9 1.4 9.3-3 10.5-7.4 1.5-2.4-1-7.7 3.3-6.2 2.9.3 7.5.7 6.5 4.9-.7 6.6-3.3 13-7.7 18-1 .9-1.9 2.1-3 2.8l-14.9.7c-3.4-3.2-6.5-6.7-8.3-11-1.7-4-3.2-8.3-2.9-12.7 1.2-3.3 6.5-1.7 9.2-3Z" id="eye"/><use xlink:href="#eye" transform="matrix(-1 0 0 1 142 0)"/>',
        '<g fill="#f3322c"><path d="M-42 -3H96V7H-32V21H-42"/><g id="eye"><path fill="#fff" d="M-10 -23H40V27H-10z" stroke="#f3322c" stroke-width="10"/><path fill="#000" d="M15 -18H35V22H15z"/></g><use xlink:href="#eye" x="108"/></g>'
    ]; 
    string[14] private _eyeIds = [
        "tiny",
        "lashes",
        "bubble",
        "froyo",
        "socket",
        "chuffed",
        "displeased",
        "kitty", 
        "deceased", 
        "angry",
        "embarrassed",
        "dizzy",
        "anime",
        "nounish"
    ];

    string[5] private _cheeks = [
        '', 
        '<ellipse cx="10" cy="60" rx="20" ry="10" fill="pink"/><ellipse cx="130" cy="60" rx="20" ry="10" fill="pink"/>', 
        '<path d="m15 6 10 12a12.8 12.8 0 1 1-20 0L15 6z" fill="#8af" transform="rotate(5 -432.172 -87.711)"/>', 
        '<path d="m15 6 10 12a12.8 12.8 0 1 1-20 0L15 6z" fill="none" stroke="black" stroke-width="3" transform="rotate(5 -432.172 -87.711)"/>',
        '<path id="chk" fill="#faf" d="M-9.5 24c.6-3.9 5-3.9 6.8-1.6 1.9-2.3 6.3-2.2 6.8 1.6.5 3.4-4 6.2-6.8 8.1-2.8-1.8-7.4-4.6-6.8-8.1z" transform="matrix(2 0 0 2.4 0 0)"/><use xlink:href="#chk" transform="translate(148)"/>'
    ]; 
    string[5] private _cheekIds = [
        "plain",
        "pink",
        "tear",
        "tattoo",
        "hearts"
    ]; 

    string[10] private _mouths = [
        '<path d="M40,100 a1,1 0 0,0 60,0"/>',
        '<path d="m40 116 60-0" class="lnrt"/>',
        '<path d="M-100 -124a1 .9 0 0 0 60 0" class="lnrt" transform="rotate(180)"/>',
        '<path d="M40,100 a1,0.9 0 0,0 60,0" class="lnrt"/>', 
        '<path d="M37 108a1 .7 0 0 0 62 0" class="lnrt"/><path d="M-31 109a1 .2 0 0 0 20 0" class="lnrt" transform="rotate(-30)"/>',
        '<path d="m28 120 14-10 14 10 14-10 14 10 14-10 14 10" class="lnrt"/>', 
        '<ellipse cx="70" cy="114" rx="18" ry="24"/>',
        '<path d="M36 127c-5.2-5.8-5.5-15.6-.6-22.5 4.5-6.3 10.3-6.4 22.2-.3 11.4 5.9 15.9 5.9 25.8.02 9.6-5.7 15.1-6 19.6-1 5 5.6 6 12.7 2.9 20.1-3.8 9-9 10-21 3.9-12.3-6-17-6-28.7-.2-11.3 5.9-14.6 5.9-19.8.07z"/>',
        '<path d="M29,105 a1,1 0 0,0 40,0M70,105 a1,1 0 0,0 40,0" class="lnrt"/>', 
        '<path d="M67,120 a0.6,0.6 0 0,0 0,-20M67,140 a1.2,1 0 0,0 0,-20" class="lnrt tn"/>' 
    ]; 
    string[10] private _mouthIds = [
        "happy",
        "uncertain",
        "sad",
        "elated",
        "chuffed",
        "angry", 
        "shocked",
        "disgusted",
        "goopy",
        "kissy"
    ]; 

    string[6] private _accessories = [
        '',
        '<path id="ac" d="m60,68c-12.4,0.9 -12.3,13.7 -29.3,12.3 7.3,13.5 24.4,13.4 34.3,6.8 9.8,-6.7 4.8,-19.7 -5,-19z"/><use xlink:href="#ac" transform="scale(-1,1),translate(-138)"/>',
        '<path fill="red" stroke="red" stroke-width="7" stroke-linejoin="round" d="m-44-82 20 15 20-15v30l-20-15-20 15z"/><rect x="-34.5" y="-77.5" width="21" height="21" rx="4" fill="red" stroke="#fff" stroke-width="2"/>',
        '<path d="M-12 -53c-3.7-2.1-6.1-6.2-6.1-10.6 0-4.4 2.3-8.5 6.1-10.7m-37.7 0c3.7 2.1 6.1 6.2 6.1 10.6 0 4.4-2.3 8.5-6.1 10.7m8.2 8.2c2.1-3.7 6.2-6.1 10.6-6.1 4.4 0 8.5 2.3 10.7 6.1m0-37.7c-2.1 3.7-6.2 6.1-10.6 6.1-4.4 0-8.5-2.3-10.7-6.1" class="lnrt tn"/>',
        '<path d="m2.5 10.8 1.5.5.4 1.6.4-1.6 1.5-.5-1.5-.5-.4-1.5-.4 1.5zM.5 3.5l2.1.7.6 2.2.6-2.2 2.1-.7-2.1-.7L3.2.7l-.6 2.2zm8.1-2L7.6 5.3l-2.6 1.1 2.6 1.1 1 3.8L9.7 7.4l2.5-1.1-2.5-1.1z" fill="#ffc502" transform="matrix(4.5 0 0 4.5 -92 -68)"/>',
        '<g class="lnrt tn" transform="matrix(.39878 -.01397 .035 .4 -150 -158)"><clipPath id="clp"><path d="M220 190h30v54h-30z"/></clipPath><ellipse id="b" cx="250" cy="217" rx="25" ry="27" fill="#f8b"/><use transform="rotate(60 250 250)" xlink:href="#b"/><use transform="rotate(120 250 250)" xlink:href="#b"/><use transform="rotate(180 250 250)" xlink:href="#b"/><use transform="rotate(240 250 250)" xlink:href="#b"/><use transform="rotate(300 250 250)" xlink:href="#b"/><use xlink:href="#b" clip-path="url(#clp)"/><circle cx="250" cy="250" r="18" fill="#fdc"/></g>'
    ]; 
    string[6] private _accessoryIds = [
        "none",
        "mustache",
        "bow",
        "pop",
        "sparkle",
        "flower"
    ]; 

    string[3] private _filters = [
        '', 
        '<feTurbulence baseFrequency="0" type="fractalNoise" stitchTiles="noStitch"><animate id="wvy" attributeName="baseFrequency" dur="6s" begin="1.5s;wvy.end+1.5s" values="0;0.03;0" keyTimes="0;0.5;1" easing="ease-in-out"/></feTurbulence><feDisplacementMap in="SourceGraphic" scale="14"/>',
        '<feTurbulence baseFrequency="0.6" type="fractalNoise"/><feDisplacementMap in="SourceGraphic" scale="0"><animate id="gltch" attributeName="scale" dur="2.5s" begin="1.5s;gltch.end+3.5s" values="36.72;58.84;36.90;14.99;13.26;47.30;58.24;21.58;46.51;40.17;35.83;36.08;42.74;32.16;46.57;33.67;17.31;52.09;30.80;40.37;43.99;36.21;16.18;20.04;15.72;50.92;30.81"/></feDisplacementMap>'
    ]; 
    string[3] private _filterIds = ["none", "wavy", "glitchy"]; 

    string[3] private _licenses = ["ARR", "CC BY-NC", "CC0"]; 
    
    function getLicense(uint256 id) public view returns (string memory) { 
        require(_exists(id)); 
        uint256 licenseId = _chubFlags[id] % 10; // 0, 1 or 2
        if(licenseId > 2) { licenseId = 2; /* this should never happen */ }
        return _licenses[licenseId]; 
    }

    function usePng(uint256 id) public view returns (bool) { 
        require(_exists(id)); 
        return _chubFlags[id] > 9; 
    }

    struct chubData {
        string bgColor;
        string bgColorId;
        string ears;
        string earsId;
        string hat;
        string hatId;
        string eyes; 
        string eyesId; 
        string cheeks; 
        string cheeksId; 
        string mouth; 
        string mouthId; 
        string accessory; 
        string accessoryId; 
        string filter; 
        string filterId; 
        string license;
        bool shimmer; 
    }

    function makeChub(uint256 id) internal view returns (chubData memory) {
        chubData memory chub;

        // random background color
        uint256 rand = uint256(keccak256(abi.encodePacked(id, address(this), "1"))) % _bgColors.length;
        chub.bgColor = _bgColors[rand];
        chub.bgColorId = _bgColorIds[rand];

        // random ears
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "2"))) % 10;
        if(rand >= _ears.length) { rand = 0; } 
        chub.ears = _ears[rand];
        chub.earsId = _earIds[rand];

        // random hats
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "3"))) % 12;
        if(rand >= _hats.length) { rand = 0; }
        chub.hat = _hats[rand];
        chub.hatId = _hatIds[rand];

        // random eyes 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "4"))) % _eyes.length;
        chub.eyes = _eyes[rand]; 
        chub.eyesId = _eyeIds[rand]; 

        // random cheeks 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "5"))) % 20;
        if(rand >= _cheeks.length) { rand = 0; }
        chub.cheeks = _cheeks[rand]; 
        chub.cheeksId = _cheekIds[rand]; 

        // random mouths
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "6"))) % _mouths.length;
        chub.mouth = _mouths[rand]; 
        chub.mouthId = _mouthIds[rand]; 

        // random accessories 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "7"))) % 24; 
        if(rand >= _accessories.length) { rand = 0; }
        chub.accessory = _accessories[rand]; 
        chub.accessoryId = _accessoryIds[rand]; 

        // random filters 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "8"))) % 100;
        if(rand >= _filters.length) { rand = 0; }
        chub.filter = _filters[rand]; 
        chub.filterId = _filterIds[rand]; 

        chub.license = getLicense(id); 

        // random shimmer 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "9"))) % 16;
        chub.shimmer = ( rand < 1 ); 

        return chub; 
    }

    function makeSVG(chubData memory chub) internal pure returns (string memory) {
        string memory filterUrl = ''; 
        string memory filter = ''; 
        if(bytes(chub.filter).length > 0) { 
            filterUrl = string.concat(" filter='url(#",chub.filterId,")'"); 
            filter = string.concat('<filter id="',chub.filterId,'" x="-50%" y="-50%" width="200%" height="200%">',chub.filter,'</filter>'); 
        }
        string memory bgfilter = ''; 
        if(chub.shimmer) { 
            bgfilter = '<path d="M0 0H600V600H0" filter="url(#fbg)"/>'; 
            filter = string.concat(filter,'<filter x="0" y="0" width="100%" height="100%" id="fbg"><feTurbulence baseFrequency="0.0024 0.0036" numOctaves="16" seed="18"/></filter>'); 
        }
        string memory open = "<svg width='600' height='600' viewBox='0 0 600 600' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'><style>.lnft,.lnrt{stroke:#000;stroke-linecap:round}.lnft{fill:gray;stroke-width:8;}.lnrt{fill:none;stroke-width:7;stroke-linejoin:bezel}.th{stroke-width:12}.tn{stroke-width:4}.wlrt{stroke:#fff;stroke-width:3}text{font-family:'Comic Sans MS','Comic Sans','Chalkboard SE','Comic Neue',cursive;font-size:12pt}</style><defs>"; 

        return string.concat(open,filter,"</defs><path d='M0 0H600V600H0' fill='#",chub.bgColor,"'/>",bgfilter,"<g cursor='pointer'",filterUrl,"><g fill='#fff'><ellipse cx='300' cy='460' rx='160' ry='50'/><path d='M140 140h320v320H140z'/></g><ellipse cx='300' cy='140' rx='160' ry='50' fill='#F8F4F4'/><g transform='rotate(-5 3422.335 -2819.49)'>",chub.ears,chub.hat,chub.eyes,chub.mouth,chub.cheeks,chub.accessory,"</g><animateMotion path='M0,0 -3,-9 0,-18 6,-9 2,0 0,4z' keyPoints='0;0.1875;0.375;0.5625;0.75;0.9;1' keyTimes='0;0.18;0.37;0.58;0.72;0.87;1' dur='0.6s' begin='click'/></g></svg>"); 
        
    }

    function makeTrait(string memory tt, string memory tv) internal pure returns (string memory) { 
        return string.concat('{"trait_type":"',tt,'","value":"',tv,'"}'); 
    }

    function makeTraits(chubData memory chub) internal pure returns (string memory) { 
        string memory shimmer = chub.shimmer ? unicode"✨" : ""; 
        shimmer = string.concat(chub.bgColorId,shimmer); 
        return string.concat('[',makeTrait("BG Color",shimmer),',',makeTrait("Ears",chub.earsId),',',makeTrait("Hat",chub.hatId),',',makeTrait("Eyes",chub.eyesId),',',makeTrait("Mouth",chub.mouthId),',',makeTrait("Cheeks",chub.cheeksId),',',makeTrait("Accessory",chub.accessoryId),',',makeTrait("Filter",chub.filterId),',',makeTrait("License",chub.license),']'); 
    }

    function tokenSVG(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId)); 

        return makeSVG(makeChub(tokenId)); 
    }

    function tokenTraits(uint256 tokenId) external view returns (string memory) { 
        require(_exists(tokenId)); 

        return makeTraits(makeChub(tokenId)); 
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        require(_exists(tokenId)); 
        
        chubData memory chub = makeChub(tokenId);

        string memory output; 
        if(usePng(tokenId) && _pngsAvailable) {
            output = string.concat(_baseTokenURI, _toString(tokenId), ".png"); 
        }
        else { 
            output = string.concat("data:image/svg+xml;base64,", Base64.encode(bytes(makeSVG(chub)))); 
        }

        string memory json =  makeTraits(chub); 

        json = string.concat('{"name":"Chublin #',_toString(tokenId),'", "description":"A Chublin born of the blockchain.","attributes":',json,', "image":"', output, '"}'); 
        return string.concat('data:application/json;base64,',Base64.encode(bytes(json))); 
    }

    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function reduceSupply(uint256 value) external onlyOwner {
        require(totalSupply() < value && value < _maxSupply);
        _maxSupply = value;
    }

    function setPrice(uint256 price) external onlyOwner { 
		_basePrice = price; 
	}

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function withdrawFunds() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success);
    }

    function pngsAvailable() external view returns (bool) {
        return _pngsAvailable;
    }

    function togglePNGsAvailable() external onlyOwner {
        _pngsAvailable = !_pngsAvailable;
    }

    function toggleOnChainArt(uint256 tokenId) external returns(bool){
        require(ownerOf(tokenId) == msg.sender);
        
        if(usePng(tokenId)) { 
            unchecked {
                _chubFlags[tokenId] -= 10; 
            }
        }
        else { 
            unchecked {
                _chubFlags[tokenId] += 10; 
            }
        }

        return usePng(tokenId); 
    }

    function modifyLicense(uint256 tokenId, uint8 level) external returns(string memory){
        require(ownerOf(tokenId) == msg.sender);
        require(level == 1 || level == 2);
        uint8 currentLicense = _chubFlags[tokenId] % 10; // 0, 1 or 2

        if(currentLicense == 0) {
            // if current level is 0, you can set it to 1 or 2
            unchecked {
                _chubFlags[tokenId] += level;
            }
            return _licenses[level]; 
        }
        else if(currentLicense == 1 && level == 2) {
            // if current level is 1 or 2, you can set it to 2
            unchecked { 
                _chubFlags[tokenId] += 1;
            }
            return _licenses[level]; 
        }
        revert(); 
    }
}