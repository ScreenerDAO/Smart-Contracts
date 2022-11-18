import { Contract } from "ethers"
import { ethers } from "hardhat"
import { expect } from "chai";
import { Registries } from "../typechain-types"

let registries: Registries

let companyData = {
    name: 'Coca Cola',
    ticker: 'KO',
    dataHash: 'QmPK1s3pNYLi9ERiq3BDxKa4XosgWwFRQUydHUtz4YgpqB'
}

describe("Registries", () => {
    it("Should deploy the contract", async () => {
        const Registries = await ethers.getContractFactory("Registries")
        registries = await Registries.deploy()

        const numberCompanies = await registries.numberCompanies()

        expect(numberCompanies).to.be.equal(0)
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
})