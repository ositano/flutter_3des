import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_3des/flutter_3des.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_3des');

  final _string = "10000^1588252956003WWIWSN";
  final _key = "01120505070B0D1112310D0B07020408010C030507112140D2";
  final _iv = "01121304060A0C10";

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('flutter3des', () async {
    final encrypt = await Flutter3des.encryptToHex(_string, _key, iv: _iv);
    final decrypt = await Flutter3des.decryptFromHex(encrypt, _key, iv: _iv);
    expect(decrypt, _string);
  });

  test('flutter3des_new', () async {
    final encrypt = await Flutter3des.encryptToHex(_string, _key, iv: _iv);
    final decrypt = await Flutter3des.decryptFromHex(encrypt, _key, iv: _iv);
    expect(decrypt, _string);
  });

}
