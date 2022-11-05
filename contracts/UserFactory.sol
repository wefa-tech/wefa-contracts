// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./interfaces/IUserFactory.sol";
import "./User.sol";

contract UserFactory is IUserFactory, Initializable, PausableUpgradeable, AccessControlUpgradeable {
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
  uint256 public version;
  FactoryStatus public status;
  address[] public users;

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

  function createUser(string memory _username, string memory _metadata) external whenNotPaused {
    User user = new User();
    user.initialize(msg.sender, _username, _metadata);
    users.push(address(user));
    emit UserCreated(address(user), _username, _metadata);
  }

  function activateUser(address _address) external onlyRole(PAUSER_ROLE) {
    User user = User(_address);
    user.unpause();
    emit UserActivated(_address, user.username(), user.metadata());
  }

  function deactivateUser(address _address) external onlyRole(PAUSER_ROLE) {
    User user = User(_address);
    user.pause();
    emit UserDeactivated(_address, user.username(), user.metadata());
  }
}
