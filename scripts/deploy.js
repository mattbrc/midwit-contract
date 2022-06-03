const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('MidwitNFT');
    const domainContract = await domainContractFactory.deploy("Your immutable IQ Score");
    await domainContract.deployed();

    console.log("Contract deployed to:", domainContract.address);

    let txn = await domainContract.register(15, {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    
    const address = await domainContract.getAddress(15);
    console.log("Owner of score 8:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();