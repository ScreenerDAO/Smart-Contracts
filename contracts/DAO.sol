// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./RegistriesV2/IRegistriesV2.sol";

struct AddCompanyParameters {
    string name;
    string ticker;
    string dataHash;
    address owner;
}

struct EditCompanyParameters {
    uint id;
    string dataHash;
}

contract DAO is Initializable, OwnableUpgradeable {
    address registriesAddress;

    function initialize(address _address) public initializer {
        __Ownable_init();

        registriesAddress = _address;
    }

    function addNewCompany(
        string memory _name,
        string memory _ticker,
        string memory _dataHash,
        address _owner
    ) external onlyOwner {
        IRegistriesV2(registriesAddress).addNewCompany(_name, _ticker, _dataHash, _owner);
    }

    function editCompanyData(uint _id, string memory _dataHash) external onlyOwner {
        IRegistriesV2(registriesAddress).editCompanyData(_id, _dataHash);
    }

    function editCompanyTicker(uint _id, string memory _ticker) external onlyOwner {
        IRegistriesV2(registriesAddress).editCompanyTicker(_id, _ticker);
    }

    function editCompanyName(uint _id, string memory _name) external onlyOwner {
        IRegistriesV2(registriesAddress).editCompanyName(_id, _name);
    }

    function addMultipleCompanies(AddCompanyParameters[] calldata parameters) external onlyOwner {
        for (uint i = 0; i < parameters.length; i++) {
            IRegistriesV2(registriesAddress).addNewCompany(parameters[i].name, parameters[i].ticker, parameters[i].dataHash, parameters[i].owner);
        }
    }

    function editMultipleCompaniesData(EditCompanyParameters[] calldata parameters) external onlyOwner {
        for (uint i = 0; i < parameters.length; i++) {
            IRegistriesV2(registriesAddress).editCompanyData(parameters[i].id, parameters[i].dataHash);
        }
    }

    function editCompany(
        uint _id,
        string memory _name,
        string memory _ticker,
        string memory _dataHash
    ) external onlyOwner {
        IRegistriesV2(registriesAddress).editCompany(_id, _name, _ticker, _dataHash);
    }

    function upgradeRegistries(address _newAddress) external onlyOwner {
        IRegistriesV2(registriesAddress).upgradeTo(_newAddress);
    }
}