// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./interfaces/IUserFactory.sol";
import "./interfaces/IUser.sol";

contract UserFactory is IUserFactory, Initializable, PausableUpgradeable, AccessControlUpgradeable {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  uint256 public version;
  uint256 public userCount;
  FactoryStatus public status;

  mapping(address => UserDetails) public users;

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

  function submitUserProposal(
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external {
    // users.push(User(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    // emit UpdatedUser(id, _name, _dna);
  }

  function createUser(
    UserStatus _status,
    string memory _name,
    string memory _mission,
    string memory _metadata
  ) external {
    // users.push(UserInfo(_name, _mission, _status));

    // userToOwner[msg.sender] = msg.sender;
    // emit CreatedUser(msg.sender, _name, _mission, _status, _metadata);
  }

  function updateUser(
    address _user,
    uint8 _status,
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external {
    // users.push(User(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    // emit UpdatedUser(id, _name, _dna);
  }

  function deactivateUser(address _address) external {
    // users.push(User(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    // emit DeletedUser(id, _name, _dna);
  }
}
