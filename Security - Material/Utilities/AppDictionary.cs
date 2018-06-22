using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;

namespace SSO_Material.Utilities
{
    public class AppDictionary
    {
        public static Dictionary<string, string> MasterMenu = new Dictionary<string, string>()
	    {
	        {"Navigation","16FAAE45-DA0F-4A21-AEE7-FD3376C211A1" }
	    };

        public static Dictionary<string, string> Language = new Dictionary<string, string>()
        {
            //--------------------------------------------------
            //language category
            {"en","3e571f3b-4d20-4c17-9f7e-f3698f326d9e"},
            {"ko","ee460c08-fded-4958-92cd-4e0fbdeb6168"},
            {"vi","0ba4c805-7de0-45ea-b867-9ecd2318b9a9"}
            //--------------------------------------------------
            //approval status
            //{"Approved","660A7ACB-F272-4DC5-A9CB-0416CB78FA32"},
            //{"New","D41AEC42-6AFB-49F6-952A-3F60ADBC3D1D"},
            //{"Received","4B1429AF-1F07-4D91-8B20-4C8B40C807A7"},
            //{"InProcess","E3A76B11-BF72-44F4-AFCB-5D581EC3E61B"},
            //{"Complete","E53CAF11-D60C-4868-9AA0-720B1D1856AC"},
            //{"Postpone","2DCC95C1-4208-46A3-A2D0-8FBC26DFC155"},
            //{"Done","FBDEBBE3-BD73-49C2-8E74-C16634F34D4E"},
            
        };

        public static Dictionary<string, string> UserStatus = new Dictionary<string, string>()
        {
            //--------------------------------------------------
            //User status
            {"Active", "beb23056-8602-4da6-9fa8-ee29f86381a7"},
            {"Block", "87ff868e-8c84-42fe-a193-07bafdb6851b"},
            {"Reset", "c056660b-aaff-436d-b70c-f0ee2b14d06e"},
            {"New", "2e8117cc-256e-481c-b3e5-5d979e670c20"}
        };
    }
}