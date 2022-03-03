//SPDX-License-Identifier: MIT

pragma solidity ^0.8.x;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;
    address contractAddress;

    constructor(address marketplaceAddress) ERC721("ALAN TOKEN","ALT")  {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns(uint) {
        _tokenIDs.increment();
        uint256 newItemID = _tokenIDs.current();
        _mint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);
        setApprovalForAll(contractAddress, true);

        return newItemID;

    }
}