//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Wefa Project interface.
/// @dev Interface of a Wefa Project  contract.
interface IProject {
  // CORE
  enum Status {
    ACTIVE,
    INACTIVE
  }

  /// @dev Elements WEFA is based on and derived from the categories picked
  enum Element {
    WATER,
    EARTH,
    FIRE,
    AIR
  }

  enum Action {
    TREE_PLANTING,
    GARDEN_PLANTING,
    LITER_CLEANUP,
    VEGETATION_CLEANUP,
    NATURAL_COMPOSTING
  }

  struct Core {
    Element[4] elements;
    Action[] actions;
    // Goal[5] goals;
    // Category[20] categories;
  }

  // INFO
  struct Details {
    string name;
    string mission;
    string metadata; // Ceramic or IPFS CID holds description,  images, tags, resources
  }

  struct Settings {
    uint8 privacy;
  }

  struct Location {
    uint256 addrs;
    uint256 street;
    uint256 city;
    uint256 state;
    uint256 country;
    uint256 planet;
  }

  // COMMUNITY
  enum MemberRole {
    TEAMMATE,
    CONTRIBUTOR,
    PATRON
  }

  enum MemberStatus {
    ACTIVE,
    INACTIVE
  }

  struct Teammate {
    MemberStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    uint32 featuresAdded;
    bool leader;
  }

  struct Contributor {
    MemberStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    uint256 verifiedAt; // Updated each time a person gets verified
    uint256 verifyCycle;
    uint32[] toolsProvided;
    uint32 workCommitment;
    uint32 workCompleted;
    address[] verifiers;
  }

  struct Patron {
    MemberStatus status;
    address[] verifiers;
    uint256[] donations;
    uint256 verifyCycle;
    uint8 reputation;
  }

  // SPACE
  enum FeatureStatus {
    ACTIVE,
    INACTIVE
  }

  enum MilestoneStatus {
    ACTIVE,
    INACTIVE
  }

  enum DonationStatus {
    ACTIVE,
    INACTIVE
  }

  enum ToolStatus {
    ACTIVE,
    INACTIVE
  }

  enum DeviceStatus {
    ACTIVE,
    INACTIVE
  }

  struct Feature {
    FeatureStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    uint256 completedAt;
    address creator; // Team member
    address[] caretakers;
  }

  struct Milestone {
    MilestoneStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    uint256 completedAt;
    address creator; // Team member
    address[] verifiers; // Users & Communitties
  }

  struct Donation {
    DonationStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    uint256 amount;
    uint256 tokenid; // ID of token stored in project contraact
    address donor;
  }

  struct Tool {
    ToolStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    uint256 dueAt;
    uint256 returnedAt;
    address user;
    address provider;
  }

  struct Device {
    DeviceStatus status;
    string metadata; // Ceramic/IPFS CID Url
    uint256 createdAt;
    uint256 updatedAt;
    address provider;
  }

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedCore(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedDetails(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedSettings(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedLocation(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is created.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event AddedMember(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is deleted.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event RemovedMember(uint256 projectId, string name, uint256 dna);

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateCore(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateDetails(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateSettings(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateLocation(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function addMember(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function removeMember(uint256 _name, uint256 _dna) external;

  /// @dev External function allowing team members to update a project
  function deactivate() external;
}
