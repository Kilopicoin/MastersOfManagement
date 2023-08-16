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

uint256 public RealmCount;
    
    mapping(address => uint256) public RealmCreated;

    mapping (uint256 => string) public Realm_Name;
    mapping (uint256 => Realm_Pos) public Realm_PosX;
    mapping (uint256 => Realm_Res) public Realm_ResX;

    mapping (int256 => mapping (int256 => bool)) public Occupied; // x - y - dolu - boş

constructor ()  {

    }

function addRealm(int256 pX, int256 pY, string memory name) public {

        require(RealmCreated[msg.sender] == 0, "Realm Exists");

        RealmCount++;

        RealmCreated[msg.sender] = RealmCount;
        
        Realm_Name[RealmCount] = name;
		Realm_PosX[RealmCount] = Realm_Pos(msg.sender,pX,pY);
        Realm_ResX[RealmCount] = Realm_Res(2,10,100,100);

        Occupied[pX][pY] = true;

	}
 

}