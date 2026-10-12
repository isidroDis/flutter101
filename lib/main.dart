import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Title',
        ),
        titleTextStyle: TextStyle(
          color: Colors.red, 
          fontSize: 30.0,
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            print("Na Click");
          } , icon: Icon(Icons.home_filled))
        ],
        
        backgroundColor: Colors.white,
        elevation: 0,
      
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_sharp), label: "Image"),
          BottomNavigationBarItem(icon: Icon(Icons.shop_sharp), label: "Shop"), 
        ],
        elevation: 10.0,
        backgroundColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){ 
        print("Clicked");
        },
        child: Icon(
          Icons.plus_one,
        ),
      ),
      drawer: Drawer(
        child: Column(children:[
            DrawerHeader(child: 
              Icon(
              Icons.home_filled, 
              size: 100.0,),
          ),
            ListTile(
              leading: Icon(Icons.phone_android), 
              title: Text("Contact Us"),
              onTap: (){
                print("Clicked Contact Us");
                Navigator.pop(context);  
              },
            ),
            ListTile(
              leading: Icon(Icons.abc_sharp), 
              title: Text("abc"),
              onTap: (){
                print("Clicked abc");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.comment_sharp), 
              title: Text("Comments"),
              onTap: (){
                print("Clicked Comments");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

