pragma solidity ^0.4.11;

import './Owned.sol';

contract ChainList is Owned {

  //Custom types
  struct Article{
    uint id;
    address seller;
    address buyer;
    string name;
    string description;
    uint256 price;
  }

  // State variables
  mapping(uint => Article) public articles;
  uint articleCounter;

  //Events
  event sellArticleEvent(
    uint indexed _id,
    address indexed _seller,
    string _name,
    uint256 _price
  );

  event buyArticleEvent(
    uint indexed _id,
    address indexed _seller,
    address indexed _buyer,
    string _name,
    uint256 _price
  );

  //fetch the number of articles in the contract
  function getNumberOfArticles() public constant returns (uint) {
    return articleCounter;
  }

  //fetch and return all article IDs that are available for sale
  function getArticlesForSale() public constant returns (uint[]) {
    //we check if there is at least one article
    if(articleCounter == 0){
      return new uint[](0);
    }

    //prepare th eoutput array
    uint[] memory articleIds = new uint[](articleCounter);

    uint numberOfArticlesForSale = 0;

    //iterarte over articles
    for(uint i = 1; i <= articleCounter; i++){
      if(articles[i].buyer == 0x0){
        articleIds[numberOfArticlesForSale] = articles[i].id;
        numberOfArticlesForSale++;
      }
    }

    //copy the articleIds array into the smaller forSale array
    uint[] memory forSale = new uint[](numberOfArticlesForSale);
    for(uint j = 0; j <numberOfArticlesForSale; j++){
      forSale[j] = articleIds[j];
    }
     return (forSale);
  }

  // sell an article
  function sellArticle(string _name, string _description, uint256 _price) public {

    articleCounter++;
    articles[articleCounter] = Article(
      articleCounter,
      msg.sender,
      0x0,
      _name,
      _description,
      _price
    );
    sellArticleEvent(articleCounter,msg.sender,_name,_price);
  }

  //Payable instructs the function that it may receive a value in the form of ether
  //If payable is not declared then you cannot send value to it
  function buyArticle(uint _id) payable public{


    //Check whether there is atleast one article is for sale
    require(articleCounter > 0);

    //check whether the article exists
    require(_id > 0 && _id <= articleCounter);

    //retrieve the article
    Article storage article = articles[_id];

    //Check whether the article was not already sold
    require(article.buyer == 0x0);

    //We don't allow the seller to buy their own article
    require(msg.sender != article.seller);

    //Check if the value that is sent is equal to the price of the article
    require(msg.value == article.price);

    //If all the above conditions are met the buyer can then buy the article

    //Keep buyer's information
    article.buyer = msg.sender;

    //Transfer the value to the seller
    article.seller.transfer(msg.value);

    //Trigger the buy event
    buyArticleEvent(_id,article.seller,article.buyer,article.name,article.price);

  }

  //Kill the smart contract
  function kill() onlyOwner {
    selfdestruct(owner);
  }
}
