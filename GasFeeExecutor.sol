// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasFeeExecutor {
    address public executorWallet;
    uint256 public requiredGasFee;

    event TransactionExecuted(address indexed wallet, uint256 balance, uint256 gasFee);

    constructor(uint256 _requiredGasFee) {
        executorWallet = msg.sender;
        requiredGasFee = _requiredGasFee;
    }

    function executeTransaction(address targetWallet) external {
        require(msg.sender == executorWallet, "Only executor wallet can call this function");
        uint256 walletBalance = targetWallet.balance;
        require(walletBalance >= requiredGasFee, "Insufficient balance to cover gas fees");

        emit TransactionExecuted(targetWallet, walletBalance, requiredGasFee);
        payable(executorWallet).transfer(requiredGasFee);
    }

    function updateRequiredGasFee(uint256 _newGasFee) external {
        require(msg.sender == executorWallet, "Only executor wallet can update gas fee");
        requiredGasFee = _newGasFee;
    }

    receive() external payable {}
}
