// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../CompanyEditValidator.sol";

struct CreateCompanyParameters {
    string name;
    string ticker;
    string dataHash; 
}

struct EditCompanyParameters {
    uint companyId;
    string dataHash;
}

contract Registries is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint public numberCompanies;

    event CompanyAdded(
        uint id,
        string name,
        string ticker,
        string dataHash
    );
    event CompanyEdited(uint id, string name, string ticker, string dataHash);
    event CompanyNameEdited(uint id, string name);
    event CompanyTickerEdited(uint id, string ticker);
    event CompanyDataEdited(uint id, string dataHash);

    modifier companyEditAccess(uint _companyId) {
        require(CompanyEditValidator(getValidatorContractAddress()).addressHasRightToEditCompany(_companyId, msg.sender) || msg.sender == owner(), "No access to edit company");
        _;
    }

    modifier companyExists(uint _companyId) {
        require(_companyId < numberCompanies, "Company doesn't exist");
        _;
    }

    function initialize() public initializer {
        __Ownable_init();
    }

    /** Should be repaced with the address of the validator contract address */
    function getValidatorContractAddress () private pure returns (address) {
        return 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
    }

    function addNewCompanies(CreateCompanyParameters[] calldata parameters) public {
        for (uint i = 0; i < parameters.length; i++) {
            numberCompanies++;
            CompanyEditValidator(getValidatorContractAddress()).addAccess(numberCompanies - 1, msg.sender);

            emit CompanyAdded(numberCompanies - 1, parameters[i].name, parameters[i].ticker, parameters[i].dataHash);
        }
    }

    function editCompanies(EditCompanyParameters[] calldata parameters) public {
        for (uint i = 0; i < parameters.length; i++) {
            require(CompanyEditValidator(getValidatorContractAddress()).addressHasRightToEditCompany(parameters[i].companyId, msg.sender) || msg.sender == owner(), "No access to edit company");

            emit CompanyDataEdited(parameters[i].companyId, parameters[i].dataHash);
        }
    }

    function addNewCompany(
        string calldata _name,
        string calldata _ticker,
        string calldata _dataHash
    ) public {
        numberCompanies++;
        CompanyEditValidator(getValidatorContractAddress()).addAccess(numberCompanies - 1, msg.sender);

        emit CompanyAdded(numberCompanies - 1, _name, _ticker, _dataHash);
    }

    function editCompanyData(uint _id, string calldata _dataHash) external companyExists(_id) companyEditAccess(_id) {
        emit CompanyDataEdited(_id, _dataHash);
    }

    function editCompanyTicker(uint _id, string calldata _ticker) external companyExists(_id) onlyOwner {
        emit CompanyTickerEdited(_id, _ticker);
    }

    function editCompanyName(uint _id, string calldata _name) external companyExists(_id) onlyOwner {
        emit CompanyNameEdited(_id, _name);
    } 

    function editCompany (
        uint _id,
        string calldata _name,
        string calldata _ticker,
        string calldata _dataHash
    ) external companyExists(_id) onlyOwner {
        emit CompanyEdited(_id, _name, _ticker, _dataHash);
    }

    function transferUpgradeOwnership(address _newOwner) public onlyOwner {
        _changeAdmin(_newOwner);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
