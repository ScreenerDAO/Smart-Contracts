// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICompanyEditValidator {
    function addAccess (uint _companyId, address _user) external;
    function removeAccess(uint _companyId, address _user) external;
    function transferUpgradeOwnership(address _newOwner) external;
    function upgradeTo(address newImplementation) external;
    function transferOwnership(address newAddress) external;
}