// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract SmartSplitter is PaymentSplitter {
    address[] internal payGroup;
    uint256[] internal payOutRatio;
    address payable public owner;

    constructor(
        address _owner,
        address[] memory _payGroup,
        uint256[] memory _payOutRatio
    ) payable PaymentSplitter(_payGroup, _payOutRatio) {
        owner = payable(_owner);
        payGroup = _payGroup;
        payOutRatio = _payOutRatio;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyPayee() {
        require(checkIfInPayGroup() == true);
        _;
    }

    function getContractAddress() public view returns (address) {
        return address(SmartSplitter(this));
    }

    function checkIfInPayGroup() internal view returns (bool) {
        for (uint256 i = 0; i < payGroup.length; i++) {
            if (payGroup[i] == msg.sender) {
                return true;
            }
        }
        return false;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Function to deposit Ether into this contract.
    function deposit() public payable {}

    function getPayGroup() public view returns (address[] memory) {
        return payGroup;
    }

    function getPayRatio() public view returns (uint256[] memory) {
        return payOutRatio;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    //contract owner can release payments to payment group as specified
    function AdminReleaseAllPayments() public onlyOwner {
        for (uint256 i = 0; i < payGroup.length; i++) {
            try
                SmartSplitter(payable(address(this))).release(
                    payable(payGroup[i])
                )
            {} catch {
                continue;
            }
        }
    }

    function releaseOwedPayment() public onlyPayee {
        uint256 index;
        for (uint256 i = 0; i < payGroup.length; i++) {
            if (payGroup[i] == msg.sender) {
                index = i;
            }
        }
        SmartSplitter(payable(address(this))).release(payable(payGroup[index]));
    }
}
