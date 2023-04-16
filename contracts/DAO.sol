// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./RegistriesV2/IRegistriesV2.sol";
import "./ICompanyEditValidator.sol";

contract DAO is Initializable, OwnableUpgradeable {
    IRegistriesV2 private registries;
    ICompanyEditValidator private companyEditValidator;

    function initialize(
        IRegistriesV2 _registriesInstance, 
        ICompanyEditValidator _companyEditValidatorInstance
    ) public initializer {
        __Ownable_init();

        registries = _registriesInstance;
        companyEditValidator = _companyEditValidatorInstance;
    }

    function addNewCompany(
        string calldata _name,
        string calldata _ticker,
        string calldata _dataHash,
        address _owner
    ) external onlyOwner {
        registries.addNewCompany(_name, _ticker, _dataHash, _owner);
    }

    function editCompanyData(uint _id, string calldata _dataHash) external onlyOwner {
        registries.editCompanyData(_id, _dataHash);
    }

    function editCompanyTicker(uint _id, string calldata _ticker) external onlyOwner {
        registries.editCompanyTicker(_id, _ticker);
    }

    function editCompanyName(uint _id, string calldata _name) external onlyOwner {
        registries.editCompanyName(_id, _name);
    }

    function addNewCompanies(AddCompanyParameters[] calldata parameters) external onlyOwner {
        registries.addNewCompanies(parameters);
    }

    function editCompanies(EditCompanyParameters[] calldata parameters) external onlyOwner {
        registries.editCompanies(parameters);
    }

    function editCompany(
        uint _id,
        string calldata _name,
        string calldata _ticker,
        string calldata _dataHash
    ) external onlyOwner {
        registries.editCompany(_id, _name, _ticker, _dataHash);
    }

    function setValidatorContractAddress(address _newAddress) external onlyOwner {
        registries.setValidatorContractAddress(_newAddress);
    }

    /** Upgrade contracts functions */

    function upgradeRegistries(address _newAddress) external onlyOwner {
        registries.upgradeTo(_newAddress);
    }

    function upgradeCompanyEditValidator(address _newAddress) external onlyOwner {
        companyEditValidator.upgradeTo(_newAddress);
    }

    /** Transfer upgrade ownership functions */

    function changeRegistriesUpgradeOwner(address newOwner) external onlyOwner {
        registries.transferUpgradeOwnership(newOwner);
    }

    function changeCompanyEditValidatorUpgradeOwnership(address newOwner) external onlyOwner {
        companyEditValidator.transferUpgradeOwnership(newOwner);
    }

    /** Change owner functions */

    function changeRegistriesOwner(address newOwner) external onlyOwner {
        registries.transferOwnership(newOwner);
    }

    function changeCompanyEditValidatorOwner(address newOwner) external onlyOwner {
        companyEditValidator.transferOwnership(newOwner);
    }
}