import { task } from "hardhat/config";


task("transfer", "transfer tokens")
    .addParam("contract", "contract address")
    .addParam("to", "to address")
    .addParam("amount", "transfer tokens amount")
    .setAction(async (taskArgs, {ethers}) => {

            const [owner]  = await ethers.getSigners();
            const factory = await ethers.getContractFactory("SPR20");
            const contract = await factory.attach(taskArgs.contract);

            const to: string = ethers.utils.getAddress(taskArgs.to);
            const amount: number = taskArgs.amount;

            await contract.connect(owner).transfer(to, amount);
            console.log(`current owner address ${owner.address}`);
            console.log(`transfer to ${to}, ${amount} tokens`);
    });