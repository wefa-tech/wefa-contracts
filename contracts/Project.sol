// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";

import "./interfaces/IProject.sol";

contract Project is IProject, Initializable, ERC1155Upgradeable, ERC1155SupplyUpgradeable, AccessControlUpgradeable {
  // CORE - TYPES
  Status public status;
  Core private core;

  // INFO - TYPES
  Details public details;
  Settings private settings;
  Location private location;

  // COMMUNITY - TYPES
  bytes32 public constant TEAM_LEADER_ROLE = keccak256("TEAM_LEADER_ROLE");
  bytes32 public constant TEAM_MEMBER_ROLE = keccak256("TEAM_MEMBER_ROLE");
  bytes32 public constant CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR_ROLE");
  bytes32 public constant PATRON_ROLE = keccak256("PATRON_ROLE");
  mapping(address => Teammate) private team;
  mapping(address => Contributor) private contributors;
  mapping(address => Patron) private patrons;

  // SPACE - TYPES
  Feature[] private features;
  Milestone[] private milestones; // Upon completion the rewards are distrbuted to members of the project.
  Tool[] private tools;
  Donation[] private donations;
  mapping(uint256 => bool) private featureExists;
  mapping(uint256 => bool) private toolExists;

  // INITIALIZATION - FUNCTIONS
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  function initialize(
    string memory _name,
    string memory _mission,
    string memory _metadata,
    address _owner
  ) public initializer {
    details.name = _name;
    details.mission = _mission;
    details.metadata = _metadata;

    __ERC1155_init("");
    __AccessControl_init();
    __ERC1155Supply_init();

    _grantRole(DEFAULT_ADMIN_ROLE, _owner);
    _grantRole(TEAM_LEADER_ROLE, _owner);
  }

  // OVERRIDE - FUNCTIONS
  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal override(ERC1155Upgradeable, ERC1155SupplyUpgradeable) {
    super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC1155Upgradeable, AccessControlUpgradeable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }

  // CORE - FUNCTIONS
  function updateCore(Element[] calldata _elements, Action[] calldata _actions) external {
    for (uint256 i = 0; i < 5; i++) {
      if (i < 4) {
        Element element = _elements[i];
        core.elements[i] = element;
      }
      Action action = _actions[i];
      core.actions[i] = action;
    }

    // emit UpdatedCore(core.elements, core.actions);
  }

  // INFO - FUNCTIONS
  function updateDetails(
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external {
    if (bytes(_name).length > 0) {
      details.name = _name;
    }
    if (bytes(_mission).length > 0) {
      details.name = _mission;
    }
    if (bytes(_metadata).length > 0) {
      details.name = _metadata;
    }
  }

  function updateSettings(Settings calldata _settings) external {
    if (_settings.privacy > 0) {
      settings.privacy = _settings.privacy;
    }
  }

  function updateLocation(Location calldata _location) external {}

  // COMMUNITY - FUNCTIONS
  function addMember(
    address _user,
    MemberRole _role,
    MemberStatus _status
  ) external {
    if (_role == MemberRole.TEAMMATE) {
      assert(team[_user].createdAt == 0);
      team[_user] = Teammate(_status, block.timestamp, block.timestamp, 0, false);
    } else if (_role == MemberRole.TEAMMATE) {
      assert(contributors[_user].createdAt == 0);
      // contributors[_user] = Contributor(_status, block.timestamp, block.timestamp, block.timestamp, 0, 0, 0);
    } else {
      assert(patrons[_user].createdAt == 0);
      // patrons[_user] = Patron(_status, block.timestamp, block.timestamp, block.timestamp, 1, 0, 0);
    }
  }

  function updateTeammate(
    address _user,
    MemberStatus _status,
    bool _leader
  ) external {}

  function updateContributor(
    address _user,
    MemberStatus _status,
    uint256 _verifyCycle,
    uint256 _verifiers
  ) external {}

  function updatePatron(
    address _user,
    MemberStatus _status,
    uint256 _verifyCycle,
    uint256 _verifiers
  ) external {}

  function removeMember(address _user, MemberRole _role) external {}

  // SPACE - FUNCTIONS
  function addFeature(uint256 _work, WorkAction _action) external {}

  function updateFeature(uint256 _work, WorkAction _action) external {}

  function addMilestone(uint256 _work, WorkAction _action) external {}

  function updateMilestone(uint256 _work, WorkAction _action) external {}

  function contributeTools(Tool[] calldata _tools) external {}

  function updateTools(Tool[] calldata _tools) external {}

  function contributeWork(uint256 _work, WorkAction _action) external {}

  function completeWork(uint256 _work) external {}

  function donate(Donation calldata _donation) external {}

  function deactivate() external {}
}
