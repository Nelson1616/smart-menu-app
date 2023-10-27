import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/product.dart';

class ProductSellItem extends StatefulWidget {
  final Product product;
  final double maxWidth;
  final Function makeOrder;

  const ProductSellItem(
      {super.key,
      required this.product,
      required this.maxWidth,
      required this.makeOrder});

  @override
  State<ProductSellItem> createState() => _ProductSellItemState();
}

class _ProductSellItemState extends State<ProductSellItem> {
  int quantity = 1;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.maxWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFD3D3D3)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widget.maxWidth * 0.4,
                height: widget.maxWidth * 0.4,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: widget.maxWidth * 0.05,
              ),
              SizedBox(
                width: widget.maxWidth * 0.5,
                child: Column(
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.product.description,
                      style: const TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 60,
                width: widget.maxWidth * 0.45,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: const Text("-"),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                    ),
                    Text('$quantity'),
                    TextButton(
                      child: const Text("+"),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: widget.maxWidth * 0.45,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (isEnabled) {
                      setState(() {
                        isEnabled = false;
                      });

                      widget.makeOrder(widget.product, quantity);
                    } else {
                      null;
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fazer Pedido',
                        style: TextStyle(
                            fontFamily: 'Sofia',
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      Text(
                        'R\$${(widget.product.price * quantity) / 100}',
                        style: const TextStyle(
                            fontFamily: 'Sofia',
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: widget.maxWidth * 0.03,
          ),
        ],
      ),
    );
  }
}
