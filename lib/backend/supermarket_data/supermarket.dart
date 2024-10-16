/*
  All of the supported supermarkets which are candidates for items to be added from. 
*/

class Supermarkets {

  /*
    Given a search term and a supermarket, returns the target URL for the scraper to scrape all product data related to this item on the website
  */
  static String getSupermarketUrl(String query, Supermarket supermarket) {
    return switch(supermarket) {
      Supermarket.waitrose => "https://www.waitrose.com/ecom/shop/search?&searchTerm=$query",
      Supermarket.morrisons => "https://groceries.morrisons.com/search?q=$query",
      // Supermarket.tesco => 'https://www.tesco.com/groceries/en-GB/search?query=$query',
      Supermarket.tesco => "https://www.tesco.com",
    };
  }
}

enum Supermarket {
  waitrose,
  tesco,
  morrisons
}