pragma solidity ^0.4.24;

import './ERC721.sol';

contract CryptoBallers is ERC721 {

    struct Baller {
        string name;
        uint level;
        uint offenseSkill;
        uint defenseSkill;
        uint winCount;
        uint lossCount;
    }

    address owner;
    Baller[] public ballers;

    // Mapping for if address has claimed their free baller
    mapping(address => bool) claimedFreeBaller;

    // Fee for buying a baller
    uint ballerFee = 0.10 ether;

    /**
    * @dev Ensures ownership of the specified token ID
    * @param tokenId uint256 ID of the token to check
    */
    modifier onlyOwnerOf(uint256 _tokenId) {
        // TODO add your code
       
       require(msg.sender==ownerOf(_tokenId));
       _;
    }

    /**
    * @dev Ensures ownership of contract
    */
    modifier onlyOwner() {
        // TODO add your code
        require(owner==msg.sender);
        _;
    }

    /**
    * @dev Ensures baller has level above specified level
    * @param level uint level that the baller needs to be above
    * @ballerId uint ID of the Baller to check
    */
    modifier aboveLevel(uint _level, uint _ballerId) {
        // TODO add your code
        require(ballers[_ballerId].level >=_level);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    /**
    * @dev Allows user to claim first free baller, ensure no address can claim more than one
    */
    function claimFreeBaller() public {
        // TODO add your code
        require(!claimedFreeBaller[msg.sender]);
       
        claimedFreeBaller[msg.sender]=true;
         //do I create a new token??
       _createBaller("FreeBaller",2, 3, 2);
    }

    /**
    * @dev Allows user to buy baller with set attributes
    */
    function buyBaller() public payable {
        // TODO add your code
        require(msg.value>=ballerFee);
        uint r_level;
        uint r_Offensive;
        uint r_defensicve;
        uint paid = msg.value/ballerFee;
        if(paid>=5){
            paid=5;
            r_defensicve=5;
            r_Offensive=5;
            r_level=5;
        }
        else if (paid>=3){
            
            paid=3;
            r_defensicve=4;
            r_Offensive=3;
            r_level=3;
        }
        else if (paid>=2){
            
            paid=2;
            r_defensicve=3;
            r_Offensive=2;
            r_level=2;
        }
        else {
            
            paid=1;
            r_defensicve=2;
            r_Offensive=2;
            r_level=1;
        }
        
        msg.sender.transfer(paid*ballerFee);
        _createBaller("NewPaidBaller",r_level, r_Offensive, r_defensicve);
    }

    /**
    * @dev Play a game with your baller and an opponent baller
    * If your baller has more offensive skill than your opponent's defensive skill
    * you win, your level goes up, the opponent loses, and vice versa.
    * If you win and your baller reaches level 5, you are awarded a new baller with a mix of traits
    * from your baller and your opponent's baller.
    * @param ballerId uint ID of the Baller initiating the game
    * @param targetId uint ID that the baller needs to be above
    */
    function playBall(uint _ballerId, uint _opponentId) onlyOwnerOf(_ballerId) public {
       // TODO add your code
       uint winner=0;
       if(ballers[_ballerId].offenseSkill>ballers[_opponentId].defenseSkill){
           winner =_ballerId;
       }
       else if(ballers[_opponentId].offenseSkill>ballers[_ballerId].defenseSkill){
           winner =_opponentId;
       }
       ballers[winner].level= ballers[winner].level.add(1);
        if(ballers[winner].level==5){
            uint r_level;
            uint r_Offensive;
            uint r_defensicve;
            (r_level, r_Offensive, r_defensicve) = _breedBallers(ballers[_ballerId],ballers[_opponentId]);
            //How do I assign to the opponent?? transfer??
            _createBaller("NewWonBaller",r_level, r_Offensive, r_defensicve);//.call(ownerOf(winner));
        }
           
       
    }

    /**
    * @dev Changes the name of your baller if they are above level two
    * @param ballerId uint ID of the Baller who's name you want to change
    * @param newName string new name you want to give to your Baller
    */
    function changeName(uint _ballerId, string _newName) external aboveLevel(2, _ballerId) onlyOwnerOf(_ballerId) {
        // TODO add your code
        ballers[_ballerId].name=_newName;
        
    }

    /**
   * @dev Creates a baller based on the params given, adds them to the Baller array and mints a token
   * @param name string name of the Baller
   * @param level uint level of the Baller
   * @param offenseSkill offensive skill of the Baller
   * @param defenseSkill defensive skill of the Baller
   */
    function _createBaller(string _name, uint _level, uint _offenseSkill, uint _defenseSkill) internal {
        // TODO add your code
        uint newId = ballers.length;
        ballers[newId].name=_name;
        ballers[newId].level=_level;
        ballers[newId].offenseSkill=_offenseSkill;
        ballers[newId].defenseSkill=_defenseSkill;
        _mint(msg.sender,newId);
        
    }

    /**
    * @dev Helper function for a new baller which averages the attributes of the level, attack, defense of the ballers
    * @param baller1 Baller first baller to average
    * @param baller2 Baller second baller to average
    * @return tuple of level, attack and defense
    */
    function _breedBallers(Baller _baller1, Baller _baller2) internal pure returns (uint, uint, uint) {
        uint level = _baller1.level.add(_baller2.level).div(2);
        uint attack = _baller1.offenseSkill.add(_baller2.offenseSkill).div(2);
        uint defense = _baller1.defenseSkill.add(_baller2.defenseSkill).div(2);
        return (level, attack, defense);

    }
}