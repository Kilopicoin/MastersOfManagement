// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

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


contract pool {

mapping (uint256 => uint256) public Realm_Points; // puan kaydı
mapping (uint256 => address) public Realm_Addresses; // adres kaydı
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Buildings; // tip ve adet sayacı ( gerçek planette )
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Weapons; // 2-Wooden Club, 3-Wooden Axe ...(gerçek planette)
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Techs; // no'lar tipi, 1-0 on-off (gerçek planette)
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Soldiers; // 2-Wooden Club, 3-Wooden Axe ... (gerçek warsta)
mapping (uint256 => uint256) public Realm_Pop; // Pop kaydı (gerçek planette)
mapping (uint256 => uint256) public Realm_Food; // food kaydı (gerçek planette)
mapping (uint256 => uint256) public Realm_Wood; // wood kaydı (gerçek planette)

address public input;
address public owner;

uint[] public Buildings_Global = [0,0,100,150,200,250,300,350,400]; // 0,0,home,warehouse,workshop,armory,pit,clanhall,tower
uint[] public Weapons_Global = [0,0,1,2,3,2]; // 0,0,WClub,WoodenAxe,WoodenSpear,WoodenBow
uint[] public Tech_Global = [0,0,1000,2000,3000,4000,5000]; // 0,0,comb,rope,design,boneArmor,training
uint[] public Soldiers_Global = [0,0,5,10,15,10]; // 0,0,WClub,WoodenAxe,WoodenSpear,WoodenBow

constructor () {
    owner = msg.sender;
}


function AddInputter (address inputter) public {
    require(msg.sender == owner, "o");
    input = inputter;
}

function P_AddRealm (address adres, uint256 no) public {
    require(msg.sender == input, "i");
    Realm_Addresses[no] = adres;
    Realm_Points[no] = 10;
}

function P_AddBuilding (uint256 no, uint256 bina) public {
    require(msg.sender == input, "i");
    Realm_Buildings[no][bina] += 1;
}

function P_AddWeapon (uint256 no, uint256 weapon, uint256 quantity) public {
    require(msg.sender == input, "i");
    Realm_Weapons[no][weapon] += quantity;
}

function P_AddTech (uint256 no, uint256 tech) public {
    require(msg.sender == input, "i");
    Realm_Techs[no][tech] = 1;
}

function P_AddSoldier (uint256 no, uint256 soldier, uint256 quantity) public {
    require(msg.sender == input, "i");
    Realm_Soldiers[no][soldier] += quantity;
}

function P_AddRes (uint256 no, uint256 pop, uint256 food, uint256 wood) public {
    require(msg.sender == input, "i");
    Realm_Pop[no] = pop;
    Realm_Food[no] = food;
    Realm_Wood[no] = wood;
}


function calculatePoints (uint256 no) public {
    require(msg.sender == input, "i");

    Realm_Points[no] = 10;

    for(uint c=2; c<=8; c++){
        Realm_Points[no] += (Realm_Buildings[no][c] * Buildings_Global[c]);
    }

    for(uint c=2; c<=5; c++){
        Realm_Points[no] += (Realm_Weapons[no][c] * Weapons_Global[c]);
    }

    for(uint c=2; c<=6; c++){
        Realm_Points[no] += (Realm_Techs[no][c] * Tech_Global[c]);
    }

    for(uint c=2; c<=5; c++){
        Realm_Points[no] += (Realm_Soldiers[no][c] * Soldiers_Global[c]);
    }

    Realm_Points[no] += ( Realm_Pop[no] * 100 );
    Realm_Points[no] += Realm_Food[no];
    Realm_Points[no] += Realm_Wood[no];


}





}