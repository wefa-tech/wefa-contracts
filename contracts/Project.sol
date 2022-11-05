// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";

import "./interfaces/IProject.sol";

contract Project is
  IProject,
  Initializable,
  ERC1155Upgradeable,
  ERC1155SupplyUpgradeable,
  AccessControlUpgradeable,
  PausableUpgradeable
{
  // CORE - TYPES
  Status public status;
  Core private core;

  // INFO - TYPES
  Details public details;
  Settings private settings;
  Location private location;

  // COMMUNITY - TYPES
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
  bytes32 public constant TEAM_LEADER_ROLE = keccak256("TEAM_LEADER_ROLE");
  bytes32 public constant TEAM_MEMBER_ROLE = keccak256("TEAM_MEMBER_ROLE");
  bytes32 public constant CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR_ROLE");
  bytes32 public constant PATRON_ROLE = keccak256("PATRON_ROLE");

  mapping(address => Teammate) private team;
  mapping(address => Contributor) private contributors;
  mapping(address => Patron) private patrons;

  // SPACE - TYPES
  Feature[] private features;
  Tool[] private tools;
  Milestone[] private milestones; // Upon completion the rewards are distrbuted to members of the project.
  Donation[] private donations;
  mapping(uint256 => bool) private featureExists;
  mapping(uint256 => bool) private toolExists;

  modifier onlyAdmin() {
    require(hasRole(ADMIN_ROLE, msg.sender), "Project: Only Admin");
    _;
  }

  modifier onlyTeamLeader() {
    require(hasRole(TEAM_LEADER_ROLE, msg.sender), "Project: Only leader can call");
    _;
  }

  modifier onlyTeamMember() {
    require(hasRole(TEAM_MEMBER_ROLE, msg.sender), "Project: Only team member can call");
    _;
  }

  modifier onlyContributor() {
    require(hasRole(CONTRIBUTOR_ROLE, msg.sender), "Project: Only contributor can call");
    _;
  }

  modifier onlyPatron() {
    require(hasRole(PATRON_ROLE, msg.sender), "Project: Only patron can call");
    _;
  }

  modifier onlyTeam() {
    require(
      hasRole(TEAM_LEADER_ROLE, msg.sender) || hasRole(TEAM_MEMBER_ROLE, msg.sender),
      "Project: Only team can call"
    );
    _;
  }

  modifier onlyCommunity() {
    require(
      hasRole(TEAM_LEADER_ROLE, msg.sender) ||
        hasRole(TEAM_MEMBER_ROLE, msg.sender) ||
        hasRole(CONTRIBUTOR_ROLE, msg.sender),
      "Project: Only community can call"
    );
    _;
  }

  modifier onlyMembers() {
    require(
      hasRole(TEAM_LEADER_ROLE, msg.sender) ||
        hasRole(TEAM_MEMBER_ROLE, msg.sender) ||
        hasRole(CONTRIBUTOR_ROLE, msg.sender) ||
        hasRole(PATRON_ROLE, msg.sender),
      "Project: Only members can call"
    );
    _;
  }

  modifier onlyValidFeature(uint256 _featureId) {
    require(featureExists[_featureId], "Project: Feature does not exist");
    _;
  }

  modifier onlyFeatureCreator(uint256 _featureId) {
    require(features[_featureId].creator == msg.sender, "Project: Only creator can call");
    _;
  }

  modifier onlyValidTool(uint256 _toolId) {
    require(toolExists[_toolId], "Project: Tool doesn't exist");
    _;
  }

  modifier onlyToolOwner(uint256 _toolId) {
    require(tools[_toolId].owner == msg.sender, "Project: Only owner can call");
    _;
  }

  modifier onlyValidMilestone(uint256 _milestoneId) {
    require(_milestoneId < milestones.length, "Project: Milestone doesn't exist");
    _;
  }

  modifier onlyMilestoneCreator(uint256 _milestoneId) {
    require(milestones[_milestoneId].creator == msg.sender, "Project: Only creator can call");
    _;
  }

  // INITIALIZATION - FUNCTIONS
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  function initialize(
    string calldata _name,
    string calldata _mission,
    string calldata _metadata,
    Element[4] calldata _elements,
    Action[5] calldata _actions,
    address _owner
  ) public initializer {
    core.elements = _elements;
    core.actions = _actions;

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

  function updateLocation(Location calldata _location) external {
    if (bytes(_location.country).length > 0) {
      location.country = _location.country;
    }
    if (bytes(_location.city).length > 0) {
      location.city = _location.city;
    }
    // if (bytes(_location.address).length > 0) {
    //   location.address = _location.address;
    // }
    // if (bytes(_location.postalCode).length > 0) {
    //   location.postalCode = _location.postalCode;
    // }
  }

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
  ) external {
    Teammate storage teammate = team[_user];
    teammate.status = _status;
    teammate.leader = _leader;
    teammate.updatedAt = block.timestamp;
  }

  function updateContributor(
    address _user,
    MemberStatus _status,
    uint256 _verifyCycle,
    address[] calldata _verifiers
  ) external {
    Contributor storage contributor = contributors[_user];
    contributor.status = _status;
    contributor.verifyCycle = _verifyCycle;
    contributor.verifiers = _verifiers;
    contributor.updatedAt = block.timestamp;
  }

  function updatePatron(
    address _user,
    MemberStatus _status,
    uint256 _verifyCycle,
    address[] calldata _verifiers
  ) external {
    Patron storage patron = patrons[_user];
    patron.status = _status;
    patron.verifyCycle = _verifyCycle;
    patron.verifiers = _verifiers;
    patron.updatedAt = block.timestamp;
  }

  function removeMember(address _user, MemberRole _role) external {
    if (_role == MemberRole.TEAMMATE) {
      delete team[_user];
    } else if (_role == MemberRole.CONTRIBUTOR) {
      delete contributors[_user];
    } else {
      delete patrons[_user];
    }
  }

  // SPACE - FUNCTIONS
  function addFeature(uint256 _work, WorkAction _action) external {}

  function updateFeature(uint256 _work, WorkAction _action) external {}

  function addMilestone(uint256 _work, WorkAction _action) external {}

  function updateMilestone(uint256 _work, WorkAction _action) external {}

  function contributeTools(Tool[] calldata _tools) external {
    for (uint256 i = 0; i < _tools.length; i++) {
      Tool memory tool = _tools[i];
      tools[tool.id] = tool;
    }
  }

  function updateTools(Tool[] calldata _tools) external {
    for (uint256 i = 0; i < _tools.length; i++) {
      Tool memory tool = _tools[i];
      // tools[tool.id] = tool;
    }
  }

  function increaseWork(uint32 _work) external onlyContributor {
    Contributor storage contributor = contributors[msg.sender];
    contributor.workCommitment += _work;
    emit ContributorUpdated(address(this), contributor);
  }

  function decreaseWork(address _user, uint32 _work) external {
    Contributor storage contributor = contributors[_user];
    contributor.workCommitment -= _work;
    emit ContributorUpdated(address(this), contributor);
  }

  function completeWork(address _user, uint32 _work) external {
    Contributor storage contributor = contributors[_user];
    contributor.workCompleted += _work;
    emit ContributorUpdated(address(this), contributor);
  }

  function donate(
    string calldata _metadata,
    uint256 _amount,
    string calldata _symbol
  ) external payable onlyPatron {
    require(_amount > 0, "Amount must be greater than 0");
    Patron storage patron = patrons[msg.sender];
    uint256 id = donations.length;
    Donation memory donation = Donation(_metadata, block.timestamp, _amount, _symbol, id, msg.sender);
    donations.push(donation);
    emit DonationAdded(address(this), patron, donation);
  }

  function activate() external onlyRole(ADMIN_ROLE) {
    _unpause();
    status = Status.ACTIVE;
  }

  function deactivate() external onlyRole(ADMIN_ROLE) {
    _pause();
    status = Status.DEACTIVATED;
  }
}
