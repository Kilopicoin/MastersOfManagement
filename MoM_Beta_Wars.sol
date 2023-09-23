// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

interface Planet {
function W_AddAttack(uint256 attacker, uint256 target, uint256 askerTop) external;
}

contract WarsX {

struct RealmsWarRecords{
        uint256 Attacker;
        uint256 Defender;
        uint256 Date;
        uint256 Rate;
        uint256 defansFaz1Okcu;
        uint256 atakFaz1Okcu;
        uint256 defansFaz2;
        uint256 atakFaz2;
        uint256 defansFaz2Okcu;
        uint256 atakFaz2Okcu;
        uint256 defansFaz2Alt1Okcu;
        uint256 atakFaz2Alt1Okcu;
        uint256 defansFaz3;
        uint256 atakFaz3;
    }

mapping(address => uint256) public RealmCreated;
mapping(uint256 => mapping (uint256 => uint256)) public Realm_Soldiers; // 2-Wooden Club, 3-Wooden Axe ...
mapping(uint256 => mapping (uint256 => uint256)) public RealmDefensiveTips; // area --> tip
mapping(uint256 => mapping (uint256 => uint256)) public RealmDefensiveAdets; // area --> Adet
mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) public RealmAttacksiveTips; // target, area -> tip
mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) public RealmAttacksiveAdets; // target, area -> adet
mapping(uint256 => mapping (uint256 => uint256)) public RealmAttacking; // target , 1=on 0=off

mapping(uint256 => uint256) public RealmReceivedAttack; // Attack protection , kimden
mapping(uint256 => uint256) public RealmReceivedAttackTurn; // Attack protection , tur

mapping (uint256 => RealmsWarRecords) public WarRecords; // adet
mapping(uint256 => uint256[6]) public defansStarttips;
mapping(uint256 => uint256[6]) public defansStartadets;
mapping(uint256 => uint256[6]) public atakStarttips;
mapping(uint256 => uint256[6]) public atakStartadets;
mapping(uint256 => uint256[6]) public defansFinishtips;
mapping(uint256 => uint256[6]) public defansFinishadets;
mapping(uint256 => uint256[6]) public atakFinishtips;
mapping(uint256 => uint256[6]) public atakFinishadets;
uint256 public WarCount;

mapping(uint256 => mapping (uint256 => uint256)) public AP_Global; // asker tipi-asker tipi-AP, // damage + possibility
uint[] public HP_Global = [0,0,4,5,5,4]; // WC_Fighter,WA,WS,WB // hp + armor

address public input;
address public owner;
Planet public A_Planet;

constructor () {
    owner = msg.sender;
    AP_Global[2][2] = 1;
    AP_Global[2][3] = 1;
    AP_Global[2][4] = 2;
    AP_Global[2][5] = 2;
    AP_Global[3][2] = 3;
    AP_Global[3][3] = 2;
    AP_Global[3][4] = 2;
    AP_Global[3][5] = 3;
    AP_Global[4][2] = 3;
    AP_Global[4][3] = 4;
    AP_Global[4][4] = 3;
    AP_Global[4][5] = 4;
    AP_Global[5][2] = 2;
    AP_Global[5][3] = 2;
    AP_Global[5][4] = 2;
    AP_Global[5][5] = 2;
}

function definePlanet (Planet A_PlanetX) public {
    require(msg.sender == owner, "o");
    A_Planet = A_PlanetX;
}

function AddInputter (address inputter) public {
    require(msg.sender == owner, "o");
    input = inputter;
}

function W_AddRealm (address adres, uint256 no) public {
  
  require(msg.sender == input, "i");
    RealmCreated[adres] = no;
}

function W_AddSoldier (uint256 no, uint256 asker, uint256 adet) public {
  
  require(msg.sender == input, "i");
    Realm_Soldiers[no][asker] += adet;
}

function W_RemoveSoldier (uint256 no, uint256 asker, uint256 adet) public {
    require(msg.sender == input, "i");
    Realm_Soldiers[no][asker] -= adet;
}

