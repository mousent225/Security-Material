using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace SSO_Material.Utilities
{
    public class KSControllerFactory:DefaultControllerFactory
    {
        protected override IController GetControllerInstance(RequestContext requestContext, Type controllerType)
        {
            try
            {
                string lang;
                if (requestContext.HttpContext.User.Identity.IsAuthenticated)
                {
                    var identity = (ClaimsIdentity)requestContext.HttpContext.User.Identity;
                    IEnumerable<Claim> claims = identity.Claims;
                    lang = claims.FirstOrDefault(x => x.Type == "Lang").Value??ApplicationStatic.defaultLanguage;
                }
                else
                {
                    lang = ApplicationStatic.defaultLanguage;
                }
                //Get the culture info of the language code
                CultureInfo culture = CultureInfo.CreateSpecificCulture(lang);
                Thread.CurrentThread.CurrentCulture = culture;
                Thread.CurrentThread.CurrentUICulture = culture;

                return base.GetControllerInstance(requestContext, controllerType); 
            }
            catch (Exception ex)
            {
                LogHelper.Error("Controller Factory: "+ex.Message+" Inner Exception: "+ex.InnerException.Message);
                return null;
            }
        }
    }
}