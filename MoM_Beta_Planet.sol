// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

interface Wars {
function W_AddRealm(address adres, uint256 no) external;
function W_AddSoldier(uint256 no, uint256 asker, uint256 adet) external;
function W_RemoveSoldier(uint256 no, uint256 asker, uint256 adet) external;
function W_Battle(uint256 attacker, uint256 defender) external;
function W_EndAttack(uint256 attacker, uint256 target) external;
function W_ReleaseAttack (uint256 no, uint256 turnUsed) external;
function W_addHpBonus (uint256 no) external;
function W_AskerCount(uint256 attacker, uint256 defender) external view returns (uint256, uint256);
}

interface Clans {
function C_AddRealm (address adres, uint256 no) external;
function C_Clanhall (uint256 no) external;
function C_turnUsage (uint256 no, uint256 turn, uint256 mesajTo, string memory mesaj) external;
function C_inviteClan (uint256 eden, uint256 alan) external;
function C_quitFromClan (uint256 no, uint256 code) external;
}


contract Planet {

struct Realm_Pos{
    address Ruler;
    int256 pX;
    int256 pY;
}

struct Realm_Res{
    uint256 popu;
    uint256 armySize;
    uint256 popuSize;
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
    uint256 research; // global araştırma kodu(2 den itibaren) ve yapının upgradei (1) // üretim
    uint256 researchProgress; // 0 ise bitti, değilse devam ediyor // üretim
    uint256 just; // 1 ise yeni başladı
}

struct Realm_TurnsX{
    uint256 start;
    uint256 turn;
}

struct Attacks{
    uint256 target;
    uint256 turn;
    uint256 half;
}

struct Realm_WarDeclarationX{
    uint256 target;
    uint256 turn;
}

struct Realm_IncomingAttackX{
    uint256 aktif; // 1 aktif , 0 pasif
    uint256 saldiran;
    uint256 toplamAsker;
}

address public owner;
address public input;
address public A_Feedback;

Wars public A_Wars;
Clans public A_Clans;

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
    // ilişki kaydı - neut0 ally1 enemy2 AllyRequest
    mapping (uint256 => uint256) public Realm_AllyRequests; // AllyRequest alan taraf

    mapping (uint256 => mapping (uint256 => Realm_WarDeclarationX)) public Realm_WarDeclaration; // Savaş ilanı süreci, açan ülke, sayaç, struct
    mapping (uint256 => uint256) public Realm_WarDeclarationCountX; // Savaş ilanı açan taraf sayacı, açan üle adet
    mapping (uint256 => mapping (uint256 => uint256)) public Realm_WarDeclarationReceived; // Savaş ilanı alan taraf bilgisi, alan ülke, sayaç, açan ülke
    mapping (uint256 => uint256) public Realm_WarDeclarationCount; // Savaş ilanı alan taraf sayacı, alan üle adet

    mapping (uint256 => uint256) public Realm_Points; // puan kaydı
    mapping (uint256 => uint256) public Realm_PopOrder; // ülke-kalan tur
    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Buildings; // tip ve adet sayacı
    mapping (uint256 => mapping (uint256 => Realm_Buildingz)) public Realm_BuildingzX; // numara ve tip-koordinat
    mapping (uint256 => uint256) public Realm_BuildingCount; // numara sayacı
    mapping (uint256 => bool) public Realm_PauseConstructions;
    mapping (uint256 => bool) public Realm_PauseResearches;
    mapping (uint256 => bool) public Realm_PauseProductions;
    mapping (uint256 => bool) public Realm_PauseTrainings;
    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Weapons; // 2-Wooden Club, 3-Wooden Axe ...
    
    mapping (uint256 => mapping (uint256 => Attacks)) public Realm_Attacks; // saldırı adedi
    mapping (uint256 => uint256) public Realm_AttacksCount; // numara sayacı

    mapping (uint256 => Realm_IncomingAttackX) public Realm_IncomingAttack; // gelen saldırı haberi

    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Techs; // no'lar tipi, 1-0 on-off

    uint[] public Researches_Global = [0,0,600,600,300,900,1200]; // 0,0,comb,rope,design,boneArmor,training
    uint[] public Productions_Global = [0,0,2,3,4,3]; // WClub,WoodenAxe,WoodenSpear,WoodenBow
    uint[] public Trainings_Global = [0,0,40,50,60,60]; // WC_Fighter,WA,WS,WB
    uint[] public Constructions_Global = [0,0,200,600,900,800,700,1500,900]; // Home,Warehouse,Workshop,Armory,FightingPit,ClanHall,Tower

    uint[] public Researches_Global_food = [0,0,5,20,10,20,60];
    uint[] public Productions_Global_food = [0,0,16,20,24,30];
    uint[] public Trainings_Global_food = [0,0,50,60,70,80];
    uint[] public Constructions_Global_food = [0,0,4,6,8,8,6,6,6];

    uint[] public Researches_Global_wood = [0,0,20,5,10,20,10];
    uint[] public Productions_Global_wood = [0,0,40,60,80,80];
    uint[] public Trainings_Global_wood = [0,0,10,10,10,10];
    uint[] public Constructions_Global_wood = [0,0,8,10,10,12,8,10,12];

    mapping (int256 => mapping (int256 => bool)) public Occupied; // x - y - dolu - boş

constructor (Clans clansAdres, Wars warsAdres, address feedbackAdres, uint256 lifeWorld)  {
    A_Clans = clansAdres;
    owner = msg.sender;
    statusWorld = false;
    A_Feedback = feedbackAdres;
    A_Wars = warsAdres;
    finishWorld = block.timestamp + ( lifeWorld * 86400 );

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
        uint256 newproduction;
        uint256 newproductionBuildingID;
        uint256 newproductionQuantity;
        uint256 cancelProduction;
        uint256 pauseProductions;
        uint256 newtraining;
        uint256 newtrainingBuildingID;
        uint256 newtrainingQuantity;
        uint256 cancelTraining;
        uint256 pauseTrainings;
        uint256 AllyRequest;
        uint256 WarDeclare;
        uint256 inviteClan;
        uint256 quitClan;
        uint256 messageTo;
        string message;
    }

function useTurn(useTurnG memory useTurnGx) public {

require(statusWorld, "Pas");

if ( block.timestamp > finishWorld ) {
            statusWorld = false;
} else {

        require(RealmCreated[msg.sender] != 0, "Real");
        calcTurn();
        uint256 realmnum = RealmCreated[msg.sender];
		require(Realm_Turns[realmnum].turn >= useTurnGx.turnA, "Tur");
        require(Realm_ResX[realmnum].popu >= useTurnGx.foodworker + useTurnGx.woodworker, "Pop");

        A_Clans.C_turnUsage(realmnum, useTurnGx.turnA, useTurnGx.messageTo, useTurnGx.message);

        if ( useTurnGx.inviteClan != 0 ) {
            A_Clans.C_inviteClan(realmnum, useTurnGx.inviteClan);
        }

        if ( useTurnGx.quitClan != 0 ) {
            A_Clans.C_quitFromClan(realmnum, useTurnGx.quitClan);
        }

        Realm_Turns[realmnum].turn -= useTurnGx.turnA;
        Realm_Turns[realmnum].start = block.timestamp;

        Realm_Reputation[realmnum] += int256(useTurnGx.turnA) ;
        Realm_Points[realmnum] += useTurnGx.turnA * 10 ;

        Realm_ResX[realmnum].foodWorker = useTurnGx.foodworker;
        Realm_ResX[realmnum].woodWorker = useTurnGx.woodworker;
        Realm_ResX[realmnum].food += (Realm_ResX[realmnum].foodWorker * Realm_ResX[realmnum].foodFactor * useTurnGx.turnA);
        Realm_ResX[realmnum].wood += (Realm_ResX[realmnum].woodWorker * Realm_ResX[realmnum].woodFactor * useTurnGx.turnA);


if ( useTurnGx.AllyRequest == 999999999 ) {
        Realm_Diplomacy[Realm_AllyRequests[realmnum]][realmnum] = Realm_Diplomacy[realmnum][Realm_AllyRequests[realmnum]];
        Realm_AllyRequests[realmnum] = 0;
} else if ( useTurnGx.AllyRequest != 0 ) {
        if ( Realm_AllyRequests[realmnum] == useTurnGx.AllyRequest ) {
            Realm_Diplomacy[realmnum][useTurnGx.AllyRequest] = 1;
            Realm_Diplomacy[useTurnGx.AllyRequest][realmnum] = 1;
            Realm_AllyRequests[realmnum] = 0;
        } else {
            require(Realm_AllyRequests[useTurnGx.AllyRequest] == 0, "Bus");
            Realm_Diplomacy[realmnum][useTurnGx.AllyRequest] = 3;
            Realm_AllyRequests[useTurnGx.AllyRequest] = realmnum;
        }
}



if ( useTurnGx.WarDeclare != 0 ) {
    Realm_WarDeclarationCountX[realmnum]++;
    Realm_WarDeclaration[realmnum][Realm_WarDeclarationCountX[realmnum]].target = useTurnGx.WarDeclare;
    if ( Realm_Reputation[useTurnGx.WarDeclare] < 1000 ) {
        Realm_WarDeclaration[realmnum][Realm_WarDeclarationCountX[realmnum]].turn = 10;
    } else {
        Realm_WarDeclaration[realmnum][Realm_WarDeclarationCountX[realmnum]].turn = uint256(Realm_Reputation[useTurnGx.WarDeclare]) / 10;
        if ( Realm_Diplomacy[realmnum][useTurnGx.WarDeclare] == 1 ) {
            Realm_WarDeclaration[realmnum][Realm_WarDeclarationCountX[realmnum]].turn += 100;
        }
    }
    Realm_WarDeclarationCount[useTurnGx.WarDeclare]++;
    Realm_WarDeclarationReceived[useTurnGx.WarDeclare][Realm_WarDeclarationCount[useTurnGx.WarDeclare]] = realmnum;
    Realm_Diplomacy[useTurnGx.WarDeclare][realmnum] = 2;
}


if ( Realm_WarDeclarationCountX[realmnum] != 0 ) {
    for(uint c=1; c<=Realm_WarDeclarationCountX[realmnum]; c++){
        if ( Realm_WarDeclaration[realmnum][c].turn != 0 ) {
            if ( Realm_WarDeclaration[realmnum][c].turn > useTurnGx.turnA ) {
                Realm_WarDeclaration[realmnum][c].turn -= useTurnGx.turnA;
            } else {
                Realm_Diplomacy[realmnum][Realm_WarDeclaration[realmnum][c].target] = 2;
                Realm_WarDeclaration[realmnum][c].turn = 0;
                Realm_WarDeclaration[realmnum][c].target = 0;
            }
        }
    }
}
    
if ( Realm_WarDeclarationCount[realmnum] != 0 ) {
    for(uint c=1; c<=Realm_WarDeclarationCount[realmnum]; c++){
        Realm_WarDeclarationReceived[realmnum][c] = 0;
    }
    Realm_WarDeclarationCount[realmnum] = 0;
}







        if (useTurnGx.poplinecancel == 1) {
            Realm_ResX[realmnum].popuSize -= ( Realm_PopOrder[realmnum] / 60 ) + 1;
            Realm_PopOrder[realmnum] = 0;
        }
        if (useTurnGx.poporder != 0) {
            if (Realm_PopOrder[realmnum] == 0 ) {
                require( useTurnGx.poporder + Realm_ResX[realmnum].armySize + Realm_ResX[realmnum].popuSize <= Realm_ResX[realmnum].popuLimit, "Lim");
                Realm_ResX[realmnum].popuSize += useTurnGx.poporder;
                Realm_PopOrder[realmnum] = useTurnGx.poporder * 60;
            }
        }

if ( useTurnGx.cancelTraining != 0 ){
Realm_ResX[realmnum].armySize -= ( Realm_BuildingzX[realmnum][useTurnGx.cancelTraining].researchProgress / Trainings_Global[Realm_BuildingzX[realmnum][useTurnGx.cancelTraining].research]) + 1;
    Realm_BuildingzX[realmnum][useTurnGx.cancelTraining].research = 0;
    Realm_BuildingzX[realmnum][useTurnGx.cancelTraining].researchProgress = 0;
}

if ( useTurnGx.pauseTrainings == 1) {
    Realm_PauseTrainings[realmnum] = true;
} else {
    Realm_PauseTrainings[realmnum] = false;
}

if ( useTurnGx.newtraining > 1 ) {
    require(Realm_BuildingzX[realmnum][useTurnGx.newtrainingBuildingID].research == 0, "busy");

    if ( useTurnGx.newtraining < 6  ) {
        require(Realm_BuildingzX[realmnum][useTurnGx.newtrainingBuildingID].typeB == 6, "Pit");
        require( useTurnGx.newtrainingQuantity + Realm_ResX[realmnum].armySize + Realm_ResX[realmnum].popuSize <= Realm_ResX[realmnum].popuLimit, "Lim");
        Realm_ResX[realmnum].armySize += useTurnGx.newtrainingQuantity;
        Realm_BuildingzX[realmnum][useTurnGx.newtrainingBuildingID].research = useTurnGx.newtraining;
        Realm_BuildingzX[realmnum][useTurnGx.newtrainingBuildingID].just = 1;
        Realm_BuildingzX[realmnum][useTurnGx.newtrainingBuildingID].researchProgress = useTurnGx.newtrainingQuantity * Trainings_Global[useTurnGx.newtraining];
    }
}

if ( useTurnGx.cancelProduction != 0 ){
    Realm_BuildingzX[realmnum][useTurnGx.cancelProduction].research = 0;
    Realm_BuildingzX[realmnum][useTurnGx.cancelProduction].researchProgress = 0;
}

if ( useTurnGx.pauseProductions == 1) {
    Realm_PauseProductions[realmnum] = true;
} else {
    Realm_PauseProductions[realmnum] = false;
}

if ( useTurnGx.newproduction > 1 ) {
    require(Realm_BuildingzX[realmnum][useTurnGx.newproductionBuildingID].research == 0, "busy");
    if ( useTurnGx.newproduction < 6  ) {
        require(Realm_BuildingzX[realmnum][useTurnGx.newproductionBuildingID].typeB == 5, "Arm");
        Realm_BuildingzX[realmnum][useTurnGx.newproductionBuildingID].research = useTurnGx.newproduction;
        Realm_BuildingzX[realmnum][useTurnGx.newproductionBuildingID].just = 1;
        Realm_BuildingzX[realmnum][useTurnGx.newproductionBuildingID].researchProgress = useTurnGx.newproductionQuantity * Productions_Global[useTurnGx.newproduction];
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
    require(Realm_Techs[realmnum][useTurnGx.newresearch] == 0, "done");
    require(Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].research == 0, "busy");

    if ( useTurnGx.newresearch < 7  ) {
        require(Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].typeB == 4, "Work");
        Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].research = useTurnGx.newresearch;
        Realm_BuildingzX[realmnum][useTurnGx.newresearchBuildingID].researchProgress = Researches_Global[useTurnGx.newresearch];
    }
} else if ( useTurnGx.newresearch == 1 ) {

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
Realm_BuildingzX[realmnum][Realm_BuildingCount[realmnum]] = Realm_Buildingz(useTurnGx.newbuilding,useTurnGx.newbuildingX,useTurnGx.newbuildingY,Constructions_Global[useTurnGx.newbuilding],0,0,0);
} 


for(uint c=1; c<=Realm_BuildingCount[realmnum]; c++){

    if ( Realm_BuildingzX[realmnum][c].construction != 0 && Realm_PauseConstructions[realmnum] == false ) {
        if ( Realm_BuildingzX[realmnum][c].construction > useTurnGx.turnA) {
            Realm_ResX[realmnum].food -= (useTurnGx.turnA * Constructions_Global_food[Realm_BuildingzX[realmnum][c].typeB]);
            Realm_ResX[realmnum].wood -= (useTurnGx.turnA * Constructions_Global_wood[Realm_BuildingzX[realmnum][c].typeB]);
            Realm_BuildingzX[realmnum][c].construction -= useTurnGx.turnA;
        } else {
            Realm_ResX[realmnum].food -= (Realm_BuildingzX[realmnum][c].construction * Constructions_Global_food[Realm_BuildingzX[realmnum][c].typeB]);
            Realm_ResX[realmnum].wood -= (Realm_BuildingzX[realmnum][c].construction * Constructions_Global_wood[Realm_BuildingzX[realmnum][c].typeB]);
            Realm_BuildingzX[realmnum][c].construction = 0;

            if (Realm_BuildingzX[realmnum][c].typeB == 2) {
                Realm_ResX[realmnum].popuLimit += 2;
            } else if (Realm_BuildingzX[realmnum][c].typeB == 3) {
                Realm_ResX[realmnum].foodFactor += 1;
                Realm_ResX[realmnum].woodFactor += 1;
            } else if ( Realm_BuildingzX[realmnum][c].typeB == 7 ) {
                A_Clans.C_Clanhall(realmnum);
            } else if ( Realm_BuildingzX[realmnum][c].typeB == 8 ) {
                Realm_Buildings[realmnum][8] += 1;
            }
        }
    }



    if ( Realm_BuildingzX[realmnum][c].research != 0 ) {

        if ( Realm_PauseResearches[realmnum] == false && Realm_BuildingzX[realmnum][c].typeB == 4 ) {
            if ( Realm_BuildingzX[realmnum][c].researchProgress > useTurnGx.turnA ) {
                Realm_ResX[realmnum].food -= (useTurnGx.turnA * Researches_Global_food[Realm_BuildingzX[realmnum][c].research]);
                Realm_ResX[realmnum].wood -= (useTurnGx.turnA * Researches_Global_wood[Realm_BuildingzX[realmnum][c].research]);
                Realm_BuildingzX[realmnum][c].researchProgress -= useTurnGx.turnA;
            } else {
                Realm_ResX[realmnum].food -= (Realm_BuildingzX[realmnum][c].researchProgress * Researches_Global_food[Realm_BuildingzX[realmnum][c].research]);
                Realm_ResX[realmnum].wood -= (Realm_BuildingzX[realmnum][c].researchProgress * Researches_Global_wood[Realm_BuildingzX[realmnum][c].research]);

                if (Realm_BuildingzX[realmnum][c].research == 2) {
                    Realm_ResX[realmnum].foodFactor += 2;
                } else if (Realm_BuildingzX[realmnum][c].research == 3) {
                    Realm_ResX[realmnum].woodFactor += 2;
                } else if (Realm_BuildingzX[realmnum][c].research == 4) {
                    Realm_ResX[realmnum].popuLimit += 6;
                } else if (Realm_BuildingzX[realmnum][c].research == 5) {
                    A_Wars.W_addHpBonus(realmnum);
                } else if (Realm_BuildingzX[realmnum][c].research == 6) {
                    A_Wars.W_addHpBonus(realmnum);
                }

                Realm_BuildingzX[realmnum][c].researchProgress = 0;
                Realm_Techs[realmnum][Realm_BuildingzX[realmnum][c].research] = 1;
                    if ( Researches_Global[Realm_BuildingzX[realmnum][c].research] > 60) {
                        Researches_Global[Realm_BuildingzX[realmnum][c].research] -= 1;
                    }
                Realm_BuildingzX[realmnum][c].research = 0;
            }
        }


        if ( Realm_PauseProductions[realmnum] == false && Realm_BuildingzX[realmnum][c].typeB == 5 ) {

            if ( Realm_BuildingzX[realmnum][c].researchProgress > useTurnGx.turnA ) {
                Realm_ResX[realmnum].food -= (useTurnGx.turnA * Productions_Global_food[Realm_BuildingzX[realmnum][c].research]);
                Realm_ResX[realmnum].wood -= (useTurnGx.turnA * Productions_Global_wood[Realm_BuildingzX[realmnum][c].research]);

                uint256 eski = Realm_BuildingzX[realmnum][c].researchProgress / Productions_Global[Realm_BuildingzX[realmnum][c].research];
                Realm_BuildingzX[realmnum][c].researchProgress -= useTurnGx.turnA;
                uint256 yeni = Realm_BuildingzX[realmnum][c].researchProgress / Productions_Global[Realm_BuildingzX[realmnum][c].research];

                Realm_Weapons[realmnum][Realm_BuildingzX[realmnum][c].research] += ( eski - yeni );
                if ( Realm_BuildingzX[realmnum][c].just == 1 ) {
                    Realm_Weapons[realmnum][Realm_BuildingzX[realmnum][c].research] -= 1;
                    Realm_BuildingzX[realmnum][c].just = 0;
                }

            } else {
                Realm_ResX[realmnum].food -= (Realm_BuildingzX[realmnum][c].researchProgress * Productions_Global_food[Realm_BuildingzX[realmnum][c].research]);
                Realm_ResX[realmnum].wood -= (Realm_BuildingzX[realmnum][c].researchProgress * Productions_Global_wood[Realm_BuildingzX[realmnum][c].research]);

Realm_Weapons[realmnum][Realm_BuildingzX[realmnum][c].research] += (( Realm_BuildingzX[realmnum][c].researchProgress / Productions_Global[Realm_BuildingzX[realmnum][c].research] ) + 1);
                if ( Realm_BuildingzX[realmnum][c].just == 1 ) {
                    Realm_Weapons[realmnum][Realm_BuildingzX[realmnum][c].research] -= 1;
                    Realm_BuildingzX[realmnum][c].just = 0;
                }

                Realm_BuildingzX[realmnum][c].researchProgress = 0;
                Realm_BuildingzX[realmnum][c].research = 0;
            }

        }


        if ( Realm_PauseTrainings[realmnum] == false && Realm_BuildingzX[realmnum][c].typeB == 6 ) {

            if ( Realm_BuildingzX[realmnum][c].researchProgress > useTurnGx.turnA ) {

                Realm_ResX[realmnum].food -= (useTurnGx.turnA * Trainings_Global_food[Realm_BuildingzX[realmnum][c].research]);
                Realm_ResX[realmnum].wood -= (useTurnGx.turnA * Trainings_Global_wood[Realm_BuildingzX[realmnum][c].research]);
                Realm_Weapons[realmnum][Realm_BuildingzX[realmnum][c].research] -= useTurnGx.turnA;

                uint256 eski = Realm_BuildingzX[realmnum][c].researchProgress / Trainings_Global[Realm_BuildingzX[realmnum][c].research];
                Realm_BuildingzX[realmnum][c].researchProgress -= useTurnGx.turnA;
                uint256 yeni = Realm_BuildingzX[realmnum][c].researchProgress / Trainings_Global[Realm_BuildingzX[realmnum][c].research];

                A_Wars.W_AddSoldier(realmnum, Realm_BuildingzX[realmnum][c].research, (eski - yeni));
                if ( Realm_BuildingzX[realmnum][c].just == 1 ) {
                    A_Wars.W_RemoveSoldier(realmnum, Realm_BuildingzX[realmnum][c].research, 1);
                    Realm_BuildingzX[realmnum][c].just = 0;
                }

            } else {

                Realm_ResX[realmnum].food -= (Realm_BuildingzX[realmnum][c].researchProgress * Trainings_Global_food[Realm_BuildingzX[realmnum][c].research]);
                Realm_ResX[realmnum].wood -= (Realm_BuildingzX[realmnum][c].researchProgress * Trainings_Global_wood[Realm_BuildingzX[realmnum][c].research]);
                Realm_Weapons[realmnum][Realm_BuildingzX[realmnum][c].research] -= Realm_BuildingzX[realmnum][c].researchProgress;

A_Wars.W_AddSoldier(realmnum, Realm_BuildingzX[realmnum][c].research, (( Realm_BuildingzX[realmnum][c].researchProgress / Trainings_Global[Realm_BuildingzX[realmnum][c].research] ) + 1));

                if ( Realm_BuildingzX[realmnum][c].just == 1 ) {
                    A_Wars.W_RemoveSoldier(realmnum, Realm_BuildingzX[realmnum][c].research, 1);
                    Realm_BuildingzX[realmnum][c].just = 0;
                }
                Realm_BuildingzX[realmnum][c].researchProgress = 0;
                Realm_BuildingzX[realmnum][c].research = 0;
            }
        }
    }
}
        

if (Realm_PopOrder[realmnum] != 0 ) {
    if (useTurnGx.turnA >= Realm_PopOrder[realmnum]) {
        require(Realm_ResX[realmnum].food >= Realm_PopOrder[realmnum] * 2, "Food");
        Realm_ResX[realmnum].food -= (Realm_PopOrder[realmnum] * 2);

        Realm_ResX[realmnum].popu += ( Realm_PopOrder[realmnum] / 60 );
        if ( useTurnGx.poporder == 0 ) {
            Realm_ResX[realmnum].popu += 1;
        }

        Realm_PopOrder[realmnum] = 0;

    } else {
        require(Realm_ResX[realmnum].food >= useTurnGx.turnA * 2, "Food");
        Realm_ResX[realmnum].food -= (useTurnGx.turnA * 2);

        uint256 eski = Realm_PopOrder[realmnum] / 60;
        Realm_PopOrder[realmnum] -= useTurnGx.turnA;
        uint256 yeni = Realm_PopOrder[realmnum] / 60;

        Realm_ResX[realmnum].popu += (eski - yeni);
        if ( useTurnGx.poporder != 0 ) {
            Realm_ResX[realmnum].popu -= 1;
        }
    }
}



A_Wars.W_ReleaseAttack(realmnum, useTurnGx.turnA);

if ( Realm_AttacksCount[realmnum] != 0 ) {
            
    for(uint c=1; c<=Realm_AttacksCount[realmnum]; c++){

    if ( Realm_Attacks[realmnum][c].turn != 0 ) {

        if ( Realm_Attacks[realmnum][c].turn > useTurnGx.turnA ) {

            Realm_Attacks[realmnum][c].turn -= useTurnGx.turnA;

            if ( Realm_Attacks[realmnum][c].half > Realm_Attacks[realmnum][c].turn ) { 
                if ( Realm_Diplomacy[realmnum][Realm_Attacks[realmnum][c].target] == 0 ) {
                    Realm_Reputation[realmnum] -= 3000;
                } else if ( Realm_Diplomacy[realmnum][Realm_Attacks[realmnum][c].target] == 1 ) {
                    Realm_Reputation[realmnum] -= 6000;
                }

                (uint256 value1, uint256 value2) = A_Wars.W_AskerCount(realmnum, Realm_Attacks[realmnum][c].target);

                A_Wars.W_Battle(realmnum, Realm_Attacks[realmnum][c].target);

                (uint256 value3, uint256 value4) = A_Wars.W_AskerCount(realmnum, Realm_Attacks[realmnum][c].target);
                Realm_ResX[realmnum].armySize -= ( value1 - value3 );
                Realm_ResX[Realm_Attacks[realmnum][c].target].armySize -= ( value2 - value4 );

                Realm_IncomingAttack[Realm_Attacks[realmnum][c].target].aktif = 0;
                Realm_Attacks[realmnum][c].half = 0;
            }

        } else {

            Realm_Attacks[realmnum][c].turn = 0;
            A_Wars.W_EndAttack(realmnum, Realm_Attacks[realmnum][c].target);

            if ( Realm_Attacks[realmnum][c].half != 0 ) {

                if ( Realm_Diplomacy[realmnum][Realm_Attacks[realmnum][c].target] == 0 ) {
                    Realm_Reputation[realmnum] -= 3000;
                } else if ( Realm_Diplomacy[realmnum][Realm_Attacks[realmnum][c].target] == 1 ) {
                    Realm_Reputation[realmnum] -= 6000;
                }

                (uint256 value1, uint256 value2) = A_Wars.W_AskerCount(realmnum, Realm_Attacks[realmnum][c].target);

                A_Wars.W_Battle(realmnum, Realm_Attacks[realmnum][c].target);

                (uint256 value3, uint256 value4) = A_Wars.W_AskerCount(realmnum, Realm_Attacks[realmnum][c].target);
                Realm_ResX[realmnum].armySize -= ( value1 - value3 );
                Realm_ResX[Realm_Attacks[realmnum][c].target].armySize -= ( value2 - value4 );

                Realm_IncomingAttack[Realm_Attacks[realmnum][c].target].aktif = 0;
                 Realm_Attacks[realmnum][c].half = 0;
            }



        }

    }

    }


}






}
}

     function calcTurn() public {
        require(RealmCreated[msg.sender] != 0, "Real");
        uint256 realmnum = RealmCreated[msg.sender];
		Realm_Turns[realmnum].turn += ((block.timestamp - Realm_Turns[realmnum].start) / 600 );
        if (Realm_Turns[realmnum].turn > 13005) {
            Realm_Turns[realmnum].turn = 13005;
   //     if (Realm_Turns[realmnum].turn > 300) {
    //        Realm_Turns[realmnum].turn = 300;
        }
	}

    function getTurn(address Accc) public view returns (uint256) {
        uint256 realmnum = RealmCreated[Accc];
        if (Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 ) > 13005) {
            return 13005 ;
  //      if (Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600 ) > 300) {
   //         return 300 ;
        } else 
        return Realm_Turns[realmnum].turn + ((block.timestamp - Realm_Turns[realmnum].start) / 600) ;
    }

