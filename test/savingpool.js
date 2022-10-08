const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { EDIT_DISTANCE_THRESHOLD } = require("hardhat/internal/constants");

describe("SavingsPool",  function () {
    let Instance;
    beforeEach(async function(){
    const Inst = await hre.ethers.getContractFactory("savingPool");
     Instance = await Inst.deploy();
    [owner,contributer1,contributer2] = await ethers.getSigners();
})
    it("Owner should be able to set pool amount and max participants",async function(){
        await Instance.deployed();

        const amount = 5000;
        const maxParticipant = 5;
       await Instance.setVar(amount,maxParticipant);

        expect(await Instance.contributionAmt()==amount && await Instance.maxParticipants()==maxParticipant);

    } )
    it("Should set current Beneficiary of the pool", async function(){
        await Instance.deployed;
        await Instance.currentBeneficiary(contributer2.address);

        expect(Instance.recepient()==contributer2.address);
    })
    it("Owner should be able to set the time that the Pool will take",async function(){
        const time = 5*24;
      const timeinSecs = time*3600;

      const current = Math.floor(Date.now() / 1000);
      finishtime = current+timeinSecs;

        await Instance.deployed();
        await Instance.FinishTime(finishtime);

        expect(await Instance.endTime()==finishtime);
    })
})