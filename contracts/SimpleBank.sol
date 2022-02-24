// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract SimpleBank {
    uint totalBankBalance = 100;

    struct deposit{
        uint depositTimestamp;
        uint amount;
    }

    mapping(address => deposit[]) accountBalance;

    function getBankBalance() public view returns (uint) {
        return totalBankBalance;
    }

    function addMoneyToBankBalance() external payable {
        totalBankBalance += msg.value;
    }

    function addMoneyToBankAccount() external payable {
        require(msg.value>0,"Deposit amount should be grater than 0");
        accountBalance[msg.sender].push(deposit(block.timestamp, msg.value));
        totalBankBalance += msg.value;
    }

    function withdrawAllMoneyFromBankAccount() external {
        uint amountToTransfer = getBankAccountBalance(msg.sender);
        address payable withdrawTo = payable(msg.sender);
        withdrawTo.transfer(amountToTransfer);

        //Clearing Bank and account balances
        for(uint i=0; i<accountBalance[msg.sender].length; i++){
            delete accountBalance[msg.sender][i];
        }
        totalBankBalance -= amountToTransfer;
    }

    function getBankAccountTransactionCount() external view returns (uint) {
        return accountBalance[msg.sender].length;
    }

    function getBankAccountBalance(address _account) public view returns(uint) {
        uint balance = 0;
        for(uint i = 0; i < accountBalance[_account].length; i++) {
            uint calculatedInterests = calculateInterests(accountBalance[_account][i]);
            balance =  balance + accountBalance[_account][i].amount + calculatedInterests; 
        }

        return balance;
    }

    function calculateInterests(deposit memory dep) internal view returns(uint) {
        uint timeElapsed = block.timestamp - dep.depositTimestamp; //time in seconds
        // uint calculatedInterests = dep.amount * (7 / 100) * (timeElapsed / (365*24*60*60));
        if(dep.amount>0) {
            return uint(dep.amount *  (timeElapsed * 7 / (365*24*60*60*100))) + 1; // +1 is added to check if it works properly
        } else {
            return 0; // It can happen if deposit was withdrawn
        }
    }
}