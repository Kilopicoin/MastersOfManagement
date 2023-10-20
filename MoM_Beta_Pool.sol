// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

interface IHarmLop {
    function totalSupply() external view returns (uint);
    function balanceOf(address who) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function burn(uint value) external returns (bool);
}

interface Planet {
function P_AddSale(uint256 realmnum, uint256 urunX, uint256 miktarX) external;
function P_AddBuy(uint256 realmnum, uint256 urunX, uint256 miktarX) external;
}

contract pool {

    struct onSale{
        uint256 satan;
        uint256 urun; // 1-food,2-wood,WoodenClub,WA,WS,WB
        uint256 miktar;
        uint256 Topfiyat;
    }

mapping (uint256 => uint256) public Realm_Points; // puan kaydı
mapping (uint256 => address) public Realm_Addresses; // adres kaydı
mapping (address => uint256) public RealmCreated;
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Buildings; // tip ve adet sayacı ( gerçek planette )
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Weapons; // 2-Wooden Club, 3-Wooden Axe ...(gerçek planette)
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Techs; // no'lar tipi, 1-0 on-off (gerçek planette)
mapping (uint256 => mapping (uint256 => uint256)) public Realm_Soldiers; // 2-Wooden Club, 3-Wooden Axe ... (gerçek warsta)
mapping (uint256 => uint256) public Realm_Pop; // Pop kaydı (gerçek planette)
mapping (uint256 => uint256) public Realm_Food; // food kaydı (gerçek planette)
mapping (uint256 => uint256) public Realm_Wood; // wood kaydı (gerçek planette)

mapping (uint256 => bool) public RealmMarket; // Market var mı
mapping (uint256 => onSale) public onSales; // Market içerik
uint256 public onSalesCounter;

address public input;
address public owner;

address public whiteHole; // video service
address public stake1Hole;
address public stake2Hole;
address public daoHole;

uint[] public Buildings_Global = [0,0,100,150,200,250,300,350,400]; // 0,0,home,warehouse,workshop,armory,pit,clanhall,tower
uint[] public Weapons_Global = [0,0,1,2,3,2]; // 0,0,WClub,WoodenAxe,WoodenSpear,WoodenBow
uint[] public Tech_Global = [0,0,1000,2000,3000,4000,5000]; // 0,0,comb,rope,design,boneArmor,training
uint[] public Soldiers_Global = [0,0,5,10,15,10]; // 0,0,WClub,WoodenAxe,WoodenSpear,WoodenBow

uint256 public prize;
IHarmLop public token;
Planet public A_Planet;

constructor (IHarmLop _token, address white, address stake1, address stake2, address dao) {
    owner = msg.sender;
    token = _token;
    whiteHole = white;
    stake1Hole = stake1;
	stake2Hole = stake2;
	daoHole = dao;
}

function definePlanet (Planet A_PlanetX) public {
    require(msg.sender == owner, "o");
    A_Planet = A_PlanetX;
}

function P_market (uint256 no) public {
    require(msg.sender == input, "i");
    RealmMarket[no] = true;
}

function putOnSale (uint256 urunX, uint256 miktarX, uint256 topFiyatX) public {
    uint256 realmnum = RealmCreated[msg.sender];
    require(RealmMarket[realmnum] == true, "Market");

    A_Planet.P_AddSale(realmnum, urunX, miktarX);


    onSalesCounter++;
    onSales[onSalesCounter].satan = realmnum;
    onSales[onSalesCounter].urun = urunX;
    onSales[onSalesCounter].miktar = miktarX;
    onSales[onSalesCounter].Topfiyat = topFiyatX;
}


function cancelSale (uint256 salesIDX) public {
    uint256 realmnum = RealmCreated[msg.sender];
    require(onSales[salesIDX].satan == realmnum, "match");
    A_Planet.P_AddBuy(realmnum, onSales[salesIDX].urun, onSales[salesIDX].miktar);
    onSales[salesIDX].miktar = 0;
}


function buy (uint256 salesIDX) public {
    uint256 realmnum = RealmCreated[msg.sender];
    require(RealmMarket[realmnum] == true, "Market");

    address satanAdres = Realm_Addresses[onSales[salesIDX].satan];
    uint256 urunSira = onSales[salesIDX].urun;
    uint256 miktarAdet = onSales[salesIDX].miktar;
    uint256 TopToken = onSales[salesIDX].Topfiyat;

    require(miktarAdet != 0, "bos");
    require(token.balanceOf(address(msg.sender)) >= TopToken, "balanceX");
    require(token.transferFrom(msg.sender,(address(this)),TopToken));

    uint256 forSatan = ( TopToken * 90 ) / 100;
	uint256 forWhiteStakeDAOburn = TopToken / 100; // white, stake1, stake2, DAO, burn

	uint256 totalDagilan = forSatan + ( forWhiteStakeDAOburn * 5 );
	prize += (TopToken - totalDagilan);

    require(token.transfer(whiteHole, forWhiteStakeDAOburn));
	require(token.transfer(stake1Hole, forWhiteStakeDAOburn));
	require(token.transfer(stake2Hole, forWhiteStakeDAOburn));
	require(token.transfer(daoHole, forWhiteStakeDAOburn));
    require(token.transfer(satanAdres, forSatan));
    require(token.burn(forWhiteStakeDAOburn));

    A_Planet.P_AddBuy(realmnum, urunSira, miktarAdet);
    onSales[salesIDX].miktar = 0;
}




function prizeadd(uint256 xyzaprize_) public {
        require(msg.sender == owner, "only owner");
        require(token.balanceOf(address(msg.sender)) >= xyzaprize_, "balanceX");
        token.transferFrom(msg.sender,(address(this)),xyzaprize_);
        prize = prize + xyzaprize_;
}

function PuanDegis(uint256 RealmN, uint256 UsersXpointsi) public {
            require(msg.sender == owner, "only owner");
            Realm_Points[RealmN] = UsersXpointsi;
}

function prizeRelease(uint256 RealmCount ) public {
require(msg.sender == owner, "only owner");

uint256 totalPoints = 0;
            for(uint b=1; b<=RealmCount; b++){
                totalPoints = totalPoints + Realm_Points[b];
            }

            for(uint t=1; t<=RealmCount; t++){
                uint256 toBeSent = Realm_Points[t] * prize;
                toBeSent = toBeSent / totalPoints;
                if ( toBeSent > 1000000 ) {
                toBeSent = toBeSent - 1000000;
                }
                token.transfer(Realm_Addresses[t], toBeSent);
            }
}

function AddInputter (address inputter) public {
    require(msg.sender == owner, "o");
    input = inputter;
}

function P_AddRealm (address adres, uint256 no) public {
    require(msg.sender == input, "i");
    Realm_Addresses[no] = adres;
    Realm_Points[no] = 10;
    RealmCreated[adres] = no;
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