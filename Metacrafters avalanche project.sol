// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Voting {
    struct Voter {
        bool registered;
        bool voted;
        uint vote;
        uint age;
        string name;
        bool stepcompleted;
    }

    struct Party {
        string partyname;
        uint voteCount;
    }

    address public chiefelection_commissioner;
    mapping(address => Voter) public voters;
    Party[] public parties;

    event VoteCast(address voter, uint party);

    constructor(string[] memory PartyNames) {
        chiefelection_commissioner = msg.sender;
        for (uint i = 0; i < PartyNames.length; i++) {
            parties.push(Party({partyname: PartyNames[i], voteCount: 0}));
        }
    }

    modifier onlychiefelection_commissioner() {
        require(msg.sender == chiefelection_commissioner, "Only the chief election commissioner can call this function");
        _;
    }

    modifier onlyafterrighttovote(address voter) {
        Voter storage voterEntry = voters[voter];
        require(voterEntry.stepcompleted, "First you need to give right to vote");
        _;
    }

    function giveRightToVote(address voter) public onlychiefelection_commissioner {
        Voter storage voterEntry = voters[voter];
        require(!voterEntry.voted, "The voter already voted");
        voterEntry.voted = false;
        voterEntry.stepcompleted = true;
    }

    function registerVoter(address voter, uint age, string memory name) public onlychiefelection_commissioner onlyafterrighttovote(voter) {
        Voter storage voterEntry = voters[voter];
        require(!voterEntry.registered, "Voter is already registered.");
        require(age >= 18, "Voter must be at least 18 years old.");

        voterEntry.registered = true;
        voterEntry.voted = false;
        voterEntry.vote = 0;
        voterEntry.age = age;
        voterEntry.name = name;
        voterEntry.stepcompleted = false;
    }

    function vote(uint party) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted");
        require(party < parties.length, "Invalid party");

        sender.voted = true;
        sender.vote = party;
        parties[party].voteCount += 1;

        emit VoteCast(msg.sender, party);
    }

    function winningParty() public view returns (uint winningParty_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < parties.length; p++) {
            if (parties[p].voteCount > winningVoteCount) {
                winningVoteCount = parties[p].voteCount;
                winningParty_ = p;
            }
        }
        assert(winningVoteCount > 0);
        return winningParty_;
    }

    function winnerName() public view returns (string memory winnerName_) {
        uint winnerIndex = winningParty();
        if (winnerIndex >= parties.length) {
            revert("Invalid party index");
        }
        winnerName_ = parties[winnerIndex].partyname;
    }
}