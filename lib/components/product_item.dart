import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/product.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final double maxWidth;

  const ProductItem({super.key, required this.product, required this.maxWidth});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
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
              SizedBox(
                height: 60,
                child: Text(
                  'R\$${(widget.product.price) / 100}',
                  style: const TextStyle(
                      fontFamily: 'Sofia',
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
