import { ethers, upgrades } from "hardhat"
import { expect } from "chai";
import { CompanyEditValidator, DAO, Registries, RegistriesRestricted } from "../typechain-types"
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let companyData = {
    name: 'Coca Cola',
    ticker: 'KO',
    dataHash: 'QmPK1s3pNYLi9ERiq3BDxKa4XosgWwFRQUydHUtz4YgpqB',
    owner: '0x154421b5abfd5fc12b16715e91d564aa47c8ddee'
}

describe("Registries", async() => {
    let registriesRestricted: RegistriesRestricted
    let registries: Registries 
    let dao: DAO
    let companyEditValidator: CompanyEditValidator
    let account1: SignerWithAddress 
    let account2: SignerWithAddress

    it("Should deploy the contracts", async () => {
        [account1, account2] = await ethers.getSigners();

        const Registries = await ethers.getContractFactory("Registries")
        registries = await upgrades.deployProxy(Registries) as Registries
        await registries.deployed()

        const numberCompanies = await registries.numberCompanies()

        expect(numberCompanies).to.be.equal(0)

        const CompanyEditValidator = await ethers.getContractFactory("CompanyEditValidator")
        companyEditValidator = await upgrades.deployProxy(CompanyEditValidator, [registries.address]) as CompanyEditValidator
        await companyEditValidator.deployed()

        const Dao = await ethers.getContractFactory("DAO")
        dao = await upgrades.deployProxy(Dao, [registries.address, companyEditValidator.address]) as DAO
        await dao.deployed()

        await registries.transferUpgradeOwnership(dao.address)
        await registries.transferOwnership(dao.address)
        await companyEditValidator.transferUpgradeOwnership(dao.address)
        await companyEditValidator.transferOwnership(dao.address)
        
        await dao.setValidatorContractAddress(companyEditValidator.address)
    })
    
    it("Should create company", async () => {
        await expect(registries.addNewCompany(companyData.name, companyData.ticker, companyData.dataHash))
            .to.emit(registries, 'CompanyAdded')
            .withArgs(0, companyData.name, companyData.ticker, companyData.dataHash)
        
        const numberCompanies = await registries.numberCompanies()

        expect(numberCompanies).to.be.equal(1)
    })

    it("Should edit company", async() => {
        await expect(dao.editCompany(0, "Coca cola 2", "KO2", `${companyData.dataHash}2`))
            .to.emit(registries, 'CompanyEdited')
            .withArgs(0, "Coca cola 2", "KO2", `${companyData.dataHash}2`)

        await expect(dao.editCompanyName(0, "Coca cola 2"))
            .to.emit(registries, 'CompanyNameEdited')
            .withArgs(0, "Coca cola 2")

        await expect(dao.editCompanyTicker(0, "KO2"))
            .to.emit(registries, 'CompanyTickerEdited')
            .withArgs(0, "KO2")

        await expect(registries.editCompanyData(0, `${companyData.dataHash}2`))
            .to.emit(registries, 'CompanyDataEdited')
            .withArgs(0, `${companyData.dataHash}2`)

        const parameters = new Array(100).fill(null).map(() => {
            return [0, `${companyData.dataHash}2`]
        })

        await dao.editCompanies(parameters as any)
    })

    it ("Should revert when editing without access", async() => {
        await expect(registries.connect(account2).editCompanyData(0, `${companyData.dataHash}2`))
            .to.be.revertedWith("No access to edit company")
    })

    it ('Should upgrade the contract', async () => {
        const RegistriesRestricted = await ethers.getContractFactory('RegistriesRestricted')
        registriesRestricted = await RegistriesRestricted.deploy()
        await registriesRestricted.deployed()

        await dao.upgradeRegistries(registriesRestricted.address)

        expect(registries.address == registriesRestricted.address, "Both contracts must have same address")
    })

    it ('Should add multiple companies', async () => {
        const parameters = new Array(100).fill(null).map(() => {
            return [companyData.name, companyData.ticker,companyData.dataHash,companyData.owner]
        })

        await dao.addNewCompanies(parameters as any)
    })

    it('Should revert when creating company without access', async() => {
        await expect(registriesRestricted.addNewCompany(companyData.name, companyData.ticker, companyData.dataHash, account1.address))
            .to.be.rejectedWith('Ownable: caller is not the owner')
    })

    it('Should revert all tries to change ownerships in dao methods', async() => {
        await expect(dao.connect(account2).changeRegistriesUpgradeOwner(account2.address)).to.be.reverted
        await expect(dao.connect(account2).changeCompanyEditValidatorUpgradeOwnership(account2.address)).to.be.reverted
        await expect(dao.connect(account2).changeRegistriesOwner(account2.address))
        await expect(dao.connect(account2).changeCompanyEditValidatorOwner(account2.address))
    })

    it('Should change ownership in dao methods', async() => {
        dao.changeCompanyEditValidatorOwner(account2.address)
        dao.changeCompanyEditValidatorUpgradeOwnership(account2.address)
        dao.changeRegistriesOwner(account2.address)
        dao.changeCompanyEditValidatorUpgradeOwnership(account2.address)
    })

    it('Should revert all tries to change ownerships in dao methods', async() => {
        await expect(dao.connect(account1).changeRegistriesUpgradeOwner(account2.address)).to.be.reverted
        await expect(dao.connect(account1).changeCompanyEditValidatorUpgradeOwnership(account2.address)).to.be.reverted
        await expect(dao.connect(account1).changeRegistriesOwner(account2.address))
        await expect(dao.connect(account1).changeCompanyEditValidatorOwner(account2.address))
    })
})