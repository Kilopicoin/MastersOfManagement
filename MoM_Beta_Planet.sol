// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;


contract Planet {


struct Realm_Pos{

    address Ruler;
    int256 pX;
    int256 pY;

}

struct Realm_Res{

    uint256 popu;
    uint256 popuLimit;
    uint256 food;
    uint256 foodFactor;
    uint256 foodWorker;
    uint256 wood;
    uint256 woodFactor;
    uint256 woodWorker;

}

struct Realm_Buildingz{

    uint256 typeB;
    int256 posxB;
    int256 posyB;
    uint256 construction; // 0 ise bitmiş, değilse kalan tur
    uint256 research; // global araştırma kodu(2 den itibaren) ve yapının upgradei (1)
    uint256 researchProgress; // 0 ise bitti, değilse devam ediyor

}


struct Realm_TurnsX{

    uint256 start;
    uint256 turn;
}

address public owner;

address public A_Feedback;

bool public statusWorld;
uint256 public finishWorld;

uint256 public RealmCount;
    
    mapping(address => uint256) public RealmCreated;

    mapping (uint256 => string) public Realm_Name;
    mapping (uint256 => Realm_Pos) public Realm_PosX;
    mapping (uint256 => Realm_Res) public Realm_ResX;

    mapping (uint256 => Realm_TurnsX) public Realm_Turns; // Turn sayacı

    mapping (uint256 => int256) public Realm_Reputation; 
    // reputasyon sayacı -+ 2000 levels outcast despicable scoundrel unsavory rude neut fair kind good honest trustworthy

    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Diplomacy; 
    // ilişki kaydı - neut0 ally1 enemy2

    mapping (uint256 => uint256) public Realm_Clan; // Clan kaydı
    mapping (uint256 => string) public Clans; // Clanlar kaydı

    mapping (uint256 => uint256) public Realm_Points; // puan kaydı

    mapping (uint256 => uint256) public Realm_PopOrder; // ülke-kalan tur

    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Buildings; // tip ve adet sayacı
    mapping (uint256 => mapping (uint256 => Realm_Buildingz)) public Realm_BuildingzX; // numara ve tip-koordinat
    mapping (uint256 => uint256) public Realm_BuildingCount; // numara sayacı

    mapping (uint256 => bool) public Realm_PauseConstructions;
    mapping (uint256 => bool) public Realm_PauseResearches;


    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Techs; // no'lar tipi, 1-0 on-off
    mapping (uint256 => uint256) public Researches_Global; // 2 den baslıyor

    mapping (int256 => mapping (int256 => bool)) public Occupied; // x - y - dolu - boş

constructor (address feedbackAdres, uint256 lifeWorld)  {

    owner = msg.sender;
statusWorld = false;
A_Feedback = feedbackAdres;
finishWorld = block.timestamp + ( lifeWorld * 86400 );
Researches_Global[2] = 300; // araştırma 2
Researches_Global[3] = 300; // araştırma 3
Researches_Global[4] = 300; // araştırma 4
Researches_Global[5] = 300; // araştırma 5
Researches_Global[6] = 300; // araştırma 6

    }

struct useTurnG{
        uint256 turnA;
        uint256 foodworker;
        uint256 woodworker;
        uint256 poporder;
        uint256 poplinecancel;
        uint256 newbuilding;
        int256 newbuildingX;
        int256 newbuildingY;
        uint256 pauseConstructions;
        uint256 cancelConstruction;
        uint256 newresearch;
        uint256 newresearchBuildingID;
        uint256 cancelResearch;
        uint256 pauseResearches;
        
    }


function useTurn(useTurnG memory useTurnGx) public {

require(statusWorld, "Passive");

 if ( block.timestamp > finishWorld ) {
            statusWorld = false;
        } else {



        require(RealmCreated[msg.sender] != 0, "No Realm");
        calcTurn();
        uint256 realmnum = RealmCreated[msg.sender];
		require(Realm_Turns[realmnum].turn >= useTurnGx.turnA, "TurnX");
        require(Realm_ResX[realmnum].popu >= useTurnGx.foodworker + useTurnGx.woodworker, "PopLimit");

        
        Realm_Turns[realmnum].turn = Realm_Turns[realmnum].turn - useTurnGx.turnA;
        Realm_Turns[realmnum].start = block.timestamp;

        Realm_Reputation[realmnum] = Realm_Reputation[realmnum] + int256(useTurnGx.turnA) ;
        Realm_Points[realmnum] = Realm_Points[realmnum] + useTurnGx.turnA ;


        Realm_ResX[realmnum].foodWorker = useTurnGx.foodworker;
        Realm_ResX[realmnum].woodWorker = useTurnGx.woodworker;
        Realm_ResX[realmnum].food = Realm_ResX[realmnum].food + (Realm_ResX[realmnum].foodWorker * Realm_ResX[realmnum].foodFactor * useTurnGx.turnA);
        Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood + (Realm_ResX[realmnum].woodWorker * Realm_ResX[realmnum].woodFactor * useTurnGx.turnA);

        if (useTurnGx.poplinecancel == 1) {

            Realm_PopOrder[realmnum] = 0;

        }
        if (useTurnGx.poporder != 0) {
            if (Realm_PopOrder[realmnum] == 0 ) {
                Realm_PopOrder[realmnum] = useTurnGx.poporder * 60;
            }
        }




if ( useTurnGx.cancelResearch != 0 ){

    Realm_BuildingzX[realmnum][useTurnGx.cancelResearch].research = 0;
    Realm_BuildingzX[realmnum][useTurnGx.cancelResearch].researchProgress = 0;

}




if ( useTurnGx.pauseResearches == 1) {

    Realm_PauseResearches[realmnum] = true;

} else {

    Realm_PauseResearches[realmnum] = false;
}




if ( useTurnGx.newresearch > 1 ) {

    require(Realm_Techs[realmnum][useTurnGx.newresearch] == 0, "already done");
    require(Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].research == 0, "building busy");

    if ( useTurnGx.newresearch < 7  ) {

    require(Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].typeB == 4, "Workshop");

    Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].research = useTurnGx.newresearch;
    Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].researchProgress = Researches_Global[useTurnGx.newresearch];

    }

} else if ( useTurnGx.newresearch == 1 ) {


}