function W_ReleaseAttack (uint256 no, uint256 turnUsed) public {
    require(msg.sender == input, "i");

    if ( RealmReceivedAttackTurn[no] > turnUsed ) {
        RealmReceivedAttackTurn[no] -= turnUsed;
    } else {
        RealmReceivedAttackTurn[no] = 0;
        RealmReceivedAttack[no] = 0;
    }

}

function setDefense(uint[] memory _inputTips, uint[] memory _inputAdets) public {

        require(RealmCreated[msg.sender] != 0, "R");
        uint256 realmnum = RealmCreated[msg.sender];

        uint[] memory toplamTemp = new uint[](6);

        for(uint c=0; c<6; c++){
            if ( _inputTips[c] == 2) {
                toplamTemp[2] += _inputAdets[c];
            } else if ( _inputTips[c] == 3) {
                toplamTemp[3] += _inputAdets[c];
            } else if ( _inputTips[c] == 4) {
                toplamTemp[4] += _inputAdets[c];
            } else if ( _inputTips[c] == 5) {
                toplamTemp[5] += _inputAdets[c];
            }
        } 

        for(uint c=2; c<6; c++){
                require(toplamTemp[c] <= Realm_Soldiers[realmnum][c], "a");
        } 


for(uint c=0; c<6; c++){
    RealmDefensiveTips[realmnum][c] = _inputTips[c];
    RealmDefensiveAdets[realmnum][c] = _inputAdets[c];
}

}



function setAttack(uint[] memory _inputTips, uint[] memory _inputAdets, uint256 to_) public {

        require(RealmCreated[msg.sender] != 0, "R");
        uint256 realmnum = RealmCreated[msg.sender];
        require(RealmAttacking[realmnum][to_] == 0, "B");

        require(RealmReceivedAttack[to_] == 0, "P");

        uint[] memory toplamTemp = new uint[](6);

        for(uint c=0; c<6; c++){
            if ( _inputTips[c] == 2) {
                toplamTemp[2] += _inputAdets[c];
            } else if ( _inputTips[c] == 3) {
                toplamTemp[3] += _inputAdets[c];
            } else if ( _inputTips[c] == 4) {
                toplamTemp[4] += _inputAdets[c];
            } else if ( _inputTips[c] == 5) {
                toplamTemp[5] += _inputAdets[c];
            }
        } 

        for(uint c=2; c<6; c++){
                require(toplamTemp[c] <= Realm_Soldiers[realmnum][c], "a");
        } 


for(uint c=0; c<6; c++){
    RealmDefensiveTips[realmnum][c] = 0;
    RealmDefensiveAdets[realmnum][c] = 0;
}

for(uint c=2; c<6; c++){
            Realm_Soldiers[realmnum][c] -= toplamTemp[c];
        } 

uint256 toplamAsker = _inputAdets[0] + _inputAdets[1] + _inputAdets[2] + _inputAdets[3] + _inputAdets[4] + _inputAdets[5];

RealmAttacking[realmnum][to_] = 1;


for(uint c=0; c<6; c++){
    RealmAttacksiveTips[realmnum][to_][c] = _inputTips[c];
    RealmAttacksiveAdets[realmnum][to_][c] = _inputAdets[c];
}

A_Planet.W_AddAttack(realmnum, to_, toplamAsker);
RealmReceivedAttack[to_] = realmnum;

}




