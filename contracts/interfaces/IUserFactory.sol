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
    DRAFT,
    PROPOSAL,
    READY,
    ACTIVE,
    INACTIVE,
    COMPLETED
  }

  struct UserDetails {
    address owner;
    UserStatus status;
    string name;
    string mission;
    string metadata;
  }

  /// @dev Emitted when a User is created.
  /// @param user: Address of the user.
  /// @param user: Address of the user.
  /// @param name: Name of the porject set when created and can be updated.
  /// @param mission: The stated mission of the user set when created.
  /// @param status: Status of user.
  /// @param metadata: CID url for metadata for users stored in IPFS.
  event CreatedUser(
    address user,
    string name,
    string mission,
    UserStatus status,
    string metadata
  );

  /// @dev Emitted when a User is updated.
  /// @param user: Address of the user.
  /// @param user: Address of the user.
  /// @param name: Name of the porject set when created and can be updated.
  /// @param mission: The stated mission of the user set when created.
  /// @param status: Status of user.
  /// @param metadata: CID url for metadata for users stored in IPFS.
  event UpdatedUser(
    address user,
    string name,
    string mission,
    UserStatus status,
    string metadata
  );

  /// @dev Emitted when a User is deleted.
  /// @param user: Address of the user.
  /// @param user: Address of the user.
  /// @param name: Name of the porject set when created and can be updated.
  event DeactivatedUser(address user, string name);

  /// @dev External function to create a user.
  /// @param _status: Status of user.
  /// @param _name: Name of the porject set when created and can be updated.
  /// @param _mission: The stated mission of the user set when created.
  /// @param _metadata: CID url for metadata for users stored in IPFS.
  function createUser(
    UserStatus _status,
    string memory _name,
    string memory _mission,
    string memory _metadata
  ) external;

  /// @dev External function allowing team members to update a user
  /// @param _user: Address of the user.
  /// @param _status: Status of user.
  /// @param _name: Name of the porject set when created and can be updated.
  /// @param _mission: The stated mission of the user set when created.
  /// @param _metadata: CID url for metadata for users stored in IPFS.
  function updateUser(
    address _user,
    uint8 _status,
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external;

  /// @dev External function allowing team members to update a user
  /// @param _address: Address of user
  function deactivateUser(address _address) external;
}
