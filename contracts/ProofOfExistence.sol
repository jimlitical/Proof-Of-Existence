pragma solidity ^0.4.17;

/** @title ProofOfExistence spin-off */
contract ProofOfExistence {
    mapping(string => OwnershipTime) photoToOwnerMap; // Stores hash to struct that contains the photo's owner address / upload time
    uint private photoHashLength = 64; // SHA256 hash length

    // Stores the owner and blockTime
    struct OwnershipTime {
        address owner; // Used to prevent another address from using the same picture
        uint blockTime; // Used to show the date an image was uploaded
    }

    /** @dev Adds a photo's SHA256 hash to a map
      * @param photoHash  SHA256 hash of the photo that will be the key to OwnershipTime which is set in the method
      * @return bool based on success or failure of photoHash insertion
      */
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

    /** @dev Uses the photo's SHA256 hash to retrieve the blocktime that was set for it in addPhotoToMap(photoHash);
      * @param photoHash SHA256 hash of the photo that was used to verify identity
      * @return The photo's blocktime or 0 on failure. (using 0 instead of -1 cause blockTime is a uint)
      */
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