function W_Battle(uint256 attacker, uint256 defender) public {
require(msg.sender == input, "i");

WarCount++;

uint[] memory HpDefansArea = new uint[](6);
uint[] memory HpAtakArea = new uint[](6);

uint[] memory HpDefansAreaTemp = new uint[](6);
uint[] memory HpAtakAreaTemp = new uint[](6);

uint[] memory AktifDefansArea = new uint[](6); // 1 aktif , 0 pasif
uint[] memory AktifAtakArea = new uint[](6); // 1 aktif , 0 pasif

for(uint c=0; c<6; c++){
    HpDefansArea[c] = HP_Global[RealmDefensiveTips[defender][c]] * RealmDefensiveAdets[defender][c];
    HpAtakArea[c] = HP_Global[RealmAttacksiveTips[attacker][defender][c]] * RealmAttacksiveAdets[attacker][defender][c];
    HpDefansAreaTemp[c] = HP_Global[RealmDefensiveTips[defender][c]] * RealmDefensiveAdets[defender][c];
    HpAtakAreaTemp[c] = HP_Global[RealmAttacksiveTips[attacker][defender][c]] * RealmAttacksiveAdets[attacker][defender][c];
}

for(uint c=0; c<6; c++){
    defansStarttips[WarCount][c] = RealmDefensiveTips[defender][c];
    defansStartadets[WarCount][c] = RealmDefensiveAdets[defender][c];
    atakStarttips[WarCount][c] = RealmAttacksiveTips[attacker][defender][c];
    atakStartadets[WarCount][c] = RealmAttacksiveAdets[attacker][defender][c];
}

    for(uint c=0; c<6; c++){
        if ( HpDefansArea[c] != 0 ) {
            AktifDefansArea[c] = 1;
        }
        if ( HpAtakArea[c] != 0 ) {
            AktifAtakArea[c] = 1;
        }
    }

// Phase 1

for(uint c=0; c<3; c++){
        if ( AktifDefansArea[c] == 1 && AktifAtakArea[c] == 1) {

            if ( RealmDefensiveTips[defender][c] == 5 ) {

                WarRecords[WarCount].defansFaz1Okcu += RealmDefensiveAdets[defender][c];
                


                if ( HpAtakAreaTemp[c] > ( AP_Global[5][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c] ) {
                    HpAtakAreaTemp[c] -= ( AP_Global[5][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c];
                } else {
                    HpAtakAreaTemp[c] = 0;
                }


                if ( HpAtakAreaTemp[c] == 0 ) {
                RealmAttacksiveTips[attacker][defender][c] = 0;
                RealmAttacksiveAdets[attacker][defender][c] = 0;
                } else {
                RealmAttacksiveAdets[attacker][defender][c] = ( RealmAttacksiveAdets[attacker][defender][c] * HpAtakAreaTemp[c] ) / HpAtakArea[c];
                if ( RealmAttacksiveAdets[attacker][defender][c] == 0 ) {
                RealmAttacksiveTips[attacker][defender][c] = 0;
                }
                }
            }


            if ( RealmAttacksiveTips[attacker][defender][c] == 5 ) {

                WarRecords[WarCount].atakFaz1Okcu += RealmAttacksiveAdets[attacker][defender][c];
            

                if ( HpDefansAreaTemp[c] > AP_Global[5][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c] ) {
                    HpDefansAreaTemp[c] -= AP_Global[5][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c];
                } else {
                    HpDefansAreaTemp[c] = 0;
                }

                if ( HpDefansAreaTemp[c] == 0 ) {
                RealmDefensiveTips[defender][c] = 0;
                RealmDefensiveAdets[defender][c] = 0;
                } else {
                RealmDefensiveAdets[defender][c] = ( RealmDefensiveAdets[defender][c] * HpDefansAreaTemp[c] ) / HpDefansArea[c];
                if ( RealmDefensiveAdets[defender][c] == 0 ) {
                    RealmDefensiveTips[defender][c] = 0;
                }
                }
            }


            if ( HpDefansAreaTemp[c] <= HpDefansArea[c] / 2 ) {
                AktifDefansArea[c] = 0;
            }
            if ( HpAtakAreaTemp[c] <= HpAtakArea[c] / 2 ) {
                AktifAtakArea[c] = 0;
            }

        }
}

  
// Phase 2
for(uint c=0; c<3; c++){
if ( AktifDefansArea[c] == 1 && AktifAtakArea[c] == 1) {

    WarRecords[WarCount].defansFaz2 += RealmDefensiveAdets[defender][c];
    WarRecords[WarCount].atakFaz2 += RealmAttacksiveAdets[attacker][defender][c];

    if ( HpAtakAreaTemp[c] > ( AP_Global[RealmDefensiveTips[defender][c]][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c] ) {
        HpAtakAreaTemp[c] -= ( AP_Global[RealmDefensiveTips[defender][c]][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c];
    } else {
        HpAtakAreaTemp[c] = 0;
    }

    if ( HpAtakAreaTemp[c] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c] = 0;
        RealmAttacksiveAdets[attacker][defender][c] = 0;
    } else {
        RealmAttacksiveAdets[attacker][defender][c] = ( RealmAttacksiveAdets[attacker][defender][c] * HpAtakAreaTemp[c] ) / HpAtakArea[c];
        if ( RealmAttacksiveAdets[attacker][defender][c] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c] = 0;
        }
    }

    
 

    if ( HpDefansAreaTemp[c] > AP_Global[RealmAttacksiveTips[attacker][defender][c]][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c] ) {
        HpDefansAreaTemp[c] -= AP_Global[RealmAttacksiveTips[attacker][defender][c]][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c];
    } else {
        HpDefansAreaTemp[c] = 0;
    }

    if ( HpDefansAreaTemp[c] == 0 ) {
        RealmDefensiveTips[defender][c] = 0;
        RealmDefensiveAdets[defender][c] = 0;
    } else {
        RealmDefensiveAdets[defender][c] = ( RealmDefensiveAdets[defender][c] * HpDefansAreaTemp[c] ) / HpDefansArea[c];
        if ( RealmDefensiveAdets[defender][c] == 0 ) {
            RealmDefensiveTips[defender][c] = 0;
        }
    }

    

    if ( RealmDefensiveTips[defender][c+3] == 5 ) {

        WarRecords[WarCount].defansFaz2Okcu += RealmDefensiveAdets[defender][c+3];
    

        if ( HpAtakAreaTemp[c] > ( (AP_Global[5][RealmAttacksiveTips[attacker][defender][c]] +1) * RealmDefensiveAdets[defender][c+3] ) / 2 ) {
            HpAtakAreaTemp[c] -= ( (AP_Global[5][RealmAttacksiveTips[attacker][defender][c]] +1) * RealmDefensiveAdets[defender][c+3] ) / 2;
        } else {
            HpAtakAreaTemp[c] = 0;
        }


        if ( HpAtakAreaTemp[c] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c] = 0;
        RealmAttacksiveAdets[attacker][defender][c] = 0;
        } else {
        RealmAttacksiveAdets[attacker][defender][c] = ( RealmAttacksiveAdets[attacker][defender][c] * HpAtakAreaTemp[c] ) / HpAtakArea[c];
        if ( RealmAttacksiveAdets[attacker][defender][c] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c] = 0;
        }
        }
    }


    


    if ( RealmAttacksiveTips[attacker][defender][c+3] == 5 ) {

        WarRecords[WarCount].atakFaz2Okcu += RealmDefensiveAdets[defender][c+3];
     

        if ( HpDefansAreaTemp[c] > ( AP_Global[5][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c+3] ) / 2 ) {
            HpDefansAreaTemp[c] -= ( AP_Global[5][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c+3] ) / 2;
        } else {
            HpDefansAreaTemp[c] = 0;
        }


        if ( HpDefansAreaTemp[c] == 0 ) {
        RealmDefensiveTips[defender][c] = 0;
        RealmDefensiveAdets[defender][c] = 0;
        } else {
        RealmDefensiveAdets[defender][c] = ( RealmDefensiveAdets[defender][c] * HpDefansAreaTemp[c] ) / HpDefansArea[c];
        if ( RealmDefensiveAdets[defender][c] == 0 ) {
            RealmDefensiveTips[defender][c] = 0;
        }
        }

    }


} else if ( AktifDefansArea[c] == 0 && AktifAtakArea[c] == 1 ) {

    if ( RealmDefensiveTips[defender][c+3] == 5 ) {

        WarRecords[WarCount].defansFaz2Alt1Okcu += RealmDefensiveAdets[defender][c+3];
     

        if ( HpAtakAreaTemp[c] > (AP_Global[5][RealmAttacksiveTips[attacker][defender][c]] +1) * RealmDefensiveAdets[defender][c+3] ) {
            HpAtakAreaTemp[c] -= (AP_Global[5][RealmAttacksiveTips[attacker][defender][c]] +1) * RealmDefensiveAdets[defender][c+3];
        } else {
            HpAtakAreaTemp[c] = 0;
        }

        if ( HpAtakAreaTemp[c] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c] = 0;
        RealmAttacksiveAdets[attacker][defender][c] = 0;
        } else {
        RealmAttacksiveAdets[attacker][defender][c] = ( RealmAttacksiveAdets[attacker][defender][c] * HpAtakAreaTemp[c] ) / HpAtakArea[c];
        if ( RealmAttacksiveAdets[attacker][defender][c] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c] = 0;
        }
        }

    }

    

} else if ( AktifDefansArea[c] == 1 && AktifAtakArea[c] == 0 ) {

    if ( RealmAttacksiveTips[attacker][defender][c+3] == 5 ) {

        WarRecords[WarCount].atakFaz2Alt1Okcu += RealmAttacksiveAdets[attacker][defender][c+3];
     


        if ( HpDefansAreaTemp[c] > AP_Global[5][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c+3] ) {
            HpDefansAreaTemp[c] -= AP_Global[5][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c+3];
        } else {
            HpDefansAreaTemp[c] = 0;
        }


        if ( HpDefansAreaTemp[c] == 0 ) {
        RealmDefensiveTips[defender][c] = 0;
        RealmDefensiveAdets[defender][c] = 0;
        } else {
        RealmDefensiveAdets[defender][c] = ( RealmDefensiveAdets[defender][c] * HpDefansAreaTemp[c] ) / HpDefansArea[c];
        if ( RealmDefensiveAdets[defender][c] == 0 ) {
            RealmDefensiveTips[defender][c] = 0;
        }
        }

    }

    


}


    if ( HpDefansAreaTemp[c] <= HpDefansArea[c] / 2 ) {
        AktifDefansArea[c] = 0;
    }
    if ( HpAtakAreaTemp[c] <= HpAtakArea[c] / 2 ) {
        AktifAtakArea[c] = 0;
    }


}

