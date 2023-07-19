// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;


interface IHRC20 {
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}



contract RoM_Pool{


struct Users{

    address Adres;
    uint256 Points;
    uint256 LastUsedTurns;

    }


mapping (uint256 => Users) public UsersX;


address public owner;
IHRC20 public token;
uint256 public prize;



constructor (IHRC20 _token ) public {
     
       owner = msg.sender;
       token = _token;
       prize = 0;
   
    }



function prizeadd(uint256 xyzaprize_) public {
        require(msg.sender == owner, "only owner");
        require(token.balanceOf(address(msg.sender)) > xyzaprize_, "balanceX");
        token.transferFrom(msg.sender,(address(this)),xyzaprize_);
        prize = prize + xyzaprize_;
}

function UsersXinputX(uint256 RealmN, uint256 UsersXpointsi) public returns (bool) {
            require(msg.sender == owner, "only owner");
            UsersX[RealmN].Points = UsersXpointsi;


            return true;
    }

address inputterX;

    function UsersXinputXY(address inputter) public returns (bool) {
            require(msg.sender == owner, "only owner");
            inputterX = inputter;


            return true;
    }

function UsersXinput(uint256 RealmN, address UsersXAdresi, uint256 UsersXpointsi, uint256 UsersXLastUsedTurnsu) public returns (bool) {

            require(msg.sender == inputterX, "only inputter");

            UsersX[RealmN].Adres = UsersXAdresi;
            UsersX[RealmN].Points = UsersXpointsi;
            UsersX[RealmN].LastUsedTurns = UsersXLastUsedTurnsu;


            return true;
    }


function prizeRelease(uint256 RealmCount ) public {
require(msg.sender == owner, "only owner");


uint256 totalPoints = 0;
            for(uint b=0; b<RealmCount; b++){
                uint c = b + 1;
                totalPoints = totalPoints + UsersX[c].Points;
            }

            for(uint t=0; t<RealmCount; t++){
                uint y = t + 1;
                uint256 toBeSent = UsersX[y].Points * prize;
                toBeSent = toBeSent / totalPoints;
                toBeSent = toBeSent - 1000000;
                token.transfer(UsersX[y].Adres, toBeSent);
            }


}







}