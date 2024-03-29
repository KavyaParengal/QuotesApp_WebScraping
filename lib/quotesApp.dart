
import 'package:flutter/material.dart';
import 'package:quotesapp/singlecategory.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class QuotesAppHome extends StatefulWidget {
  const QuotesAppHome({Key? key}) : super(key: key);

  @override
  State<QuotesAppHome> createState() => _QuotesAppHomeState();
}

class _QuotesAppHomeState extends State<QuotesAppHome> {

  List quotes=[];
  List author=[];
  bool isData=false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getQuotes();
  }

  getQuotes() async{
    String url='https://quotes.toscrape.com/';
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName('quote');
    quotes=quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    author=quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();

    setState(() {
      isData=true;
    });
  }

  List<String> categories=["love","inspirational","life","humor"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 50),
              child: const Text("Quotes App",style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: 28
              ),),
            ),
            GridView.count(
                crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 0,
              children: categories.map((category) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleCategoryPage(category)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Text(category.toUpperCase(),style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                          fontSize: 18
                        ),),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            isData==false? const Center(child: CircularProgressIndicator(),): ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 20,left: 20,bottom: 20),
                              child: Text(quotes[index],style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(author[index],style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600
                            ),),
                          )
                        ],
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
