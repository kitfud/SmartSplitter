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

    modifier onlyOwner(address client) {
        require(client == owner, "Sender not authorized. Not owner");
        _;
    }

    modifier onlyPayee(address payee) {
        require(checkIfInPayGroup(payee) == true, "Sender not payee");
        _;
    }

    function getContractAddress() public view returns (address) {
        return address(SmartSplitter(this));
    }

    function checkIfInPayGroup(address _sender) internal view returns (bool) {
        for (uint256 i = 0; i < payGroup.length; i++) {
            if (payGroup[i] == _sender) {
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
    function AdminReleaseAllPayments(address _sender)
        public
        onlyOwner(_sender)
    {
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

    function releaseOwedPayment(address _payee) public onlyPayee(_payee) {
        uint256 index;
        for (uint256 i = 0; i < payGroup.length; i++) {
            if (payGroup[i] == _payee) {
                index = i;
            }
        }
        SmartSplitter(payable(address(this))).release(payable(payGroup[index]));
    }
}
