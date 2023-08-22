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
    uint256 wood;

}

struct Realm_Buildingz{

    uint256 typeB;
    int256 posxB;
    int256 posyB;

}

address public owner;

address public A_Feedback;

bool public statusWorld;

uint256 public RealmCount;
    
    mapping(address => uint256) public RealmCreated;

    mapping (uint256 => string) public Realm_Name;
    mapping (uint256 => Realm_Pos) public Realm_PosX;
    mapping (uint256 => Realm_Res) public Realm_ResX;

    mapping (uint256 => mapping (uint256 => uint256)) public Realm_Buildings; // tip ve adet sayacı
    mapping (uint256 => mapping (uint256 => Realm_Buildingz)) public Realm_BuildingzX; // numara ve tip-koordinat
    mapping (uint256 => uint256) public Realm_BuildingCount; // numara sayacı


    mapping (int256 => mapping (int256 => bool)) public Occupied; // x - y - dolu - boş

constructor (address feedbackAdres)  {

    owner = msg.sender;
statusWorld = false;
A_Feedback = feedbackAdres;

    }

function addRealm(int256 pX, int256 pY, string memory name) public {

        require(statusWorld, "Wworld Inactive");

        require(RealmCreated[msg.sender] == 0, "Realm Exists");

        RealmCount++;

        RealmCreated[msg.sender] = RealmCount;
        
        Realm_Name[RealmCount] = name;
		Realm_PosX[RealmCount] = Realm_Pos(msg.sender,pX,pY);
        Realm_ResX[RealmCount] = Realm_Res(2,10,100,100);

        Occupied[pX][pY] = true;


        Realm_Buildings[RealmCount][1] = 1;
        Realm_BuildingCount[RealmCount] = 1;
        Realm_BuildingzX[RealmCount][1] = Realm_Buildingz(1,pX,pY);

	}






    function setStatusWorld() public {
        require(msg.sender == owner, "Only owner");
  
        if (statusWorld == false) {
            statusWorld = true;
        } else 
        statusWorld = false;
	}







}