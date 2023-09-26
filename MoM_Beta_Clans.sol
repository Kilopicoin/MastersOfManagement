// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

contract Clans {

struct Realm_ClanRemoveX{
    uint256 code;
    uint256 target;
    uint256 turn;
}


mapping(address => uint256) public RealmCreated;

mapping(uint256 => bool) public RealmClanHall; // ClanHall var mı

mapping (uint256 => uint256) public Realm_Clan; // Clan kaydı
mapping (uint256 => uint256) public Realm_ClanRank; // Clan rütbesi Emperor,1 King,2 Prince,3 Duke,4 Viscount,5 Baron

mapping (uint256 => string) public ClansX; // Clanlar kaydı
uint256 public ClanCounter; // Clan sayacı
mapping (uint256 => uint256) public ClanCounter_User; // Clan üye sayacı
mapping (uint256 => mapping (uint256 => uint256)) public ClanCounter_UserX; // Clan üye kaydı sayacı

mapping (uint256 => uint256) public Realm_ClanRequests; // Clan daveti alan, eden
mapping (uint256 => mapping (uint256 => bool)) public Realm_ClanRequestsX; // Clan davet eden, alan, aktif-pasif

mapping (uint256 => uint256) public Realm_ClanQuit; // Clandan çıkış süreci
mapping (uint256 => uint256) public Realm_ClanRemoveCount; // Clandan çıkarma sayacı
mapping (uint256 => mapping (uint256 => Realm_ClanRemoveX)) public Realm_ClanRemove; // Clandan çıkarma takibi



address public input;
address public owner;

constructor () {
    owner = msg.sender;
}

function AddInputter (address inputter) public {
    require(msg.sender == owner, "o");
    input = inputter;
}

function C_AddRealm (address adres, uint256 no) public {
    require(msg.sender == input, "i");
    RealmCreated[adres] = no;
}

function C_Clanhall (uint256 no) public {
    require(msg.sender == input, "i");
    RealmClanHall[no] = true;
}

function CreateClan (string memory clanName) public {
    require(RealmCreated[msg.sender] != 0, "Real");
    uint256 realmnum = RealmCreated[msg.sender];
    require(RealmClanHall[realmnum] == true, "Hall");
    require(Realm_Clan[realmnum] == 0, "Busy");
    ClanCounter++;
    ClansX[ClanCounter] = clanName;
    Realm_Clan[realmnum] = ClanCounter;
    Realm_ClanRank[realmnum] = 1;
    ClanCounter_User[ClanCounter]++;
    ClanCounter_UserX[ClanCounter][ClanCounter_User[ClanCounter]] = realmnum;
}


function RemoveClan (uint256 id) public {
    require(RealmCreated[msg.sender] != 0, "Real");
    uint256 realmnum = RealmCreated[msg.sender];
    require(RealmClanHall[realmnum] == true, "Hall");
    require(Realm_Clan[realmnum] == id, "Match");
    require(Realm_ClanRank[realmnum] == 1, "King");

    for(uint c=1; c<=ClanCounter_User[id]; c++){
        Realm_Clan[ClanCounter_UserX[id][c]] = 0;
        Realm_ClanRank[ClanCounter_UserX[id][c]] = 0;
    }

}


function C_inviteClan (uint256 eden, uint256 alan) public {
    require(msg.sender == input, "i");
    if ( Realm_Clan[eden] != 0 ) {
        require(Realm_ClanRank[eden] < 4, "Rank");
        Realm_ClanRequests[alan] = eden;
        Realm_ClanRequestsX[eden][alan] = true;
    } else if ( alan == 999999999 ) {
        Realm_ClanRequestsX[Realm_ClanRequests[eden]][eden] = false;
        Realm_ClanRequests[eden] = 0;
    } else if ( alan == Realm_ClanRequests[eden] ) {
        Realm_ClanRequestsX[alan][eden] = false;
        Realm_ClanRequests[eden] = 0;
        Realm_Clan[eden] = Realm_Clan[alan];
        ClanCounter_User[ClanCounter]++;
        ClanCounter_UserX[Realm_Clan[alan]][ClanCounter_User[ClanCounter]] = eden;
    }
}



function C_quitFromClan (uint256 no, uint256 code) public {
    require(msg.sender == input, "i");
    require(Realm_Clan[no] != 0, "clan");

    if ( no == ClanCounter_UserX[Realm_Clan[no]][code] ) {
        Realm_ClanRemoveCount[no]++;
        Realm_ClanRemove[no][Realm_ClanRemoveCount[no]].code = code;
        Realm_ClanRemove[no][Realm_ClanRemoveCount[no]].target = ClanCounter_UserX[Realm_Clan[no]][code];
        Realm_ClanRemove[no][Realm_ClanRemoveCount[no]].turn = 150;
    } else {
        require(Realm_ClanRank[no] < 3, "Rank");
        Realm_ClanRemoveCount[no]++;
        Realm_ClanRemove[no][Realm_ClanRemoveCount[no]].code = code;
        Realm_ClanRemove[no][Realm_ClanRemoveCount[no]].target = ClanCounter_UserX[Realm_Clan[no]][code];
        Realm_ClanRemove[no][Realm_ClanRemoveCount[no]].turn = 150;
    }
}




function C_turnUsage (uint256 no, uint256 turn) public {
require(msg.sender == input, "i");

if ( Realm_ClanRemoveCount[no] > 0 ){
    for(uint c=1; c<=Realm_ClanRemoveCount[no]; c++){
        if ( Realm_ClanRemove[no][c].turn > 0 ) {

            if ( Realm_ClanRemove[no][c].turn > turn ) {
                Realm_ClanRemove[no][c].turn -= turn;
            } else {
                Realm_ClanRemove[no][c].turn = 0;
                ClanCounter_UserX[Realm_Clan[no]][Realm_ClanRemove[no][c].code] = 0;
                Realm_ClanRemove[no][c].code = 0;
                Realm_Clan[Realm_ClanRemove[no][c].target] = 0;
                Realm_ClanRank[Realm_ClanRemove[no][c].target] = 0;
                Realm_ClanRemove[no][c].target = 0;
                

            }
        }


    }





}





}











}