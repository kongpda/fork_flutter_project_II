import 'package:flutter/material.dart';
import 'package:flutter_project_ii/all_event_module/all_event_screen.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/profile_module/language_data.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project_ii/detail_screen.dart';
import 'package:flutter_project_ii/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  //const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Language _lang = Language();
  bool language = true;

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().language;
    List<Event> record = context.watch<EventLogic>().records;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF1A202C),
        title: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Row(
            children: [
              Image(
                image: Image.asset('assets/Wegocolor.png').image,
                height: 45,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 35,
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Positioned(
                right: 10,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF1A202C),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _lang.feature,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 235,
              child: _buildSlider(record),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(
                  _lang.popular,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Spacer(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllEventScreen(),
                          ));
                    },
                    child: Text(
                      _lang.more,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF455AF7)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: record.length,
                itemBuilder: (context, index) {
                  return _buildPopularEventItem(record[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//bool isFavorited = false;
  Widget _buildPopularEventItem(Event slide) {
    bool isFavorited = context.watch<EventLogic>().isFavorited;
    return _navigateToDetailScreen(
      slide,
      child: Card(
        color: Color(0xFF1A1D24),
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        child: Container(
          //padding: EdgeInsets.all(10),
          child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    slide.attributes.featureImage,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slide.attributes.startDate.toString(),
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF455AF7)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        slide.attributes.title,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context.read<EventLogic>().addFavorite(slide, context);
                      context.read<EventLogic>().read(context);
                    },
                    icon: Icon(
                      slide.attributes.isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: slide.attributes.isFavorited
                          ? Colors.red
                          : Colors.grey.shade700,
                      size: 26,
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _buildSlider(List<Event> event) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          height: 235,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: PageView.builder(
            physics: BouncingScrollPhysics(),
            pageSnapping: true,
            itemCount: event.length,
            itemBuilder: (context, index) {
              return _buildSlideItem(event[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlideItem(Event items) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(items),
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  items.attributes.featureImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.sizeOf(context).width,
                  height: 150,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 50,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          (DateFormat('MMM dd, yyyy')
                              .format(DateTime.parse(
                                  items.attributes.startDate.toString()))
                              .substring(0, 3)),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(
                          (DateFormat('MMM dd, yyyy')
                              .format(DateTime.parse(
                                  items.attributes.startDate.toString()))
                              .substring(4, 6)),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            //width: 380,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 350,
                          child: Text(
                            items.attributes.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Row(children: [
                    //   Container(
                    //   width: 50,
                    //   padding: EdgeInsets.all(5),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFF455AF7),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: Center(
                    //   child:
                    //     Text(items.categories.toString(), style: TextStyle(fontSize: 18, color: Colors.white),
                    //     ),

                    // )
                    // ),
                    // ],)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigateToDetailScreen(Event items, {Widget? child}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(items),
            ));
      },
      child: child,
    );
  }
}
