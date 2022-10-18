// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./interfaces/IProjectFactory.sol";
import "./interfaces/IProject.sol";

contract ProjectFactory is IProjectFactory, Initializable, PausableUpgradeable, AccessControlUpgradeable {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  uint256 public version;
  uint256 public projectCount;
  FactoryStatus public status;

  ProjectDetails[] public projectProposals;
  mapping(address => ProjectDetails) public projects;

  mapping(address => uint256) private ownerProjectCount;
  mapping(address => uint256[]) private ownerToProposals;

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
  ) external {
    // projects.push(Project(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    // emit UpdatedProject(id, _name, _dna);
  }

  function createProject(
    ProjectStatus _status,
    string memory _name,
    string memory _mission,
    string memory _metadata
  ) external {
    // projects.push(ProjectInfo(_name, _mission, _status));

    // projectToOwner[msg.sender] = msg.sender;
    ownerProjectCount[msg.sender] = ownerProjectCount[msg.sender] + 1;

    // emit CreatedProject(msg.sender, _name, _mission, _status, _metadata);
  }

  function updateProject(
    address _project,
    uint8 _status,
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external {
    // projects.push(Project(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    // emit UpdatedProject(id, _name, _dna);
  }

  function deactivateProject(address _address) external {
    // projects.push(Project(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    // emit DeletedProject(id, _name, _dna);
  }
}