// Phase 3

for(uint c=0; c<3; c++){
    
    WarRecords[WarCount].defansFaz3 += RealmDefensiveAdets[defender][c] + RealmDefensiveAdets[defender][c+3];
    WarRecords[WarCount].atakFaz3 += RealmAttacksiveAdets[attacker][defender][c] + RealmAttacksiveAdets[attacker][defender][c+3];

if ( AktifDefansArea[c] == 1 ) {
    if ( AktifAtakArea[c] == 1 ) {

        
    

        if ( HpAtakAreaTemp[c] > ( AP_Global[RealmDefensiveTips[defender][c]][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c] ) {
            HpAtakAreaTemp[c] -= ( AP_Global[RealmDefensiveTips[defender][c]][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c];
        } else {
            HpAtakAreaTemp[c] = 0;
        }

        if ( HpAtakAreaTemp[c] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c] = 0;
        RealmAttacksiveAdets[attacker][defender][c] = 0;
        } else {
        RealmAttacksiveAdets[attacker][defender][c] = ( RealmAttacksiveAdets[attacker][defender][c] * HpAtakAreaTemp[c] ) / HpAtakArea[c];
        if ( RealmAttacksiveAdets[attacker][defender][c] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c] = 0;
        }
        }


        if ( HpDefansAreaTemp[c] > AP_Global[RealmAttacksiveTips[attacker][defender][c]][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c] ) {
            HpDefansAreaTemp[c] -= AP_Global[RealmAttacksiveTips[attacker][defender][c]][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c];
        } else {
            HpDefansAreaTemp[c] = 0;
        }

        if ( HpDefansAreaTemp[c] == 0 ) {
        RealmDefensiveTips[defender][c] = 0;
        RealmDefensiveAdets[defender][c] = 0;
        } else {
        RealmDefensiveAdets[defender][c] = ( RealmDefensiveAdets[defender][c] * HpDefansAreaTemp[c] ) / HpDefansArea[c];
        if ( RealmDefensiveAdets[defender][c] == 0 ) {
            RealmDefensiveTips[defender][c] = 0;
        }
        }
        


    }

    if ( AktifAtakArea[c+3] == 1 ) {

        if ( HpAtakAreaTemp[c+3] > ( AP_Global[RealmDefensiveTips[defender][c]][RealmAttacksiveTips[attacker][defender][c+3]] ) * RealmDefensiveAdets[defender][c] ) {
            HpAtakAreaTemp[c+3] -= ( AP_Global[RealmDefensiveTips[defender][c]][RealmAttacksiveTips[attacker][defender][c+3]] ) * RealmDefensiveAdets[defender][c];
        } else {
            HpAtakAreaTemp[c+3] = 0;
        }

        if ( HpAtakAreaTemp[c+3] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c+3] = 0;
        RealmAttacksiveAdets[attacker][defender][c+3] = 0;
        } else {
        RealmAttacksiveAdets[attacker][defender][c+3] = ( RealmAttacksiveAdets[attacker][defender][c+3] * HpAtakAreaTemp[c+3] ) / HpAtakArea[c+3];
        if ( RealmAttacksiveAdets[attacker][defender][c+3] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c+3] = 0;
        }
        }

        if ( HpDefansAreaTemp[c] > AP_Global[RealmAttacksiveTips[attacker][defender][c+3]][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c+3] ) {
            HpDefansAreaTemp[c] -= AP_Global[RealmAttacksiveTips[attacker][defender][c+3]][RealmDefensiveTips[defender][c]] * RealmAttacksiveAdets[attacker][defender][c+3];
        } else {
            HpDefansAreaTemp[c] = 0;
        }

        if ( HpDefansAreaTemp[c] == 0 ) {
        RealmDefensiveTips[defender][c] = 0;
        RealmDefensiveAdets[defender][c] = 0;
        } else {
        RealmDefensiveAdets[defender][c] = ( RealmDefensiveAdets[defender][c] * HpDefansAreaTemp[c] ) / HpDefansArea[c];
        if ( RealmDefensiveAdets[defender][c] == 0 ) {
            RealmDefensiveTips[defender][c] = 0;
        }
        }
        


    }
}

