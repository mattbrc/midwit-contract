// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { StringUtils } from "./libraries/StringUtils.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MidwitNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public iq;
    string public iqText;

    // store NFTs as SVG strings
    string svgPartOne = '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 270 270" style="enable-background:new 0 0 270 270;" xml:space="preserve"> <style type="text/css"> .st0{fill:url(#SVGID_1_);} .st1{fill:none;} .st2{fill:#FFFFFF;} .st3{font-family: MyriadPro-Regular;} .st4{font-size:21px;} .st5{font-size:12px;} </style> <linearGradient id="SVGID_1_" gradientUnits="userSpaceOnUse" x1="-11.2373" y1="134.9593" x2="281.4653" y2="134.9593" gradientTransform="matrix(1 0 0 -1 0 270)"> <stop  offset="0" style="stop-color:#405DAA"/> <stop  offset="1" style="stop-color:#E33C96"/> </linearGradient> <rect x="-11.2" y="-10.6" class="st0" width="292.7" height="291.3"/> <rect x="55.7" y="184.3" class="st1" width="62.6" height="10.1"/>  <text transform="matrix(1 0 0 1 10 40)" class="st2 st3 st4">Midwit.io</text> <text transform="matrix(1 0 0 1 10 80)" class="st2 st3 st4">IQ Score: ';
    string svgPartTwo = '</text><text transform="matrix(1 0 0 1 10 115)" class="st2 st3 st5">';
    string svgPartThree = '</text></svg>';

    // A "mapping" data type to store their names
    mapping(uint => address) public scores;

    constructor(string memory _iq) payable ERC721("Midwit NFTs", "MID") {
        iq = _iq;
    }

    function price() public pure returns(uint) {
        return 1 * 10**17;
    }

    // A register function that adds their names to our mapping
    function register(uint score) public payable {
        uint _price = price();

        require(msg.value >= _price, "Not enough Matic paid");

        // define nft description output depending on score
        if (score < 10) {
            iqText = "Let's be honest, you're kind of an idiot";
        } else if (score < 18) {
            iqText = "You're average at best.";
        } else {
            iqText = "Is it hard to socialize being this autistic?";
        }

        uint iqMath = score * 100 / 20;
        uint completeIqMath = (iqMath * 100) / 70;

        string memory _name = string(abi.encodePacked(iq));
        string memory finalSvg = string(abi.encodePacked(svgPartOne, Strings.toString(completeIqMath), svgPartTwo, iqText, svgPartThree));
        uint256 newRecordId = _tokenIds.current();

        // Create the JSON metadata for the NFT. 
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "Because the natural progression of web3 is to mint your iq as an nft.", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '"}'
            )
        );

        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

        console.log("\n--------------------------------------------------------");
        console.log("Final tokenURI", finalTokenUri);
        console.log("--------------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        

        scores[score] = msg.sender;
        _tokenIds.increment();
    }

    // This will give us the domain owners' address
    function getAddress(uint score) public view returns (address) {
        require(scores[score] == msg.sender);
        return scores[score];
    }
}