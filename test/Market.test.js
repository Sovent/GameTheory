const Market = artifacts.require("Market");
const Cards = artifacts.require("Cards");
const Currency = artifacts.require("Currency");

const unwrapUint = async (valuePromise) => {
    const value = await valuePromise;
    return Array.isArray(value) ? value.map(element => element.toNumber()) : value.toNumber();
}

contract("Market", (accounts) => {
    beforeEach(async () => {
        currencyInstance = await Currency.new();
        cardsInstance = await Cards.new();
        marketInstance = await Market.new(cardsInstance.address, currencyInstance.address);
    });

    it("can add cards to market", async () => {
        const id = await marketInstance.addCard(5);
        const cards = await marketInstance.getCardsInStorage();
        assert.equal(cards.length, 1);
    });

    it("can't buy cards when there are not enough cards in the storage", async () => {
        await currencyInstance.reward(accounts[0], 200);
        await currencyInstance.approve(marketInstance.address, 200);
        
        let throws = false;
        try {
            await marketInstance.buySmallBooster();
        } catch(e) {
            throws = true;
        }

        assert.equal(true, throws);
    });

    it("can buy cards", async () => {
        await currencyInstance.reward(accounts[0], 200);
        await currencyInstance.approve(marketInstance.address, 200);
        for (let cardType = 0; cardType < 10; cardType++) {
            await marketInstance.addCard(cardType);
        }

        await marketInstance.buySmallBooster();

        cardsInStorage = await unwrapUint(marketInstance.getCardsInStorage());
        console.log("get cards in storage after booster purchase", cardsInStorage);
        
        const cards = await unwrapUint(cardsInstance.getCards(accounts[0]));
        assert.equal(5, cards.length);
        console.log("cardIds", cards);
    });
});