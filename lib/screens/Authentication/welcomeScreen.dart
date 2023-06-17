import 'package:flutter/material.dart';
import 'package:travel_almaty/models/WelcomeModel.dart';
import 'package:travel_almaty/screens/Authentication/SignIn.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const signIn()));
          }, child: Text("Пропустить")),
        ],
      ),
      body: Padding(
          padding:EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
          controller: _pageController,
            itemCount: screens.length,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index){
            setState(() {
              currentIndex = index;
            });
            },
            itemBuilder: (context,index){

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(screens[index].img,
                scale: 0.7,
              ),
              Container(
                height: 13,
                child: ListView.builder(
                    itemCount: screens.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )
                        ],
                      );
                    }),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          screens[index].text,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 27.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(
                      screens[index].desc,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),

              ),

              InkWell(
                onTap: (){
                  if(index==screens.length-1){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> signIn()));

                  }
                  _pageController.nextPage(duration: Duration(microseconds: 500), curve: Curves.bounceIn);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Дальше",

                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),

                        ),
                        SizedBox(width: 15.0,),
                        Icon(Icons.arrow_forward,color: Colors.white,)

                      ],
                  ),
                ),
              )

            ],
          );
        }),
      ),
    );
  }
}
