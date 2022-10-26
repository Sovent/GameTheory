pragma solidity ^0.8.17;

import "./Cards.sol";
import "./Currency.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Market is Ownable {
    Cards cardsContract;
    Currency currencyContract;

    constructor(address cardsContractAddress, address currencyContractAddress) {
        cardsContract = Cards(cardsContractAddress);
        currencyContract = Currency(currencyContractAddress);
    }

    uint smallBoosterPrice = 10;
    uint mediumBoosterPrice = 20;
    uint bigBoosterPrice = 30;

    using EnumerableSet for EnumerableSet.UintSet;
    EnumerableSet.UintSet private supplyStorage;

    function setCardsAddress(address _newCardsAddress) public onlyOwner {
        cardsContract = Cards(_newCardsAddress);
    }

    function setCurrencyAddress(address _newCurrencyAddress) public onlyOwner {
        currencyContract = Currency(_newCurrencyAddress);
    }

    function addCard(uint cardType) public returns(uint) {
        uint createdCardId = cardsContract.createCardOfType(cardType);
        supplyStorage.add(createdCardId);
        return createdCardId;
    }

    function getCardsInStorage() public view returns(uint[] memory) {
        return supplyStorage.values();
    }

    function buySmallBooster() public {
        _buyBooster(5, smallBoosterPrice);
    }

    function buyMediumBooster() public {
        _buyBooster(15, mediumBoosterPrice);
    }

    function buyBigBooster() public {
        _buyBooster(30, bigBoosterPrice);
    }

    error InsufficientBalance(uint available, uint required, address account);
    error InsufficientStorage(uint storageSize, uint boosterSize);

    function _buyBooster(uint _boosterSize, uint _boosterPrice) private {
        require(supplyStorage.length() >= _boosterSize, "Not enough cards in storage");

        currencyContract.transferFrom(msg.sender, address(this), _boosterPrice);

        for (uint256 index = 0; index < _boosterSize; index++) {
            uint cardId = _getRandomCardIdFromStorage(index);
            cardsContract.safeTransferFrom(address(this), msg.sender, cardId);
            supplyStorage.remove(cardId);
        }
    }

    function _getRandomCardIdFromStorage(uint _salt) private view returns(uint){
        uint index = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender, _salt))) % supplyStorage.length();
        return supplyStorage.at(index);
    }
}