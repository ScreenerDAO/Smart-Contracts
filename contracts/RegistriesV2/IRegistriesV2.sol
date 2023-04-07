// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

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
    
    function editCompanyName(uint _id, string memory _name) external;
    function editCompanyTicker(uint _id, string memory _ticker) external;
    function editCompanyData(uint _id, string memory _dataHash) external;
    function upgradeTo(address newImplementation) external;
    function transferRegistriesUpgradeOwnership(address _newOwner) external;
}
