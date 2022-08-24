// SPDX-License-Identifier: MIT

// Get fund from users
// Withdraw funds
// Set a minimum funding value in USD

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 1 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // want to be able to set a minimum fund amount in USD
        // 1. How we do send ETH to this contract?
        // msg.value.getConversionRate() the value we call gona be the first parameter of the library function
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!"); // 1e15 == 1 * 10 * 15
        // What is reverting?
        // Undo any action before, and send remaining gas back
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // Modifier is like a decorator called before the rest of the code
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender == i_owner) {
            revert NotOwner();
        }
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund method?

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
