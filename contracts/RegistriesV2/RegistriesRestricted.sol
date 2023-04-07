// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract RegistriesRestricted is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint public numberCompanies;
    mapping(uint => address) public companiesOwners;

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

    modifier onlyCompanyOwner(uint companyId) {
        require(msg.sender == companiesOwners[companyId], "Not the owner of the company");
        _;
    }

    function initialize() public reinitializer(2) {
        __Ownable_init();
    }

    function addNewCompany(
        string memory _name,
        string memory _ticker,
        string memory _dataHash,
        address _owner
    ) public onlyOwner {
        numberCompanies++;
        companiesOwners[numberCompanies - 1] = _owner;

        emit CompanyAdded(numberCompanies - 1, _name, _ticker, _dataHash);
    }

    function editCompany (
        uint _id,
        string memory _name,
        string memory _ticker,
        string memory _dataHash
    ) external onlyCompanyOwner(_id) {
        require(_id < numberCompanies, "Company doesn't exist");

        emit CompanyEdited(_id, _name, _ticker, _dataHash);
    }

    function editCompanyName(uint _id, string memory _name) external onlyCompanyOwner(_id) {
        require(_id < numberCompanies, "Company doesn't exist");

        emit CompanyNameEdited(_id, _name);
    } 

    function editCompanyTicker(uint _id, string memory _ticker) external onlyCompanyOwner(_id) {
        require(_id < numberCompanies, "Company doesn't exist");

        emit CompanyTickerEdited(_id, _ticker);
    }

    function editCompanyData(uint _id, string memory _dataHash) external onlyCompanyOwner(_id) {
        require(_id < numberCompanies, "Company doesn't exist");

        emit CompanyDataEdited(_id, _dataHash);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function transferRegistriesUpgradeOwnership(address _newOwner) public onlyOwner {
        _changeAdmin(_newOwner);
    }
}
