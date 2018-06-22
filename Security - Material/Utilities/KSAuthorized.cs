using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Utilities
{
    public class KSAuthorized : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var httpContext = filterContext.HttpContext;
            if (httpContext.Request.RequestType == "GET" && !httpContext.Request.IsAjaxRequest() && filterContext.IsChildAction == false && !filterContext.ActionDescriptor.ActionName.ToLower().Contains("print")) // do no overwrite if we do child action.
            {
                // stop overwriting previous page if we just reload the current page.
                if (HttpContext.Current.Session["CurUrl"] != null && ((Uri)HttpContext.Current.Session["CurUrl"]).Equals(httpContext.Request.Url))
                    return;

                HttpContext.Current.Session["PrevUrl"] = HttpContext.Current.Session["CurUrl"] ?? httpContext.Request.Url;
                HttpContext.Current.Session["CurUrl"] = httpContext.Request.Url;
            }
            if (!filterContext.HttpContext.User.Identity.IsAuthenticated)
            {
                filterContext.Result = new RedirectToRouteResult(
                    new System.Web.Routing.RouteValueDictionary {
                        {"controller", "Anonymous"}, {"action", "Login"}
                    }
                );
            }
            //else
            //{
            //    if (!filterContext.IsChildAction)
            //    {
            //        string actionName = filterContext.ActionDescriptor.ActionName;
            //        string controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;

            //    }

            //}

        }
    }
}