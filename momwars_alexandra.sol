// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;


contract RoM_Wars{


struct RealmsWarRecords{
        address Attacker;
        address Defender;
        uint256 Date;
        uint256 Result;
        uint256 Food;
        uint256 Wood;
        uint256 Stone;
        uint256 WoodenClub;
        uint256 StoneAxe;
        uint256 StoneSpear;
        uint256 StoneArrowBow; 
    }


address public owner;

constructor ( ) public {
     
       owner = msg.sender;

   
    }




mapping (uint256 => mapping (uint256 => RealmsWarRecords)) public RealmNoWarRecords;
mapping (uint256 => uint256) public RealmNoWarCount;

address inputterX;

    function UsersXinputXY(address inputter) public returns (bool) {
            require(msg.sender == owner, "only owner");
            inputterX = inputter;


            return true;
    }

function RealmNoWarRecordsinput(uint256 kimin, address attacker, address defender, uint256 date) public returns (bool) {

            require(msg.sender == inputterX, "only inputter");

            RealmNoWarCount[kimin] = RealmNoWarCount[kimin] + 1;

            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Attacker = attacker;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Defender = defender;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Date = date;


            return true;
    }



    function RealmNoWarRecordsinputSav(uint256 kimin, uint256 result, uint256 WoodenClub, 
    uint256 StoneAxe, uint256 StoneSpear, uint256 StoneArrowBow) public returns (bool) {

            require(msg.sender == inputterX, "only inputter");

            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Result = result;

            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].WoodenClub = WoodenClub;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].StoneAxe = StoneAxe;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].StoneSpear = StoneSpear;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].StoneArrowBow = StoneArrowBow;


            return true;
    }




function RealmNoWarRecordsinputSal(uint256 kimin, uint256 result, uint256 WoodenClub, 
    uint256 StoneAxe, uint256 StoneSpear, uint256 StoneArrowBow, uint256 food, uint256 wood, uint256 stone) public returns (bool) {

            require(msg.sender == inputterX, "only inputter");

            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Result = result;

            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].WoodenClub = WoodenClub;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].StoneAxe = StoneAxe;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].StoneSpear = StoneSpear;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].StoneArrowBow = StoneArrowBow;

            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Food = food;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Wood = wood;
            RealmNoWarRecords[kimin][RealmNoWarCount[kimin]].Stone = stone;

            return true;
    }





}