using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;

namespace SSO_Material.Utilities
{
    public class LogHelper
    {
        private static readonly ILog logger = LogManager.GetLogger("KSOLUTION");

        public static void Info(string mess)
        {
            logger.Info(mess);
        }

        public static void Debug(string mess)
        {
            logger.Debug(mess);
        }
        public static void Error(string mess)
        {
            logger.Error(mess);
        }
        public static void Warn(string mess)
        {
            logger.Warn(mess);
        }
        public static void Fatal(string mess)
        {
            logger.Fatal(mess);
        }
    }
}