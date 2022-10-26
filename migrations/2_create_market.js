const Cards = artifacts.require("Cards");
const Market = artifacts.require("Market");
const Currency = artifacts.require("Currency");

module.exports = async function (deployer) {
    const currency = await Currency.deployed();
    const cards = await deployer.deploy(Cards);
    const market = await deployer.deploy(Market, cards.address, currency.address);
}