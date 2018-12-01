pragma solidity ^0.4.24;

import "./IERC20.sol";
import "./SafeMath.sol";
/*
for the CrowdSale contract, 
OK you need to require a non-null token, a non-zero rate, a non-null wallet,  
OK it should accept payments within cap once deployed, 
OK it should fail with zero cap, and should reject payments that exceed the cap. 

Also the contract doesn’t revert on zero-valued payments, 
not does it log high-level/low-level purchases, 
or assign tokens to the sender/forward funds to wallet on high-level purchases, 
or assign tokens to beneficary on a low level purchase, or forward funds to wallet. 
You also need to make sure the crowdsale does not reach cap if sent under the cap when ending, 
and should reach cap when ending if the cap is sent.

*/
contract Crowdsale {
    using SafeMath for uint256;

    uint256 private cap; // maximum amount of ether to be raised
    uint256 private weiRaised; // current amount of wei raised

    uint256 private rate; // price in wei per smallest unit of token (e.g. 1 wei = 10 smallet unit of a token)
    address private wallet; // wallet to hold the ethers
    IERC20 private token; // address of erc20 tokens

   /**
    * Event for token purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */
    event TokensPurchased(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    // -----------------------------------------
    // Public functions (DO NOT change the interface!)
    // -----------------------------------------
   /**
    * @param _rate Number of token units a buyer gets per wei
    * @dev The rate is the conversion between wei and the smallest and indivisible token unit.
    * @param _wallet Address where collected funds will be forwarded to
    * @param _token Address of the token being sold
    */
    constructor(uint256 _rate, address _wallet, IERC20 _token, uint _cap) public {
        // TODO: Your Code Here
        require(_cap>0);
        require(_rate>0);
        require(_wallet!=0);
       // require();

        weiRaised=0;
        rate = _rate;
        wallet = _wallet;
        token = _token;
        cap = _cap;//token.totalSupply().div(rate);
    }

    /**
    * @dev Fallback function for users to send ether directly to contract address
    */
    function() external payable {
        // TODO: Your Code Here
        buyTokens(msg.sender);
    }

    function buyTokens(address beneficiary) public payable {
        // Below are some general steps that should be done.
        // You need to decide the right order to do them in.
        //  - Validate any conditions
        //  - Calculate number of tokens
        //  - Update any states
        //  - Transfer tokens and emit event
        //  - Forward funds to wallet

        // TODO: Your Code Here
        require(msg.value>=rate);
        require(msg.value<=cap);
        require(!capReached());
        require(cap >= weiRaised.add(msg.value));
        uint256 pay = msg.value;

        uint256 tok = pay.div(rate);
        uint256 rest = pay.mod(rate);
         pay = pay.sub(rest);
         
        weiRaised =weiRaised.add(pay);
        wallet.transfer(pay);
        token.transfer(beneficiary,tok);
        msg.sender.transfer(rest);
        
        emit TokensPurchased(msg.sender,beneficiary,pay,tok);

    }

    /**
    * @dev Checks whether the cap has been reached.
    * @return Whether the cap was reached
    */
    function capReached() public view returns (bool) {
        // TODO: Your Code Here
        return (weiRaised>=cap);
    }

    // -----------------------------------------
    // Internal functions (you can write any other internal helper functions here)
    // -----------------------------------------


}