if ( Realm_PauseResearches[realmnum] == false ) {

for(uint k=0; k<Realm_BuildingCount[realmnum]; k++){
                uint c = k + 1;

if ( Realm_BuildingzX[realmnum][c].research != 0 ) {

    if ( Realm_BuildingzX[realmnum][c].researchProgress > useTurnGx.turnA ) {

        if ( Realm_BuildingzX[realmnum][c].research == 2 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 6);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 6);

        } else if ( Realm_BuildingzX[realmnum][c].research == 3 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 8);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 8);

        } else if ( Realm_BuildingzX[realmnum][c].research == 4 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 10);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 10);

        } else if ( Realm_BuildingzX[realmnum][c].research == 5 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 12);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 12);

        } else if ( Realm_BuildingzX[realmnum][c].research == 6 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 14);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 14);

        }

        Realm_BuildingzX[realmnum][c].researchProgress = Realm_BuildingzX[realmnum][c].researchProgress - useTurnGx.turnA;

    } else {


        if ( Realm_BuildingzX[realmnum][c].research == 2 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].researchProgress * 6);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].researchProgress * 6);
            Realm_ResX[realmnum].foodFactor = Realm_ResX[realmnum].foodFactor + 2;

        } else if ( Realm_BuildingzX[realmnum][c].research == 3 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].researchProgress * 8);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].researchProgress * 8);
            Realm_ResX[realmnum].woodFactor = Realm_ResX[realmnum].woodFactor + 2;

        } else if ( Realm_BuildingzX[realmnum][c].research == 4 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].researchProgress * 10);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].researchProgress * 10);
            Realm_ResX[realmnum].popuLimit = Realm_ResX[realmnum].popuLimit + 6;

        } else if ( Realm_BuildingzX[realmnum][c].research == 5 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].researchProgress * 12);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].researchProgress * 12);

        } else if ( Realm_BuildingzX[realmnum][c].research == 6 ) {

            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].researchProgress * 14);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].researchProgress * 14);

        }

        Realm_BuildingzX[realmnum][c].researchProgress = 0;
        Realm_Techs[realmnum][Realm_BuildingzX[realmnum][c].research] = 1;

        if ( Researches_Global[Realm_BuildingzX[realmnum][c].research] > 60) {
            Researches_Global[Realm_BuildingzX[realmnum][c].research] = Researches_Global[Realm_BuildingzX[realmnum][c].research] - 1;
        }
        Realm_BuildingzX[realmnum][c].research = 0;




    }


}


}

}










if ( useTurnGx.cancelConstruction != 0 ){

    delete Realm_BuildingzX[realmnum][useTurnGx.cancelConstruction];
}


if ( useTurnGx.pauseConstructions == 1) {

    Realm_PauseConstructions[realmnum] = true;

} else {

    Realm_PauseConstructions[realmnum] = false;
}




        if ( useTurnGx.newbuilding != 0) {

            Realm_BuildingCount[realmnum]++;
            
            if ( useTurnGx.newbuilding == 2 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(2,useTurnGx.newbuildingX,useTurnGx.newbuildingY,100,0,0);

            } else if ( useTurnGx.newbuilding == 3 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(3,useTurnGx.newbuildingX,useTurnGx.newbuildingY,300,0,0);

            } else if ( useTurnGx.newbuilding == 4 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(4,useTurnGx.newbuildingX,useTurnGx.newbuildingY,600,0,0);

            } else if ( useTurnGx.newbuilding == 5 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(5,useTurnGx.newbuildingX,useTurnGx.newbuildingY,600,0,0);

            } else if ( useTurnGx.newbuilding == 6 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(6,useTurnGx.newbuildingX,useTurnGx.newbuildingY,600,0,0);

            } else if ( useTurnGx.newbuilding == 7 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(7,useTurnGx.newbuildingX,useTurnGx.newbuildingY,600,0,0);

            } else if ( useTurnGx.newbuilding == 8 ) {

            Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(8,useTurnGx.newbuildingX,useTurnGx.newbuildingY,600,0,0);

            }

        } 

            
            
            
