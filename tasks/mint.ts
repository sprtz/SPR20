import { task } from "hardhat/config";


task("mint", "mint tokens")
    .addParam("contract", "contract address")
    .addParam("to", "mint to account")
    .addParam("amount", "mint tokens amount")
    .setAction(async (taskArgs, {ethers}) => {

        const [owner]  = await ethers.getSigners();
        const factory = await ethers.getContractFactory("SPR20");
        const contract = await factory.attach(taskArgs.contract);
    
        const to: string = ethers.utils.getAddress(taskArgs.to);
        const amount: number = taskArgs.amount;
    
        await contract.connect(owner).mint(to, amount);
        console.log(`current owner address ${owner.address}`);
        console.log(`mint to ${to}, ${amount} tokens`);
    });