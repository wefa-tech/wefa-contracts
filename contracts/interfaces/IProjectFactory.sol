//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Wefa Project Factory interface.
/// @dev Interface of a Wefa Project Factory contract.
interface IProjectFactory {
  enum FactoryStatus {
    ACTIVE,
    INACTIVE
  }

  enum ProjectStatus {
    DRAFT,
    PROPOSAL,
    READY,
    ACTIVE,
    INACTIVE,
    COMPLETED
  }

  /// @dev Emitted when a Project is created.
  /// @param user: Address of the user.
  /// @param project: Address of the project.
  /// @param name: Name of the porject set when created and can be updated.
  /// @param mission: The stated mission of the project set when created.
  /// @param status: Status of project.
  /// @param metadata: CID url for metadata for projects stored in IPFS.
  event CreatedProject(
    address user,
    address project,
    string name,
    string mission,
    ProjectStatus status,
    string metadata
  );

  /// @dev Emitted when a Project is deleted.
  /// @param user: Address of the user.
  /// @param project: Address of the project.
  /// @param name: Name of the porject set when created and can be updated.
  event DeactivatedProject(address user, address project, string name);

  /// @dev External function to create a project.
  /// @param _status: Status of project.
  /// @param _name: Name of the porject set when created and can be updated.
  /// @param _mission: The stated mission of the project set when created.
  /// @param _metadata: CID url for metadata for projects stored in IPFS.
  function createProject(
    ProjectStatus _status,
    string memory _name,
    string memory _mission,
    string memory _metadata
  ) external;

  /// @dev External function allowing team members to update a project
  /// @param _address: Address of project
  function deactivateProject(address _address) external;
}
