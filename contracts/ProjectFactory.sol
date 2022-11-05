// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./interfaces/IProjectFactory.sol";
import "./Project.sol";

contract ProjectFactory is IProjectFactory, Initializable, PausableUpgradeable, AccessControlUpgradeable {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  uint256 public version;
  uint256 public projectCount;
  FactoryStatus public status;

  address[] public projects;
  mapping(address => mapping(address => bool)) public ownerToProjectExists;
  mapping(address => uint256) public ownerProjectCount;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  function initialize() public initializer {
    __Pausable_init();
    __AccessControl_init();

    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(PAUSER_ROLE, msg.sender);
  }

  function pause() public onlyRole(PAUSER_ROLE) {
    _pause();
  }

  function unpause() public onlyRole(PAUSER_ROLE) {
    _unpause();
  }

  function submitProjectProposal(
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external {}

  function createProject(
    ProjectStatus _status,
    string memory _name,
    string memory _mission,
    string memory _metadata
  ) external {}

  function deactivateProject(address _address) external {}
}
