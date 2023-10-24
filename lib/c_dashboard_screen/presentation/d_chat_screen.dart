import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:mmatka/utils/core/app_constant.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:AppConstant.secondaryColor,
        appBar: AppBar(
          title: const Text('M-Matka'),
          backgroundColor:AppConstant.backgroundColor,
          elevation: 0,
        ),
        body: Tawk(
          directChatLink: 'https://tawk.to/chat/62e2de9f37898912e960232b/1g933b8ek/',
          visitor: TawkVisitor(
            name: 'gvgvgh',
            email: 'cfgvgvg@gmail.com',
          ),
          onLoad: () {
            print('Hello M-Matka user!');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: const Center(
            child: Text('Loading....'),
          ),
        ),
      ),
    );
  }
}


