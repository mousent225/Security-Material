using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace SSO_Material.Utilities
{
    public class ED5Helper
    {
        public static string Encrypt(string toEncrypt)
        {
            byte[] keyArray;
            byte[] toEncryptArray = Encoding.UTF8.GetBytes(toEncrypt);

            var settingsReader = new AppSettingsReader();
            // Get the key from config file
            var key = (string)settingsReader.GetValue("SecurityMD5Key", typeof(String));

            var hashmd5 = new MD5CryptoServiceProvider();
            keyArray = hashmd5.ComputeHash(Encoding.UTF8.GetBytes(key));
            hashmd5.Clear();


            var tdes = new TripleDESCryptoServiceProvider();
            tdes.Key = keyArray;
            tdes.Mode = CipherMode.ECB;
            tdes.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = tdes.CreateEncryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            tdes.Clear();
            return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        }

        /// <summary>
        /// DeCrypt a string using dual encryption method. Return a DeCrypted clear string
        /// </summary>
        /// <param name="cipherString">encrypted string</param>
        /// <param name="useHashing">Did you use hashing to encrypt this data? pass true is yes</param>
        /// <returns></returns>
        public static string Decrypt(string cipherString)
        {
            byte[] keyArray;
            byte[] toEncryptArray = Convert.FromBase64String(cipherString);

            var settingsReader = new AppSettingsReader();
            //Get your key from config file to open the lock!
            var key = (string)settingsReader.GetValue("SecurityMD5Key", typeof(String));
            //key = "vncomm.vn";

            var hashmd5 = new MD5CryptoServiceProvider();
            keyArray = hashmd5.ComputeHash(Encoding.UTF8.GetBytes(key));
            hashmd5.Clear();


            var tdes = new TripleDESCryptoServiceProvider();
            tdes.Key = keyArray;
            tdes.Mode = CipherMode.ECB;
            tdes.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = tdes.CreateDecryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

            tdes.Clear();
            return Encoding.UTF8.GetString(resultArray);
        }


        public static string ConvertStringToHex(String input, System.Text.Encoding encoding)
        {
            Byte[] stringBytes = encoding.GetBytes(input);
            StringBuilder sbBytes = new StringBuilder(stringBytes.Length * 2);
            foreach (byte b in stringBytes)
            {
                sbBytes.AppendFormat("{0:X2}", b);
            }
            return sbBytes.ToString();
        }

        public static string ConvertHexToString(String hexInput, System.Text.Encoding encoding)
        {
            int numberChars = hexInput.Length;
            byte[] bytes = new byte[numberChars / 2];
            for (int i = 0; i < numberChars; i += 2)
            {
                bytes[i / 2] = Convert.ToByte(hexInput.Substring(i, 2), 16);
            }
            return encoding.GetString(bytes);
        }
    }
}