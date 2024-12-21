// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedAccreditationSystem {

    struct Accreditation {
        uint256 id;
        string institutionName;
        string accreditationDetails;
        address accreditedBy;
        uint256 timestamp;
    }

    address public admin;
    uint256 public accreditationCounter;
    mapping(uint256 => Accreditation) public accreditations;

    event AccreditationCreated(
        uint256 id,
        string institutionName,
        string accreditationDetails,
        address indexed accreditedBy,
        uint256 timestamp
    );

    event AccreditationRevoked(
        uint256 id,
        string institutionName,
        address indexed revokedBy,
        uint256 timestamp
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
        accreditationCounter = 0;
    }

    function createAccreditation(string memory institutionName, string memory accreditationDetails) public onlyAdmin {
        accreditationCounter++;
        accreditations[accreditationCounter] = Accreditation({
            id: accreditationCounter,
            institutionName: institutionName,
            accreditationDetails: accreditationDetails,
            accreditedBy: msg.sender,
            timestamp: block.timestamp
        });

        emit AccreditationCreated(
            accreditationCounter,
            institutionName,
            accreditationDetails,
            msg.sender,
            block.timestamp
        );
    }

    function revokeAccreditation(uint256 id) public onlyAdmin {
        require(accreditations[id].id != 0, "Accreditation does not exist");

        emit AccreditationRevoked(
            id,
            accreditations[id].institutionName,
            msg.sender,
            block.timestamp
        );

        delete accreditations[id];
    }

    function getAccreditation(uint256 id) public view returns (Accreditation memory) {
        require(accreditations[id].id != 0, "Accreditation does not exist");
        return accreditations[id];
    }
}