import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFT Marketplace", function () {
  it("should create and execute sales", async () => {
    const Market = await ethers.getContractFactory("NFTMarket");
    const market = await Market.deploy();
    await market.deployed();
  
    const marketAddress = market.address;

    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy(marketAddress);
    await nft.deployed();

    const nftContractAddress = nft.address;

    let listingPrice = await market.getListingPrice();

    const auctionPrice = ethers.utils.parseUnits("100");

    await nft.createToken("token1.com");
    await nft.createToken("token2.com");

    await market.createMarketItem(nftContractAddress, 1, auctionPrice, {value: listingPrice});
    await market.createMarketItem(nftContractAddress, 2, auctionPrice, { value: listingPrice });

    const [_, buyerAddress] = await ethers.getSigners();

    await market.connect(buyerAddress).createMarketSake(nftContractAddress, 1, { value: auctionPrice});

    const items = await market.fetchMarketItems();

    console.log(items);
  });
});
