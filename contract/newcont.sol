// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

contract MyTicket is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyTicket", "BRA") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmQaCGH6vD23rvYeXenhM2NUKMw7gQkfSzDXuQVzczWY1d/";
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    uint256 number; //ticket num

    uint status = 0;

    struct Ticket {
       address owner; // ticket owner
        bytes32 hashData;  // hashed user data
        bool useStatus; // check-in status
        
    }


    Ticket[] public ticketList; // all tickets

     function CheckTicketExists(address user) public view returns (uint){

        
        for (uint i = 0; i < ticketList.length; i++) {

            if(ticketList[i].owner == user){

                
                return (i+1);


            }

        }        

        return 0;
    }


    function AddTicket(address user, bytes32 data) public returns (bool){
        
        
        if (CheckTicketExists(user)==0) {
            
            number++;

        ticketList.push(Ticket({
                owner: user,
                hashData: data,
                useStatus: false
            }));

            status = 6;
            return true;

        } else {
            
            status = 7;
            return false;


        }
        
             


    }

    function UseTicket(address user, bytes32 data) public returns (bytes32){
       
            uint num = CheckTicketExists(user);

       if (num ==0) {

          status = 1;
           return "No ticket";

       }
       
       if(ticketList[num-1].hashData != data){

           status = 2;
           return "Wrong data";

       }
       
         if(ticketList[num-1].useStatus == true){

             status = 3;
            return "Used ticket";

        }

        //number--;

        ticketList[num-1].useStatus = true;


        safeMint(user);

        status = 5;
        return "OK";




    }


   function AddTestTiket() public {


       address addr = address(uint160(uint(keccak256(abi.encodePacked(block.timestamp, number)))));
       AddTicket(addr, "q");


   }

   function UseTestTicket(uint num) public returns(bytes32){


       if(num>=ticketList.length){

           status = 4;
           return "Bad index";

       }

       address testNm = ticketList[num].owner;
       bytes32 testData = ticketList[num].hashData;

        bytes32 str = UseTicket(testNm, testData);

    return str;




   }

   function ShowStatus() public view returns(uint){

       
       return status;


   }








}