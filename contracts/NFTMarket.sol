//SPDX-License-Identifier: MIT

pragma solidity ^0.8.x;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _ItemIDs;
    Counters.Counter private _ItemsSold;

    address payable owner;
    uint listingPrice = 0.025 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint ItemID;
        address nftContract;
        uint256 tokenID;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated (
        uint indexed itemID,
        address indexed nftContract,
        uint256 indexed tokenID,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function createMarketItem(
        address nftContract,
        uint256 tokenID,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0, "Price must be atleast one wei");
        require(msg.value == listingPrice, "Price must be equal to the listing price");

        _ItemIDs.increment();

        uint256 _ItemID = _ItemIDs.current();

        idToMarketItem[_ItemID] = MarketItem(
            _ItemID,
            nftContract,
            tokenID,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenID);

        emit MarketItemCreated(
            _ItemID,
            nftContract,
            tokenID,
            msg.sender,
            address(0),
            price,
            false
        );
    }

    function createMarketSake(
        address nftContract,
        uint256 ItemID
    ) public payable nonReentrant {

        uint256 price = idToMarketItem[ItemID].price;
        uint tokenID = idToMarketItem[ItemID].tokenID;
        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

        idToMarketItem[ItemID].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenID);
        idToMarketItem[ItemID].owner = payable(msg.sender);
        idToMarketItem[ItemID].sold = true;

        _ItemsSold.increment();
        payable(owner).transfer(listingPrice);

    }
}