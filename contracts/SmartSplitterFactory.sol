// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./SmartSplitter.sol";

contract SmartSplitterFactory {
    SmartSplitter[] public smartSplitterArray;
    mapping(address => uint256) public addressToIndex;

    function createSmartSplitterContract(
        address[] memory _payGroup,
        uint256[] memory _payOutRatio
    ) public {
        SmartSplitter smartSplitter = new SmartSplitter(
            _payGroup,
            _payOutRatio
        );
        smartSplitterArray.push(smartSplitter);
        uint256 arrayIndex = smartSplitterArray.length - 1;
        addressToIndex[address(smartSplitter)] = arrayIndex;
    }

    function getAddressFromIndex(uint256 _storageIndex)
        public
        view
        returns (address)
    {
        return address(smartSplitterArray[_storageIndex]);
    }

    function getIndexFromAddress(address _address)
        public
        view
        returns (uint256)
    {
        return addressToIndex[_address];
    }

    function contractsStored() public view returns (uint256) {
        return smartSplitterArray.length;
    }

    function callGetContractAddress(uint256 _storageIndex)
        public
        view
        returns (address)
    {
        return
            SmartSplitter((smartSplitterArray[_storageIndex]))
                .getContractAddress();
    }

    function callGetBalance(uint256 _storageIndex)
        public
        view
        returns (uint256)
    {
        return SmartSplitter((smartSplitterArray[_storageIndex])).getBalance();
    }

    function callGetPayGroup(uint256 _storageIndex)
        public
        view
        returns (address[] memory)
    {
        return SmartSplitter((smartSplitterArray[_storageIndex])).getPayGroup();
    }

    function callGetPayRatio(uint256 _storageIndex)
        public
        view
        returns (uint256[] memory)
    {
        return SmartSplitter((smartSplitterArray[_storageIndex])).getPayRatio();
    }

    function callAdminReleaseAllPayments(uint256 _storageIndex) public {
        SmartSplitter((smartSplitterArray[_storageIndex]))
            .AdminReleaseAllPayments();
    }

    function callGetOwner(uint256 _storageIndex) public view returns (address) {
        return SmartSplitter((smartSplitterArray[_storageIndex])).getOwner();
    }

    function callReleaseOwedPayment(uint256 _storageIndex) public {
        SmartSplitter((smartSplitterArray[_storageIndex])).releaseOwedPayment();
    }
}
