// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        // The new keyworkd generated a new contract on blockchain
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint _simpleStorageNumber) public {
        SimpleStorage simpleStorage = SimpleStorage(
            simpleStorageArray[_simpleStorageIndex]
        );

        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint) {
        SimpleStorage simpleStorage = SimpleStorage(
            simpleStorageArray[_simpleStorageIndex]
        );
        
        return simpleStorage.retrieve();
    }
}
