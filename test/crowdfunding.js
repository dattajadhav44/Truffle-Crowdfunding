var CrowdFunding = artifacts.require('./CrowdFunding.sol')

contract("CrowdFunding", function(accounts) {
    it('should be possible to create a idea request if the duration is greater than current date & goal is greater than 0.', function() {
        var crowdInstance;
        return CrowdFunding.deployed().then(function(instance) {
            crowdInstance = instance;
            return crowdInstance.createProject(101,"Automotive project", web3.toWei(100,'ether'),30, "ideaOne","Github.com",
             {from: accounts[0]}).then(function(result){
                //console.log(result); 
             });
        })
    });

    it('should fetch the amount of investor which has made in ideas.', function() {
        var crowdInstance;
        return CrowdFunding.deployed().then(function(instance) {
            crowdInstance = instance;
            return crowdInstance.getInvestment.call(101).then(function(balance){
              //console.log(balance);
            });
        })
    });

    it('should should fetch number of ideas are the under this contract.', function() {
        var crowdInstance;
        return CrowdFunding.deployed().then(function(instance) {
            crowdInstance = instance;
            return crowdInstance.getListOfIdeas.call().then(function(balance){
              //console.log(balance);
            });
        })
    });

    it('should fetch the project details against the key(id) of it.', function() {
        var crowdInstance;
        return CrowdFunding.deployed().then(function(instance) {
            crowdInstance = instance;
            return crowdInstance.getProjectInfo.call(101).then(function(){
              //console.log(balance);
            });
        })
    });

    it('should fetch the project details against the key(id) of it.', function() {
        var crowdInstance;
        return CrowdFunding.deployed().then(function(instance) {
            crowdInstance = instance;
            return crowdInstance.payout.call(101).then(function(){
              //console.log(balance);
            });
        })
    });

    it('should should fail, as we are NOT yet reached to our goal.', function() {
        var crowdInstance;
        return CrowdFunding.deployed().then(function(instance) {
            crowdInstance = instance;
            return crowdInstance.refund.call(101).then(function(balance){
              //console.log(balance);
            });
        })
    });

});