if ( AktifDefansArea[c+3] == 1 ) {
    if ( AktifAtakArea[c] == 1 ) {

        if ( HpAtakAreaTemp[c] > ( AP_Global[RealmDefensiveTips[defender][c+3]][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c+3] ) {
            HpAtakAreaTemp[c] -= ( AP_Global[RealmDefensiveTips[defender][c+3]][RealmAttacksiveTips[attacker][defender][c]] ) * RealmDefensiveAdets[defender][c+3];
        } else {
            HpAtakAreaTemp[c] = 0;
        }

        if ( HpAtakAreaTemp[c] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c] = 0;
        RealmAttacksiveAdets[attacker][defender][c] = 0;
        } else {
        RealmAttacksiveAdets[attacker][defender][c] = ( RealmAttacksiveAdets[attacker][defender][c] * HpAtakAreaTemp[c] ) / HpAtakArea[c];
        if ( RealmAttacksiveAdets[attacker][defender][c] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c] = 0;
        }
        }

        if ( HpDefansAreaTemp[c+3] > AP_Global[RealmAttacksiveTips[attacker][defender][c]][RealmDefensiveTips[defender][c+3]] * RealmAttacksiveAdets[attacker][defender][c] ) {
            HpDefansAreaTemp[c+3] -= AP_Global[RealmAttacksiveTips[attacker][defender][c]][RealmDefensiveTips[defender][c+3]] * RealmAttacksiveAdets[attacker][defender][c];
        } else {
            HpDefansAreaTemp[c+3] = 0;
        }


        if ( HpDefansAreaTemp[c+3] == 0 ) {
        RealmDefensiveTips[defender][c+3] = 0;
        RealmDefensiveAdets[defender][c+3] = 0;
        } else {
        RealmDefensiveAdets[defender][c+3] = ( RealmDefensiveAdets[defender][c+3] * HpDefansAreaTemp[c+3] ) / HpDefansArea[c+3];
        if ( RealmDefensiveAdets[defender][c+3] == 0 ) {
            RealmDefensiveTips[defender][c+3] = 0;
        }
        }
        

    }

    if ( AktifAtakArea[c+3] == 1 ) {

        if ( HpAtakAreaTemp[c+3] > ( AP_Global[RealmDefensiveTips[defender][c+3]][RealmAttacksiveTips[attacker][defender][c+3]] ) * RealmDefensiveAdets[defender][c+3] ) {
            HpAtakAreaTemp[c+3] -= ( AP_Global[RealmDefensiveTips[defender][c+3]][RealmAttacksiveTips[attacker][defender][c+3]] ) * RealmDefensiveAdets[defender][c+3];
        } else {
            HpAtakAreaTemp[c+3] = 0;
        }

        if ( HpAtakAreaTemp[c+3] == 0 ) {
        RealmAttacksiveTips[attacker][defender][c+3] = 0;
        RealmAttacksiveAdets[attacker][defender][c+3] = 0;
        } else {
        RealmAttacksiveAdets[attacker][defender][c+3] = ( RealmAttacksiveAdets[attacker][defender][c+3] * HpAtakAreaTemp[c+3] ) / HpAtakArea[c+3];
        if ( RealmAttacksiveAdets[attacker][defender][c+3] == 0 ) {
            RealmAttacksiveTips[attacker][defender][c+3] = 0;
        }
        }


        if ( HpDefansAreaTemp[c+3] > AP_Global[RealmAttacksiveTips[attacker][defender][c+3]][RealmDefensiveTips[defender][c+3]] * RealmAttacksiveAdets[attacker][defender][c+3] ) {
            HpDefansAreaTemp[c+3] -= AP_Global[RealmAttacksiveTips[attacker][defender][c+3]][RealmDefensiveTips[defender][c+3]] * RealmAttacksiveAdets[attacker][defender][c+3];
        } else {
            HpDefansAreaTemp[c+3] = 0;
        }

        if ( HpDefansAreaTemp[c+3] == 0 ) {
        RealmDefensiveTips[defender][c+3] = 0;
        RealmDefensiveAdets[defender][c+3] = 0;
        } else {
        RealmDefensiveAdets[defender][c+3] = ( RealmDefensiveAdets[defender][c+3] * HpDefansAreaTemp[c+3] ) / HpDefansArea[c+3];
        if ( RealmDefensiveAdets[defender][c+3] == 0 ) {
            RealmDefensiveTips[defender][c+3] = 0;
        }
        }
    

    }
}
}

