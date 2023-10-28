import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_app/components/order_item.dart';
import 'package:smart_menu_app/components/product_sell_item.dart';
import 'package:smart_menu_app/components/session_user_bar.dart';
import 'package:smart_menu_app/models/product.dart';
import 'package:smart_menu_app/models/session_order.dart';
import 'package:smart_menu_app/models/session_user.dart';
import 'package:smart_menu_app/models/table.dart';

class SessionScreen extends StatefulWidget {
  final SessionUser sessionUser;
  final RestaurantTable table;
  const SessionScreen(
      {super.key, required this.sessionUser, required this.table});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  double screenWidth = 300;

  void showErro(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.red[300],
    ));
  }

  int screenState = 0;

  final ScrollController scrollController = ScrollController();

  void payOrder(BuildContext context) async {
    try {} on Exception catch (e) {
      debugPrint('$e');
    }
  }

  Widget menuButton = const SizedBox.shrink();

  Widget cartButton = const SizedBox.shrink();

  bool makeWaiterCallIsEnabled = true;

  Widget createMenuButton() {
    if (screenState == 1) {
      return TextButton(
        onPressed: () {
          scrollList(0);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
        child:
            const Text("Cardápio", style: TextStyle(color: Color(0xFFFFFFF2))),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          scrollList(0);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),
          // Background color
        ),
        child: Text("Cardápio", style: TextStyle(color: Colors.red[300])),
      );
    }
  }

  Widget createCartButton() {
    if (screenState == 1) {
      return ElevatedButton(
        onPressed: () {
          scrollList(1);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFF2),
          // Background color
        ),
        child: Text("Conta", style: TextStyle(color: Colors.red[300])),
      );
    } else {
      return TextButton(
        onPressed: () {
          scrollList(1);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
        child: const Text("Conta", style: TextStyle(color: Color(0xFFFFFFF2))),
      );
    }
  }

  void scrollList(int state) {
    setState(() {
      screenState = state;
    });

    if (screenState == 1) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    } else {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  bool makeWaiterCall() {
    return true;
  }

  List<Container> products = [];

  List<Container> orders = [];

  List<UserBar> sessionUsers = [];

  void makeOrder(Product product, int quantity) {
    debugPrint("ordering $quantity of ${product.name}");

    SmartMenuSocketApi().makeOrder(widget.sessionUser.id, product.id, quantity);
  }

  void onSocketUsersListener() {
    try {
      sessionUsers = [];

      for (int i = 0; i < SmartMenuSocketApi().sessionUsers.length; i++) {
        SessionUser sessionUser = SmartMenuSocketApi().sessionUsers[i];

        if (sessionUser.id == widget.sessionUser.id) {
          widget.sessionUser.amountToPay = sessionUser.amountToPay;
        }

        if (sessionUser.user != null) {
          sessionUsers.add(UserBar(sessionUser: sessionUser));
        }
      }

      setState(() {});
    } on Error catch (e) {
      debugPrint('$e');
    }
  }

  void onSocketOrdersListener() {
    try {
      orders = [];

      for (int i = 0; i < SmartMenuSocketApi().sessionOrders.length; i++) {
        SessionOrder sessionOrder = SmartMenuSocketApi().sessionOrders[i];

        debugPrint(sessionOrder.product!.name);

        orders.add(Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: OrderItem(
              maxWidth: screenWidth,
              sessionOrder: sessionOrder,
              currentUser: widget.sessionUser,
            )));
      }

      setState(() {});
    } on Error catch (e) {
      debugPrint('$e');
    }
  }

  void onSocketError(data) {
    debugPrint('error no socket');
    debugPrint('$data');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    SmartMenuSocketApi().connect();

    SmartMenuSocketApi().setOnSocketUsersListener(onSocketUsersListener);
    SmartMenuSocketApi().setOnSocketErrorListener(onSocketError);
    SmartMenuSocketApi().setOnSocketOrdersListener(onSocketOrdersListener);

    onSocketUsersListener();

    products = [];

    for (int i = 0; i < widget.table.restaurant!.products.length; i++) {
      products.add(Container(
        margin: EdgeInsets.all(screenWidth * 0.05),
        child: ProductSellItem(
          maxWidth: screenWidth * 0.9,
          product: widget.table.restaurant!.products.elementAt(i),
          makeOrder: makeOrder,
        ),
      ));
    }

    scrollList(screenState);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFFFFF2),
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          backgroundColor: Colors.red[300],
          leading: const SizedBox.shrink(),
          title: Container(
            padding: const EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 110,
                  child: createMenuButton(),
                ),
                SizedBox(
                  width: 110,
                  child: createCartButton(),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: 58,
              child: PopupMenuButton(
                icon: CircleAvatar(
                  backgroundImage: AssetImage(
                      "images/avatar_${widget.sessionUser.user!.imageId}.png"),
                  backgroundColor: Colors.red,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: '1',
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text("Sair")),
                          const Icon(Icons.exit_to_app),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size(screenWidth, sessionUsers.isNotEmpty ? 70 : 10),
            child: Container(
              margin: EdgeInsets.only(bottom: sessionUsers.isNotEmpty ? 10 : 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: sessionUsers.isNotEmpty
                        ? sessionUsers
                        : [const SizedBox.shrink()],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                color: const Color(0xFFFFFFF2),
                width: screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: products),
                      ]),
                ),
              ),
              SizedBox(
                width: screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: orders),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red[300],
          ),
          width: screenWidth,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Total: ',
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFF2),
                              fontSize: 14),
                        ),
                        Text(
                          'R\$${(widget.sessionUser.amountToPay) / 100}',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              color: Color(0xFFFFFFF2),
                              fontWeight: FontWeight.w900,
                              fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 170,
                      height: 55,
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  StatefulBuilder(
                                builder: (context, setState) =>
                                    SingleChildScrollView(
                                  child: Dialog(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFFFFFF2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(children: [
                                        const Text(
                                          "Deseja pagar a sua conta?",
                                          style: TextStyle(
                                              fontFamily: 'Sofia',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Total: ',
                                              style: TextStyle(
                                                  fontFamily: 'Sofia',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              'R\$${(widget.sessionUser.amountToPay) / 100}',
                                              style: const TextStyle(
                                                  fontFamily: 'Sofia',
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 30),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              makeWaiterCall();
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Chamar Garçom"),
                                                Icon(Icons.waving_hand),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const ElevatedButton(
                                            onPressed: null,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Pagar com PIX"),
                                                Icon(Icons.qr_code),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const ElevatedButton(
                                            onPressed: null,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Pagar com Cartão"),
                                                Icon(Icons.credit_card),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "PAGAR",
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (makeWaiterCallIsEnabled) {
              setState(() {
                makeWaiterCallIsEnabled = false;
              });

              // await makeWaiterCall().then((value) {
              //   Future.delayed(const Duration(seconds: 3)).then((value) {
              //     setState(() {
              //       makeWaiterCallIsEnabled = true;
              //     });
              //   });
              // });
            } else {
              null;
            }
          },
          tooltip: 'Chamar Garçom',
          child: const Icon(Icons.waving_hand),
        ),
      ),
    );
  }
}
