//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Wefa User Factory interface.
/// @dev Interface of a Wefa User Factory contract.
interface IUserFactory {
  enum FactoryStatus {
    ACTIVE,
    INACTIVE
  }

  enum UserStatus {
    ACTIVE,
    INACTIVE,
    DEACTIVATED
  }

  /// @dev Emitted when a User is created.
  /// @param addrs: Address of the user.
  /// @param username: Username of the user.
  /// @param metadata: CID url for metadata for users stored in IPFS.
  event UserCreated(address addrs, string username, string metadata);

  /// @dev Emitted when a User is deactivated.
  /// @param addrs: Address of the user.
  /// @param username: Username of the user.
  /// @param metadata: CID url for metadata for users stored in IPFS.
  event UserActivated(address addrs, string username, string metadata);

  /// @dev Emitted when a User is deactivated.
  /// @param addrs: Address of the user.
  /// @param username: Username of the user.
  /// @param metadata: CID url for metadata for users stored in IPFS.
  event UserDeactivated(address addrs, string username, string metadata);

  /// @dev External function to create a user.
  /// @param _username: Name of the porject set when created and can be updated.
  /// @param _metadata: CID url for metadata for users stored in IPFS.
  function createUser(string memory _username, string memory _metadata) external;

  /// @dev External function allowing team members to activate a user.
  /// @param _address: Address of user
  function activateUser(address _address) external;

  /// @dev External function allowing team members to deactivate a user.
  /// @param _address: Address of user
  function deactivateUser(address _address) external;
}
