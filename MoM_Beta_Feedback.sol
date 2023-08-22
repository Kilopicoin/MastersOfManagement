// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;



contract C_Feedback {


struct Feedback{
    address commenter;
    string content;
    uint256 date;
}


uint256 public FeedbackNo;

mapping (uint256 => Feedback) public Feedbacks;

event e_addFeedback (address indexed e_realm, uint256 indexed e_date);


function addFeedback(string memory contenty_) public {



    Feedbacks[FeedbackNo].commenter = msg.sender;

    Feedbacks[FeedbackNo].content = contenty_;

    Feedbacks[FeedbackNo].date = block.timestamp;
    
    FeedbackNo++;




    emit e_addFeedback(msg.sender, block.timestamp);



		}

        



}