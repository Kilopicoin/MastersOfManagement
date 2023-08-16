// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;



contract Universe {



struct Planets {
    string planetName;
    address planetAddress;
    uint256 CoordinateX;
    uint256 CoordinateY;
    uint256 CoordinateZ;
    uint256 Radius;
}


mapping (uint256 => Planets) public mapPlanets;


address private  owner;
uint256 public planetCount;

constructor ()  {
  
  owner = msg.sender;

    }

 

function planetInsert(string memory name, address adres, uint256 pX, uint256 pY, uint256 pZ, uint256 R) public returns (bool) {
            require(msg.sender == owner, "only owner");
            planetCount++;

            mapPlanets[planetCount] = Planets(name,adres,pX,pY,pZ,R);


            return true;
    }









}