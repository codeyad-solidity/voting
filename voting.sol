// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Proposal {
        string name;
        string description;
        address creator;
        uint256 createTime;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(address => bool) hasVoted;
    }

    Proposal[] public proposals;

    function addProposal(string memory _name, string memory _description, uint256 _durationInMinutes) public {
        Proposal storage proposal = proposals.push();
        proposal.name = _name;
        proposal.description = _description;
        proposal.creator = msg.sender;
        proposal.createTime = block.timestamp;
        proposal.endTime = block.timestamp + (_durationInMinutes + 1 minutes);
        proposal.yesVotes = 0;
        proposal.noVotes = 0;
    }

    function vote(uint256 proposalIndex, bool voteYes) public {
        require(proposalIndex < proposals.length, "Proposal does not exist");
        Proposal storage proposal = proposals[proposalIndex];

        require(!proposal.hasVoted[msg.sender], "You have already voted on this proposal");
        require(block.timestamp < proposal.endTime, "Voting on this proposal has ended");

        if (voteYes) {
            proposal.yesVotes += 1;
        } else {
            proposal.noVotes += 1;
        }

        proposal.hasVoted[msg.sender] = true;
    }

    function getResult(uint256 proposalIndex) public view returns (uint256 yesVotes, uint256 noVotes) {
        require(proposalIndex < proposals.length, "Proposal does not exist");
        Proposal storage proposal = proposals[proposalIndex];
        return (proposal.yesVotes, proposal.noVotes);
    }
}
