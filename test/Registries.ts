import { ethers, upgrades } from "hardhat"
import { expect } from "chai";
import { DAO, Registries, RegistriesRestricted } from "../typechain-types"
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let companyData = {
    name: 'Coca Cola',
    ticker: 'KO',
    dataHash: 'QmPK1s3pNYLi9ERiq3BDxKa4XosgWwFRQUydHUtz4YgpqB'
}

describe("Registries", async() => {
    let registriesRestricted: RegistriesRestricted
    let registries: Registries 
    let dao: DAO
    let account1: SignerWithAddress 
    let account2: SignerWithAddress

    it("Should deploy the contracts", async () => {
        [account1, account2] = await ethers.getSigners();

        const Registries = await ethers.getContractFactory("Registries")
        registries = await upgrades.deployProxy(Registries) as Registries
        await registries.deployed()

        const numberCompanies = await registries.numberCompanies()

        expect(numberCompanies).to.be.equal(0)

        const Dao = await ethers.getContractFactory("DAO")
        dao = await upgrades.deployProxy(Dao, [registries.address]) as DAO
        await dao.deployed()

        registries.transferRegistriesUpgradeOwnership(dao.address)
        registries.transferOwnership(dao.address)
    })
    
    it("Should create company", async () => {
        await expect(registries.addNewCompany(companyData.name, companyData.ticker, companyData.dataHash))
            .to.emit(registries, 'CompanyAdded')
            .withArgs(0, companyData.name, companyData.ticker, companyData.dataHash)
        
        const numberCompanies = await registries.numberCompanies()

        expect(numberCompanies).to.be.equal(1)
    })

    it("Should edit company", async() => {
        await expect(registries.editCompany(0, "Coca cola 2", "KO2", `${companyData.dataHash}2`))
            .to.emit(registries, 'CompanyEdited')
            .withArgs(0, "Coca cola 2", "KO2", `${companyData.dataHash}2`)

        await expect(registries.editCompanyName(0, "Coca cola 2"))
            .to.emit(registries, 'CompanyNameEdited')
            .withArgs(0, "Coca cola 2")

        await expect(registries.editCompanyTicker(0, "KO2"))
            .to.emit(registries, 'CompanyTickerEdited')
            .withArgs(0, "KO2")

        await expect(registries.editCompanyData(0, `${companyData.dataHash}2`))
            .to.emit(registries, 'CompanyDataEdited')
            .withArgs(0, `${companyData.dataHash}2`)
    })

    it ("Should revert when editing without access", async() => {
        await expect(registries.connect(account2).editCompany(0, "Coca cola 2", "KO2", `${companyData.dataHash}2`))
            .to.be.revertedWith("Not the owner of the company")
    })

    it ('Should upgrade the contract', async () => {
        const RegistriesRestricted = await ethers.getContractFactory('RegistriesRestricted')
        registriesRestricted = await RegistriesRestricted.deploy()
        await registriesRestricted.deployed()

        await dao.upgradeRegistries(registriesRestricted.address)

        expect(registries.address == registriesRestricted.address, "Both contracts must have same address")
    })

    it('Should revert when creating company without access', async() => {
        await expect(registriesRestricted.addNewCompany(companyData.name, companyData.ticker, companyData.dataHash, account1.address))
            .to.be.rejectedWith('Ownable: caller is not the owner')
    })
})