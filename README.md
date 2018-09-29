# Truffle-Crowdfunding

Executions steps:-
1. Please make sure that all the pre-requisites are installed in order to execture this execercise.
  if NOT
2. Please install Node,npm
3. Please installl truffle framework - can be done through npm install -g truffle - This is will install the latest version.
4. Please OPEN new TERMINAL and nevegate to the directory where you have placed this folder.
5. START the ganache-cli using the command called- "ganache-cli". If you are running over meta mask you may use the those accounts by give mnemonic as a extra parament to ganache cli. That will look like this- "ganache-cli -m ' seed '". Ganache will make a connection to local host :8545 or 127.0.0.1:8545
OPEN anather TERMINAL and nevigate to the same directory. 
6. execute the command- "truffle develop" - to get into the development environment
7. execute the command- "compile"
8. execute the command- "migrate"
9. execute the command- "test" this will execure the test cases.
---------------------------------------------------------------------------------------------

Crowdfunding smart contract functionality:-

This smart contract is basically for the crowd funding purpose where the idea creator register for the ideas, give all the neccessory details including the WHITE paper link where they have published paper.
If investor likes that project(idea) then they go fo investment, they go voting with weight of the fund against the perticular idea. 
BUT the investment has conditions end time(deadline) and goal.
Investor can vote n number of time, investor can make a investment n number of times. Like wise the owner of the smart contract can create the n number of ideas.

ALL the ideas are based on KEY value, that is Project/idea ID. This is a key to retrive the whole information about ideas.

The smart contract is fully tested through REMIX IDE and with truffle test cases.
The Crowdfunding smart contract has total 8 functions. let me talk about them one by one.

1. createProject: This is the function where contract owner creates the ideas/projects. Pass all the neccessory information to create a idea. The conditions is deadline has to be greated than todays date and goal should be greater than zero.

2. getProjectDetails:- This function is for retriving the project or idea details against the registered ID.

3. investInIdeas:- This is a function where user can invest there amount. Primarly there are few checks amount should be be less than or equal to goal, dead line shoulnt have crossed, The idea should have already been created and must be exist.

4. refund: This function is to refund the amount of investor, if the project does meet up with expectations, otherwise refund would not be available.

5. payout:-This function is to send the amount to idea creator if everything met successfuly. If we have not reached to our goal do not transfer the amount.

6. getListOfIdeas:- This function is to view the list of all ideas.

7. getInvestment:- This is function is to see the entire investor that have done by one investor accross all ideas.

8. kill:- This is to destroy the smart contract when owner decides. 

----------------------------------------------------------------------------
Contract deployed address:

<pre>Running migration: 2_deploy_contracts.js
  Deploying CrowdFunding...
  ... 0x46ecdb7c7cbcd1bf99e3b06f90c5024e8cad87d5e145be959322a8e2676a91db
  CrowdFunding: 0x345ca3e014aaf5dca488057592ee47305d9b3e10
Saving successful migration to network...
  ... 0xf36163615f41ef7ed8f4a8f192149a0bf633fe1a2398ce001bf44c43dc7bdda0
</pre>
