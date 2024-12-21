// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChallengeNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => bool) public challengeCompleted;
    mapping(uint256 => string) public challengeDescription;

    // Events
    event ChallengeMinted(uint256 indexed tokenId, address indexed owner, string description);
    event ChallengeCompleted(uint256 indexed tokenId, address indexed owner);

    // Constructor to initialize the ERC721 and Ownable contracts
    constructor() ERC721("ChallengeNFT", "CNFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    // Mint a new NFT to represent a challenge
    function mintChallenge(address to, string memory tokenURI, string memory description) public onlyOwner {
        uint256 tokenId = tokenCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        challengeDescription[tokenId] = description;
        tokenCounter++;
        emit ChallengeMinted(tokenId, to, description);
    }

    // Mark a challenge as completed
    function completeChallenge(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        require(!challengeCompleted[tokenId], "Challenge already completed");

        challengeCompleted[tokenId] = true;
        emit ChallengeCompleted(tokenId, msg.sender);
    }

    // Check if a challenge is completed
    function isChallengeCompleted(uint256 tokenId) public view returns (bool) {
        return challengeCompleted[tokenId];
    }

    // Get the description of a challenge
    function getChallengeDescription(uint256 tokenId) public view returns (string memory) {
        return challengeDescription[tokenId];
    }
}
