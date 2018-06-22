using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Utilities
{
    public class MessageHelper
    {
        public static void ShowMessage(Controller control,string msg)
        {
            control.TempData["notiTitle"] = "Hyosung Portal";
            control.TempData["notiMsg"] = msg;
            control.TempData["notiStyle"] = "gray";
        }

        public static void ShowMessage(Controller control, string title, string msg, NotificationStyle style)
        {
            control.TempData["notiTitle"] = title;
            control.TempData["notiMsg"] = msg;
            switch (style)
            {
                case NotificationStyle.Default:
                    control.TempData["notiStyle"] = "gray";
                    break;
                case NotificationStyle.Success:
                    control.TempData["notiStyle"] = "gray success";
                    break;
                case NotificationStyle.Error:
                    control.TempData["notiStyle"] = "gray error";
                    break;
                default:
                    control.TempData["notiStyle"] = "gray";
                    break;
            }
        }
    }

    public enum NotificationStyle
    {
        Default,
        Success,
        Error
    }
}