/*
  Class designed to send HTTP requests to supermarket websites and 
*/

import 'package:eatneat/backend/supermarket_data/supermarket.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:puppeteer/puppeteer.dart';


class Scraper {

  static Future<List<dynamic>> fetchProductData(String searchQuery, Supermarket supermarket) async {

    List<dynamic> scrapedProducts = [];

    final url = Supermarkets.getSupermarketUrl(searchQuery, supermarket);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36'
      });

      // scraping succeeded so parse our data and process it
      if (response.statusCode == 200) {
        scrapedProducts = _parseResponse(response);
        
      } else {
        print('Error: Unable to fetch data. Status code: ${response.statusCode}');
      }
    } 
    catch(exception) {
      print("Error ${exception.toString()}");
    }
    
    return scrapedProducts;
  }

  static List<dynamic> _parseResponse(http.Response response) {
    print(response.body);

    return [];
  }

  static Future<List<dynamic>> fetchProductData2(String searchQuery, Supermarket supermarket) async {
    List<dynamic> products = [];

    final browser = await puppeteer.launch(headless: true);
    final page = await browser.newPage();

    await page.goto(Supermarkets.getSupermarketUrl(searchQuery, supermarket), wait: Until.networkIdle);

    var productTitle = await page.evaluate('''
      () => {
        const element = document.getElementById('your-element-id');
        return element ? element.innerText : 'Element not found';
      }
    ''');

    print(productTitle);

    return [];
  }
}