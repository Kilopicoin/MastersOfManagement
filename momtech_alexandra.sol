// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract RoM_Tech{


mapping (uint256 => mapping (string => uint256)) public RealmNoResearchRate;



function RealmNoResearchRatex(uint256 user_id, string memory tech, uint256 amount) public returns (bool) {
            RealmNoResearchRate[user_id][tech] = amount;
            return true;
    }


function RealmNoResearchRatey(uint256 user_id, string memory techname) public view returns (uint256) {
            uint256 amount = RealmNoResearchRate[user_id][techname];
            return amount;
    }

function techRateClear(uint256 realmidxy) public returns (bool) {

        RealmNoResearchRate[realmidxy]["Gathering"] = 0;
        RealmNoResearchRate[realmidxy]["StoneCutting"] = 0;
        RealmNoResearchRate[realmidxy]["WoodCutting"] = 0;
        RealmNoResearchRate[realmidxy]["WoodenClub"] = 0;
        RealmNoResearchRate[realmidxy]["StoneTools"] = 0;
        RealmNoResearchRate[realmidxy]["StoneAxe"] = 0;
        RealmNoResearchRate[realmidxy]["StoneKnife"] = 0;
        RealmNoResearchRate[realmidxy]["StoneSpear"] = 0;
        RealmNoResearchRate[realmidxy]["StoneArrowBow"] = 0;
        RealmNoResearchRate[realmidxy]["Hunting"] = 0;
        RealmNoResearchRate[realmidxy]["ControlOfFire"] = 0;
        RealmNoResearchRate[realmidxy]["Taming"] = 0;
        RealmNoResearchRate[realmidxy]["Fishing"] = 0;
        RealmNoResearchRate[realmidxy]["Rope"] = 0;
        RealmNoResearchRate[realmidxy]["WoodenBoat"] = 0;
        RealmNoResearchRate[realmidxy]["Clothing"] = 0;
        RealmNoResearchRate[realmidxy]["Cooking"] = 0;
        RealmNoResearchRate[realmidxy]["Harpoon"] = 0;
        RealmNoResearchRate[realmidxy]["Bed"] = 0;
        RealmNoResearchRate[realmidxy]["Shoes"] = 0;
        RealmNoResearchRate[realmidxy]["Weaving"] = 0;
        RealmNoResearchRate[realmidxy]["Ceramics"] = 0;
        RealmNoResearchRate[realmidxy]["Pottery"] = 0;
        RealmNoResearchRate[realmidxy]["Farming"] = 0;
        RealmNoResearchRate[realmidxy]["Settlement"] = 0;

        return true;
    }


}