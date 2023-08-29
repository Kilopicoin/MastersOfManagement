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
    uint256 foodWorker;
    uint256 wood;
    uint256 woodWorker;

}

struct Realm_Buildingz{

    uint256 typeB;
    int256 posxB;
    int256 posyB;
    uint256 construction; // 0 ise bitmiş, değilse kalan tur

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




    mapping (int256 => mapping (int256 => bool)) public Occupied; // x - y - dolu - boş

constructor (address feedbackAdres, uint256 lifeWorld)  {

    owner = msg.sender;
statusWorld = false;
A_Feedback = feedbackAdres;
finishWorld = block.timestamp + ( lifeWorld * 86400 );

    }


function useTurn(uint256 turnA, uint256 foodworker, uint256 woodworker,
uint256 poporder, uint256 poplinecancel,
uint256 newbuilding, int256 newbuildingX, int256 newbuildingY



) public {

require(statusWorld, "Passive");

 if ( block.timestamp > finishWorld ) {
            statusWorld = false;
        } else {



        require(RealmCreated[msg.sender] != 0, "No Realm");
        calcTurn();
        uint256 realmnum = RealmCreated[msg.sender];
		require(Realm_Turns[realmnum].turn >= turnA, "TurnX");
        require(Realm_ResX[realmnum].popu >= foodworker + woodworker, "PopLimit");

        
        Realm_Turns[realmnum].turn = Realm_Turns[realmnum].turn - turnA;
        Realm_Turns[realmnum].start = block.timestamp;

        Realm_Reputation[realmnum] = Realm_Reputation[realmnum] + int256(turnA) ;
        Realm_Points[realmnum] = Realm_Points[realmnum] + turnA ;


        Realm_ResX[realmnum].foodWorker = foodworker;
        Realm_ResX[realmnum].woodWorker = woodworker;
        Realm_ResX[realmnum].food = Realm_ResX[realmnum].food + (Realm_ResX[realmnum].foodWorker * turnA);
        Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood + (Realm_ResX[realmnum].woodWorker * turnA);

        if (poplinecancel == 1) {

            Realm_PopOrder[realmnum] = 0;

        }
        if (poporder != 0) {
            if (Realm_PopOrder[realmnum] == 0 ) {
                Realm_PopOrder[realmnum] = poporder * 60;
            }
        }




        if ( newbuilding != 0) {

            Realm_BuildingCount[RealmCount]++;
            
            if ( newbuilding == 2 ) {

          
            Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]] = Realm_Buildingz(2,newbuildingX,newbuildingY,100);

            if ( Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]].construction > turnA) {
            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (turnA * 6);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (turnA * 6);
            Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]].construction = Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]].construction - turnA;
            } else {
            Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]].construction * 6);
            Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]].construction * 6);
            Realm_BuildingzX[RealmCount][Realm_BuildingCount[RealmCount]].construction = 0;
            


            }




            }

        } else {

            for(uint b=0; b<Realm_BuildingCount[RealmCount]; b++){
                uint c = b + 1;

                if ( Realm_BuildingzX[RealmCount][c].construction != 0 ) {

                    if ( Realm_BuildingzX[RealmCount][c].construction > turnA) {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (turnA * 6);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (turnA * 6);
                    Realm_BuildingzX[RealmCount][c].construction = Realm_BuildingzX[RealmCount][c].construction - turnA;
                    } else {
                    Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_BuildingzX[RealmCount][c].construction * 6);
                    Realm_ResX[realmnum].wood = Realm_ResX[realmnum].wood - (Realm_BuildingzX[RealmCount][c].construction * 6);
                    Realm_BuildingzX[RealmCount][c].construction = 0;
                    }


                }


            }

        }


        
        





        if (Realm_PopOrder[realmnum] != 0 ) {

            if (turnA >= Realm_PopOrder[realmnum]) {

                require(Realm_ResX[realmnum].food >= Realm_PopOrder[realmnum] * 2, "Food");
                Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (Realm_PopOrder[realmnum] * 2);

                uint256 yenipop;
                if ( poporder == 0 ) {

                    yenipop = ( Realm_PopOrder[realmnum] / 60 ) + 1;

                } else {

                    yenipop = ( Realm_PopOrder[realmnum] / 60 );

                }

            
                Realm_ResX[realmnum].popu = Realm_ResX[realmnum].popu + yenipop;
                Realm_PopOrder[realmnum] = 0;

            } else {

                require(Realm_ResX[realmnum].food >= turnA * 2, "Food");
                Realm_ResX[realmnum].food = Realm_ResX[realmnum].food - (turnA * 2);
                uint256 eski = Realm_PopOrder[realmnum] / 60;
                Realm_PopOrder[realmnum] = Realm_PopOrder[realmnum] - turnA;
                uint256 yeni = Realm_PopOrder[realmnum] / 60;

                uint256 fark;
                if ( poporder == 0 ) {
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
  //      if (Realm_Turns[realmnum].turn > 5005) {
    //        Realm_Turns[realmnum].turn = 5005;
        if (Realm_Turns[realmnum].turn > 300) {
            Realm_Turns[realmnum].turn = 300;
        }
	}





    function getTurn(address Accc) public view returns (uint256) {
        uint256 realmnum = RealmCreated[Accc];
 //       if (Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 ) > 5005) {
  //          return 5005 ;
        if (Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 ) > 300) {
            return 300 ;
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
        Realm_ResX[RealmCount] = Realm_Res(2,10,100,1,100,1);

        Occupied[pX][pY] = true;


        Realm_Buildings[RealmCount][1] = 1;
        Realm_BuildingCount[RealmCount] = 1;
        Realm_BuildingzX[RealmCount][1] = Realm_Buildingz(1,pX,pY,0);

        Realm_Turns[RealmCount] = Realm_TurnsX(300,block.timestamp);
//      Realm_Turns[RealmCount] = Realm_TurnsX(5005,block.timestamp);
	}






    function setStatusWorld() public {
        require(msg.sender == owner, "Only owner");
  
        if (statusWorld == false) {
            statusWorld = true;
        } else 
        statusWorld = false;
	}







}