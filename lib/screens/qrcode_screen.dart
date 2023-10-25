import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smert_menu_api.dart';
import 'package:smart_menu_app/models/table.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String tableCode = "";

  void searchTable() async {
    try {
      ResponseJson res = await SmartMenuApi.getTableByCode(tableCode);

      if (!res.success) {
        showErro(res.message);
      } else {
        RestaurantTable table = RestaurantTable.fromJson(res.data!);

        if (table.restaurant != null) {
          if (table.restaurant!.products.isNotEmpty) {
            debugPrint(table.restaurant!.products[0].name);
          }
        }
      }
    } on Exception catch (e) {
      debugPrint('$e');
    }
  }

  void showErro(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.red[300],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR-Code",
          style: TextStyle(
              fontFamily: 'Sofia', fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  child: const Image(
                      image: AssetImage('images/qr_code_block.png')),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: const Text(
                    "QR code Indisponível no momento 😢",
                    style: TextStyle(fontFamily: 'Sofia', fontSize: 14),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "Entrar por código da mesa",
                    style: TextStyle(fontFamily: 'Sofia', fontSize: 18),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      tableCode = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Código Inválido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Digite o código da mesa',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      searchTable();
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
      ),
    );
  }
}
