import { task } from "hardhat/config";


task("transferFrom", "transfer from account tokens")
    .addParam("contract", "contract address")
    .addParam("from", "from address")
    .addParam("to", "to address")
    .addParam("amount", "transfer tokens amount")
    .setAction(async (taskArgs, {ethers}) => {
      
        const [owner]  = await ethers.getSigners();
        const factory = await ethers.getContractFactory("SPR20");
        const contract = await factory.attach(taskArgs.contract);

        const from: string = ethers.utils.getAddress(taskArgs.from);
        const to: string = ethers.utils.getAddress(taskArgs.to);
        const amount: number = taskArgs.amount;

        await contract.connect(owner).transferFrom(from, to, amount);
        console.log(`current owner address ${owner.address}`);
        console.log(`transfer from ${from} to ${to}, ${amount} tokens`);
    });