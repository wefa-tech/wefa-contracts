// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts/interfaces/IERC1271.sol";
import "../node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/IUser.sol";

contract User is IUser, IERC1271, Initializable, AccessControlUpgradeable, PausableUpgradeable, ERC1155Holder {
  using ECDSA for bytes32;

  bytes4 internal constant MAGICVALUE = 0x1626ba7e;
  bytes4 internal constant INVALID_SIGNATURE = 0xffffffff;
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
  string public username;
  string public metadata;
  uint8 public reputation;
  uint256 private minimumSignatures = 3;
  mapping(bytes32 => uint256) private messageSignatures;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  function initialize(
    address _address,
    string calldata _username,
    string calldata _metadata
  ) public initializer {
    __Pausable_init();
    __AccessControl_init();
    _grantRole(DEFAULT_ADMIN_ROLE, _address);
    _grantRole(PAUSER_ROLE, msg.sender); // User factory contract
    username = _username;
    metadata = _metadata;
  }

  function pause() public onlyRole(PAUSER_ROLE) {
    _pause();
  }

  function unpause() public onlyRole(PAUSER_ROLE) {
    _unpause();
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC1155Receiver, AccessControlUpgradeable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }

  function sign(bytes32 _messageHash, bytes memory _signature) public whenNotPaused {
    address signer = _messageHash.recover(_signature);
    if (hasRole(DEFAULT_ADMIN_ROLE, signer)) {
      messageSignatures[_messageHash] += 1;
    }
  }

  function isValidSignature(bytes32 _hash, bytes calldata _signature)
    external
    view
    override
    whenNotPaused
    returns (bytes4)
  {
    address signer = _hash.recover(_signature);
    if (messageSignatures[_hash] >= minimumSignatures && hasRole(DEFAULT_ADMIN_ROLE, signer)) {
      return MAGICVALUE;
    } else {
      return INVALID_SIGNATURE;
    }
  }

  function updateUsername(string calldata _username) external whenNotPaused {
    username = _username;
    emit UsernameUpdated(msg.sender, _username);
  }

  function updateMetadata(string calldata _metadata) external whenNotPaused {
    metadata = _metadata;
    emit MetadataUpdated(msg.sender, _metadata);
  }

  function updateReputation(uint8 _reputation) external whenNotPaused {
    reputation = _reputation;
    emit ReputationUpdated(msg.sender, _reputation);
  }
}
