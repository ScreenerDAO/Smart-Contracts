// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./RegistriesV2/IRegistriesV2.sol";

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

    function upgradeRegistries(address _newAddress) external onlyOwner {
        IRegistriesV2(registriesAddress).upgradeTo(_newAddress);
    }
}