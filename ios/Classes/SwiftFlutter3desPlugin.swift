import Flutter
import UIKit
import CommonCrypto

public class SwiftFlutter3desPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_3des", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutter3desPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [Any] ?? []
        guard arguments.count > 2 else {
            result(nil)
            return
        }
        let key = arguments[1] as? String ?? ""
        let iv = arguments[2] as? String ?? ""
        switch call.method {
        case "encrypt":
            encrypt(string: arguments[0] as? String ?? "", key: key, iv: iv, result: result)
        case "encryptToHex":
            encryptToHex(string: arguments[0] as? String ?? "", key: key, iv: iv, result: result)
        case "decrypt":
            if let data = arguments[0] as? FlutterStandardTypedData {
                decrypt(data: data.data, key: key, iv: iv, result: result)
            } else {
                result(nil)
            }
        case "decryptFromHex":
            decryptFromHex(string: arguments[0] as? String ?? "", key: key, iv: iv, result: result)
        default:
            result(nil)
            break
        }
    }

    func encryptToHex(string: String, key: String, iv: String, result: FlutterResult) {
        result(encrypt(string: string, key: key, iv: iv)?.toHexString)
    }

    func encrypt(string: String, key: String, iv: String, result: FlutterResult) {
        result(encrypt(string: string, key: key, iv: iv))
    }

    func encrypt(string: String, key: String, iv: String) -> Data? {
        return string.data(using: .utf8)?.crypt(operation: CCOperation(kCCEncrypt), key: key, iv: iv)
    }

    func decryptFromHex(string: String, key: String, iv: String, result: FlutterResult) {
        result(decrypt(data: string.hexToData, key: key, iv: iv))
    }

    func decrypt(data: Data, key: String, iv: String, result: FlutterResult) {
       result(decrypt(data: data, key: key, iv: iv))
    }

    func decrypt(data: Data, key: String, iv: String) -> String? {
        guard let data = data.crypt(operation: CCOperation(kCCDecrypt), key: key, iv: iv) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}


private extension Data {

    func crypt(operation: CCOperation, key: String, iv: String) -> Data? {

        let algorithm = kCCAlgorithm3DES
        let options = kCCOptionPKCS7Padding

        let keyData = key.hexStringToByteArray //converting string key to byte array [UInt8]
        let ivData = iv.hexStringToByteArray //converting string iv to byte array [UInt8]

        let keyLength = kCCKeySize3DES
        let dataIn = [UInt8](self)
        let dataInLength = self.count
        let dataOutAvailable = dataInLength + kCCBlockSize3DES
        let dataOut = UnsafeMutablePointer<UInt8>.allocate(capacity: dataOutAvailable)
        var dataOutMoved = 0

        let cryptStatus = CCCrypt(
            CCOperation(operation), //mode/operation type (kCCEncrypt or kCCDecrypt)
            CCAlgorithm(algorithm),  //Algorithm type
            CCOptions(options),     //options
            keyData,                //Key (using not less than 8 bits)
            keyLength,
            ivData,
            dataIn,                 //data to be encrypted/decrypted
            dataInLength,           //length of data to be encrypted/decrypted
            dataOut,                //result of encryption/decryption
            dataOutAvailable,       //length of expected result
            &dataOutMoved)          //actual length of expected result

        if cryptStatus == kCCSuccess {
            let result = Data(bytes: dataOut, count: dataOutMoved)
            dataOut.deallocate()
            return result
        } else {
            print("\(#function) error = \(cryptStatus)")
            dataOut.deallocate()
            return nil
        }
    }

}

private extension Data {

    var toHexString: String {
        return toHexString()
    }

    var toHexLowercasedString: String {
        return toHexString(isLowercased: true)
    }

    private func toHexString(isLowercased: Bool = false) -> String {
        return map { String(format: "%02\(isLowercased ? "x" : "X")", $0) }.joined(separator: "")
    }

}

private extension String {

    /// Convert hexadecimal string to Data
    var hexToData: Data {
        let bytes = hexToBytes
        #if swift(>=4.2)
        return Data(bytes)
        #else
        return Data(bytes: bytes)
        #endif
    }

    /// Convert hexadecimal string to [UInt8]
    var hexToBytes: [UInt8] {
        assert(count % 2 == 0, "The input string format is incorrect, 8 bits represent a character")
        var bytes = [UInt8]()
        var sum = 0
        // Shaping utf8 encoding range
        let intRange = 48...57
        // Lowercase a ~ f utf8 encoding range
        let lowercaseRange = 97...102
        // The encoding range of utf8 in uppercase A ~ F
        let uppercasedRange = 65...70
        for (index, c) in utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("The input string format is incorrect, each character needs to be in the range of 0 ~ 9, a ~ f, A ~ F")
            }
            sum = sum * 16 + intC
            // Every two hexadecimal letters represent 8 bits, or one byte
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }

        //transform string data (010203) to {0x01, 0x02, 0x03} or {1, 2, 3}
        var hexStringToByteArray: [UInt8] {
            var startIndex = self.startIndex
            return stride(from: 0, to: count, by: 2).compactMap { _ in
                let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
                defer { startIndex = endIndex }
                return UInt8(self[startIndex..<endIndex], radix: 16)
            }
        }
}

