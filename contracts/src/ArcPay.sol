// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ArcPay
/// @notice Forwards native USDC on Arc to a merchant and emits a receipt the merchant UI can watch.
/// @dev On Arc, native value IS USDC (18 decimals). No balances are held by this contract.
contract ArcPay {
    event Paid(address indexed payer, address indexed merchant, uint256 amount, string memo);

    error ZeroAmount();
    error ZeroMerchant();
    error TransferFailed();

    function pay(address merchant, string calldata memo) external payable {
        if (msg.value == 0) revert ZeroAmount();
        if (merchant == address(0)) revert ZeroMerchant();

        (bool ok,) = merchant.call{value: msg.value}("");
        if (!ok) revert TransferFailed();

        emit Paid(msg.sender, merchant, msg.value, memo);
    }
}
