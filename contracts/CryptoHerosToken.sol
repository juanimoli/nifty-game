pragma solidity >=0.4.22 <0.9.0;

//import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
//import 'zeppelin-solidity/contracts/ownership/OwnaFle.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

/**
 * @title ERC721TokenMock
 * This mock just provides a public mint and burn functions for testing purposes,
 * and a public setter for metadata URI
 */
contract CryptoHerosToken is ERC721Enumerable, Ownable {
  mapping (uint256 => address payable) internal tokenOwner;
  uint constant minPrice = 0.01 ether;

  string[] public images;
  string[] public backgrounds;
  string[] public descriptions;
  uint[] public numbers;

  struct Hero {
    uint number;
    string image;
    string background;
    string description;
  }

  uint nonce = 0;
  Hero[] public heros;
  
  mapping(uint256 => Hero) public tokenProperty;
  
  constructor(string memory name, string memory symbol) public
    ERC721(name, symbol)
  { }

  function initImage(string memory _image) public onlyOwner {
    images.push(_image);
  }

  function initBackground(string memory _background) public onlyOwner {
    backgrounds.push(_background);
  }

  function initNumberAndDescription(uint _number, string memory _description) public onlyOwner {
    numbers.push(_number);
    descriptions.push(_description);
  }

  /**
   * Only owner can mint
   */
  function mint() public payable {
    address payable _owner = payable(owner());
    require(numbers.length > 0,"error1");
    require(images.length > 0,"error2");
    require(backgrounds.length > 0,"error3");
    require(descriptions.length > 0,"error4");
    require(msg.value >= minPrice,"error5");
    require(_owner.send(msg.value),"error6");
    uint256 _tokenId = totalSupply();
    tokenOwner[_tokenId] = payable(msg.sender);
    uint num = rand(0, numbers.length);
    uint _number = numbers[num];
    string memory _image = images[rand(0, images.length)];
    string memory _background = backgrounds[rand(0, backgrounds.length)];
    string memory _description = descriptions[num];
    heros.push(Hero({number: _number, image: _image, background: _background, description: _description}));
    tokenProperty[_tokenId] = Hero({number: _number, image: _image, background: _background, description: _description});
    super._mint(msg.sender, _tokenId);
  }

  function burn(uint256 _tokenId) public onlyOwner {
    tokenOwner[_tokenId] = payable(address(0));
    super._burn(_tokenId);
  }

//  function getOwnedTokens(address _owner) external view returns (uint256[]) {
//    return ownedTokens[_owner];
//  }

  function getTokenProperty(uint256 _tokenId) external view returns (uint _number, string memory _image, string memory _background, string memory _description) {
    return (tokenProperty[_tokenId].number, tokenProperty[_tokenId].image, tokenProperty[_tokenId].background, tokenProperty[_tokenId].description);
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
    
  function getHerosLength() external view returns (uint) {
    return heros.length;
  }

  function withdraw(uint amount) public payable onlyOwner returns(bool) {
    require(amount <= address(this).balance);
    address payable _owner = payable(owner());
    _owner.transfer(amount);
    return true;
  }
  
}