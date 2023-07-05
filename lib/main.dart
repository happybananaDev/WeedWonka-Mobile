import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'includes/base_http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize variables
  List<dynamic> products = [];
  int currentIndex = 0;
  final controller = CarouselController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var response =
        await BaseHttp().get('/products/best-sellers').catchError((error) {
      print(error);
    });
    setState(() {
      products = response['products'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeedWonka Mobile Shop',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WeedWonka - Home'),
          backgroundColor: Colors.green[400],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Prodotti in evidenza',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
              products.isEmpty
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        CarouselSlider.builder(
                          carouselController: controller,
                          itemCount: products.length,
                          itemBuilder: (context, index, realIdex) {
                            return Container(
                              width: 300,
                              height: 350,
                              margin: const EdgeInsets.only(
                                  top: 10, left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                'https://api.weedwonka.it/storage/${products[index]['images'][0]['image']}',
                                width: 200,
                                height: 200,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 350,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: AnimatedSmoothIndicator(
                            activeIndex: currentIndex,
                            count: products.length,
                            effect: const SlideEffect(
                              dotColor: Colors.green,
                              activeDotColor: Colors.greenAccent,
                            ),
                            onDotClicked: (index) {
                              controller.animateToPage(index);
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.orange,
        //   child: const Icon(Icons.add),
        //   onPressed: () async {
        //     var response =
        //         await BaseHttp().get('/products').catchError((error) {
        //       print(error);
        //     });
        //     products = response['products'];
        //   },
        // ),
      ),
    );
  }
}
