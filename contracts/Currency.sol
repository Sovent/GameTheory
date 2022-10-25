pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Currency is ERC20, Ownable {
    constructor() ERC20("TheoryCoins", "THC") {}

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    function reward(address receiver, uint256 amount) public onlyOwner {
        _mint(receiver, amount);
    }
}