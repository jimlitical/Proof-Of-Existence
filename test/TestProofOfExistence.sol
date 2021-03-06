pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProofOfExistence.sol";

// Testing ProofOfExistence.sol
// Mainly tests the different ways addPhotoToMap() and getPhotoTimestamp() can be used
contract TestProofOfExistence {
    ProofOfExistence existenceContract = ProofOfExistence(DeployedAddresses.ProofOfExistence());

    // Tests addPhotoToMap will succeed when adding the SHA256 hash of 'test'
    function testValidHashAddPhotoToMap() public {
        bool success = existenceContract.addPhotoToMap("9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08"); // SHA256 hash of 'test' but this would be handled client-side for the images

        bool expected = true;

        Assert.equal(success, expected, "SHA256 hash of 'test' has been added to the map");
    }

    // Tests adding the same hash to the photoToOwnerMap does not succeed
    function testSameHashAddPhotoToMap() public {
        bool failure = existenceContract.addPhotoToMap("9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08"); // Add hash from previous test function

        bool expected = false;

        Assert.equal(failure, expected, "SHA256 hash of 'test' has already been added to the map");
    }

    // Tests photoToOwnerMap can store multiple hashs
    function testMultipleHashesAddPhotoToMap() public {
        bool firstInsert = existenceContract.addPhotoToMap("03AC674216F3E15C761EE1A5E255F067953623C8B388B4459E13F978D7C846F4"); // new hash to insert
        bool secondInsert = existenceContract.addPhotoToMap("5994471ABB01112AFCC18159F6CC74B4F511B99806DA59B3CAF5A9C173CACFC5"); // another new hash to insert

        bool expected = true;

        Assert.equal(firstInsert, expected, "The first insert was successful");
        Assert.equal(secondInsert, expected, "The second insert was successful");
    }

    // Tests getPhotoTimestamp using the hash of 'test'
    function testGetValidPhotoTimestamp() public {
        uint photoBlockTime = existenceContract.getPhotoTimestamp("9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08");

        bool timeGreaterThanZero = (photoBlockTime != 0);

        bool expected = true;

        Assert.equal(timeGreaterThanZero, expected, "Block time returned was not 0.");
    }

    // Tests getPhotoTimestamp using an hash not yet stored but valid length
    function testGetInvalidPhotoTimestamp() public {
        uint invalidPhotoHash = existenceContract.getPhotoTimestamp("12345678984C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08");

        bool notZeroReturned = true;
        if(invalidPhotoHash == 0){
            notZeroReturned = false;
        }

        bool expected = false;

        Assert.equal(notZeroReturned, expected, "Hash was not valid so false was returned");
    }

}