uint256 rate;
for(uint c=0; c<6; c++){

    if ( HpDefansAreaTemp[c] <= HpDefansArea[c] / 2 ) {
        AktifDefansArea[c] = 0;
        rate += 1;
    }
}


for(uint c=0; c<6; c++){
    defansFinishtips[WarCount][c] = RealmDefensiveTips[defender][c];
    defansFinishadets[WarCount][c] = RealmDefensiveAdets[defender][c];
    atakFinishtips[WarCount][c] = RealmAttacksiveTips[attacker][defender][c];
    atakFinishadets[WarCount][c] = RealmAttacksiveAdets[attacker][defender][c];
}

    WarRecords[WarCount].Attacker = attacker;
    WarRecords[WarCount].Defender = defender;
    WarRecords[WarCount].Date = block.timestamp;
    WarRecords[WarCount].Rate = rate;


RealmReceivedAttackTurn[defender] = 300;
}


function W_EndAttack(uint256 attacker, uint256 target) public {
require(msg.sender == input, "i");

for(uint c=2; c<6; c++){
            if ( RealmAttacksiveTips[attacker][target][0] == c) {
                Realm_Soldiers[attacker][c] += RealmAttacksiveAdets[attacker][target][0];
            } else if ( RealmAttacksiveTips[attacker][target][1] == c) {
                Realm_Soldiers[attacker][c] += RealmAttacksiveAdets[attacker][target][1];
            } else if ( RealmAttacksiveTips[attacker][target][2] == c) {
                Realm_Soldiers[attacker][c] += RealmAttacksiveAdets[attacker][target][2];
            } else if ( RealmAttacksiveTips[attacker][target][3] == c) {
                Realm_Soldiers[attacker][c] += RealmAttacksiveAdets[attacker][target][3];
            } else if ( RealmAttacksiveTips[attacker][target][4] == c) {
                Realm_Soldiers[attacker][c] += RealmAttacksiveAdets[attacker][target][4];
            } else if ( RealmAttacksiveTips[attacker][target][5] == c) {
                Realm_Soldiers[attacker][c] += RealmAttacksiveAdets[attacker][target][5];
            }
        } 

RealmAttacking[attacker][target] = 0;


for(uint c=0; c<6; c++){
    RealmAttacksiveTips[attacker][target][c] = 0;
    RealmAttacksiveAdets[attacker][target][c] = 0;
}

}




}