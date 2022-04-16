import { ethers } from "hardhat";

async function main() {

  const ERC20_TokenFactory = await ethers.getContractFactory("SPR20");
  const erc20_Token = await ERC20_TokenFactory.deploy();

  await erc20_Token.deployed();

  console.log("SPR20 deployed to:", erc20_Token.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
