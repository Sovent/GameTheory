pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Cards is ERC721, ERC721Enumerable {
    constructor() ERC721("Game Theory Card", "GTC") {

    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping (uint => uint) private cardToCardTypes;

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function createCardOfType(uint cardType) public returns(uint) {
        uint tokenId = _tokenIdCounter.current();
        _mint(msg.sender, tokenId);
        cardToCardTypes[tokenId] = cardType;
        _tokenIdCounter.increment();
        return tokenId;
    }

    function getCards(address owner) external view returns (uint[] memory) {
        uint balance = balanceOf(owner);
        uint[] memory cards = new uint[](balance);
        for (uint256 index = 0; index < balance; index++) {
            cards[index] = tokenOfOwnerByIndex(owner, index);
        }
        return cards;
    }
}
