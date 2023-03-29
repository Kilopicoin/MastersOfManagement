// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

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



interface MoM_Tech {

function techRateClear(uint256 value) external returns (bool);
function RealmNoResearchRatex(uint256 user_id, string memory tech, uint256 amount) external returns (bool);
function RealmNoResearchRatey(uint256 user_id, string memory tech) external view returns (uint256);


}


contract RoM{



    struct Realms{
        uint256 turn;
        uint256 start;
        uint256 points;
        string name;
        address ruler;
        uint256 popT;
        uint256 popRate;
        uint256 popMax;
        uint256 food;
        uint256 foodRate;
        uint256 foodFactor;
        uint256 foodMax;
        uint256 wood;
        uint256 woodRate;
        uint256 woodMax;
        uint256 stone;
        uint256 stoneRate;
        uint256 stoneMax;
        uint256 productionRate;
        uint256 underProduction; 
        uint256 underProductionName; 
        uint256 underProductionQuantity;
        uint256 underTraining; 
        uint256 underTrainingName;
        uint256 underTrainingQuantity;
        uint256 underAttack; 
        address underAttackAdres;
        uint256 warAlert;
    }


struct Feedback{
    address commenter;
    string content;
}


struct RealmsProducts{
        uint256 WoodenClub;
        uint256 StoneAxe;
        uint256 StoneSpear;
        uint256 StoneArrowBow;
    }


struct RealmsWarriors{
        uint256 WoodenClubFighter;
        uint256 StoneAxeFighter;
        uint256 StoneSpearFighter;
        uint256 StoneArrowBowFighter;
    }


struct RealmsAttackers{
        uint256 WoodenClubFighter;
        uint256 StoneAxeFighter;
        uint256 StoneSpearFighter;
        uint256 StoneArrowBowFighter;
    }

struct RealmsWarRecords{
        address Attacker;
        address Defender;
        uint256 Date;
        uint256 Result; 
    }


    struct Tech{
        uint256 Gathering;
        uint256 StoneCutting;
        uint256 WoodCutting; 
        uint256 WoodenClub; 
        uint256 StoneTools; 
        uint256 StoneAxe;
        uint256 StoneKnife;
        uint256 StoneSpear;
        uint256 StoneArrowBow;
        uint256 Hunting;
        uint256 ControlOfFire;
        uint256 Taming;
        uint256 Fishing;
        uint256 Rope;
        uint256 WoodenBoat;
        uint256 Clothing;
        uint256 Cooking;
        uint256 Harpoon;
        uint256 Bed;
        uint256 Shoes;
        uint256 Weaving;
        uint256 Ceramics;
        uint256 Pottery;
        uint256 Farming;
        uint256 Settlement;
    }



    struct LaborArea{
        uint256 FoodGathering;
        uint256 WoodGathering;
        uint256 StoneGathering;
        uint256 Production;
    }
	




    mapping (uint256 => mapping (string => uint256)) public RealmNoResearching;
    mapping (uint256 => Tech) internal RealmNoResearches;
    mapping (uint256 => LaborArea) internal PopLaborAreas;

    mapping (uint256 => uint256) public RealmNoProducing;
    mapping (uint256 => RealmsProducts) public RealmNoProducts;

    mapping (uint256 => uint256) public RealmNoTraining;
    mapping (uint256 => RealmsWarriors) public RealmNoWarriors;

    mapping (uint256 => uint256) public RealmNoAttacking;
    mapping (uint256 => RealmsAttackers) public RealmNoAttackers;

    mapping (uint256 => mapping (uint256 => RealmsWarRecords)) public RealmNoWarRecords;
    mapping (uint256 => uint256) public RealmNoWarCount;

	address public owner;
    uint256 public RealmCount;
    uint256 public startWorld;
    uint256 public finishWorld;
    bool public statusWorld;
    mapping (string => uint256) public Techs;
    uint256 public FeedbackNo;

    IHRC20 public token;
    MoM_Tech public token_Tech;

    uint256 public prize;


	constructor (uint256 lifeWorld, IHRC20 _token, MoM_Tech token_Tech_) public {
       RealmCount = 0;
       prize = 0;
       token = _token;
       token_Tech = token_Tech_;
       owner = msg.sender;
       startWorld = block.timestamp;
       finishWorld = block.timestamp + ( lifeWorld * 86400 );
       statusWorld = false;
       Techs["Gathering"] = 150000;
       Techs["StoneCutting"] = 150000;
       Techs["WoodCutting"] = 120000;
       Techs["WoodenClub"] = 60000;
       Techs["StoneTools"] = 90000;
       Techs["StoneAxe"] = 110000;
       Techs["StoneKnife"] = 100000;
       Techs["StoneSpear"] = 160000;
       Techs["StoneArrowBow"] = 170000;
       Techs["Hunting"] = 90000;
       Techs["ControlOfFire"] = 260000;
       Techs["Taming"] = 150000;
       Techs["Fishing"] = 170000;
       Techs["Rope"] = 370000;
       Techs["WoodenBoat"] = 210000;
       Techs["Clothing"] = 180000;
       Techs["Cooking"] = 130000;
       Techs["Harpoon"] = 310000;
       Techs["Bed"] = 320000;
       Techs["Shoes"] = 280000;
       Techs["Weaving"] = 380000;
       Techs["Ceramics"] = 390000;
       Techs["Pottery"] = 280000;
       Techs["Farming"] = 490000;
       Techs["Settlement"] = 600000;
    }
   
	event e_addRealm (address indexed e_realm);
    event e_useturn (address indexed e_realm, uint256 indexed usedturn);
	event e_addFeedback (address indexed e_realm, string indexed content);
	
	mapping (uint256 => Realms) internal RealmNo;
    mapping (uint256 => Feedback) public Feedbacks;
	mapping(address => uint256) public RealmCreated;


    struct useTurnG{
        uint256 turnUse;
        string res1;
        uint256 res1am;
        string res2;
        uint256 res2am;
        string res3;
        uint256 res3am;
        uint256 foodRatex;
        uint256 woodRatex;
        uint256 stoneRatex;
        uint256 popRatex;
        uint256 productionRatex;
        uint256 product;
        uint256 productQuantity;
        uint256 productManPower;
        uint256 warrior;
        uint256 warriorQuantity;
        uint256 atak_woodenclubfighter;
        uint256 atak_stoneaxefighter;
        uint256 atak_stonespearfighter;
        uint256 atak_stonearrowbowfighter;
        address atak_adres;
        uint256 cancelproduction;
    }

	
	function addRealm(string memory _name) public {
        require(statusWorld, "W P");
        require(RealmCreated[msg.sender] == 0, "Realm Exists");
        RealmCount++;
        RealmCreated[msg.sender] = RealmCount;
		RealmNo[RealmCount] = Realms(300,block.timestamp,10,_name,msg.sender,2000,0,1000000,0,0,5,10000000,0,0,10000000,0,0,10000000,0,0,0,0,0,0,0,0,msg.sender,0);
//      RealmNo[RealmCount] = Realms(5005,block.timestamp,10,_name,msg.sender,2000,0,1000000,0,0,5,10000000,0,0,10000000,0,0,10000000,0,0,0,0,0,0,0,0,msg.sender,0);
        RealmNoResearches[RealmCount] = Tech(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        PopLaborAreas[RealmCount] = LaborArea(0,0,0,0);
		emit e_addRealm(msg.sender);
	}
	
    function calcTurn() public {
        require(RealmCreated[msg.sender] != 0, "No Realm");
        uint256 realmnum = RealmCreated[msg.sender];
		RealmNo[realmnum].turn = RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600 );
//        if (RealmNo[realmnum].turn > 5005) {
//            RealmNo[realmnum].turn = 5005;
        if (RealmNo[realmnum].turn > 300) {
            RealmNo[realmnum].turn = 300;
        }
	}

    function setStatusWorld() public {
        require(msg.sender == owner, "Only owner");
        require(block.timestamp < finishWorld, "W finalized");
        if (statusWorld == false) {
            statusWorld = true;
        } else 
        statusWorld = false;
	}


    function getTurn(address Accc) public view returns (uint256) {
        uint256 realmnum = RealmCreated[Accc];
//        if (RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600 ) > 5005) {
//            return 5005 ;
        if (RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600 ) > 300) {
            return 300 ;
        } else 
        return RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600) ;
        
    }

    function getAgeWorld() public view returns (uint256) {

        if ( block.timestamp < finishWorld ) {
        return block.timestamp - startWorld;
        } else {
        return finishWorld - startWorld;
        }


    }


    function prizeadd(uint256 xyzaprize_) public {
        require(msg.sender == owner, "only owner");
        require(statusWorld, "W P");
        require(token.balanceOf(address(msg.sender)) > xyzaprize_, "balanceX");
        token.transferFrom(msg.sender,(address(this)),xyzaprize_);
        prize = prize + xyzaprize_;
}


    function useTurn(useTurnG memory useTurnGx

     ) public{
        require(statusWorld, "W P");

        if ( block.timestamp > finishWorld ) {
            statusWorld = false;

            uint256 totalPoints = 0;
            for(uint b=0; b<RealmCount; b++){
                uint c = b + 1;
                totalPoints = totalPoints + RealmNo[c].points;
            }

            for(uint t=0; t<RealmCount; t++){
                uint y = t + 1;
                uint256 toBeSent = RealmNo[y].points * prize;
                toBeSent = toBeSent / totalPoints;
                toBeSent = toBeSent - 1000000;
                token.transfer(RealmNo[y].ruler, toBeSent);
            }

            emit e_useturn(msg.sender, useTurnGx.turnUse);



        } else {

        require(RealmCreated[msg.sender] != 0, "No Realm");
        calcTurn();
        uint256 realmnum = RealmCreated[msg.sender];
		require(RealmNo[realmnum].turn >= useTurnGx.turnUse, "TurnX");
        RealmNo[realmnum].turn = RealmNo[realmnum].turn - useTurnGx.turnUse;
        RealmNo[realmnum].start = block.timestamp;
        

        






        



RealmNo[realmnum].popRate = useTurnGx.popRatex;
        RealmNo[realmnum].foodRate = useTurnGx.foodRatex;
        RealmNo[realmnum].woodRate = useTurnGx.woodRatex;
        RealmNo[realmnum].stoneRate = useTurnGx.stoneRatex;
        RealmNo[realmnum].productionRate = useTurnGx.productionRatex;


        uint256 popE = RealmNo[realmnum].popT;
        RealmNo[realmnum].popT = RealmNo[realmnum].popT + ( ( popE * RealmNo[realmnum].popRate * useTurnGx.turnUse ) / 10000);
        uint256 popH = ( RealmNo[realmnum].popT + popE ) / 2;

        if ( RealmNo[realmnum].food > popH * useTurnGx.turnUse / 10) {

            if ( RealmNo[realmnum].food > 1000000) {

            RealmNo[realmnum].food = RealmNo[realmnum].food - ( popH * useTurnGx.turnUse  / 10 );

            }

        } else {

                if ( popE > 100000) {

                    RealmNo[realmnum].popT = popE - ( popE / ( 1000 / useTurnGx.turnUse ) ) ;
                    popH = ( RealmNo[realmnum].popT + popE ) / 2;
                }

                RealmNo[realmnum].food = 0;


        }



        RealmNo[realmnum].food = RealmNo[realmnum].food + (( ( RealmNo[realmnum].foodRate + RealmNo[realmnum].foodFactor ) * useTurnGx.turnUse * popH) / 1000 );

        RealmNo[realmnum].wood = RealmNo[realmnum].wood + (( RealmNo[realmnum].woodRate * useTurnGx.turnUse * popH) / 1000 );
        RealmNo[realmnum].stone = RealmNo[realmnum].stone + (( RealmNo[realmnum].stoneRate * useTurnGx.turnUse * popH) / 1000 );






















if ( RealmNo[realmnum].underAttack == 1) {




                 if ( useTurnGx.turnUse >= RealmNoAttacking[realmnum] ) {



                        


uint256 realmnumD = RealmCreated[RealmNo[realmnum].underAttackAdres];
uint256 saldiran = (RealmNoAttackers[realmnum].WoodenClubFighter * 2) + (RealmNoAttackers[realmnum].StoneAxeFighter * 3) + (RealmNoAttackers[realmnum].StoneSpearFighter * 4) + (RealmNoAttackers[realmnum].StoneArrowBowFighter * 4);
uint256 savunan = (RealmNoWarriors[realmnumD].WoodenClubFighter * 1) + (RealmNoWarriors[realmnumD].StoneAxeFighter * 2) + (RealmNoWarriors[realmnumD].StoneSpearFighter * 6) + (RealmNoWarriors[realmnumD].StoneArrowBowFighter * 4);
savunan = savunan +  (( savunan * 30) / 100);

RealmNoWarCount[realmnum] = RealmNoWarCount[realmnum] + 1;
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Attacker = msg.sender;
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Defender = RealmNo[realmnum].underAttackAdres;
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Date = block.timestamp;

RealmNoWarCount[realmnumD] = RealmNoWarCount[realmnumD] + 1;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Attacker = msg.sender;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Defender = RealmNo[realmnum].underAttackAdres;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Date = block.timestamp;




if ( savunan >= saldiran ) {

RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Result = 2;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Result = 1;

    if ( RealmNoWarriors[realmnumD].WoodenClubFighter > 10) {

        RealmNoWarriors[realmnumD].WoodenClubFighter = RealmNoWarriors[realmnumD].WoodenClubFighter - 1;

    }

    if ( RealmNoWarriors[realmnumD].StoneAxeFighter > 10) {

        RealmNoWarriors[realmnumD].StoneAxeFighter = RealmNoWarriors[realmnumD].StoneAxeFighter - 1;

    }

    if ( RealmNoWarriors[realmnumD].StoneSpearFighter > 10) {

        RealmNoWarriors[realmnumD].StoneSpearFighter = RealmNoWarriors[realmnumD].StoneSpearFighter - 1;

    }

    if ( RealmNoWarriors[realmnumD].StoneArrowBowFighter > 10) {

        RealmNoWarriors[realmnumD].StoneArrowBowFighter = RealmNoWarriors[realmnumD].StoneArrowBowFighter - 1;

    }







if ( RealmNoAttackers[realmnum].WoodenClubFighter > 10) {

        RealmNoAttackers[realmnum].WoodenClubFighter = RealmNoAttackers[realmnum].WoodenClubFighter - (( RealmNoAttackers[realmnum].WoodenClubFighter * 30 ) / 100 );
    

    }

    if ( RealmNoAttackers[realmnum].StoneAxeFighter > 10) {

        RealmNoAttackers[realmnum].StoneAxeFighter = RealmNoAttackers[realmnum].StoneAxeFighter - (( RealmNoAttackers[realmnum].StoneAxeFighter * 30 ) / 100 );


    }

    if ( RealmNoAttackers[realmnum].StoneSpearFighter > 10) {

        RealmNoAttackers[realmnum].StoneSpearFighter = RealmNoAttackers[realmnum].StoneSpearFighter - (( RealmNoAttackers[realmnum].StoneSpearFighter * 30 ) / 100 );
        

    }

    if ( RealmNoAttackers[realmnum].StoneArrowBowFighter > 10) {

        RealmNoAttackers[realmnum].StoneArrowBowFighter = RealmNoAttackers[realmnum].StoneArrowBowFighter - (( RealmNoAttackers[realmnum].StoneArrowBowFighter * 30 ) / 100 );
        

    }










} else {


RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Result = 1;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Result = 2;






if ( RealmNoWarriors[realmnumD].WoodenClubFighter > 10) {

        RealmNoWarriors[realmnumD].WoodenClubFighter = RealmNoWarriors[realmnumD].WoodenClubFighter - (( RealmNoWarriors[realmnumD].WoodenClubFighter * 20 ) / 100 );
        

    }

    if ( RealmNoWarriors[realmnumD].StoneAxeFighter > 10) {

        RealmNoWarriors[realmnumD].StoneAxeFighter = RealmNoWarriors[realmnumD].StoneAxeFighter - (( RealmNoWarriors[realmnumD].StoneAxeFighter * 20 ) / 100 );
        

    }

    if ( RealmNoWarriors[realmnumD].StoneSpearFighter > 10) {

        RealmNoWarriors[realmnumD].StoneSpearFighter = RealmNoWarriors[realmnumD].StoneSpearFighter - (( RealmNoWarriors[realmnumD].StoneSpearFighter * 20 ) / 100 );
        
    }


    if ( RealmNoWarriors[realmnumD].StoneArrowBowFighter > 10) {

        RealmNoWarriors[realmnumD].StoneArrowBowFighter = RealmNoWarriors[realmnumD].StoneArrowBowFighter - (( RealmNoWarriors[realmnumD].StoneArrowBowFighter * 20 ) / 100 );
        

    }







if ( RealmNoAttackers[realmnum].WoodenClubFighter > 10) {


        RealmNoAttackers[realmnum].WoodenClubFighter = RealmNoAttackers[realmnum].WoodenClubFighter - 1;

    }

    if ( RealmNoAttackers[realmnum].StoneAxeFighter > 10) {


        RealmNoAttackers[realmnum].StoneAxeFighter = RealmNoAttackers[realmnum].StoneAxeFighter - 1;

    }

    if ( RealmNoAttackers[realmnum].StoneSpearFighter > 10) {


        RealmNoAttackers[realmnum].StoneSpearFighter = RealmNoAttackers[realmnum].StoneSpearFighter - 1;

    }

    if ( RealmNoAttackers[realmnum].StoneArrowBowFighter > 10) {


        RealmNoAttackers[realmnum].StoneArrowBowFighter = RealmNoAttackers[realmnum].StoneArrowBowFighter - 1;

    }



if ( RealmNo[realmnumD].food > 100000) {

        RealmNo[realmnum].food = RealmNo[realmnum].food + ( ( RealmNo[realmnumD].food * 30 ) / 100 );
        RealmNo[realmnumD].food = RealmNo[realmnumD].food - ( ( RealmNo[realmnumD].food * 30 ) / 100 );

}


if ( RealmNo[realmnumD].wood > 100000) {

        RealmNo[realmnum].wood = RealmNo[realmnum].wood + ( ( RealmNo[realmnumD].wood * 30 ) / 100 );
        RealmNo[realmnumD].wood = RealmNo[realmnumD].wood - ( ( RealmNo[realmnumD].wood * 30 ) / 100 );

}


if ( RealmNo[realmnumD].stone > 100000) {
        
        RealmNo[realmnum].stone = RealmNo[realmnum].stone + ( ( RealmNo[realmnumD].stone * 30 ) / 100 );
        RealmNo[realmnumD].stone = RealmNo[realmnumD].stone - ( ( RealmNo[realmnumD].stone * 30 ) / 100 );

}


if ( RealmNoProducts[realmnumD].WoodenClub > 10) {

        RealmNoProducts[realmnum].WoodenClub = RealmNoProducts[realmnum].WoodenClub + ( ( RealmNoProducts[realmnumD].WoodenClub * 30 ) / 100 );
        RealmNoProducts[realmnumD].WoodenClub = RealmNoProducts[realmnumD].WoodenClub - ( ( RealmNoProducts[realmnumD].WoodenClub * 30 ) / 100 );

}


if ( RealmNoProducts[realmnumD].StoneAxe > 10) {

        RealmNoProducts[realmnum].StoneAxe = RealmNoProducts[realmnum].StoneAxe + ( ( RealmNoProducts[realmnumD].StoneAxe * 30 ) / 100 );
        RealmNoProducts[realmnumD].StoneAxe = RealmNoProducts[realmnumD].StoneAxe - ( ( RealmNoProducts[realmnumD].StoneAxe * 30 ) / 100 );

}


if ( RealmNoProducts[realmnumD].StoneSpear > 10) {

        RealmNoProducts[realmnum].StoneSpear = RealmNoProducts[realmnum].StoneSpear + ( ( RealmNoProducts[realmnumD].StoneSpear * 30 ) / 100 );
        RealmNoProducts[realmnumD].StoneSpear = RealmNoProducts[realmnumD].StoneSpear - ( ( RealmNoProducts[realmnumD].StoneSpear * 30 ) / 100 );

}

if ( RealmNoProducts[realmnumD].StoneArrowBow > 10) {

        RealmNoProducts[realmnum].StoneArrowBow = RealmNoProducts[realmnum].StoneArrowBow + ( ( RealmNoProducts[realmnumD].StoneArrowBow * 30 ) / 100 );
        RealmNoProducts[realmnumD].StoneArrowBow = RealmNoProducts[realmnumD].StoneArrowBow - ( ( RealmNoProducts[realmnumD].StoneArrowBow * 30 ) / 100 );

}











}



                        RealmNo[realmnum].underAttack = 0;

                        RealmNo[realmnum].underAttackAdres = msg.sender;

                        RealmNoWarriors[realmnum].WoodenClubFighter = RealmNoWarriors[realmnum].WoodenClubFighter + RealmNoAttackers[realmnum].WoodenClubFighter;
                        RealmNoWarriors[realmnum].StoneAxeFighter = RealmNoWarriors[realmnum].StoneAxeFighter + RealmNoAttackers[realmnum].StoneAxeFighter;
                        RealmNoWarriors[realmnum].StoneSpearFighter = RealmNoWarriors[realmnum].StoneSpearFighter + RealmNoAttackers[realmnum].StoneSpearFighter;
                        RealmNoWarriors[realmnum].StoneArrowBowFighter = RealmNoWarriors[realmnum].StoneArrowBowFighter + RealmNoAttackers[realmnum].StoneArrowBowFighter;

                        RealmNoAttackers[realmnum].WoodenClubFighter = 0;
                        RealmNoAttackers[realmnum].StoneAxeFighter = 0;
                        RealmNoAttackers[realmnum].StoneSpearFighter = 0;
                        RealmNoAttackers[realmnum].StoneArrowBowFighter = 0;


                        RealmNoAttacking[realmnum] = 0;

                        RealmNo[realmnumD].warAlert = 1;







                    } else {

                        RealmNoAttacking[realmnum] = RealmNoAttacking[realmnum] - useTurnGx.turnUse;


                    }
                




            } else {

                if ( useTurnGx.atak_adres != msg.sender ) {


                        RealmNo[realmnum].underAttack = 1;

                        RealmNo[realmnum].underAttackAdres = useTurnGx.atak_adres;

                        RealmNoAttackers[realmnum].WoodenClubFighter = useTurnGx.atak_woodenclubfighter;
                        RealmNoAttackers[realmnum].StoneAxeFighter = useTurnGx.atak_stoneaxefighter;
                        RealmNoAttackers[realmnum].StoneSpearFighter = useTurnGx.atak_stonespearfighter;
                        RealmNoAttackers[realmnum].StoneArrowBowFighter = useTurnGx.atak_stonearrowbowfighter;

                        RealmNoWarriors[realmnum].WoodenClubFighter = RealmNoWarriors[realmnum].WoodenClubFighter - useTurnGx.atak_woodenclubfighter;
                        RealmNoWarriors[realmnum].StoneAxeFighter = RealmNoWarriors[realmnum].StoneAxeFighter - useTurnGx.atak_stoneaxefighter;
                        RealmNoWarriors[realmnum].StoneSpearFighter = RealmNoWarriors[realmnum].StoneSpearFighter - useTurnGx.atak_stonespearfighter;
                        RealmNoWarriors[realmnum].StoneArrowBowFighter = RealmNoWarriors[realmnum].StoneArrowBowFighter - useTurnGx.atak_stonearrowbowfighter;


                        RealmNoAttacking[realmnum] = 60;

uint256 toplamAsker = useTurnGx.atak_woodenclubfighter + useTurnGx.atak_stoneaxefighter + useTurnGx.atak_stonespearfighter + useTurnGx.atak_stonearrowbowfighter;

                        RealmNo[realmnum].food = RealmNo[realmnum].food - ( toplamAsker * 180000 );




                    if ( useTurnGx.turnUse >= RealmNoAttacking[realmnum] ) {

uint256 realmnumD = RealmCreated[RealmNo[realmnum].underAttackAdres];
uint256 saldiran = (RealmNoAttackers[realmnum].WoodenClubFighter * 2) + (RealmNoAttackers[realmnum].StoneAxeFighter * 3) + (RealmNoAttackers[realmnum].StoneSpearFighter * 4) + (RealmNoAttackers[realmnum].StoneArrowBowFighter * 4);
uint256 savunan = (RealmNoWarriors[realmnumD].WoodenClubFighter * 1) + (RealmNoWarriors[realmnumD].StoneAxeFighter * 2) + (RealmNoWarriors[realmnumD].StoneSpearFighter * 6) + (RealmNoWarriors[realmnumD].StoneArrowBowFighter * 4);
savunan = savunan +  (( savunan * 30) / 100);

RealmNoWarCount[realmnum] = RealmNoWarCount[realmnum] + 1;
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Attacker = msg.sender;
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Defender = RealmNo[realmnum].underAttackAdres;
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Date = block.timestamp;

RealmNoWarCount[realmnumD] = RealmNoWarCount[realmnumD] + 1;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Attacker = msg.sender;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Defender = RealmNo[realmnum].underAttackAdres;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Date = block.timestamp;

if ( savunan >= saldiran ) {
RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Result = 2;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Result = 1;

    if ( RealmNoWarriors[realmnumD].WoodenClubFighter > 10) {

        RealmNoWarriors[realmnumD].WoodenClubFighter = RealmNoWarriors[realmnumD].WoodenClubFighter - 1;

    }

    if ( RealmNoWarriors[realmnumD].StoneAxeFighter > 10) {


        RealmNoWarriors[realmnumD].StoneAxeFighter = RealmNoWarriors[realmnumD].StoneAxeFighter - 1;

    }

    if ( RealmNoWarriors[realmnumD].StoneSpearFighter > 10) {


        RealmNoWarriors[realmnumD].StoneSpearFighter = RealmNoWarriors[realmnumD].StoneSpearFighter - 1;

    }

    if ( RealmNoWarriors[realmnumD].StoneArrowBowFighter > 10) {


        RealmNoWarriors[realmnumD].StoneArrowBowFighter = RealmNoWarriors[realmnumD].StoneArrowBowFighter - 1;

    }







if ( RealmNoAttackers[realmnum].WoodenClubFighter > 10) {

        RealmNoAttackers[realmnum].WoodenClubFighter = RealmNoAttackers[realmnum].WoodenClubFighter - (( RealmNoAttackers[realmnum].WoodenClubFighter * 30 ) / 100 );
        

    }

    if ( RealmNoAttackers[realmnum].StoneAxeFighter > 10) {

        RealmNoAttackers[realmnum].StoneAxeFighter = RealmNoAttackers[realmnum].StoneAxeFighter - (( RealmNoAttackers[realmnum].StoneAxeFighter * 30 ) / 100 );
        

    }

    if ( RealmNoAttackers[realmnum].StoneSpearFighter > 10) {

        RealmNoAttackers[realmnum].StoneSpearFighter = RealmNoAttackers[realmnum].StoneSpearFighter - (( RealmNoAttackers[realmnum].StoneSpearFighter * 30 ) / 100 );
        

    }

    if ( RealmNoAttackers[realmnum].StoneArrowBowFighter > 10) {

        RealmNoAttackers[realmnum].StoneArrowBowFighter = RealmNoAttackers[realmnum].StoneArrowBowFighter - (( RealmNoAttackers[realmnum].StoneArrowBowFighter * 30 ) / 100 );
        

    }










} else {



RealmNoWarRecords[realmnum][RealmNoWarCount[realmnum]].Result = 1;
RealmNoWarRecords[realmnumD][RealmNoWarCount[realmnumD]].Result = 2;





if ( RealmNoWarriors[realmnumD].WoodenClubFighter > 10) {

        RealmNoWarriors[realmnumD].WoodenClubFighter = RealmNoWarriors[realmnumD].WoodenClubFighter - (( RealmNoWarriors[realmnumD].WoodenClubFighter * 20 ) / 100 );
        

    }

    if ( RealmNoWarriors[realmnumD].StoneAxeFighter > 10) {

        RealmNoWarriors[realmnumD].StoneAxeFighter = RealmNoWarriors[realmnumD].StoneAxeFighter - (( RealmNoWarriors[realmnumD].StoneAxeFighter * 20 ) / 100 );
        

    }

    if ( RealmNoWarriors[realmnumD].StoneSpearFighter > 10) {

        RealmNoWarriors[realmnumD].StoneSpearFighter = RealmNoWarriors[realmnumD].StoneSpearFighter - (( RealmNoWarriors[realmnumD].StoneSpearFighter * 20 ) / 100 );
        

    }

    if ( RealmNoWarriors[realmnumD].StoneArrowBowFighter > 10) {

        RealmNoWarriors[realmnumD].StoneArrowBowFighter = RealmNoWarriors[realmnumD].StoneArrowBowFighter - (( RealmNoWarriors[realmnumD].StoneArrowBowFighter * 20 ) / 100 );
        

    }







if ( RealmNoAttackers[realmnum].WoodenClubFighter > 10) {

 

        RealmNoAttackers[realmnum].WoodenClubFighter = RealmNoAttackers[realmnum].WoodenClubFighter - 1;

    }

    if ( RealmNoAttackers[realmnum].StoneAxeFighter > 10) {



        RealmNoAttackers[realmnum].StoneAxeFighter = RealmNoAttackers[realmnum].StoneAxeFighter - 1;

    }

    if ( RealmNoAttackers[realmnum].StoneSpearFighter > 10) {


        RealmNoAttackers[realmnum].StoneSpearFighter = RealmNoAttackers[realmnum].StoneSpearFighter - 1;

    }

    if ( RealmNoAttackers[realmnum].StoneArrowBowFighter > 10) {


        RealmNoAttackers[realmnum].StoneArrowBowFighter = RealmNoAttackers[realmnum].StoneArrowBowFighter - 1;

    }




if ( RealmNo[realmnumD].food > 100000) {

        RealmNo[realmnum].food = RealmNo[realmnum].food + ( ( RealmNo[realmnumD].food * 30 ) / 100 );
        RealmNo[realmnumD].food = RealmNo[realmnumD].food - ( ( RealmNo[realmnumD].food * 30 ) / 100 );

}


if ( RealmNo[realmnumD].wood > 100000) {

        RealmNo[realmnum].wood = RealmNo[realmnum].wood + ( ( RealmNo[realmnumD].wood * 30 ) / 100 );
        RealmNo[realmnumD].wood = RealmNo[realmnumD].wood - ( ( RealmNo[realmnumD].wood * 30 ) / 100 );

}


if ( RealmNo[realmnumD].stone > 100000) {
        
        RealmNo[realmnum].stone = RealmNo[realmnum].stone + ( ( RealmNo[realmnumD].stone * 30 ) / 100 );
        RealmNo[realmnumD].stone = RealmNo[realmnumD].stone - ( ( RealmNo[realmnumD].stone * 30 ) / 100 );

}



if ( RealmNoProducts[realmnumD].WoodenClub > 10) {

        RealmNoProducts[realmnum].WoodenClub = RealmNoProducts[realmnum].WoodenClub + ( ( RealmNoProducts[realmnumD].WoodenClub * 30 ) / 100 );
        RealmNoProducts[realmnumD].WoodenClub = RealmNoProducts[realmnumD].WoodenClub - ( ( RealmNoProducts[realmnumD].WoodenClub * 30 ) / 100 );

}


if ( RealmNoProducts[realmnumD].StoneAxe > 10) {

        RealmNoProducts[realmnum].StoneAxe = RealmNoProducts[realmnum].StoneAxe + ( ( RealmNoProducts[realmnumD].StoneAxe * 30 ) / 100 );
        RealmNoProducts[realmnumD].StoneAxe = RealmNoProducts[realmnumD].StoneAxe - ( ( RealmNoProducts[realmnumD].StoneAxe * 30 ) / 100 );

}


if ( RealmNoProducts[realmnumD].StoneSpear > 10) {

        RealmNoProducts[realmnum].StoneSpear = RealmNoProducts[realmnum].StoneSpear + ( ( RealmNoProducts[realmnumD].StoneSpear * 30 ) / 100 );
        RealmNoProducts[realmnumD].StoneSpear = RealmNoProducts[realmnumD].StoneSpear - ( ( RealmNoProducts[realmnumD].StoneSpear * 30 ) / 100 );

}

if ( RealmNoProducts[realmnumD].StoneArrowBow > 10) {

        RealmNoProducts[realmnum].StoneArrowBow = RealmNoProducts[realmnum].StoneArrowBow + ( ( RealmNoProducts[realmnumD].StoneArrowBow * 30 ) / 100 );
        RealmNoProducts[realmnumD].StoneArrowBow = RealmNoProducts[realmnumD].StoneArrowBow - ( ( RealmNoProducts[realmnumD].StoneArrowBow * 30 ) / 100 );

}












}



                        RealmNo[realmnum].underAttack = 0;

                        RealmNo[realmnum].underAttackAdres = msg.sender;

                        RealmNoWarriors[realmnum].WoodenClubFighter = RealmNoWarriors[realmnum].WoodenClubFighter + RealmNoAttackers[realmnum].WoodenClubFighter;
                        RealmNoWarriors[realmnum].StoneAxeFighter = RealmNoWarriors[realmnum].StoneAxeFighter + RealmNoAttackers[realmnum].StoneAxeFighter;
                        RealmNoWarriors[realmnum].StoneSpearFighter = RealmNoWarriors[realmnum].StoneSpearFighter + RealmNoAttackers[realmnum].StoneSpearFighter;
                        RealmNoWarriors[realmnum].StoneArrowBowFighter = RealmNoWarriors[realmnum].StoneArrowBowFighter + RealmNoAttackers[realmnum].StoneArrowBowFighter;

                        RealmNoAttackers[realmnum].WoodenClubFighter = 0;
                        RealmNoAttackers[realmnum].StoneAxeFighter = 0;
                        RealmNoAttackers[realmnum].StoneSpearFighter = 0;
                        RealmNoAttackers[realmnum].StoneArrowBowFighter = 0;


                        RealmNoAttacking[realmnum] = 0;


                        RealmNo[realmnumD].warAlert = 1;


                    } else {

                        RealmNoAttacking[realmnum] = RealmNoAttacking[realmnum] - useTurnGx.turnUse;


                    }




                }


            }












            if (RealmNo[realmnum].underProduction == 1 && useTurnGx.cancelproduction == 1) {


                if (RealmNo[realmnum].underProductionName == 1) {

                        RealmNo[realmnum].wood = RealmNo[realmnum].wood + ( RealmNo[realmnum].underProductionQuantity * 50000 );


                        } else if (RealmNo[realmnum].underProductionName == 2) {

                        RealmNo[realmnum].wood = RealmNo[realmnum].wood + ( RealmNo[realmnum].underProductionQuantity * 50000 );
                        RealmNo[realmnum].stone = RealmNo[realmnum].stone + ( RealmNo[realmnum].underProductionQuantity * 25000 );


                        } else if (RealmNo[realmnum].underProductionName == 3) {

                        RealmNo[realmnum].wood = RealmNo[realmnum].wood + ( RealmNo[realmnum].underProductionQuantity * 60000 );
                        RealmNo[realmnum].stone = RealmNo[realmnum].stone + ( RealmNo[realmnum].underProductionQuantity * 15000 );


                        } else if (RealmNo[realmnum].underProductionName == 4) {

                        RealmNo[realmnum].wood = RealmNo[realmnum].wood + ( RealmNo[realmnum].underProductionQuantity * 50000 );
                        RealmNo[realmnum].stone = RealmNo[realmnum].stone + ( RealmNo[realmnum].underProductionQuantity * 10000 );


                        }


                        RealmNo[realmnum].underProduction = 0;
                        RealmNo[realmnum].underProductionName = 0;
                        RealmNo[realmnum].underProductionQuantity = 0;




            }











                if ( RealmNo[realmnum].underProduction == 1) {




                 if ( useTurnGx.turnUse >= RealmNoProducing[realmnum] ) {



                        if (RealmNo[realmnum].underProductionName == 1) {

                            RealmNoProducts[realmnum].WoodenClub = RealmNoProducts[realmnum].WoodenClub + RealmNo[realmnum].underProductionQuantity;


                        } else if (RealmNo[realmnum].underProductionName == 2) {

                            RealmNoProducts[realmnum].StoneAxe = RealmNoProducts[realmnum].StoneAxe + RealmNo[realmnum].underProductionQuantity;


                        } else if (RealmNo[realmnum].underProductionName == 3) {

                            RealmNoProducts[realmnum].StoneSpear = RealmNoProducts[realmnum].StoneSpear + RealmNo[realmnum].underProductionQuantity;


                        } else if (RealmNo[realmnum].underProductionName == 4) {

                            RealmNoProducts[realmnum].StoneArrowBow = RealmNoProducts[realmnum].StoneArrowBow + RealmNo[realmnum].underProductionQuantity;


                        }

                        RealmNo[realmnum].underProduction = 0;
                        RealmNo[realmnum].underProductionName = 0;
                        RealmNo[realmnum].underProductionQuantity = 0;


                    } else {

                        RealmNoProducing[realmnum] = RealmNoProducing[realmnum] - useTurnGx.turnUse;


                    }
                




            } else {

                if ( useTurnGx.productQuantity != 0) {


                        RealmNo[realmnum].underProduction = 1;
                        RealmNo[realmnum].underProductionName = useTurnGx.product;
                        RealmNo[realmnum].underProductionQuantity = useTurnGx.productQuantity;
                        RealmNo[realmnum].food = RealmNo[realmnum].food - ( useTurnGx.productManPower * 1000);

                        if (useTurnGx.product == 1) {

                        RealmNoProducing[realmnum] = ( useTurnGx.productQuantity * 300 ) / useTurnGx.productManPower;
                        RealmNo[realmnum].wood = RealmNo[realmnum].wood - ( useTurnGx.productQuantity * 100000 );
                        


                        } else if (useTurnGx.product == 2) {

                        RealmNoProducing[realmnum] = ( useTurnGx.productQuantity * 500 ) / useTurnGx.productManPower;
                        RealmNo[realmnum].wood = RealmNo[realmnum].wood - ( useTurnGx.productQuantity * 100000 );
                        RealmNo[realmnum].stone = RealmNo[realmnum].stone - ( useTurnGx.productQuantity * 50000 );



                        } else if (useTurnGx.product == 3) {

                        RealmNoProducing[realmnum] = ( useTurnGx.productQuantity * 500 ) / useTurnGx.productManPower;
                        RealmNo[realmnum].wood = RealmNo[realmnum].wood - ( useTurnGx.productQuantity * 120000 );
                        RealmNo[realmnum].stone = RealmNo[realmnum].stone - ( useTurnGx.productQuantity * 60000 );



                        } else if (useTurnGx.product == 4) {

                        RealmNoProducing[realmnum] = ( useTurnGx.productQuantity * 600 ) / useTurnGx.productManPower;
                        RealmNo[realmnum].wood = RealmNo[realmnum].wood - ( useTurnGx.productQuantity * 100000 );
                        RealmNo[realmnum].stone = RealmNo[realmnum].stone - ( useTurnGx.productQuantity * 20000 );



                        }







                    if ( useTurnGx.turnUse >= RealmNoProducing[realmnum] ) {



                        if (RealmNo[realmnum].underProductionName == 1) {

                            RealmNoProducts[realmnum].WoodenClub = RealmNoProducts[realmnum].WoodenClub + RealmNo[realmnum].underProductionQuantity;


                        } else if (RealmNo[realmnum].underProductionName == 2) {

                            RealmNoProducts[realmnum].StoneAxe = RealmNoProducts[realmnum].StoneAxe + RealmNo[realmnum].underProductionQuantity;


                        } else if (RealmNo[realmnum].underProductionName == 3) {

                            RealmNoProducts[realmnum].StoneSpear = RealmNoProducts[realmnum].StoneSpear + RealmNo[realmnum].underProductionQuantity;


                        } else if (RealmNo[realmnum].underProductionName == 4) {

                            RealmNoProducts[realmnum].StoneArrowBow = RealmNoProducts[realmnum].StoneArrowBow + RealmNo[realmnum].underProductionQuantity;


                        }

                        RealmNo[realmnum].underProduction = 0;
                        RealmNo[realmnum].underProductionName = 0;
                        RealmNo[realmnum].underProductionQuantity = 0;


                    } else {

                        RealmNoProducing[realmnum] = RealmNoProducing[realmnum] - useTurnGx.turnUse;


                    }




                }


            }





























if ( RealmNo[realmnum].underTraining == 1) {




                 if ( useTurnGx.turnUse >= RealmNoTraining[realmnum] ) {



                        if (RealmNo[realmnum].underTrainingName == 1) {

                            RealmNoWarriors[realmnum].WoodenClubFighter = RealmNoWarriors[realmnum].WoodenClubFighter + RealmNo[realmnum].underTrainingQuantity;


                        } else if (RealmNo[realmnum].underTrainingName == 2) {

                            RealmNoWarriors[realmnum].StoneAxeFighter = RealmNoWarriors[realmnum].StoneAxeFighter + RealmNo[realmnum].underTrainingQuantity;


                        } else if (RealmNo[realmnum].underTrainingName == 3) {

                            RealmNoWarriors[realmnum].StoneSpearFighter = RealmNoWarriors[realmnum].StoneSpearFighter + RealmNo[realmnum].underTrainingQuantity;


                        } else if (RealmNo[realmnum].underTrainingName == 4) {

                            RealmNoWarriors[realmnum].StoneArrowBowFighter = RealmNoWarriors[realmnum].StoneArrowBowFighter + RealmNo[realmnum].underTrainingQuantity;


                        }

                        RealmNo[realmnum].underTraining = 0;
                        RealmNo[realmnum].underTrainingName = 0;
                        RealmNo[realmnum].underTrainingQuantity = 0;


                    } else {

                        RealmNoTraining[realmnum] = RealmNoTraining[realmnum] - useTurnGx.turnUse;


                    }
                




            } else {

                if ( useTurnGx.warriorQuantity != 0) {

                    if ( RealmNo[realmnum].popT >= useTurnGx.warriorQuantity ) {

                        RealmNo[realmnum].underTraining = 1;
                        RealmNo[realmnum].underTrainingName = useTurnGx.warrior;
                        RealmNo[realmnum].underTrainingQuantity = useTurnGx.warriorQuantity;

                        if (useTurnGx.warrior == 1) {

                        RealmNoTraining[realmnum] = useTurnGx.warriorQuantity * 4 ;
                        RealmNoProducts[realmnum].WoodenClub = RealmNoProducts[realmnum].WoodenClub - ( useTurnGx.warriorQuantity * 10 );



                        } else if (useTurnGx.warrior == 2) {

                        RealmNoTraining[realmnum] = useTurnGx.warriorQuantity * 6 ;
                        RealmNoProducts[realmnum].StoneAxe = RealmNoProducts[realmnum].StoneAxe - ( useTurnGx.warriorQuantity * 10 );



                        } else if (useTurnGx.warrior == 3) {

                        RealmNoTraining[realmnum] = useTurnGx.warriorQuantity * 8 ;
                        RealmNoProducts[realmnum].StoneSpear = RealmNoProducts[realmnum].StoneSpear - ( useTurnGx.warriorQuantity * 10 );



                        } else if (useTurnGx.warrior == 4) {

                        RealmNoTraining[realmnum] = useTurnGx.warriorQuantity * 6 ;
                        RealmNoProducts[realmnum].StoneArrowBow = RealmNoProducts[realmnum].StoneArrowBow - ( useTurnGx.warriorQuantity * 10 );



                        }




                    }


                    if ( useTurnGx.turnUse >= RealmNoTraining[realmnum] ) {



                        if (RealmNo[realmnum].underTrainingName == 1) {

                            RealmNoWarriors[realmnum].WoodenClubFighter = RealmNoWarriors[realmnum].WoodenClubFighter + RealmNo[realmnum].underTrainingQuantity;


                        } else if (RealmNo[realmnum].underTrainingName == 2) {

                            RealmNoWarriors[realmnum].StoneAxeFighter = RealmNoWarriors[realmnum].StoneAxeFighter + RealmNo[realmnum].underTrainingQuantity;


                        } else if (RealmNo[realmnum].underTrainingName == 3) {

                            RealmNoWarriors[realmnum].StoneSpearFighter = RealmNoWarriors[realmnum].StoneSpearFighter + RealmNo[realmnum].underTrainingQuantity;


                        } else if (RealmNo[realmnum].underTrainingName == 4) {

                            RealmNoWarriors[realmnum].StoneArrowBowFighter = RealmNoWarriors[realmnum].StoneArrowBowFighter + RealmNo[realmnum].underTrainingQuantity;


                        }

                        RealmNo[realmnum].underTraining = 0;
                        RealmNo[realmnum].underTrainingName = 0;
                        RealmNo[realmnum].underTrainingQuantity = 0;


                    } else {

                        RealmNoTraining[realmnum] = RealmNoTraining[realmnum] - useTurnGx.turnUse;


                    }




                }


            }







































 

        token_Tech.techRateClear(realmnum);

        RealmNoResearching[realmnum][useTurnGx.res1] = RealmNoResearching[realmnum][useTurnGx.res1] + ( ( useTurnGx.res1am * useTurnGx.turnUse * 1000 ) / 100 );
        token_Tech.RealmNoResearchRatex(realmnum, useTurnGx.res1, useTurnGx.res1am);
        if (RealmNoResearching[realmnum][useTurnGx.res1] >= Techs[useTurnGx.res1]) {
            checktech(realmnum, useTurnGx.res1);
        }

        RealmNoResearching[realmnum][useTurnGx.res2] = RealmNoResearching[realmnum][useTurnGx.res2] + ( ( useTurnGx.res2am * useTurnGx.turnUse * 1000 ) / 100 );
        token_Tech.RealmNoResearchRatex(realmnum, useTurnGx.res2, useTurnGx.res2am);
        if (RealmNoResearching[realmnum][useTurnGx.res2] >= Techs[useTurnGx.res2]) {
            checktech(realmnum, useTurnGx.res2);
        }

        RealmNoResearching[realmnum][useTurnGx.res3] = RealmNoResearching[realmnum][useTurnGx.res3] + ( ( useTurnGx.res3am * useTurnGx.turnUse * 1000 ) / 100 );
        token_Tech.RealmNoResearchRatex(realmnum, useTurnGx.res3, useTurnGx.res3am);
        if (RealmNoResearching[realmnum][useTurnGx.res3] >= Techs[useTurnGx.res3]) {
            checktech(realmnum, useTurnGx.res3);
        }







        if ( RealmNo[realmnum].popT > RealmNo[realmnum].popMax ) {
            RealmNo[realmnum].popT = RealmNo[realmnum].popMax;
        }
        if ( RealmNo[realmnum].food > RealmNo[realmnum].foodMax ) {
            RealmNo[realmnum].food = RealmNo[realmnum].foodMax;
        }
        if ( RealmNo[realmnum].wood > RealmNo[realmnum].woodMax ) {
            RealmNo[realmnum].wood = RealmNo[realmnum].woodMax;
        }
        if ( RealmNo[realmnum].stone > RealmNo[realmnum].stoneMax ) {
            RealmNo[realmnum].stone = RealmNo[realmnum].stoneMax;
        }



        RealmNo[realmnum].warAlert = 0;

        RealmNo[realmnum].points = 10;

        RealmNo[realmnum].points = RealmNo[realmnum].points + (( block.timestamp - RealmNo[realmnum].start) / 100 );

        RealmNo[realmnum].points = RealmNo[realmnum].points + (( RealmNo[realmnum].popT * 5 ) / 1000 );

        RealmNo[realmnum].points = RealmNo[realmnum].points + (( RealmNo[realmnum].food ) / 1000 );
        RealmNo[realmnum].points = RealmNo[realmnum].points + (( RealmNo[realmnum].wood * 2 ) / 1000 );
        RealmNo[realmnum].points = RealmNo[realmnum].points + (( RealmNo[realmnum].stone * 3 ) / 1000 );

        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoProducts[realmnum].WoodenClub * 50);
        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoProducts[realmnum].StoneAxe * 200);
        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoProducts[realmnum].StoneSpear * 180);
        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoProducts[realmnum].StoneArrowBow * 100);

        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoWarriors[realmnum].WoodenClubFighter * 500);
        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoWarriors[realmnum].StoneAxeFighter * 800);
        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoWarriors[realmnum].StoneSpearFighter * 920);
        RealmNo[realmnum].points = RealmNo[realmnum].points + ( RealmNoWarriors[realmnum].StoneArrowBowFighter * 600);


        emit e_useturn(msg.sender, useTurnGx.turnUse);

        }

	}






    function checktech(uint256 realmidx, string memory techname) private{
         
        if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Gathering'))) {

            RealmNoResearches[realmidx].Gathering = 2;
            RealmNoResearches[realmidx].StoneCutting = 1;
            RealmNoResearches[realmidx].WoodCutting = 1;

            RealmNo[realmidx].popRate = 100;
            RealmNo[realmidx].foodRate = 34;
            RealmNo[realmidx].woodRate = 33;
            RealmNo[realmidx].stoneRate = 33;

            PopLaborAreas[realmidx].FoodGathering = 1;
            PopLaborAreas[realmidx].WoodGathering = 1;
            PopLaborAreas[realmidx].StoneGathering = 1;


       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('WoodCutting'))) {

            RealmNoResearches[realmidx].WoodCutting = 2;
            RealmNoResearches[realmidx].WoodenClub = 1;

            RealmNo[realmidx].productionRate = 0;
            PopLaborAreas[realmidx].Production = 1;

            if (RealmNoResearches[realmidx].StoneCutting == 2) {

                RealmNoResearches[realmidx].StoneTools = 1;
                RealmNoResearches[realmidx].StoneAxe = 1;
                RealmNoResearches[realmidx].StoneKnife = 1;
                RealmNoResearches[realmidx].StoneSpear = 1;
                RealmNoResearches[realmidx].StoneArrowBow = 1;
            }

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneCutting'))) {

            RealmNoResearches[realmidx].StoneCutting = 2;

            if (RealmNoResearches[realmidx].WoodCutting == 2) {

                RealmNoResearches[realmidx].StoneTools = 1;
                RealmNoResearches[realmidx].StoneAxe = 1;
                RealmNoResearches[realmidx].StoneKnife = 1;
                RealmNoResearches[realmidx].StoneSpear = 1;
                RealmNoResearches[realmidx].StoneArrowBow = 1;
            }

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneTools'))) {

            RealmNoResearches[realmidx].StoneTools = 2;
            RealmNoResearches[realmidx].ControlOfFire = 1;
            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 6;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('WoodenClub'))) {

            RealmNoResearches[realmidx].WoodenClub = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneAxe'))) {

            RealmNoResearches[realmidx].StoneAxe = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneKnife'))) {

            RealmNoResearches[realmidx].StoneKnife = 2;
            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 6;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneSpear'))) {

            RealmNoResearches[realmidx].StoneSpear = 2;
            RealmNoResearches[realmidx].Hunting = 1;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneArrowBow'))) {

            RealmNoResearches[realmidx].StoneArrowBow = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Hunting'))) {

            RealmNoResearches[realmidx].Hunting = 2;
            RealmNoResearches[realmidx].Taming = 1;
            RealmNoResearches[realmidx].Fishing = 1;

            if (RealmNoResearches[realmidx].ControlOfFire == 2) {

                RealmNoResearches[realmidx].Farming = 1;
            }

            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 8;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('ControlOfFire'))) {

            RealmNoResearches[realmidx].ControlOfFire = 2;
            RealmNoResearches[realmidx].Rope = 1;
            RealmNoResearches[realmidx].Clothing = 1;

            if (RealmNoResearches[realmidx].Rope == 2) {

                RealmNoResearches[realmidx].WoodenBoat = 1;
            }
            if (RealmNoResearches[realmidx].Hunting == 2) {

                RealmNoResearches[realmidx].Farming = 1;
            }
            if (RealmNoResearches[realmidx].Taming == 2 && RealmNoResearches[realmidx].Fishing == 2) {

                RealmNoResearches[realmidx].Cooking = 1;
            }

            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 10;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Taming'))) {

            RealmNoResearches[realmidx].Taming = 2;

            if (RealmNoResearches[realmidx].ControlOfFire == 2 && RealmNoResearches[realmidx].Fishing == 2) {

                RealmNoResearches[realmidx].Cooking = 1;
            }

            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 9;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Fishing'))) {

            RealmNoResearches[realmidx].Fishing = 2;

            if (RealmNoResearches[realmidx].ControlOfFire == 2 && RealmNoResearches[realmidx].Taming == 2) {

                RealmNoResearches[realmidx].Cooking = 1;
            }

            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 9;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Rope'))) {

            RealmNoResearches[realmidx].Rope = 2;

            if (RealmNoResearches[realmidx].Bed == 2 && RealmNoResearches[realmidx].Farming == 2) {

                RealmNoResearches[realmidx].Settlement = 1;
            }
            if (RealmNoResearches[realmidx].ControlOfFire == 2) {

                RealmNoResearches[realmidx].WoodenBoat = 1;
            }

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('WoodenBoat'))) {

            RealmNoResearches[realmidx].WoodenBoat = 2;
            RealmNoResearches[realmidx].Harpoon = 1;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Clothing'))) {

            RealmNoResearches[realmidx].Clothing = 2;
            RealmNoResearches[realmidx].Bed = 1;
            RealmNoResearches[realmidx].Shoes = 1;
            RealmNoResearches[realmidx].Weaving = 1;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Cooking'))) {

            RealmNoResearches[realmidx].Cooking = 2;
            RealmNoResearches[realmidx].Ceramics = 1;

            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 12;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Harpoon'))) {

            RealmNoResearches[realmidx].Harpoon = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Bed'))) {

            RealmNoResearches[realmidx].Bed = 2;

            if (RealmNoResearches[realmidx].Rope == 2 && RealmNoResearches[realmidx].Farming == 2) {

                RealmNoResearches[realmidx].Settlement = 1;
            }


       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Shoes'))) {

            RealmNoResearches[realmidx].Shoes = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Weaving'))) {

            RealmNoResearches[realmidx].Weaving = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Ceramics'))) {

            RealmNoResearches[realmidx].Ceramics = 2;
            RealmNoResearches[realmidx].Pottery = 1;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Pottery'))) {

            RealmNoResearches[realmidx].Pottery = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Farming'))) {

            RealmNoResearches[realmidx].Farming = 2;

            if (RealmNoResearches[realmidx].Rope == 2 && RealmNoResearches[realmidx].Bed == 2) {

                RealmNoResearches[realmidx].Settlement = 1;
            }

            RealmNo[realmidx].foodFactor = RealmNo[realmidx].foodFactor + 15;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Settlement'))) {

            RealmNoResearches[realmidx].Settlement = 2;

       }







	}




    function RealmNoResearchesx(uint256 user_id) public view returns (Tech memory) {
            return RealmNoResearches[user_id];
    }

    function PopLaborAreasx (uint256 user_id) public view returns (LaborArea memory) {
            return PopLaborAreas[user_id];
    }

    function RealmNox(uint256 user_id) public view returns (Realms memory) {
            return RealmNo[user_id];
    }

    function RealmNoResearchRate(uint256 user_id, string memory techname) public view returns (uint256) {
            uint256 amount = token_Tech.RealmNoResearchRatey(user_id, techname);
            return amount;
    }



    
function addFeedback(string memory contenty_) public {



    Feedbacks[FeedbackNo].commenter = msg.sender;
    Feedbacks[FeedbackNo].content = contenty_;
    FeedbackNo++;

    emit e_addFeedback(msg.sender, contenty_);
		}



	
}