if ( Realm_PauseConstructions[realmnum] == false ) {
            
for(uint b=0; b<Realm_BuildingCount[realmnum]; b++){
                uint c = b + 1;

                if ( Realm_BuildingzX[realmnum][c].construction != 0 ) {

                    if ( Realm_BuildingzX[realmnum][c].construction > useTurnGx.turnA) {

                        if ( Realm_BuildingzX[realmnum][c].typeB == 2 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 6);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 6);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 3 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 10);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 10);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 4 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 20);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 5 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 20);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 6 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 20);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 7 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 20);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 8 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (useTurnGx.turnA * 20);
                    Realm_BuildingzX[realmnum][c].construction = Realm_BuildingzX[realmnum][c].construction - useTurnGx.turnA;
                        }

                    } else {

                        if ( Realm_BuildingzX[realmnum][c].typeB == 2 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 6);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 6);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                    Realm_ResX[realmnum].popuLimit = Realm_ResX[realmnum].popuLimit + 2;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 3 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 10);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 10);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                    Realm_ResX[realmnum].foodFactor = Realm_ResX[realmnum].foodFactor + 1;
                    Realm_ResX[realmnum].woodFactor = Realm_ResX[realmnum].woodFactor + 1;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 4 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 5 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 6 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 7 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                        } else if ( Realm_BuildingzX[realmnum][c].typeB == 8 ) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[realmnum][c].construction * 20);
                    Realm_BuildingzX[realmnum][c].construction = 0;
                        }

                    }


                }


}
}
        


        
        





        if (Realm_PopOrder[realmnum] != 0 ) {

            if (useTurnGx.turnA >= Realm_PopOrder[realmnum]) {

                require(Realm_ResX[realmnum].food >= Realm_PopOrder[realmnum] * 2, "Food");
                Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_PopOrder[realmnum] * 2);

                uint256 yenipop;
                if ( useTurnGx.poporder == 0 ) {

                    yenipop = ( Realm_PopOrder[realmnum] / 60 ) + 1;

                } else {

                    yenipop = ( Realm_PopOrder[realmnum] / 60 );

                }

            
                Realm_ResX[realmnum].popu = Realm_ResX[realmnum].popu + yenipop;
                Realm_PopOrder[realmnum] = 0;

            } else {

                require(Realm_ResX[realmnum].food >= useTurnGx.turnA * 2, "Food");
                Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (useTurnGx.turnA * 2);
                uint256 eski = Realm_PopOrder[realmnum] / 60;
                Realm_PopOrder[realmnum] = Realm_PopOrder[realmnum] - useTurnGx.turnA;
                uint256 yeni = Realm_PopOrder[realmnum] / 60;

                

                uint256 fark;
                if ( useTurnGx.poporder == 0 ) {
                    fark = eski - yeni;
                } else {
                    fark = (eski - yeni) - 1;
                }
                
                Realm_ResX[realmnum].popu = Realm_ResX[realmnum].popu + fark;

            }

        }



        }

     }



     function calcTurn() public {
        require(RealmCreated[msg.sender] != 0, "No Realm");
        uint256 realmnum = RealmCreated[msg.sender];
		Realm_Turns[realmnum].turn = Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 );
        if (Realm_Turns[realmnum].turn > 5005) {
            Realm_Turns[realmnum].turn = 5005;
   //     if (Realm_Turns[realmnum].turn > 300) {
    //        Realm_Turns[realmnum].turn = 300;
        }
	}





    function getTurn(address Accc) public view returns (uint256) {
        uint256 realmnum = RealmCreated[Accc];
        if (Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 ) > 5005) {
            return 5005 ;
  //      if (Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 ) > 300) {
   //         return 300 ;
        } else 
        return Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600) ;
        
    }





function addRealm(int256 pX, int256 pY, string memory name) public {

        require(statusWorld, "Wworld Inactive");

        require(RealmCreated[msg.sender] == 0, "Realm Exists");

        RealmCount++;

        RealmCreated[msg.sender] = RealmCount;
        
        Realm_Name[RealmCount] = name;
		Realm_PosX[RealmCount] = Realm_Pos(msg.sender,pX,pY);
        Realm_ResX[RealmCount] = Realm_Res(2,10,100,1,1,100,1,1);

        Occupied[pX][pY] = true;


        Realm_Buildings[RealmCount][1] = 1;
        Realm_BuildingCount[RealmCount] = 1;
        Realm_BuildingzX[RealmCount][1] = Realm_Buildingz(1,pX,pY,0,0,0);

 //       Realm_Turns[RealmCount] = Realm_TurnsX(300,block.timestamp);
      Realm_Turns[RealmCount] = Realm_TurnsX(5005,block.timestamp);
	}



    function setStatusWorld() public {
        require(msg.sender == owner, "Only owner");
  
        if (statusWorld == false) {
            statusWorld = true;
        } else 
        statusWorld = false;
	}







}