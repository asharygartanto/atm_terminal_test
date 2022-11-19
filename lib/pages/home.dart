import 'package:atm_terminal_test/model/account.dart';
import 'package:atm_terminal_test/widget/toolbar.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_export.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String cmd;
  List<String> lItems = [];
  final TextEditingController eCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    var rootText = Text(
      "ATM@command:-\$  ",
      style: const TextStyle(color: Color(0xff87d441)),
    );
    var isLogin = false;
    var accName = "";
    double balance = 0;
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Material(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        color: const Color.fromRGBO(56, 4, 40, 0.9),
                        type: MaterialType.canvas,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width,
                                // ignore: prefer_const_constructors
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xff504b45),
                                    Color(0xff3c3b37),
                                  ], stops: [
                                    0,
                                    100
                                  ]),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Text(
                                        "ATM@command:",
                                        style:
                                            TextStyle(color: Color(0xffd5d0ce)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        "Welcome to gartanto JAGO ATM Terminal!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const Text(
                                        "```bash",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      BlocBuilder<ActionCommandBloc,
                                          ActionCommandState>(
                                        builder: (context, state) {
                                          var msg;

                                          if (state
                                              is ActionCommandLoadingState) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (state
                                              is ActionCommandLoadedState) {
                                            var act = state.account;
                                            if (state.account != null) {
                                              isLogin = state.account!.isLogin!;
                                              accName =
                                                  state.account!.accountName;
                                              balance = state.account!.balance;
                                            }
                                            try {
                                              msg = state.account!.message;
                                              isLogin = state.account!.isLogin!;
                                              lItems.add(msg!);
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: lItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        rootText,
                                                        cmdMsg(index),
                                                      ],
                                                    );
                                                  });
                                            } catch (e) {
                                              msg = e.toString();
                                            }
                                          }
                                          return const Text("");
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          rootText,
                                          Expanded(
                                            child: TextField(
                                              controller: eCtrl,
                                              onChanged: (value) {
                                                cmd = value;
                                              },
                                              textInputAction:
                                                  TextInputAction.go,
                                              onSubmitted: (_) {
                                                setState(() {
                                                  final splitted =
                                                      cmd.split(' ');
                                                  if (!isLogin &&
                                                      splitted[0]
                                                              .toLowerCase() ==
                                                          "login") {}
                                                  var acc;
                                                  if (splitted.length > 1) {
                                                    acc = Account(
                                                      act: splitted[0],
                                                      param: splitted[1],
                                                      isLogin: isLogin,
                                                      accountName: accName,
                                                      balance: balance,
                                                    );
                                                  } else {
                                                    acc = Account(
                                                      act: splitted[0],
                                                      isLogin: isLogin,
                                                      accountName: accName,
                                                      balance: balance,
                                                    );
                                                  }
                                                  context
                                                      .read<ActionCommandBloc>()
                                                      .add(UpdateAction(
                                                          account: acc));

                                                  lItems.add(cmd);
                                                });
                                                eCtrl.clear();
                                              },
                                              autocorrect: false,
                                              autofocus: true,
                                              showCursor: true,
                                              cursorColor: Colors.white,
                                              cursorWidth: 6,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: const InputDecoration
                                                  .collapsed(hintText: ""),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text cmdMsg(int index) {
    return Text(
      lItems[index],
      style: const TextStyle(color: Colors.white),
    );
  }
}
