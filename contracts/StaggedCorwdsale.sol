pragma solidity ^0.6.2;

import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StaggedCrowdsale is Context, Ownable {
    using SafeMath for uint256;
    using Address for address;

  struct Milestone {
    uint256 start;
    uint256 end;
    uint256 bonus;
    uint256 minInesetedLimit;
    uint256 maxInesetedLimit;
    uint256 invested;
    uint256 tokensSold;
    uint256 hardcapInTokens;
  }

  Milestone[] public milestones;

  function milestonesCount() public view returns(uint) {
    return milestones.length;
  }

  function addMilestone(uint256 start, uint256 end, uint256 bonus, uint256 minInvestedLimit, uint256 maxInvestedLimit, uint256 invested, uint256 tokensSold, uint256 hardcapInTokens) public onlyOwner {
    milestones.push(Milestone(start, end, bonus, minInvestedLimit, maxInvestedLimit, invested, tokensSold, hardcapInTokens));
  }

  function removeMilestone(uint8 number) public onlyOwner {
    require(number < milestones.length);
    Milestone storage milestone = milestones[number];

    delete milestones[number];

    for (uint i = number; i < milestones.length - 1; i++) {
      milestones[i] = milestones[i+1];
    }

    milestones.length--;
  }

  function changeMilestone(uint8 number, uint256 start, uint256 end256, uint256 bonus, uint256 minInvestedLimit, uint256 maxInvestedLimit, uint256 invested, uint256 tokensSold, uint256 hardcapInTokens) public onlyOwner {
    require(number < milestones.length);
    Milestone storage milestone = milestones[number];

    milestone.start = start;
    milestone.end = end;
    milestone.bonus = bonus;
    milestone.minInvestedLimit = minInvestedLimit;
    milestone.maxInvestedLimit = maxInvestedLimit;
    milestone.invested = invested;
    milestone.tokensSold = tokensSold;
    milestone.hardcapInTokens = hardcapInTokens;
  }

  function insertMilestone(uint8 numberAfter, uint256 start, uint256 end, uint256 bonus, uint256 minInvestedLimit, uint256 maxInvestedLimit, uint256 invested, uint256 tokensSold, uint256 hardcapInTokens) public onlyOwner {
    require(numberAfter < milestones.length);
    milestones.length++;
    for (uint i = milestones.length - 2; i > numberAfter; i--) {
      milestones[i + 1] = milestones[i];
    }
    milestones[numberAfter + 1] = Milestone(start, end, bonus, minInvestedLimit, maxInvestedLimit, invested, tokensSold, hardcapInTokens);
  }

  function clearMilestones() public onlyOwner {
    require(milestones.length > 0);
    for (uint i = 0; i < milestones.length; i++) {
      delete milestones[i];
    }
    milestones.length -= milestones.length;
  }

  function currentMilestone(uint start) public view returns(uint) {
    for(uint i=0; i < milestones.length; i++) {
      if(now >= milestones[i].start && now < milestones[i].end && milestones[i].tokensSold <= milestones[i].hardcapInTokens[i]) {
        return i;
      }
    }
    revert();
  }

}
