pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CardCatalogue {
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.UintSet;

    struct CardTypeDescription {
        string name;
        mapping (uint8 => uint8) stats;
    }

    Counters.Counter private _cardTypeIdCounter;

    mapping (uint => CardTypeDescription) cardTypes;

    function addNewCardType(string memory _name) external returns (uint) {
        require(_isNonEmptyString(_name), "Name should not be empty");
        _cardTypeIdCounter.increment();
        uint cardTypeId = _cardTypeIdCounter.current();
        CardTypeDescription storage description = cardTypes[cardTypeId];
        description.name = _name;
        return cardTypeId;
    }

    function doesCardTypeExists(uint cardTypeId) public view returns (bool) {
        CardTypeDescription storage cardTypeDescription = cardTypes[cardTypeId];
        return _isNonEmptyString(cardTypeDescription.name);
    }

    function getLastAddedCardType() public view returns (uint) {
        return _cardTypeIdCounter.current();
    }

    function _isNonEmptyString(string memory input) private pure returns(bool) {
        bytes memory inputBytes = bytes(input);
        return inputBytes.length != 0;
    }
}