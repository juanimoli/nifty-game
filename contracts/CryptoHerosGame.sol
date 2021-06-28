pragma solidity >=0.4.22 <0.9.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';
import './CryptoHerosToken.sol';

contract CryptoHerosGame is Ownable {
  
  uint constant gameFee = 0.005 ether;
  uint constant minPrice = 0.01 ether;
  uint constant minHerosToken = 5 ether;

  //address public cryptoHerosGame = 0x0;
  uint256 public maxSingleGameId = 0;

  uint nonce = 0;
  CryptoHerosToken cryptoHerosToken;

  struct SingleGame {
    address player;
    uint256 userResult;
    uint256 contractResult;
    uint256 playerBet;
    uint8 game; // 0: smaller. 1: greater
    uint8 result; // 0 user win, 1 contract win, 2 draw
  }

  SingleGame[] public singleGames;

  mapping(address => uint256[]) public usersSingleGames;

  constructor(CryptoHerosToken _cryptoHerosToken) public { 
    cryptoHerosToken = _cryptoHerosToken;
  }

  fallback() external payable {}

  function createSingleGame(uint _tokenId) payable public returns (uint256) {
    require(msg.value >= minPrice);
    require(address(this).balance >= minHerosToken);
    require(cryptoHerosToken.ownerOf(_tokenId) == msg.sender);

    uint userTokenNumber;
    uint contractTokenNumber;
    (userTokenNumber, , ,) = cryptoHerosToken.getTokenProperty(_tokenId);
    (contractTokenNumber, , ,) = cryptoHerosToken.getTokenProperty(rand(0, cryptoHerosToken.getHerosLength()));

    int result;
    uint8 game = uint8(rand(0, 2));
    if (game > 0) {
      result = int(userTokenNumber - contractTokenNumber);
    } else {
      result = int(contractTokenNumber - userTokenNumber);
    }

    SingleGame memory _singleGame;
    if (result == 0) {
      _singleGame = SingleGame({player: msg.sender, userResult: userTokenNumber, contractResult: contractTokenNumber, playerBet: msg.value, game: game, result: 2});
      require(payable(msg.sender).send(msg.value * 1 - gameFee));

    } else if (result > 0) {
      _singleGame = SingleGame({player: msg.sender, userResult: userTokenNumber, contractResult: contractTokenNumber, playerBet: msg.value, game: game, result: 0});
      require(payable(msg.sender).send(msg.value * 150 / 100));

    } else {
      _singleGame = SingleGame({player: msg.sender, userResult: userTokenNumber, contractResult: contractTokenNumber, playerBet: msg.value, game: game, result: 1});
    }

    singleGames.push(_singleGame);
    
    maxSingleGameId = singleGames.length - 1;

    usersSingleGames[msg.sender].push(maxSingleGameId);

    return maxSingleGameId;
  }

  // function readUserGamesCount(address _address, uint _idx) public returns (uint){
  //   return usersSingleGames[_address][_idx].length;
  // }

  function getUserSingleGames(address _address) external view returns (uint256[] memory) {
    return usersSingleGames[_address];
  }

  function rand(uint min, uint max) private returns(uint256) {
    nonce++;
    uint256 seed = uint256(keccak256(abi.encodePacked(
        block.timestamp + block.difficulty +
        ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
        block.gaslimit + 
        ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
        block.number + nonce
    )));
    
    return seed%(min+max)-min;
    }

  function withdraw(uint amount) public payable onlyOwner returns(bool) {
    require(amount <= address(this).balance);
    address payable _owner = payable(owner());
    _owner.transfer(amount);
    return true;
  }
  
}