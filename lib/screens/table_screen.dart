import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_app/components/product_item.dart';
import 'package:smart_menu_app/models/session_user.dart';
import 'package:smart_menu_app/models/table.dart';

class TableScreen extends StatefulWidget {
  final RestaurantTable table;
  const TableScreen({super.key, required this.table});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  // goToSessionScreen() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const TableScreen(),
  //     ),
  //   );
  // }

  SmartMenuSocketApi? ws;

  void onSocketUsers(data) {
    try {
      debugPrint('$data');

      for (int i = 0; i < (data as List<dynamic>).length; i++) {
        SessionUser sessionUser = SessionUser.fromJson(data[i]);
        debugPrint('${sessionUser.userId}');

        if (sessionUser.user != null) {
          debugPrint(sessionUser.user!.name);
        }
      }
    } on Error catch (e) {
      debugPrint('$e');
    }
  }

  void onSocketError(data) {
    debugPrint('error no socket');
    debugPrint('$data');
  }

  void showErro(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.red[300],
    ));
  }

  List<Widget> avatars = [
    const SizedBox(
      height: 180,
      width: 180,
    )
  ];

  List<Container> products = [];

  int avatarSelected = 1;
  String name = "";

  void enterTable() {}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    ws ??= SmartMenuSocketApi.getSocketByTableCode((widget.table.enterCode));

    ws!.onSocketUsersListener = onSocketUsers;
    ws!.onSocketErrorListener = onSocketError;

    avatars = [];

    for (int i = 1; i < 9; i++) {
      avatars.add(
        RotatedBox(
          quarterTurns: 1,
          child: Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child: Image(
              image: AssetImage('images/avatar_$i.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }

    if (widget.table.restaurant!.products.isNotEmpty) {
      for (int i = 0; i < widget.table.restaurant!.products.length; i++) {
        products.add(
          Container(
            margin: const EdgeInsets.all(10),
            child: ProductItem(
              product: widget.table.restaurant!.products[i],
              maxWidth: screenWidth * 0.9,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.red[300],
      appBar: AppBar(
        title: Text(
          widget.table.restaurant!.name,
          style: const TextStyle(
              fontFamily: 'Sofia', fontSize: 26, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            height: 200,
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              widget.table.restaurant!.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              widget.table.restaurant!.description,
                              style: const TextStyle(
                                fontFamily: 'Sofia',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Mesa ${widget.table.number}",
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontFamily: 'Sofia',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(children: sessionUsers),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(children: products)),
              Container(
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 80),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.red[300],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Perfil",
                          style: TextStyle(
                              color: Colors.grey[100],
                              fontFamily: 'Sofia',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: ListWheelScrollView(
                            diameterRatio: 1.6,
                            offAxisFraction: -0.8,
                            itemExtent: 180,
                            onSelectedItemChanged: (value) {
                              avatarSelected = value + 1;
                            },
                            children: avatars,
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          "Nome",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sofia',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: TextFormField(
                          onChanged: (value) {
                            name = value;
                            debugPrint("avatar = $avatarSelected");
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nome Inválido';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sofia',
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            labelText: 'Digite seu nome',
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 60,
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            enterTable();
                          },
                          child: const Text(
                            'ENTRAR',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
