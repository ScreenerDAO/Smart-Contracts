// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Registries is Initializable {
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

    function addNewCompany(
        string memory name,
        string memory ticker,
        string memory dataHash
    ) public {
        numberCompanies++;

        emit CompanyAdded(numberCompanies - 1, name, ticker, dataHash);
    }

    function editCompany(
        uint id,
        string memory name,
        string memory ticker,
        string memory dataHash
    ) public {
        require(id < numberCompanies, "Company doesn't exist");

        emit CompanyEdited(id, name, ticker, dataHash);
    }

    function editCompanyName(uint id, string memory name) public {
        require(id < numberCompanies, "Company doesn't exist");

        emit CompanyNameEdited(id, name);
    } 

    function editCompanyTicker(uint id, string memory ticker) public {
        require(id < numberCompanies, "Company doesn't exist");

        emit CompanyTickerEdited(id, ticker);
    }

    function editCompanyData(uint id, string memory dataHash) external {
        require(id < numberCompanies, "Company doesn't exist");

        emit CompanyDataEdited(id, dataHash);
    }
}