function addRealm(int256 pX, int256 pY, string memory name) public {

        require(statusWorld, "acti");
        require(RealmCreated[msg.sender] == 0, "Real");

        RealmCount++;

        RealmCreated[msg.sender] = RealmCount;
        
        Realm_Name[RealmCount] = name;
		Realm_PosX[RealmCount] = Realm_Pos(msg.sender,pX,pY);
        Realm_ResX[RealmCount] = Realm_Res(2,0,2,10,100,1,1,100,1,1);

        Occupied[pX][pY] = true;

        Realm_Buildings[RealmCount][1] = 1;
        Realm_BuildingCount[RealmCount] = 1;
        Realm_BuildingzX[RealmCount][1] = Realm_Buildingz(1,pX,pY,0,0,0,0);

 //       Realm_Turns[RealmCount] = Realm_TurnsX(300,block.timestamp);
        Realm_Turns[RealmCount] = Realm_TurnsX(13005,block.timestamp);


        A_Wars.W_AddRealm(msg.sender, RealmCount);
        A_Clans.C_AddRealm(msg.sender, RealmCount);

	}

function setStatusWorld() public {
        require(msg.sender == owner, "own");
  
        if (statusWorld == false) {
            statusWorld = true;
        } else 
        statusWorld = false;
	}


function AddInputter (address inputter) public {
    require(msg.sender == owner, "own");
    input = inputter;
}

function W_AddAttack (uint256 attacker, uint256 target, uint256 askerTop) public {
    require(msg.sender == input, "input");
    Realm_AttacksCount[attacker]++;

    int a = Realm_PosX[attacker].pX - Realm_PosX[target].pX;
    int b = Realm_PosX[attacker].pY - Realm_PosX[target].pY;

    int top = (a * a) + (b * b);

    uint256 num = uint256(top);

    uint256 distance = num;
    uint256 y = (distance + 1) / 2;
        
    while (y < distance) {
            distance = y;
            y = (distance + num / distance) / 2;
    }


    uint256 tur = ((distance / 10 ) * 2 ) + ( askerTop / 10 );
    uint256 foodCost = tur * askerTop * 10;

    Realm_ResX[attacker].food -= foodCost;

    Realm_Attacks[attacker][Realm_AttacksCount[attacker]] = Attacks(target,tur,tur/2);

    if ( Realm_Buildings[target][8] != 0 ) {
        Realm_IncomingAttack[target].aktif = 1;
        Realm_IncomingAttack[target].saldiran = attacker;
        Realm_IncomingAttack[target].toplamAsker = askerTop;
    }

}

}