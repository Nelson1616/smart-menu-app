import 'package:flutter/material.dart';
import 'package:smart_menu_app/components/session_user_bar.dart';
import 'package:smart_menu_app/models/session_order.dart';
import 'package:smart_menu_app/models/session_user.dart';

class OrderItem extends StatefulWidget {
  final SessionUser currentUser;
  final SessionOrder sessionOrder;
  final double maxWidth;

  const OrderItem(
      {super.key,
      required this.currentUser,
      required this.sessionOrder,
      required this.maxWidth});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool currentUserInOrder = false;

  List<UserBar> sessionUserBars = [];

  List<SessionUser> getSessionUsers() {
    List<SessionUser> list = [];

    for (int i = 0; i < widget.sessionOrder.sessionOrderUsers.length; i++) {
      if (widget.sessionOrder.sessionOrderUsers.elementAt(i).sessionUser!.id ==
          widget.currentUser.id) {
        currentUserInOrder = true;
      }

      list.add(widget.sessionOrder.sessionOrderUsers.elementAt(i).sessionUser!);
    }

    return list;
  }

  bool verifyOrderNotFinished() {
    return widget.sessionOrder.statusId != 4 &&
        widget.sessionOrder.statusId != 0;
  }

  Widget createTableNumberText() {
    return const SizedBox.shrink();
  }

  Widget createHelpWithOrderButton() {
    if (!currentUserInOrder && verifyOrderNotFinished()) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 60,
        width: widget.maxWidth * 0.8,
        child: ElevatedButton(
          onPressed: () async {
            // try {
            //   await widget.controller
            //       .helpWithOrder(context, widget.sessionOrder.id);
            // } on Exception catch (e) {
            //   widget.controller.showErro(context, e);
            // }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text("Dividir Pedido"), Icon(Icons.handshake_outlined)],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget createNotHelpWithOrderButton() {
    if (currentUserInOrder &&
        widget.sessionOrder.sessionOrderUsers.length > 1 &&
        verifyOrderNotFinished()) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 60,
        width: widget.maxWidth * 0.8,
        child: ElevatedButton(
          onPressed: () async {
            // try {
            //   await widget.controller
            //       .notHelpWithOrder(context, widget.sessionOrder.id);
            // } on Exception catch (e) {
            //   widget.controller.showErro(context, e);
            // }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Deixar de Dividir Pedido"),
              Icon(Icons.exit_to_app)
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget createCancelOrderButton() {
    return const SizedBox.shrink();
  }

  Widget createReceiveOrderButton() {
    return const SizedBox.shrink();
  }

  Widget createDeliverOrderButton() {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    currentUserInOrder = false;
    sessionUserBars = [];

    List<SessionUser> sessionUsers = getSessionUsers();

    for (int i = 0; i < sessionUsers.length; i++) {
      sessionUserBars.add(UserBar(sessionUser: sessionUsers.elementAt(i)));
    }

    String statusText = "Pedido Feito";
    Color colorStatusText = Colors.yellow[800]!;

    Color color = const Color(0xFFFFFFFF);

    if (widget.sessionOrder.statusId == 0) {
      color = Colors.green[100]!;
      statusText = "Pedido Pago";
      colorStatusText = Colors.green[800]!;
    } else if (widget.sessionOrder.statusId == 1) {
      color = Colors.yellow[100]!;
      statusText = "Pedido Feito";
      colorStatusText = Colors.yellow[800]!;
    } else if (widget.sessionOrder.statusId == 2) {
      color = Colors.blue[100]!;
      statusText = "Pedido Recebido";
      colorStatusText = Colors.blue[800]!;
    } else if (widget.sessionOrder.statusId == 3) {
      color = Colors.white;
      statusText = "Pedido Entregue";
      colorStatusText = Colors.black;
    } else {
      color = Colors.red[100]!;
      statusText = "Pedido Cancelado";
      colorStatusText = Colors.red[800]!;
    }

    return Container(
      width: widget.maxWidth,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0xFFD3D3D3))),
      child: Column(
        children: [
          createTableNumberText(),
          SizedBox(
            height: widget.maxWidth * 0.05,
          ),
          Row(
            children: [
              SizedBox(
                width: widget.maxWidth * 0.05,
              ),
              SizedBox(
                width: widget.maxWidth * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sessionOrder.product!.name,
                      style: const TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.sessionOrder.quantity}x ',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                        Text(
                          'R\$${(widget.sessionOrder.product!.price) / 100}',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          '= ',
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Text(
                          'R\$${(widget.sessionOrder.amount) / 100}',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w900,
                              fontSize: 22),
                        ),
                      ],
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                          color: colorStatusText,
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: widget.maxWidth * 0.05,
              ),
              Container(
                width: widget.maxWidth * 0.30,
                height: widget.maxWidth * 0.40,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  widget.sessionOrder.product!.image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: sessionUserBars,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createDeliverOrderButton(),
                  createReceiveOrderButton(),
                  createHelpWithOrderButton(),
                  createNotHelpWithOrderButton(),
                  createCancelOrderButton(),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
