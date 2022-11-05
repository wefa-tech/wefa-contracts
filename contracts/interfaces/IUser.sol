//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Wefa Project interface.
/// @dev Interface of a Wefa Project  contract.
interface IUser {
  enum UserStatus {
    ACTIVE,
    DEACTIVATED
  }

  event UsernameUpdated(address indexed user, string username);
  event MetadataUpdated(address indexed user, string metadata);
  event ReputationUpdated(address indexed user, uint8 reputation);

  function updateUsername(string calldata _username) external;

  function updateMetadata(string calldata _metadata) external;

  function updateReputation(uint8 _reputation) external;
}
