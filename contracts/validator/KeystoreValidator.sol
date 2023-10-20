// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./BaseValidator.sol";

contract KeystoreValidator is BaseValidator {
    using ECDSA for bytes32;
    using TypeConversion for address;

    /**
     * @dev pack hash message with `signatureData.validationData`
     */

    function _packSignatureHash(bytes32 hash, uint8 signatureType, uint256 validationData)
        internal
        pure
        override
        returns (bytes32 packedHash)
    {
        if (signatureType == 0x0) {
            packedHash = hash;
        } else if (signatureType == 0x1) {
            packedHash = keccak256(abi.encodePacked(hash, validationData));
        } else if (signatureType == 0x2) {
            // passkey sign doesn't need toEthSignedMessageHash
            packedHash = hash;
        } else if (signatureType == 0x3) {
            // passkey sign doesn't need toEthSignedMessageHash
            packedHash = keccak256(abi.encodePacked(hash, validationData));
        } else {
            revert Errors.INVALID_SIGNTYPE();
        }
    }

    function _pack1271SignatureHash(bytes32 hash, uint8 signatureType, uint256 validationData)
        internal
        pure
        virtual
        override
        returns (bytes32)
    {
        revert("KeystoreValidator doesn't support 1271");
    }
}
