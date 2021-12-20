//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {


    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    mapping(address => uint ) public allowance;

    modifier allowedOrOwner(uint amount)  {
        require(isOwner() || allowance[msg.sender] >= amount,"you are not allowed");
        _;
    }

    function addAllowance(address  who, uint amount) public {
        allowance[who]=amount;
    }
    function reduceAllowance(address who , uint amount) internal {
        allowance[who] = allowance[who] -(amount);
    }
}
    contract sharedWallet is Allowance{
    
        function withdrawAmount(address payable to , uint amount) public allowedOrOwner( amount){
            if(!isOwner()){
                reduceAllowance(msg.sender , amount);
            }
            require(amount <= address(this).balance, "not enough ether");
            to.transfer(amount);
        }

    receive() external payable {

    }
}
