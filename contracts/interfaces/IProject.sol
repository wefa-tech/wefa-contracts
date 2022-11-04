//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Wefa Project interface.
/// @dev Interface of a Wefa Project  contract.
interface IProject {
  // CORE - ENUMS & STRUCTS
  enum Status {
    ACTIVE,
    INACTIVE
  }

  // Elements WEFA is based on and derived from the categories picked
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
    Action[5] actions;
    mapping(Element => bool) elementExists;
    mapping(Action => bool) actionExists;
    // Goal[5] goals;
    // Category[20] categories;
  }

  // INFO - ENUMS & STRUCTS
  enum Planet {
    EARTH
  }

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
    string street;
    string city;
    string state;
    string country;
    Planet planet;
  }

  // COMMUNITY - ENUMS & STRUCTS
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
    uint256 createdAt;
    uint256 updatedAt;
    uint32 featuresAdded;
    bool leader;
  }

  struct Contributor {
    MemberStatus status;
    uint256 createdAt;
    uint256 updatedAt;
    uint256 verifiedAt; // Updated each time a person gets verified
    uint256 verifyCycle;
    uint32 workCommitment;
    uint32 workCompleted;
    uint32[] toolsProvided;
    address[] verifiers;
  }

  struct Patron {
    MemberStatus status;
    uint256 createdAt;
    uint256 updatedAt;
    uint256 verifiedAt; // Updated each time a person gets verified
    uint256 verifyCycle;
    uint256[] donations;
    address[] verifiers;
  }

  // SPACE - ENUMS & STRUCTS
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

  enum WorkAction {
    INCREASE,
    DECREASE
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

  // CORE - EVENTS
  /// @dev Emitted when a Project elements are updated.
  /// @param elements: WEFA elements
  /// @param actions: Actions the project is taking.
  event UpdatedCore(Element[4] elements, Action[5] actions);

  // INFO - EVENTS
  /// @dev Emitted when a Project details are updated.
  /// @param project: Address of the project.
  /// @param name: Semaphore signal.
  /// @param mission: Semaphore signal.
  /// @param metadata: Semaphore signal.
  event UpdatedDetails(address project, string name, string mission, string metadata);

  /// @dev Emitted when a Project settings are updated.
  /// @param project: Address of the project.
  event UpdatedSettings(address project);

  /// @dev Emitted when a Project location is updated.
  /// @param project: Address of the project.
  /// @param location: Semaphore signal.
  event UpdatedLocation(address project, Location location);

  // COMMUUNITY - EVENTS
  /// @dev Emitted when a member is added to the project.
  /// @param project: Address of the project.
  /// @param user: Address of the user.
  /// @param role: Role of the member.
  event MemberAdded(address project, address user, MemberRole role);

  /// @dev Emitted when a team member is updated.
  /// @param project: Address of the project.
  /// @param member: Details of team member.
  event TeammateUpdated(address project, Teammate member);

  /// @dev Emitted when a contributor is updated.
  /// @param project: Address of the project.
  /// @param contributor: Details of contributor.
  event ContributorUpdated(address project, Contributor contributor);

  /// @dev Emitted when a patron is updated.
  /// @param project: Address of the project.
  /// @param patron: Details of patron.
  event PatronUpdated(address project, Patron patron);

  /// @dev Emitted when a member is removed from the project.
  /// @param project: Address of the project.
  /// @param user: Address of the user.
  /// @param role: Role of the member.
  event MemberRemoved(address project, address user, MemberRole role);

  // SPACE - EVENTS
  /// @dev Emitted when a milestone is added to the project.
  /// @param project: Address of the project.
  /// @param name: Name of milestone.
  /// @param id: Id of the milestone added.
  /// @param metadata: extra data stored in IPFS via ceramic.
  event MilestoneAdded(address project, string name, uint256 id, string metadata);

  /// @dev Emitted when a milestone is added to the project.
  /// @param project: Address of the project.
  /// @param milestone: Milestone details.
  event MilestoneUpdated(address project, Milestone milestone);

  /// @dev Emitted when a donation is added to the project.
  /// @param project: Address of the project.
  /// @param name: Name of donation.
  /// @param id: ID of donation added.
  /// @param metadata: extra data stored in IPFS via ceramic.
  event DonationAdded(address project, string name, uint256 id, string metadata);

  /// @dev Emitted when a milestone is added to the project.
  /// @param project: Address of the project.
  /// @param donation: Donation details.
  event DonationUpdated(address project, Donation donation);

  /// @dev Emitted when a feature is added to the project.
  /// @param project: Address of the project.
  /// @param name: Name of feature
  /// @param id: ID of feature added.
  /// @param metadata: extra data stored in IPFS via ceramic.
  event FeatureAdded(address project, string name, uint256 id, string metadata);

  /// @dev Emitted when a milestone is added to the project.
  /// @param project: Address of the project.
  /// @param feature: Feature details.
  event FeatureUpdated(address project, Feature feature);

  /// @dev Emitted when a tool is added to the project.
  /// @param project: address of the project.
  /// @param name: Name of tool.
  /// @param id: ID of tool added.
  /// @param metadata: extra data stored in IPFS via ceramic.
  event ToolAdded(address project, string name, uint256 id, string metadata);

  /// @dev Emitted when a milestone is added to the project.
  /// @param project: Address of the project.
  /// @param tool: Tool details.
  event ToolUpdated(address project, Tool tool);

  // CORE - FUNCTIONS
  /// @dev Function to update the project core elements and actions.
  /// @param _elements: root of tree
  /// @param _actions: Nullifier hash.
  function updateCore(Element[] calldata _elements, Action[] calldata _actions) external;

  // INFO - FUNCTIONS
  /// @dev Function to update the project details.
  /// @param _name: root of tree
  /// @param _mission: Nullifier hash.
  /// @param _metadata: Nullifier hash.
  function updateDetails(
    string calldata _name,
    string calldata _mission,
    string calldata _metadata
  ) external;

  /// @dev Function to update the project settings.
  /// @param _settings: settings for projects
  function updateSettings(Settings calldata _settings) external;

  /// @dev Function to update the project location.
  /// @param _location: root of tree
  function updateLocation(Location calldata _location) external;

  // COMMUNITY - FUNCTIONS
  /// @dev Allow a member with the proper privlege to add members
  /// @param _user: Address of user being added as member.
  /// @param _role: Role of member when added to project
  /// @param _status: Status of member when added to project
  function addMember(
    address _user,
    MemberRole _role,
    MemberStatus _status
  ) external;

  /// @dev Allow a member with the proper privlege to update teammate.
  /// @param _user: Address of user being added as member.
  /// @param _status: Status of member when added to project
  /// @param _leader: Assign the leader position to a team member
  function updateTeammate(
    address _user,
    MemberStatus _status,
    bool _leader
  ) external;

  /// @dev Allow a member with the proper privlege to update contributor.
  /// @param _user: Address of user being added as member.
  /// @param _status: Status of member when added to project
  /// @param _verifyCycle: Status of member when added to project
  /// @param _verifiers: Status of member when added to project
  function updateContributor(
    address _user,
    MemberStatus _status,
    uint256 _verifyCycle,
    uint256 _verifiers
  ) external;

  /// @dev Allow a member with the proper privlege to update patron.
  /// @param _user: Address of user being added as member.
  /// @param _status: Status of member when added to project.
  /// @param _verifyCycle: Status of member when added to project
  /// @param _verifiers: Status of member when added to project
  function updatePatron(
    address _user,
    MemberStatus _status,
    uint256 _verifyCycle,
    uint256 _verifiers
  ) external;

  /// @dev Function to remove a member from the project.
  /// @param _user: Address of user being added as member.
  /// @param _role: Role of member when added to project
  function removeMember(address _user, MemberRole _role) external;

  // SPACE - FUNCTIONS
  /// @dev Function to add a feature to the project.
  /// @param _work: root of tree
  /// @param _action: root of tree
  function addFeature(uint256 _work, WorkAction _action) external;

  /// @dev Function to update a feature to the project.
  /// @param _work: root of tree
  /// @param _action: root of tree
  function updateFeature(uint256 _work, WorkAction _action) external;

  /// @dev Function 
  /// @param _work: root of tree
  /// @param _action: root of tree
  function addMilestone(uint256 _work, WorkAction _action) external;

  /// @dev Function
  /// @param _work: root of tree
  /// @param _action: root of tree
  function updateMilestone(uint256 _work, WorkAction _action) external;

  /// @dev Function
  /// @param _tools: root of tree
  function contributeTools(Tool[] calldata _tools) external;

  /// @dev Function
  /// @param _tools: root of tree
  function updateTools(Tool[] calldata _tools) external;

  /// @dev Function to contribute work to the project.
  /// @param _work: root of tree
  /// @param _action: root of tree
  function contributeWork(uint256 _work, WorkAction _action) external;

  /// @dev Function to complete work by a contributor.
  /// @param _work: root of tree
  function completeWork(uint256 _work) external;

  /// @dev Function to add a donation to the project.
  /// @param _donation: root of tree
  function donate(Donation calldata _donation) external;

  /// @dev External function allowing team members to update a project
  function deactivate() external;
}
