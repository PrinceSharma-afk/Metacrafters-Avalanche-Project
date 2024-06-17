# Metacrafters-Avalanche-Project
This is my third project of metacrafters in which i create a solidity smart contract for a voting system.
This Solidity smart contract implements a simple voting system where voters can register, cast votes for parties, and determine the winning party. The contract includes functionalities to register voters, give them the right to vote, cast votes, and check the winning party.
Functions
Constructor:
Initializes the contract with a list of party names and sets the deployer as the chief election commissioner.
Modifiers: 
onlychiefelection_commissioner: Restricts function access to the chief election commissioner.
onlyafterrighttovote: ensures right to vote is given before registring the voter.
registerVoter:
Registers a voter with their address, age, and name.
giveRightToVote:
Grants the right to vote to a registered voter.
vote:
Allows a registered voter to cast a vote for a party.
winningParty:
Returns the index of the winning party.
winnerName:
Returns the name of the winning party.
