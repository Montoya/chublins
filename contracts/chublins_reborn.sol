/*
  ___  _   _  __  __  ____  __    ____  _  _  ___
 / __)( )_( )(  )(  )(  _ \(  )  (_  _)( \( )/ __)
( (__  ) _ (  )(__)(  ) _ < )(__  _)(_  )  ( \__ \
 \___)(_) (_)(______)(____/(____)(____)(_)\_)(___/ ~ Reborn ~

By Christian Montoya
m0nt0y4.eth

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "@openzeppelin/contracts/utils/Base64.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; 
import "erc721a/contracts/ERC721A.sol";

// Chublins Reborn Contract v0.0.3
// Creator: Christian Montoya
contract ChublinsReborn is ERC721A, Ownable { 
    constructor() ERC721A("Chublins Reborn", "CHBR") {}
    
    uint256 private _basePrice = 0.01 ether; 
    uint256 private _maxSupply = 4444; 
    bytes32 public merkleRoot; 
    bool private _publicMintOpen; // enable after allowlist mint period
    bool private _pngsAvailable; // when true, PNGs exist for all Chublins
    string private _baseTokenURI = "https://chublins.xyz/pngs/"; // for NFTs rendered off-chain (to be compatible with Twitter, etc.)
    uint8[4444] private _chubFlags; // will track license status, whether to return PNG or SVG

    function openPublicMint() external onlyOwner {
        _publicMintOpen = true; 
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner { 
        merkleRoot = _merkleRoot; 
    }

    function toBytes32(address addr) pure internal returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }

    function allowListMint(uint256 quantity, bytes32[] calldata merkleProof) external payable {
        require(_maxSupply + 1 > (totalSupply() + quantity));
        require(_numberMinted(msg.sender) + quantity < 3); // max 2 per address 
        require(msg.value == (_basePrice * quantity));
        require(MerkleProof.verify(merkleProof, merkleRoot, toBytes32(msg.sender)) == true);
        _mint(msg.sender, quantity);
    }

    function mint(uint256 quantity) external payable {
        require(_publicMintOpen && _maxSupply + 1 > (totalSupply() + quantity)); 
        require(_numberMinted(msg.sender) + quantity < 3); // max 2 per address 
        require(msg.value == (_basePrice * quantity));
        require(msg.sender == tx.origin); 
        _mint(msg.sender, quantity);
    }

    // this is for raffles and for making secondary buyers from first collection whole 
    function ownerMint(uint256 quantity) external onlyOwner {
        require(_maxSupply + 1 > (totalSupply() + quantity));
        _mint(msg.sender, quantity);
    }

    // traits

    string[8] private _bgColors = ["c0caff","ff6b6b","ffdd59","0be881","fd9644","a55eea","778ca3","f8a5c2"];
    string[8] private _bgColorIds = ["sky","tomato","lemon","jade","clementine","royal","slate","sakura"];

    string[3] private _ears = [
        '',
		'<path d="M-46 -140 -26 -170 -6 -140" class="lnft"/><path d="M124 -137 144 -167 164 -137" class="lnft"/>',
		'<path d="M-48,-142 a0.9,1 0 0,1 60,-8" class="lnft th"/><path d="M116,-146 a0.9,1 0 0,1 60,12" class="lnft th"/>'
	];
    string[3] private _earIds = ["none","cat","bear"];

    string[4] private _hats = [
        '',
        '<ellipse cx="62" cy="-128" rx="50" ry="15"/><path d="M27,-130 a1,1 0 0,1 70,0"/><path d="M27,-130 a6,1 0 1,0 70,0" stroke="gray" stroke-width="2"/>',
        '<path d="M16 -112a1 1 0 0 1 100 0"/><path d="M17-112h99" stroke="#000" stroke-width="2"/><path d="M16 -112a2.5 1.5 18 1 0 100 0"/><path d="M16-112a50 6.25 0 1 0 100 0" stroke="#555" stroke-width="2" stroke-linecap="round"/><text x="52" y="-117" fill="#ddd">chub</text>',
        '<path d="m62-146 4-58-40-20" class="lnrt"/><circle cx="26" cy="-224" r="14"/>'
    ];
    string[4] private _hatIds = ["none","bowl","cap","antenna"];

    string[12] private _eyes = [
        '<circle cx="10" cy="10" r="10"/><circle cx="130" cy="10" r="10"/>',
        '<g id="eye" transform="scale(2)"><path d="M5-7v4.522m-8.334-.87L-.422.112m13.756-3.46L10.422.112" class="lnrt tn"/><circle r="8" cy="5" cx="5"/></g><use xlink:href="#eye" transform="translate(120,0)"/>',
        '<g id="eye"><circle cx="10" cy="10" r="30"/><circle cx="25" cy="5" r="8" fill="#fff"/><circle cx="-8" cy="20" r="4" fill="#fff"/></g><use xlink:href="#eye" transform="translate(120,0)"/>',
        '<g id="eye"><circle cx="10" cy="10" r="30"/><circle cx="10" cy="10" r="24" class="wlrt"/></g><use xlink:href="#eye" transform="translate(120,0)"/>',
        '<rect x="24" y="-18" width="16" height="48" ry="8"/><rect x="100" y="-18" width="16" height="48" ry="8"/>', 
        '<path d="M40 10 A10 10 10 10 0 13 10" class="lnrt"/><path d="M140 11 A10 10 10 10 100 12 10" class="lnrt"/>',
        '<path class="lnrt" d="M-5 0h50"/><circle cx="28" cy="12" r="13"/><path class="lnrt" d="M90 0h50"/><circle cx="123" cy="12" r="13"/>', 
        '<path class="lnrt" d="m-12 18 25-36m0 0 25 36m62 0 25-36m0 0 25 36"/>', 
        '<path d="m0-18 42 42M0 24l42-42m54 0 42 42m-42 0 42-42" class="lnrt"/>', 
        '<path stroke="#000" class="th" d="M-4-30 44-6"/><circle cx="23" cy="12" r="13"/><path stroke="#000" class="th" d="m108-6 48-24"/><circle cx="128" cy="12" r="13"/>',
        '<path class="lnrt" d="m-6 -16 40 24m0 0 -40 24m152 0 -40 -24m0 0 40 -24"/>',
        '<path id="eye" d="M299.348 296.348a18.83 18.83 0 0 1-20.378-17.1 18.835 18.835 0 0 1 17.098-20.382 11.605 11.605 0 0 1 12.562 10.545 11.605 11.605 0 0 1-10.546 12.557 4.375 4.375 0 0 1-.762-8.716 2.85 2.85 0 0 0-.496-5.669 10.075 10.075 0 0 0-9.135 10.903c.484 5.529 5.375 9.628 10.899 9.145a17.3 17.3 0 0 0 15.708-18.72 17.3 17.3 0 0 0-18.725-15.708 24.525 24.525 0 0 0-22.272 26.542 4.375 4.375 0 0 1-8.716.762 33.285 33.285 0 0 1 30.23-36.021 26.055 26.055 0 0 1 28.2 23.662 26.05 26.05 0 0 1-23.662 28.2z" transform="translate(-286,-260)"/><use xlink:href="#eye" transform="rotate(180,70,10)"/>'
    ]; 
    string[12] private _eyeIds = [
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
        "dizzy"
    ];

    string[5] private _cheeks = [
        '', 
        '<ellipse cx="10" cy="60" rx="20" ry="10" fill="pink"/><ellipse cx="130" cy="60" rx="20" ry="10" fill="pink"/>', 
        '<path d="m15 6 10 12a12.8 12.8 0 1 1-20 0L15 6z" fill="#8af" transform="rotate(5 -432.172 -87.711)"/>', 
        '<path d="m15 6 10 12a12.8 12.8 0 1 1-20 0L15 6z" fill="none" stroke="black" stroke-width="3" transform="rotate(5 -432.172 -87.711)"/>',
        '<path id="chk" fill="#ffaafc" d="M-8 24c.568-3.85 4.951-3.909 6.844-1.609 1.892-2.3 6.275-2.241 6.843 1.61.506 3.436-4.012 6.23-6.843 8.058-2.832-1.829-7.35-4.622-6.844-8.059z" transform="matrix(2 0 0 2.4 0 0)"/><use xlink:href="#chk" transform="translate(148,0)"/>'
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
        '<path d="M40 100a1 .8 0 0 0 64 0" class="lnrt"/><path d="M-30 104a1 .2 0 0 0 26 0" class="lnrt" transform="rotate(-30)"/>',
        '<path d="m24 120 14-10 14 10 14-10 14 10 14-10 14 10" class="lnrt"/>', 
        '<ellipse cx="70" cy="114" rx="18" ry="24"/>',
        '<path d="M4.623 27.78C-.62 21.919-.9 12.146 3.975 5.216c4.483-6.372 10.306-6.444 22.16-.274 11.405 5.936 15.884 5.94 25.844.019 9.603-5.71 15.137-5.99 19.605-.996 4.985 5.574 6.003 12.724 2.861 20.09-3.841 9.007-9.145 9.968-21.313 3.863-12.263-6.153-17.197-6.189-28.692-.206-11.331 5.898-14.593 5.909-19.817.068Z" transform="translate(30,100)"/>',
        '<path d="M27,105 a1,1 0 0,0 40,0" class="lnrt"/><path d="M68,105 a1,1 0 0,0 40,0" class="lnrt"/>', 
        '<path d="M67,120 a0.6,0.6 0 0,0 0,-20" class="lnrt tn"/><path d="M67,140 a1.2,1 0 0,0 0,-20" class="lnrt tn"/>' 
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

    string[5] private _accessories = [
        '',
        '<path id="ac" d="m 62.75,68.40197 c -12.39952,0.86941 -12.32504,13.72601 -29.25,12.25 7.34151,13.53549 24.42044,13.43629 34.25,6.75 9.82956,-6.68629 4.81982,-19.68853 -5,-19 z"/><use xlink:href="#ac" transform="scale(-1,1),translate(-142,0)"/>',
        '<path fill="red" stroke="red" stroke-width="7" stroke-linejoin="round" d="m-44-82 20 15 20-15v30l-20-15-20 15z"/><rect x="-34.5" y="-77.5" width="21" height="21" rx="4" fill="red" stroke="#fff" stroke-width="2"/>',
        '<path d="M-12 -53c-3.73-2.115-6.055-6.2-6.06-10.643 0-4.447 2.327-8.537 6.06-10.655m-37.738 0c3.73 2.115 6.055 6.2 6.06 10.643 0 4.448-2.326 8.538-6.06 10.655m8.22 8.22c2.116-3.73 6.2-6.055 10.643-6.06 4.448 0 8.538 2.327 10.655 6.06m0-37.738c-2.115 3.73-6.2 6.055-10.643 6.06-4.447 0-8.537-2.326-10.655-6.06" class="lnrt tn"/>',
        '<path d="m2.45 10.806 1.488.469.444 1.56.44-1.56 1.487-.469-1.488-.48-.439-1.547-.444 1.547zM.523 3.496l2.063.658.647 2.188.604-2.188 2.087-.658-2.087-.652L3.232.668l-.646 2.176zm8.11-2.028L7.626 5.263l-2.61 1.079 2.61 1.08 1.007 3.794L9.701 7.42l2.525-1.079-2.525-1.08z" fill="#ffc502" transform="translate(-88,-18)scale(4.5)"/>'
    ]; 
    string[5] private _accessoryIds = [
        "none",
        "mustache",
        "bow",
        "pop",
        "sparkle"
    ]; 

    string[3] private _filters = [
        '', 
        '<feTurbulence baseFrequency="0" type="fractalNoise" stitchTiles="noStitch"><animate id="waves" attributeName="baseFrequency" dur="6s" begin="1.5s;waves.end+1.5s" values="0;0.03;0" keyTimes="0;0.5;1" easing="ease-in-out"/></feTurbulence><feDisplacementMap in="SourceGraphic" scale="14"/>',
        '<feTurbulence baseFrequency="0.6" type="fractalNoise"/><feDisplacementMap in="SourceGraphic" scale="0"><animate id="glitch" attributeName="scale" dur="2.5s" begin="1.5s;glitch.end+3s" values="36.72;58.84;36.90;14.99;13.26;47.30;58.24;21.58;46.51;40.17;35.83;36.08;42.74;32.16;46.57;33.67;17.31;52.09;30.80;40.37;43.99;36.21;16.18;20.04;15.72;50.92;30.81"/></feDisplacementMap>'
    ]; 
    string[3] private _filterIds = ["none", "wavy", "glitchy"]; 

    string[3] private _licenses = ["ARR", "CC BY-NC", "CC0"]; 
    
    function getLicense(uint256 id) public view returns (string memory) { 
        uint256 licenseId = _chubFlags[id] % 10; // 0, 1 or 2
        if(licenseId > 2) { licenseId = 2; /* this should never happen */ }
        return _licenses[licenseId]; 
    }

    function usePng(uint256 id) public view returns (bool) { 
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
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "5"))) % 48;
        if(rand >= _cheeks.length) { rand = 0; }
        chub.cheeks = _cheeks[rand]; 
        chub.cheeksId = _cheekIds[rand]; 

        // random mouths
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "6"))) % _mouths.length;
        chub.mouth = _mouths[rand]; 
        chub.mouthId = _mouthIds[rand]; 

        // random accessories 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "7"))) % 60;
        if(rand >= _accessories.length) { rand = 0; }
        chub.accessory = _accessories[rand]; 
        chub.accessoryId = _accessoryIds[rand]; 

        // random filters 
        rand = uint256(keccak256(abi.encodePacked(id, address(this), "8"))) % 100;
        if(rand >= _filters.length) { rand = 0; }
        chub.filter = _filters[rand]; 
        chub.filterId = _filterIds[rand]; 

        chub.license = getLicense(id); 

        return chub; 
    }

    function makeSVG(chubData memory chub) internal pure returns (string memory) {
        string memory filterUrl = ''; 
        string memory filter = ''; 
        if(bytes(chub.filter).length > 0) { 
            filterUrl = string.concat(" filter='url(#",chub.filterId,")'"); 
            filter = string.concat('<filter id="',chub.filterId,'" x="-50%" y="-50%" width="200%" height="200%">',chub.filter,'</filter>'); 
        }

        return string.concat("<svg width='600' height='600' viewBox='0 0 600 600' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'><style>.lnft,.lnrt{stroke:#000;stroke-linecap:round}.lnft{fill:gray;stroke-width:8;}.lnrt{fill:none;stroke-width:7;stroke-linejoin:bezel}.th{stroke-width:12}.tn{stroke-width:4}.wlrt{stroke:#fff;stroke-width:3}text{font-family:'Comic Sans MS','Comic Sans','Chalkboard SE','Comic Neue',cursive;font-size:12pt}</style><defs>",chub.filter,"</defs><rect width='100%' height='100%' fill='#",chub.bgColor,"'/><g id='chub' cursor='pointer'",filterUrl,"><ellipse cx='300' cy='460' rx='160' ry='50' fill='#fff'/><path fill='#fff' d='M140 140h320v320H140z'/><ellipse cx='300' cy='140' rx='160' ry='50' fill='#F8F4F4'/><g id='face' transform='rotate(-5 3422.335 -2819.49)'>",chub.ears,chub.hat,chub.eyes,chub.mouth,chub.cheeks,chub.accessory,"</g><animateMotion path='M0,0 -3,-9 0,-18 6,-9 2,0 0,4z' keyPoints='0;0.1875;0.375;0.5625;0.75;0.9;1' keyTimes='0;0.18;0.37;0.58;0.72;0.87;1' dur='0.8s' begin='click'/></g></svg>"); 
        
    }

    function makeTraits(chubData memory chub) internal pure returns (string memory) { 
        return string.concat('[{"trait_type":"BG Color","value":"',chub.bgColorId,'"},{"trait_type":"Ears","value":"',chub.earsId,'"},{"trait_type":"Hat","value":"',chub.hatId,'"},{"trait_type":"Eyes","value":"',chub.eyesId,'"},{"trait_type":"Mouth","value":"',chub.mouthId,'"},{"trait_type":"Cheeks","value":"',chub.cheeksId,'"},{"trait_type":"Accessory","value":"',chub.accessoryId,'"},{"trait_type":"Filter","value":"',chub.filterId,'"},{"trait_type":"License","value":"',chub.license,'"}]');
    }

    function tokenSVG(uint256 tokenId) public view returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        
        chubData memory chub = makeChub(tokenId);

        return makeSVG(chub); 
    }

    function tokenTraits(uint256 tokenId) public view returns (string memory) { 
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        
        chubData memory chub = makeChub(tokenId);

        return makeTraits(chub); 
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        
        chubData memory chub = makeChub(tokenId);

        string memory output; 
        if(usePng(tokenId) == true && _pngsAvailable == true) {
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
        require(value >= totalSupply() && value < _maxSupply);
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

    function pngsAvailable() public view returns (bool) {
        return _pngsAvailable;
    }

    function togglePNGsAvailable() external onlyOwner {
        _pngsAvailable = !_pngsAvailable;
    }

    function toggleOnChainArt(uint256 tokenId) external returns(bool){
        require(ownerOf(tokenId) == msg.sender);
        
        if(usePng(tokenId)) { 
            _chubFlags[tokenId] -= 10; 
        }
        else { 
            _chubFlags[tokenId] += 10; 
        }

        return usePng(tokenId); 
    }

    function modifyLicense(uint256 tokenId, uint8 level) external returns(string memory){
        require(ownerOf(tokenId) == msg.sender);
        require(level == 1 || level==2);
        uint8 currentLicense = _chubFlags[tokenId] % 10; // 0, 1 or 2

        if(currentLicense == 0) {
            // if current level is 0, you can set it to 1 or 2
            _chubFlags[tokenId] += level;
            return _licenses[level]; 
        }
        else if(currentLicense == 1 && level == 2) {
            // if current level is 1 or 2, you can set it to 2
            _chubFlags[tokenId] += 1;
            return _licenses[level]; 
        }
        revert("Unchanged"); 
    }
}