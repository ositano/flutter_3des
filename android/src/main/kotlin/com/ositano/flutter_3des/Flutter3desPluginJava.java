package com.ositano.flutter_3des;

import java.security.Key;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;

public class Flutter3desPluginJava {


    private static final String ALGORITHM_3DES = "DESede/CBC/PKCS5Padding";
    private static final String KEY_INSTANCE = "DESede";

    /**
     * Encrypt
     */
    public static String encryptToHex(String originStr, String secretKey, String iv) {
        return byte2hex(encrypt(originStr, secretKey, iv));
    }

    /**
     * Decrypt
     */
    public static String decryptFromHex(String encryptHexStr, String secretKey, String iv) {
        if(encryptHexStr == null || iv == null)
            return null;
        try {
            return decrypt(hex2byte(encryptHexStr.getBytes()), secretKey, iv);
        } catch (Exception e){
            e.printStackTrace();
            return "";
        }
    }


    /**
     * 3DES
     *
     * @param data string to be encrypted
     * @param key  can't be less than 8 bits
     * @param iv  vector (usually 8 bits)
     * @return return byte array
     */
    public static byte[] encrypt(String data, String key, String iv) {
        if(data == null || iv == null)
            return null;
        try{

            byte[] keyByteArray = hexStringToByteArray(key);
            byte[] ivByteArray = hexStringToByteArray(iv);

            DESedeKeySpec dks = new DESedeKeySpec(keyByteArray);
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(KEY_INSTANCE);
            Key secretKey = keyFactory.generateSecret(dks);
            Cipher cipher = Cipher.getInstance(ALGORITHM_3DES);

            AlgorithmParameterSpec paramSpec = new IvParameterSpec(ivByteArray);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey,paramSpec);
            return cipher.doFinal(data.getBytes());
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 3DES
     *
     * @param data to be decrypted
     * @param key  can't be less than 8 bits
     * @param iv  vector (usually 8 bits)
     * @return return String
     */
    public static String decrypt(byte[] data, String key, String iv) {
        if(data == null || iv == null)
            return null;
        try {

            byte[] keyByteArray = hexStringToByteArray(key);
            byte[] ivByteArray = hexStringToByteArray(iv);

            DESedeKeySpec dks = new DESedeKeySpec(keyByteArray);
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(KEY_INSTANCE);
            Key secretKey = keyFactory.generateSecret(dks);
            Cipher cipher = Cipher.getInstance(ALGORITHM_3DES);
            AlgorithmParameterSpec paramSpec = new IvParameterSpec(ivByteArray);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, paramSpec);
            return new String(cipher.doFinal(data));
        } catch (Exception e){
            e.printStackTrace();
            return "";
        }
    }

    /**
     *
     * Two-line conversion string
     */
    private static String byte2hex(byte[] b) {
        StringBuilder hs = new StringBuilder();
        String stmp;
        for (int n = 0; b!=null && n < b.length; n++) {
            stmp = Integer.toHexString(b[n] & 0XFF);
            if (stmp.length() == 1)
                hs.append('0');
            hs.append(stmp);
        }
        return hs.toString().toUpperCase();
    }

    private static byte[] hex2byte(byte[] b) {
        if((b.length%2)!=0)
            throw new IllegalArgumentException();
        byte[] b2 = new byte[b.length/2];
        for (int n = 0; n < b.length; n+=2) {
            String item = new String(b,n,2);
            b2[n/2] = (byte)Integer.parseInt(item,16);
        }
        return b2;
    }

    //transform string data (010203) to {0x01, 0x02, 0x03} or {1, 2, 3}
    public static byte[] hexStringToByteArray(String s) {
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                    + Character.digit(s.charAt(i+1), 16));
        }
        return data;
    }
}
