pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract VestingContract is Ownable, ReentrancyGuard {
    address payable public beneficiary;
    uint256 public interval;
    uint256 public payoutAmount;
    uint256 public startTime;
    uint256 public lastPayout;

    event Payout(address indexed beneficiary, uint256 amount);
    event Withdrawn(uint256 amount);

    constructor(
        address payable _beneficiary,
        uint256 _interval,
        uint256 _payoutAmount,
        uint256 _startTime
    ) {
        beneficiary = _beneficiary;
        interval = _interval;
        payoutAmount = _payoutAmount;
        startTime = _startTime;
        lastPayout = _startTime;
    }

    function setPayoutInterval(uint256 _interval) external onlyOwner {
        interval = _interval;
    }

    function setPayoutAmount(uint256 _payoutAmount) external onlyOwner {
        payoutAmount = _payoutAmount;
    }

    function setBeneficiary(address payable _beneficiary) external onlyOwner {
        beneficiary = _beneficiary;
    }

    function claim() external nonReentrant {
        require(block.timestamp >= startTime, "Vesting not started yet");
        require(block.timestamp >= lastPayout + interval, "Interval not reached");

        uint256 contractBalance = address(this).balance;
        require(contractBalance >= payoutAmount, "Not enough funds");

        lastPayout = block.timestamp;
        beneficiary.transfer(payoutAmount);
        emit Payout(beneficiary, payoutAmount);
    }

    function cancel() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner()).transfer(contractBalance);
        emit Withdrawn(contractBalance);
    }

    receive() external payable {}
}
