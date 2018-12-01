pragma solidity ^0.4.25;

import "./SafeMath.sol";

contract Escrow {

    enum State { AWAITING_PAYMENT, AWAITING_APPROVAL, COMPLETE, REFUNDED}
    State public currentState;

//what about this???

//get the renter and the landlord from the apartment ID
    modifier renterOnly(uint _apartmentId) { require(msg.sender == renter || msg.sender == arbiter); _; }
    modifier landlordOnly(uint _apartmentId) { require(msg.sender == landlord || msg.sender == arbiter); _; }
    modifier inState(uint _apartmentId,State expectedState) { require(_state[_apartmentId] == expectedState); _; }

   // address public renter;
    //address public landlord;
    address public arbiter;
    
    mapping (uint => uint256) internal _balances;//map each renter with the amount paid
    mapping (uint => State) internal _state;//map each renter with the status of the payment
    
    
    //What should be the constructor??
    constructor(address _renter, address _landlord, address _arbiter) public {
        renter = _renter;
        landlord = _landlord;
        arbiter = _arbiter;
    }
    
    
    function sendPayment(uint _apartmentId) inState(_apartmentId,State.AWAITING_PAYMENT) public payable {
        //get apartment id 
        uint monthlyRent;//from the apartment 
        require(msg.value>=monthlyRent);
        _balances[_apartmentId]= _balances[_apartmentId].add(msg.value);
        
        
        _state[_apartmentId] = State.AWAITING_APPROVAL;
    }

    function confirmApproval(uint _apartmentId) renterOnly inState(_apartmentId,State.AWAITING_APPROVAL) public {
        //get landlord address from apartment and end of lease
         //read renter address get from apartment??
       //maybe check if above the balance is above Monthlyrent
        bool LastMonth;
        uint payment=_balances[_apartmentId];
        _balances[_apartmentId]=0;
        landlord.transfer(payment);
        if(LastMonth){
            _state[_apartmentId] = State.AWAITING_PAYMENT;
        }
        else{
            _state[_apartmentId] = State.AWAITING_PAYMENT;
        }
        
    }

    function refundRenter(uint _apartmentId) landlordOnly inState(_apartmentId,State.AWAITING_APPROVAL) public {
        //read renter address get from apartment
        uint payment=_balances[_apartmentId];
        _balances[_apartmentId]=0;
        renter.transfer(payment);
        _state[_apartmentId] = State.REFUNDED;
    }
}
