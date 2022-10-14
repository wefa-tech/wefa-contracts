//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Wefa Project interface.
/// @dev Interface of a Wefa Project  contract.
interface IProject {
  /// @dev Elements WEFA is based on and derived from the categories picked
  enum Element {
    WATER,
    EARTH,
    FIRE,
    AIR
  }

  enum Goal {
    RESTORATION,
    CONSERVATION,
    PRESERVATION,
    CULTIVATION,
    ENERGY_REDUCTION,
    RECYCLING
  }

  enum Category {
    GROUND_BIOMASS_CARBON_SEQUESTRATION,
    EXTENDED_GROWING_SEASON,
    ANIMAL_BIODIVERSITY,
    ANIMAL_WELFARE,
    DROUGHT_RESILIENCE,
    ECOSYSTEM_HEALTH,
    FIRE_RESILIENCE,
    GROUND_COVER,
    PEST_RESILIENCE,
    PLANT_BIODIVERSITY,
    VEGETATION_TRANSITION,
    SOIL_HEALTH,
    WATER_FILTRATION,
    INDIGENOUS_RIGHTS,
    REDUCED_CHEMICAL_RUNOFF,
    REDUCED_FLOODING,
    REDUCED_SOIL_EROSION,
    SOCIAL_COBENEFITS,
    SOIL_ORRGANIC_CARBON_SEQUESTRATION
  }

  enum Action {
    TREE_PLANTING,
    GARDEN_PLANTING,
    LITER_CLEANUP,
    VEGETATION_CLEANUP,
    NATURAL_COMPOSTING
  }

  enum UserStatus {
    ACTIVE,
    INACTIVE
  }

  enum Status {
    ACTIVE,
    INACTIVE
  }

  enum ComponentStatus {
    ACTIVE,
    INACTIVE
  }

  struct Location {
    uint256 addrs;
    uint256 street;
    uint256 city;
    uint256 state;
    uint256 country;
    uint256 planet;
  }

  struct Device {
    uint32 completed;
    Status status;
    string metadata;
    address[] verifiers;
  }

  struct Component {
    bool completed;
    ComponentStatus status;
    string metadata; // Ceramic/IPFS CID Url
    address[] verifiers;
  }

  struct Teammate {
    address[] verifiers;
    uint256 verifyCycle;
    Status status;
    uint8 quality;
  }

  struct Patron {
    address[] verifiers;
    uint256 verifyCycle;
    Status status;
    uint8 reputation;
  }

  struct Contributor {
    uint32 commitment;
    uint32 completed;
    uint8 quality;
    Status status;
    uint256 verifyCycle;
    address[] verifiers;
  }

  struct Donation {
    uint32 completed;
    Status status;
    string metadata; // Ceramic/IPFS CID Url
    address[] verifiers;
  }

  struct Tool {
    uint32 completed;
    Status status;
    string metadata; // Ceramic/IPFS CID Url
    address[] verifiers;
  }

  struct Milestone {
    uint32 completed;
    Status status;
    string metadata; // Ceramic/IPFS CID Url
    address[] verifiers;
    uint256 verifyCycle;
  }

  struct Core {
    Element[4] elements;
    Goal[5] goals;
    Category[20] categories;
  }

  struct Settings {
    uint8 privacy;
  }

  struct Details {
    string name;
    string mission;
    string metadata; // Ceramic or IPFS CID holds description,  images, tags, resources
  }

  /// @dev Emitted when a Project is created.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event AddedTeammate(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is deleted.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event RemovedTeammate(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is created.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event AddedContributor(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is deleted.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event RemovedContributor(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is created.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event AddedPatron(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is deleted.
  /// @param projectId: Semaphore signal.
  /// @param name: Semaphore signal.
  /// @param dna: Semaphore signal.
  event RemovedPatron(uint256 projectId, string name, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedProjectCore(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedProjectRules(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedProjectInfo(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedProjectSpace(uint256 projectId, string action, uint256 dna);

  /// @dev Emitted when a Project is updated.
  /// @param projectId: Semaphore signal.
  /// @param action: Semaphore signal.
  /// @param dna: Semaphore signal.
  event UpdatedProjectCommunity(uint256 projectId, string action, uint256 dna);

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function addTeammate(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function removeTeammate(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function addContributor(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function removeContributor(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function addPatron(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function removePatron(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateProjectRules(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateProjectCore(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateProjectInfo(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateProjectSpace(uint256 _name, uint256 _dna) external;

  /// @dev Saves the nullifier hash to avoid double signaling and exit an event
  /// if the zero-knowledge proof is valid.
  /// @param _name: root of tree
  /// @param _dna: Nullifier hash.
  function updateProjectCommunity(uint256 _name, uint256 _dna) external;
}
