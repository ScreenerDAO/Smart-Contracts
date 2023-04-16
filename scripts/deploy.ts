import { ethers, upgrades } from "hardhat";

async function main() {
    const Registries = await ethers.getContractFactory("Registries")
    const registries = await upgrades.deployProxy(Registries) 
    await registries.deployed()

    const CompanyEditValidator = await ethers.getContractFactory("CompanyEditValidator")
    const companyEditValidator = await upgrades.deployProxy(CompanyEditValidator, [registries.address]) 
    await companyEditValidator.deployed()

    const Dao = await ethers.getContractFactory("DAO")
    const dao = await upgrades.deployProxy(Dao, [registries.address, companyEditValidator.address])
    await dao.deployed()

    await registries.transferUpgradeOwnership(dao.address)
    await registries.transferOwnership(dao.address)
    await companyEditValidator.transferUpgradeOwnership(dao.address)
    await companyEditValidator.transferOwnership(dao.address)
    
    await dao.setValidatorContractAddress(companyEditValidator.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
