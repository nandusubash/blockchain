// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery {

    address payable[] public players;
    address payable public admin;

    

    constructor()  {
        admin = payable(msg.sender);
    }
    receive() external payable{
        require(msg.value ==1 ether,"not 1 ether");
        require(msg.sender != admin,"you are admin, not allowed");
        players.push(payable(msg.sender));

    }

    function getBalance() public view  returns(uint) {
        return address(this).balance;
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public {
        require(admin == msg.sender,"you are not the admin");
        require(players.length >= 3 , "not enough players");
        address payable winner;
        winner = players[random()% players.length];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }

}
