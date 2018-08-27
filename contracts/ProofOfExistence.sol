pragma solidity ^0.4.17;

contract ProofOfExistence {
    mapping(string => OwnershipTime) photoToOwnerMap;
    uint photoHashLength = 64;

    struct OwnershipTime {
        address owner;
        uint blockTime;
    }

    function addPhotoToMap(string photoHash) public returns (bool) {
        bytes memory byteStr = bytes(photoHash);
        require(byteStr.length == photoHashLength);

        if(photoToOwnerMap[photoHash].owner == 0 && photoToOwnerMap[photoHash].blockTime == 0){
            photoToOwnerMap[photoHash] = OwnershipTime(msg.sender, now);
        } else {
            return false;
        }

        return true;
    }

    function getPhotoTimestamp(string photoHash) public view returns(uint) {
        bytes memory byteStr = bytes(photoHash);
        require(byteStr.length == photoHashLength);

        if(photoToOwnerMap[photoHash].blockTime <= 0){
            return 0;
        } else {
            return photoToOwnerMap[photoHash].blockTime;
        }
    }
}