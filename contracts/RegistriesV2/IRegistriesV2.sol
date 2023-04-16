// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

struct AddCompanyParameters {
    string name;
    string ticker;
    string dataHash; 
    address user;
}

struct EditCompanyParameters {
    uint companyId;
    string dataHash;
}

interface IRegistriesV2 {
    function numberCompanies() external view returns (uint);
    function companiesOwners(uint companyId) external view returns (address);

    function addNewCompany(
        string memory _name,
        string memory _ticker,
        string memory _dataHash,
        address _owner
    ) external;

    function editCompany(
        uint _id,
        string memory _name,
        string memory _ticker,
        string memory _dataHash
    ) external;
    
    function addNewCompanies(AddCompanyParameters[] calldata parameters) external;
    function editCompanies(EditCompanyParameters[] calldata parameters) external;
    function editCompanyName(uint _id, string memory _name) external;
    function editCompanyTicker(uint _id, string memory _ticker) external;
    function editCompanyData(uint _id, string memory _dataHash) external;
    function upgradeTo(address newImplementation) external;
    function transferUpgradeOwnership(address newOwner) external;
    function transferOwnership(address newOwner) external;
}
