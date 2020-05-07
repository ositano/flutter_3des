# flutter_3des

A flutter implementation of Triple DES (3DES) algorithm. This plugin is an improvement of [flutter_des](https://pub.dev/packages/flutter_des)

A comparison of Android/iOS result and that of [CryptoJS](https://www.npmjs.com/package/crypto-js)

Android                   |  iOS
:-------------------------:|:-------------------------:
![Android](https://user-images.githubusercontent.com/50879868/81287915-853ccf00-905b-11ea-9d94-f22fdbc572fc.png)   |  ![iOS](https://user-images.githubusercontent.com/50879868/81288121-e795cf80-905b-11ea-9a92-4357aebc9dc2.png)



CryptoJS Implementation             |  CryptoJS Output
:-------------------------:|:-------------------------:
![CryptoJS Implementation](https://user-images.githubusercontent.com/50879868/81287580-ec0db880-905a-11ea-9138-c277da8d7a72.png)  |  ![CryptoJS Output](https://user-images.githubusercontent.com/50879868/81287791-4d358c00-905b-11ea-9f2e-7714a7892965.png)



## Getting Started

## Add Dependency
```
dependencies:
  flutter_3des: #latest version
```

## Implementation

```import 'package:flutter_3des/flutter_3des.dart';

void example() async {
  const string = "my name is flutter";
  const key = "702040801020305070B0D1101020305070B0D1112110D0B0";
  const iv = "070B0D1101020305";

  var encrypt = await Flutter3des.encrypt(string, key, iv: iv);
  var decrypt = await Flutter3des.decrypt(encrypt, key, iv: iv);
  var encryptHex = await Flutter3des.encryptToHex(string, key, iv: iv);
  var decryptHex = await Flutter3des.decryptFromHex(encryptHex, key, iv: iv);
  var encryptBase64 = await Flutter3des.encryptToBase64(string, key, iv: iv);
  var decryptBase64 = await Flutter3des.decryptFromBase64(encryptBase64, key, iv: iv);
}```

