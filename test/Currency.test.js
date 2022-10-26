const Currency = artifacts.require("Currency");

contract("Currency", (accounts) => {
    const ownerAccount = accounts[0];
    const nonOwnerAccount = accounts[1];
    const fraudster = accounts[2];
    beforeEach(async () => {
        instance = await Currency.new();
    });

    it("creates contract with the proper owner", async () => {
        let owner = await instance.owner();
        assert.equal(ownerAccount, owner, "Owner should be proper");
    });

    it("can reward an account with coins", async () => {
        await instance.reward(nonOwnerAccount, 200);
        let newBalance = await instance.balanceOf(nonOwnerAccount);
        assert.equal(newBalance, 200, "Account should have coins");
    });

    it("non-owner can't reward itself", async () => {
        try {
            await instance.reward(fraudster, 200, {from: fraudster})
        }
        catch (e) {
            console.log(e);
        }

        let newBalance = (await instance.balanceOf(fraudster)).toNumber();
        assert.equal(newBalance, 0, "Account shouldn't have been rewarded");
    });

    it("can transfer currency rewarded to it", async () => {
        await instance.reward(ownerAccount, 300);
        await instance.transfer(nonOwnerAccount, 250);
        let newBalance = (await instance.balanceOf(nonOwnerAccount)).toNumber();
        assert.equal(newBalance, 250, "Coins should be transfered");
    });
});