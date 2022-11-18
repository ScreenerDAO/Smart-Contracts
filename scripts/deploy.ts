import { ethers } from "hardhat";

async function main() {
    const Registries = await ethers.getContractFactory('Registries')
    const registries = await Registries.deploy()

    await registries.deployed()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
