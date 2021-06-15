import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_3des/flutter_3des.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const _string = "my name is flutter";

class _MyAppState extends State<MyApp> {
  static const _key = "702040801020305070B0D1101020305070B0D1112110D0B0";
  static const _iv = "070B0D1101020305";

  Uint8List? _encrypt;
  String _decrypt = '';
  String _encryptHex = '';
  String _decryptHex = '';
  String _encryptBase64 = '';
  String _decryptBase64 = '';
  String _text = _string;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {
    if (_text.isEmpty) {
      _text = _string;
    }
    try {
      _encrypt = await Flutter3des.encrypt(_text, _key, iv: _iv);
      _decrypt = await Flutter3des.decrypt(_encrypt!, _key, iv: _iv);
      _encryptHex = await Flutter3des.encryptToHex(_text, _key, iv: _iv);
      _decryptHex = await Flutter3des.decryptFromHex(_encryptHex, _key, iv: _iv);
      _encryptBase64 = await Flutter3des.encryptToBase64(_text, _key, iv: _iv);
      _decryptBase64 = await Flutter3des.decryptFromBase64(_encryptBase64, _key, iv: _iv);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'TripleDES (3DES)'
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                _row('KEY', _key),
                _row('IV', _iv),
                _row('String', _string),
                _row('Encrypted in Base64', _encryptBase64),
                _row('Encrypted in Byte Array', _encrypt.toString()),
                _row('Encrypted in Hex', _encryptHex),
              ],
            ),
          ),
        ),
      ),
    );
  }


  _row(String label, String value){
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.w600),),
      subtitle: Text(value),
    );
  }

}