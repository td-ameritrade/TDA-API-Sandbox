using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Win32;

namespace TDAmeritradeNet
{
    // http://stackoverflow.com/questions/13141434/httpclient-request-throws-ioexception
    // This fix is for The following code throws a IOException with the message: "The specified registry key does not exist."
    public class clsRegistryFix
    {
        public static void LegacyWPADSupport()
        {
            string[] keys = new string[]
                {
                    @"SOFTWARE\Microsoft\.NETFramework",
                    @"SOFTWARE\Wow6432Node\Microsoft\.NETFramework"
                };

            foreach (var key in keys)
            {
                using (RegistryKey regKey = Registry.LocalMachine.OpenSubKey(key, true))
                {
                    if (regKey != null)
                    {
                        try
                        {
                            var v = regKey.GetValue("LegacyWPADSupport");

                            if (v == null)
                            {
                                regKey.SetValue("LegacyWPADSupport", 0, RegistryValueKind.DWord);
                                Debug.Print("The LegacyWPADSupport registry key has been added to {0}", key);
                            }
                        }
                        catch (Exception)
                        {
                            regKey.SetValue("LegacyWPADSupport", 0, RegistryValueKind.DWord);
                            Debug.Print("The LegacyWPADSupport registry key has been added to {0}", key);
                        }
                    }
                }
            }
        }
    }
}
