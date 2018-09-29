pragma solidity ^0.4.24;


contract CrowdFunding {
    struct Properties {   
        string description;                            /* This is a description of each project idea */
        uint   goal;                                   /* This is a Goal of the each project idea. This is a requirement that project creator has */
        uint   deadline;                               /* This is a deadline of each project idea, which would be set up by idea creator */
        string title;                                  /* This is a GitHub or any other site URL where the documentation/white paper of idea is located */
        string gitUrl;                                 /* This would need to be handled in front-end developemnt in terms of using the hyperlink of URL */
        address creator;                               /* This is gonna hold the address of idea creator. */
        bool isIdeaExists;                             /* This is to check whether idea is exist or not. */
        uint currentBalance;                           /* This is to current balance of perticular project */
        uint InvestorsVoteCount;                       /* This is to hold the vote of investor */
        uint InvestmentsCount;                         /* This is a count of InvestmentsCount */
    }

    mapping(uint => Properties) ideaInfo;     
    mapping (uint => mapping(address => uint)) private investorsInIdeas; /* The use of this mapping hold the amount of single investor against the ProjectId */
    mapping (address => uint) public investorsEntireFunding;  /* The use of this mapping is hold the entire amount of a inverstor which he/she has made in all the projects(ideas) as a Investment */
    mapping (address => bool) ideaCreators;
     
    uint price = 0.1 ether;                                /* the price is set to 0.1 to send a reward to Investor */
    address public owner;                                  /* This is a owner of contract   */

    uint[] private numOfProjects;                          /* This is the count of number projects that we hold under this contract */
    uint public numOfIdeasCount;
    

    event LogRefundIssued(address projectAddress, address Investor, uint refundAmount);
    event LogProjectCreated(uint id, string title, address creator);
    event LogContributionSent(uint ProId, address contributor, uint amount); /* These are the events */
    event LogInformation(string message);
    
    modifier onlyOwner { require(owner == msg.sender);
        _;
    }

    constructor() public {
        owner = msg.sender;                                 /* owner of the smart contract */
    }
    
    /* Create the project with all the details. including the white paper path where ever it has been published */
    function createProject(uint _id, string _description,uint _goal, uint _durationInMins, string _title, string _gitUrl) public {
        uint deadlineOfProject = now * _durationInMins * 1;
        require(_goal > 0 && deadlineOfProject > now);
        var ideaDetails = ideaInfo[_id];
        
        ideaDetails.description = _description;
        ideaDetails.goal = _goal;
        ideaDetails.deadline = deadlineOfProject;
        ideaDetails.title = _title;
        ideaDetails.gitUrl = _gitUrl;
        ideaDetails.creator = msg.sender;
        ideaDetails.isIdeaExists = true;
        ideaDetails.currentBalance = 0 ;
        ideaDetails.InvestorsVoteCount = 0;
        ideaDetails.InvestmentsCount = 0;
        
        ideaCreators[msg.sender] = true;
        numOfIdeasCount++;
        
        numOfProjects.push(_id);
    
        emit LogProjectCreated(_id, _title, msg.sender);
    }
    
    /**
    * Project values are indexed in return value:
    * [0] -> Project.arrProperties.description
    * [1] -> Project.arrProperties.goal
    * [2] -> Project.arrProperties.deadline
    * [3] -> Project.arrProperties.title
    * [4] -> Project.arrProperties.gitUrl
    * [5] -> Project.arrProperties.creator
    * [6] -> Project.arrProperties.currentBalance
    * [7] -> Project.arrProperties.InvestmentsCount
    * [8] -> Project.arrProperties.InvestorsVoteCount
    */
    /* Retrive the complete Project details. Please note that the projects identied based on key values. as we can have several projects */
    function getProjectInfo(uint _id) public view returns (string, uint, uint, string, string, address, uint, uint, uint) {
        var ideaDetails = ideaInfo[_id];
        return (ideaDetails.description,
                ideaDetails.deadline,
                ideaDetails.goal,
                ideaDetails.title,
                ideaDetails.gitUrl,
                ideaDetails.creator,
                ideaDetails.currentBalance,
                ideaDetails.InvestorsVoteCount,
                ideaDetails.InvestmentsCount);
    }

    function getInvestment(address _investor) public view returns (uint) {     /* Retrieve indiviual investment in all projects that he/she has done  -> Investment.amount */
        return investorsEntireFunding[_investor];
    }
    
    function getListOfIdeas() public view returns (uint[]) {                   /* get the list of ideas */
        return numOfProjects;
    }
    
    /*
    * This is the function called when the CrowdFunding receives a Investment. 
    * If the Investment was sent after the deadline of the project passed, 
    * or the full amount has been reached, the function must return the value 
    * to the originator of the transaction. 
    * If the full funding amount has been reached, the function must call payout. 
    * [0] -> Investment was made
    */
    function investInProject(uint _id) public payable returns (bool successful) {
        var ideaDetails = ideaInfo[_id];
        
        require(msg.value > 0 && ideaDetails.isIdeaExists &&  ideaDetails.goal >= ideaDetails.currentBalance);

        uint amount = msg.value;
        ideaDetails.currentBalance += amount;            /* add the investors investment to current currentBalance */
        ideaDetails.InvestmentsCount++;
        ideaDetails.InvestorsVoteCount++;
        
        emit LogContributionSent(_id, msg.sender, amount);
        investorsInIdeas[_id][msg.sender] += amount;
        uint Token = amount / price;
        
        msg.sender.transfer(Token);      /* transfer token to investor. These could done with ERC20 standard as well */
       
        emit LogInformation("Token has been sent to the investor as per the standard rate of Ether");
       
        investorsEntireFunding[msg.sender] += amount;
       
       return true;
    }

    /**
    * If the deadline is passed and the goal was not reached, allow contributors to withdraw their contributions.
    * This is slightly different that the final project requirements, see README for details
    * [0] -> refund was successful
    */
    function refund(uint _id) public payable returns (bool successful) {
        var ideaDetails = ideaInfo[_id];
   
        if (now < ideaDetails.deadline) {                                 /* Check that the project dealine has passed */
            emit LogInformation("Refund is only possible if project is past deadline");     
           revert();
        }

        if (ideaDetails.currentBalance >= ideaDetails.goal) {  /* Check that funding goal has not already been met */
            emit LogInformation("Refund is not possible if project has met goal");
            revert();
        }

       uint amount = investorsInIdeas[_id][msg.sender];
       investorsInIdeas[_id][msg.sender] = 0;                     /* prevent re-entrancy attack */
     
       if (msg.sender.send(amount)) {                              /* send refund to the investor */
           emit LogRefundIssued(address(this), msg.sender, amount);
           return true;
        } else {
            investorsInIdeas[_id][msg.sender] = amount;            /* if failed revert to previous state */
            emit LogInformation("Refund did not send successfully");
            return false;
        }
  }
    
    /* If funding goal has been met, transfer fund to project creator * [0] -> payout was successful */
    
    function payout(uint _id) public payable onlyOwner returns (bool successful) {
       var ideaDetails = ideaInfo[_id];
       
       require(ideaDetails.currentBalance >= ideaDetails.goal && ideaCreators[msg.sender]); /* make a check wheather the goal is met of not and the person who is calling this realy idea creator */
        
       uint amount = ideaDetails.currentBalance;                /* Move the total fund of the project into the local variable */
        
       emit LogInformation("The perticular funding goal has been met");
        
       if (ideaDetails.creator.send(amount)) {
            delete numOfProjects[_id];                          /* Once the fund sent to idea creator blank out/ delete the record from array book */
            delete ideaInfo[_id];
            numOfIdeasCount--;
            emit LogInformation("The amoount has been sent to owner of the idea creator");
            return true;
        } else {
            ideaDetails.currentBalance = amount;
            emit LogInformation("Refund did not send successfully, revert back to current balance");
            return false;
        }
    }

    function kill() public onlyOwner {                           /* if wish to destroy the entire contract here the owner can do it */
        selfdestruct(owner);
        emit LogInformation("The contract has been destroyed");
    }
}