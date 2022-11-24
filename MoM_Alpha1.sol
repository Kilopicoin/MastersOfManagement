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

contract RoM {

    struct Realms{
        uint256 turn;
        uint256 start;
        uint256 points;
        string name;
        address ruler;
        uint256 popT;
        uint256 popRate;
        uint256 food;
        uint256 foodRate;
        uint256 wood;
        uint256 woodRate;
        uint256 stone;
        uint256 stoneRate;
    }

struct Feedback{
    address commenter;
    string content;
}

    struct Tech{
        uint256 Gathering;
        uint256 StoneCutting; // 0 for unable, 1 for able, 2 for finalized
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
        uint256 WoodGathering; // 0 for unable, 1 for able
        uint256 StoneGathering;
        uint256 Hunting;
    }
	
    mapping (uint256 => mapping (string => uint256)) public RealmNoResearchRate;
    mapping (uint256 => mapping (string => uint256)) public RealmNoResearching;
    mapping (uint256 => Tech) internal RealmNoResearches;
    mapping (uint256 => LaborArea) internal PopLaborAreas;
    mapping (uint256 => Feedback) public Feedbacks;

	address public owner;
    uint256 public RealmCount;
    uint256 public startWorld;
    uint256 public finishWorld;
    string _namex;
    bool public statusWorld;
    mapping (string => uint256) public Techs;
    uint256 public FeedbackNo;
    string content__;
    IHRC20 public token;
    uint256 xyzaprizex_;
    uint256 public prize;

    uint256 turnUseFu;
    string res1Fu;
    uint256 res1amFu;
    string res2Fu;
    uint256 res2amFu;
    string res3Fu;
    uint256 res3amFu;
    uint256 foodRatexy;
    uint256 woodRatexy;
    uint256 stoneRatexy;


	constructor (uint256 lifeWorld, IHRC20 _token) public {
       RealmCount = 0;
       prize = 0;
       token = _token;
       owner = msg.sender;
       startWorld = block.timestamp;
//       finishWorld = block.timestamp + ( lifeWorld * 86400 );
     finishWorld = block.timestamp + ( lifeWorld * 600 );
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
	mapping(address => uint256) public RealmCreated;

	receive() external payable {
        addRealm(_namex);
        addFeedback(content__);
        prizeadd(xyzaprizex_);
        useTurn(turnUseFu, res1Fu, res1amFu, res2Fu, res2amFu, res3Fu, res3amFu, foodRatexy, woodRatexy, stoneRatexy);
    }
	
	function addRealm(string memory _name) payable public {
        require(statusWorld, "World is not active");
        require(RealmCreated[msg.sender] == 0, "Sender already created a Realm.");
        RealmCount++;
        RealmCreated[msg.sender] = RealmCount;
		RealmNo[RealmCount] = Realms(5005,block.timestamp,0,_name,msg.sender,2000,0,0,0,0,0,0,0);
//        RealmNo[RealmCount] = Realms(300,block.timestamp,0,_name,msg.sender,2,0,0,0,0,0,0,0);
        RealmNoResearches[RealmCount] = Tech(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        PopLaborAreas[RealmCount] = LaborArea(0,0,0,0);
		emit e_addRealm(msg.sender);
	}
	
    function calcTurn() public {
        require(RealmCreated[msg.sender] != 0, "Sender does not have a Realm created");
        uint256 realmnum = RealmCreated[msg.sender];
		RealmNo[realmnum].turn = RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600 );
        if (RealmNo[realmnum].turn > 5005) {
            RealmNo[realmnum].turn = 5005;
//        if (RealmNo[realmnum].turn > 300) {
//            RealmNo[realmnum].turn = 300;
        }
	}

    function setStatusWorld() public {
        require(msg.sender == owner, "Only owner can change the status");
        require(block.timestamp < finishWorld, "World has been finalized");
        if (statusWorld == false) {
            statusWorld = true;
        } else 
        statusWorld = false;
	}


    function getTurn(address Accc) public view returns (uint256) {
        uint256 realmnum = RealmCreated[Accc];
        if (RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600 ) > 5005) {
            return 5005 ;
//        if (RealmNo[realmnum].turn + ((block.timestamp - RealmNo[realmnum].start) / 600 ) > 300) {
//            return 300 ;
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


    function prizeadd(uint256 xyzaprize_) payable public {
        require(msg.sender == owner, "only owner");
        require(statusWorld, "World is not active");
        require(token.balanceOf(address(msg.sender)) > xyzaprize_, "must be more than balance");
        token.transferFrom(msg.sender,(address(this)),xyzaprize_);
        prize = prize + xyzaprize_;
}


    function useTurn(uint256 turnUse,
     string memory res1, uint256 res1am, string memory res2, uint256 res2am, string memory res3, uint256 res3am,
     uint256 foodRatex, uint256 woodRatex, uint256 stoneRatex
     ) public payable{
        require(statusWorld, "World is not active");

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

            emit e_useturn(msg.sender, turnUse);



        } else {

        require(RealmCreated[msg.sender] != 0, "Sender does not have a Realm created");
        calcTurn();
        uint256 realmnum = RealmCreated[msg.sender];
		require(RealmNo[realmnum].turn >= turnUse, "Not enough turn to use");
        RealmNo[realmnum].turn = RealmNo[realmnum].turn - turnUse;
        RealmNo[realmnum].points = RealmNo[realmnum].points + turnUse;
        RealmNo[realmnum].start = block.timestamp;
        RealmNo[realmnum].popT = RealmNo[realmnum].popT + ( RealmNo[realmnum].popRate * turnUse );

        RealmNo[realmnum].foodRate = foodRatex;
        RealmNo[realmnum].woodRate = woodRatex;
        RealmNo[realmnum].stoneRate = stoneRatex;

        RealmNo[realmnum].food = RealmNo[realmnum].food + (( RealmNo[realmnum].foodRate * turnUse * RealmNo[realmnum].popT) / 100 );
        RealmNo[realmnum].wood = RealmNo[realmnum].wood + (( RealmNo[realmnum].woodRate * turnUse * RealmNo[realmnum].popT) / 100 );
        RealmNo[realmnum].stone = RealmNo[realmnum].stone + (( RealmNo[realmnum].stoneRate * turnUse * RealmNo[realmnum].popT) / 100 );

        techRateClear(realmnum); 

        uint256 res1amx = res1am * turnUse * 1000;
        RealmNoResearching[realmnum][res1] = RealmNoResearching[realmnum][res1] + ( res1amx / 100 );
        RealmNoResearchRate[realmnum][res1] = res1am;
        if (RealmNoResearching[realmnum][res1] >= Techs[res1]) {
            RealmNo[realmnum].points = RealmNo[realmnum].points + ( Techs[res1] / 10000 );
            checktech(realmnum, res1);
        }

        uint256 res2amx = res2am * turnUse * 1000;
        RealmNoResearching[realmnum][res2] = RealmNoResearching[realmnum][res2] + ( res2amx / 100 );
        RealmNoResearchRate[realmnum][res2] = res2am;
        if (RealmNoResearching[realmnum][res2] >= Techs[res2]) {
            RealmNo[realmnum].points = RealmNo[realmnum].points + ( Techs[res2] / 10000 );
            checktech(realmnum, res2);
        }

        uint256 res3amx = res3am * turnUse * 1000;
        RealmNoResearching[realmnum][res3] = RealmNoResearching[realmnum][res3] + ( res3amx / 100 );
        RealmNoResearchRate[realmnum][res3] = res3am;
        if (RealmNoResearching[realmnum][res3] >= Techs[res3]) {
            RealmNo[realmnum].points = RealmNo[realmnum].points + ( Techs[res3] / 10000 );
            checktech(realmnum, res3);
        }

        emit e_useturn(msg.sender, turnUse);

        }

	}



    function techRateClear(uint256 realmidxy) private{

        RealmNoResearchRate[realmidxy]["Gathering"] = 0;
        RealmNoResearchRate[realmidxy]["StoneCutting"] = 0;
        RealmNoResearchRate[realmidxy]["WoodCutting"] = 0;
        RealmNoResearchRate[realmidxy]["WoodenClub"] = 0;
        RealmNoResearchRate[realmidxy]["StoneTools"] = 0;
        RealmNoResearchRate[realmidxy]["StoneAxe"] = 0;
        RealmNoResearchRate[realmidxy]["StoneKnife"] = 0;
        RealmNoResearchRate[realmidxy]["StoneSpear"] = 0;
        RealmNoResearchRate[realmidxy]["StoneArrowBow"] = 0;
        RealmNoResearchRate[realmidxy]["Hunting"] = 0;
        RealmNoResearchRate[realmidxy]["ControlOfFire"] = 0;
        RealmNoResearchRate[realmidxy]["Taming"] = 0;
        RealmNoResearchRate[realmidxy]["Fishing"] = 0;
        RealmNoResearchRate[realmidxy]["Rope"] = 0;
        RealmNoResearchRate[realmidxy]["WoodenBoat"] = 0;
        RealmNoResearchRate[realmidxy]["Clothing"] = 0;
        RealmNoResearchRate[realmidxy]["Cooking"] = 0;
        RealmNoResearchRate[realmidxy]["Harpoon"] = 0;
        RealmNoResearchRate[realmidxy]["Bed"] = 0;
        RealmNoResearchRate[realmidxy]["Shoes"] = 0;
        RealmNoResearchRate[realmidxy]["Weaving"] = 0;
        RealmNoResearchRate[realmidxy]["Ceramics"] = 0;
        RealmNoResearchRate[realmidxy]["Pottery"] = 0;
        RealmNoResearchRate[realmidxy]["Farming"] = 0;
        RealmNoResearchRate[realmidxy]["Settlement"] = 0;

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

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('WoodenClub'))) {

            RealmNoResearches[realmidx].WoodenClub = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneAxe'))) {

            RealmNoResearches[realmidx].StoneAxe = 2;

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('StoneKnife'))) {

            RealmNoResearches[realmidx].StoneKnife = 2;

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

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Taming'))) {

            RealmNoResearches[realmidx].Taming = 2;

            if (RealmNoResearches[realmidx].ControlOfFire == 2 && RealmNoResearches[realmidx].Fishing == 2) {

                RealmNoResearches[realmidx].Cooking = 1;
            }

       } else if (keccak256(abi.encodePacked(techname)) == keccak256(abi.encodePacked('Fishing'))) {

            RealmNoResearches[realmidx].Fishing = 2;

            if (RealmNoResearches[realmidx].ControlOfFire == 2 && RealmNoResearches[realmidx].Taming == 2) {

                RealmNoResearches[realmidx].Cooking = 1;
            }

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



    function addFeedback(string memory contenty_) payable public {

    require(statusWorld, "World is not active");

    Feedbacks[FeedbackNo].commenter = msg.sender;
    Feedbacks[FeedbackNo].content = contenty_;
    FeedbackNo++;

    emit e_addFeedback(msg.sender, contenty_);
		}




	
}