// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";

import "./interfaces/IProject.sol";

contract Project is IProject, Initializable, ERC1155Upgradeable, ERC1155SupplyUpgradeable, AccessControlUpgradeable {
  bytes32 public constant TEAM_LEADER_ROLE = keccak256("TEAM_LEADER_ROLE");
  bytes32 public constant TEAM_MEMBER_ROLE = keccak256("TEAM_MEMBER_ROLE");
  bytes32 public constant CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR_ROLE");
  bytes32 public constant PATRON_ROLE = keccak256("PATRON_ROLE");

  // CORE
  Status public status;
  Core private core;

  // INFO
  Details public details;
  Settings private settings;
  Location private location;

  // COMMUNITY
  mapping(address => Teammate) private team;
  mapping(address => Contributor) private contributors;
  mapping(address => Patron) private patrons;

  // SPACE
  // This data is kept consistent by using ZKPs to create the CID urls
  // Ensuring they can be veirifed by the contract when updated
  Feature[] private features;
  Milestone[] private milestones; // Upon completion the rewards are distrbuted to members of the project.
  Donation[] private donations;
  Tool[] private tools;

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

  function setURI(string memory newuri) public onlyRole(TEAM_MEMBER_ROLE) {
    _setURI(newuri);
  }

  // The following functions are overrides required by Solidity.

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

  function updateCore(uint256 _name, uint256 _dna) external {}

  function updateDetails(uint256 _name, uint256 _dna) external {}

  function updateSettings(uint256 _name, uint256 _dna) external {}

  function updateLocation(uint256 _name, uint256 _dna) external {}

  function addMember(uint256 _name, uint256 _dna) external {}

  function removeMember(uint256 _name, uint256 _dna) external {}

  function deactivate() external {}
}
