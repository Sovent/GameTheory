const assert = require("assert");

const Cards = artifacts.require("Cards");

contract("Cards", (accounts) => {
    beforeEach(async () => {        
        cardsInstance = await Cards.new();
    });

    it("Doesn't have a card type before it's added", async () => {
        const cardTypeExists = await cardsInstance.doesCardTypeExists(1);
        assert.ok(!cardTypeExists);
    });

    it("Has a card type after it's added", async () => {
        await cardsInstance.addNewCardType("Pretty lady");
        const cardType = await cardsInstance.getLastAddedCardType();
        const cardTypeExists = await cardsInstance.doesCardTypeExists(cardType.toNumber());
        assert.ok(cardTypeExists);
    });

    it("Can't add a cart type with the empty name", async () => {
        let throws = false;
        try {
            await cardsInstance.addNewCardType("");
        }
        catch (e) {
            throws = true;
        }

        assert.ok(throws);
    })
});