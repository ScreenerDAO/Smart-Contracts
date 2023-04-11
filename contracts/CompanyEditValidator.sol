// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract CompanyEditValidator is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    mapping(uint => mapping(address => bool)) public addressHasRightToEditCompany;
    address registriesContractAddress;

    function initialize(address _registriesContractAddress) public initializer {
        __Ownable_init();

        registriesContractAddress = _registriesContractAddress;
    }

    function addAccess(
        uint _companyId,
        address _user
    ) public {
        require(msg.sender == registriesContractAddress || msg.sender == owner(), "This can only be called from registries contract");

        addressHasRightToEditCompany[_companyId][_user] = true;
    }

    function removeAccess(
        uint _companyId,
        address _user
    ) public onlyOwner {
        addressHasRightToEditCompany[_companyId][_user] = false;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function transferRegistriesUpgradeOwnership(address _newOwner) public onlyOwner {
        _changeAdmin(_newOwner);
    }
}
