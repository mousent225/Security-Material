using SSO_Material.Repositories;
using SSO_Material.Repositories.SecurityApplication;
using SSO_Material.Utilities;
using SSO_Material.ViewModels;
using SSO_Material.ViewModels.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Claims;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace SSO_Material.Controllers
{
    [KSAuthorized]
    public class HomeController : Controller
    {
        ForgetCardRepository _rep = new ForgetCardRepository();
        public ActionResult DashBoard()
        {
            return View();
        }
        public ActionResult Index()
        {
            var guard = (new GuardRepository()).GetInfor(User.GetClaimValue(ClaimTypes.Sid));
            ViewBag.GateDefaultId = guard == null ? "" : guard.Gate;
            return View();
        }
        [AllowAnonymous]
        public ActionResult NavigationBar()
        {
            string menus = GenerateMenu();
            ViewBag.Navigation = menus;
            return PartialView("_NavigationBar");
        }
        [AllowAnonymous]
        public ActionResult Print(string empId, DateTime workDate)
        {
            return View(_rep.GetInfor(empId, workDate));
        }
        [AllowAnonymous]
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "none")]
        public ActionResult GetAll(int deptId, string empId, string empName, string position, string jobTitle, DateTime fromDate, DateTime toDate)
        {
            return Json(_rep.GetAll(deptId, empId == "" ? null : empId, empName == "" ? null : empName, position == "" ? null : position
                    , jobTitle == "" ? null : jobTitle, fromDate, toDate), JsonRequestBehavior.AllowGet);
        }
        [AllowAnonymous]
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "none")]
        public JsonResult GetForGetCardInfor(string empId, DateTime? workDate)
        {
            var result = Json(_rep.GetInfor(empId, workDate));
            result.MaxJsonLength = int.Parse(ConfigurationManager.AppSettings["MaxJsonLength"]);
            return result;
        }
        [AllowAnonymous]
        public JsonResult UpdateForgetCardInfor(ForgetCardModel model)
        {
            return Json(_rep.UpdateForgetCard(model));
        }
        [AllowAnonymous]
        public JsonResult DeleteForgetCardInfor(string empId, DateTime? workDate)
        {
            return Json(_rep.DeleteForgetCard(empId, workDate));
        }
        [AllowAnonymous]
        public ActionResult ShowPersionalInformation()
        {
            return PartialView("_PersonalInformation");
        }
        #region NonAction

        [NonAction]
        private IEnumerable<MenuModel> GetMenus()
        {
            try
            {
                MenuRepository res = new MenuRepository();
                //return res.GetActiveMenuViaMasterMenu(AppDictionary.MasterMenu.First(x => x.Key == "Navigation").Value);
                return res.GetActiveMenuViaMasterMenuUser(AppDictionary.MasterMenu.First(x => x.Key == "Navigation").Value, User.GetClaimValue(ClaimTypes.Role), 3);
            }
            catch (Exception ex)
            {
                LogHelper.Error("Controller: " + Request.RequestContext.RouteData.Values["Controller"].ToString() + " Action: " + Request.RequestContext.RouteData.Values["Action"].ToString() + " Method GetMenus:" + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        [NonAction]
        private string GenerateMenu()
        {
            string result = null;
            try
            {
                var menus = GetMenus();
                if (menus != null)
                {
                    var listParent = menus.Where(m => m.ParentID == "").ToList();
                    var ul = new HtmlGenericControl("ul");
                    ul.Attributes["class"] = @"gui-controls";
                    ul.ID = "main-menu";

                    var liHome = new HtmlGenericControl("li");
                    liHome.Attributes["class"] = @"active expanding";
                    var home = GenerateControl("Home", "Index", "md md-home", "Dashboard");                    
                    liHome.Controls.Add(home);
                    ul.Controls.Add(liHome);
                    
                    foreach (var item in listParent)
                    {
                        var li = new HtmlGenericControl("li");
                        li.Attributes["class"] = @"gui-folder";
                        
                        var listChildren = GetChildrenMenu(item.ID, menus);
                        var a = GenerateControl(item.Controller, item.Action, item.Icon, item.Name);
                        li.Controls.Add(a);
                        ul.Controls.Add(li);
                        //gen ra html cho mấy menu con
                        if (listChildren != null && listChildren.Count() > 0)
                        {
                            li.Controls.Add(AddChildrenMenu(item.ID, menus, li));
                        }
                    }
                    using (System.IO.StringWriter swriter = new System.IO.StringWriter())
                    {
                        HtmlTextWriter writer = new HtmlTextWriter(swriter);
                        ul.RenderControl(writer);
                        result = swriter.ToString();
                    }
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error("Controller: " + Request.RequestContext.RouteData.Values["Controller"].ToString() + " Action: " + Request.RequestContext.RouteData.Values["Action"].ToString() + " Method GenerateMenu:" + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
            return result;
        }

        [NonAction]
        private HtmlGenericControl GenerateControl(string controller, string action, string icon, string title)
        {
            var tagA = new HtmlGenericControl("a");
            tagA.Attributes["href"] = string.IsNullOrEmpty(controller) ? "#" : ("/" + controller + (string.IsNullOrEmpty(action) ? "" : "/" + action));
            //tagA.Attributes["class"] = @"active";
            var div = new HtmlGenericControl("div");
            div.Attributes["class"] = @"gui-icon";
            var tagI = new HtmlGenericControl("i");
            tagI.Attributes["class"] = icon;
            div.Controls.Add(tagI);
            var span = new HtmlGenericControl("span");
            span.Attributes["class"] = @"title";
            span.InnerHtml = title;
            tagA.Controls.Add(div);
            tagA.Controls.Add(span);
            return tagA;
        }

        [NonAction]
        private IEnumerable<MenuModel> GetChildrenMenu(string parent, IEnumerable<MenuModel> source)
        {
            if (string.IsNullOrEmpty(parent))
                return null;
            return source.Where(m => m.ParentID == parent).ToList();
        }

        [NonAction]
        private HtmlGenericControl AddChildrenMenu(string parent, IEnumerable<MenuModel> source, HtmlGenericControl pLi)
        {
            var ul = new HtmlGenericControl("ul");
            var listChildren = GetChildrenMenu(parent, source);
            if (listChildren != null && listChildren.Count() > 0)
            {
                foreach (var item in listChildren)
                {
                    var li = new HtmlGenericControl("li");
                    li.Attributes["data-href"] = item.Controller + "/" + item.Action;
                    var a = new HtmlGenericControl("a");
                    a.Attributes["href"] = string.IsNullOrEmpty(item.Controller) ? "#" : ("/" + item.Controller + (string.IsNullOrEmpty(item.Action) ? "" : "/" + item.Action));

                    var span = new HtmlGenericControl("span");
                    span.Attributes["class"] = @"title";
                    var i = new HtmlGenericControl("i");
                    i.Attributes["class"] = item.Icon;
                    span.Controls.Add(i);
                    var span2 = new HtmlGenericControl("span")
                    {
                        InnerHtml = "&nbsp;" + item.Name
                    };
                    span.Controls.Add(span2);

                    a.Controls.Add(span);
                    li.Controls.Add(a);
                    ul.Controls.Add(li);
                    HtmlGenericControl liChild = AddChildrenMenu(item.ID, source, li);
                    if (liChild != null)
                        li.Controls.Add(liChild);
                }
                pLi.Controls.Add(ul);
                return ul;
            }
            return null;
        }

        #endregion
    }
}