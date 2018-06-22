using System;
using System.Globalization;

namespace SSO_Material.Utilities
{
    public class ConvertHelper
    {
        public static DateTime ToDateTime(string datetime, string format)
        {
            try
            {
                return DateTime.ParseExact(datetime, format, CultureInfo.InvariantCulture);
            }
            catch (Exception)
            {
                return DateTime.Now;
            }
        }
        public static int ToInt32(string number)
        {
            int result;
            return int.TryParse(number, out result) ? Convert.ToInt32(number) : 0;
        }
    }
}