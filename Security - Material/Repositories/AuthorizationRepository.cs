using Security___Material;
using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace SSO_Material.Repositories
{
    public class AuthorizationRepository
    {
        PortalEntities _db = new PortalEntities();
        public IEnumerable<AuthorizationModel> GetControllerAction(string id)
        {
            var asm = Assembly.GetAssembly(typeof(MvcApplication));
            var controlleractionlist = asm.GetTypes()
                    .Where(type => typeof(System.Web.Mvc.Controller).IsAssignableFrom(type))
                    .SelectMany(type => type.GetMethods(BindingFlags.Instance | BindingFlags.DeclaredOnly | BindingFlags.Public))
                    .Where(m => !m.GetCustomAttributes(typeof(System.Runtime.CompilerServices.CompilerGeneratedAttribute), true).Any())
                    .Select(x => new AuthorizationModel { Controller = x.DeclaringType.Name, Action = x.Name })//.Select(x => new { Controller = x.DeclaringType.Name, Action = x.Name, ReturnType = x.ReturnType.Name, Attributes = String.Join(",", x.GetCustomAttributes().Select(a => a.GetType().Name.Replace("Attribute", ""))) })
                    .OrderBy(x => x.Controller).ThenBy(x => x.Action).Distinct().ToList();
            foreach (var item in controlleractionlist)
            {
                item.Controller = item.Controller.Substring(0, item.Controller.Length - 10);
                if (id != null)
                    item.Owner = id;
            }
            var removeDuplicate = RemoveDuplicates(controlleractionlist);
            var listInData = GetViaUser(id);
            var i = 0;
            foreach (var item in removeDuplicate)
            {
                foreach (var x in listInData.Where(x => x.Action == item.Action && x.Controller == item.Controller))
                {
                    item.sID = x.sID;
                    item.IsAllowed = x.IsAllowed;
                }
                item.id = i++;
            }

            return removeDuplicate;
        }

        public IEnumerable<AuthorizationModel> GetViaUser(string id)
        {
            try
            {
                var author = (from a in _db.SysAuthorization
                              where a.Owner.ToString() == id
                              select new AuthorizationModel
                              {
                                  sID = a.Id.ToString(),
                                  Controller = a.Controller,
                                  Action = a.Action,
                                  IsAllowed = a.IsAllowed,
                                  Owner = a.Owner.ToString()
                              }).ToList();
                return author;
            }
            catch (Exception ex)
            {
                LogHelper.Error("AuthorizationRepository:GetViaUser: " + ex.Message);
                return null;
            }
        }

        public bool InsertAuthorization(IEnumerable<SysAuthorization> list)
        {
            if (list == null || !list.Any())
                return false;
            try
            {

                _db.SysAuthorization.AddRange(list);
                _db.SaveChanges();
                return true;

            }
            catch (Exception ex)
            {
                LogHelper.Error("AuthorizationRepository:InsertAuthorization: " + ex.Message);
                return false;
            }
        }

        public bool DeleteAuthorization(string id)
        {
            var deleteAuthor = from a in _db.SysAuthorization where a.Owner.ToString() == id select a;
            _db.SysAuthorization.RemoveRange(deleteAuthor);
            _db.SaveChanges();
            return true;
        }


        static List<AuthorizationModel> RemoveDuplicates(IEnumerable<AuthorizationModel> inputList)
        {
            var finalList = new List<AuthorizationModel>();
            foreach (var currValue in inputList.Where(currValue => !Contains(finalList, currValue)))
            {
                finalList.Add(currValue);
            }
            return finalList;
        }
        static bool Contains(IEnumerable<AuthorizationModel> list, AuthorizationModel comparedValue)
        {
            return list.Any(listValue => listValue.Controller == comparedValue.Controller && listValue.Action == comparedValue.Action);
        }

        public bool CheckAuthorized(ActionFilterModel model)
        {
            if (model == null)
                return false;
            try
            {
                
                    var item = (from u in 
                                    _db.SysRoleMapping
                                where
                                    u.RoleId.ToString() == model.ID && u.ControllerId == model.Controller &&
                                    u.ActionId == model.Action
                                select u).FirstOrDefault();
                    return item != null && item.IsAllow;
               
            }
            catch (Exception ex)
            {
                LogHelper.Error("AuthorizationRepository:CheckAuthorized: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public string GetRights(string controllerId, string roleId)
        {
            var actionList = "";
            try
            {
               
                    var list = (from u in _db.SysRoleMapping
                                where u.RoleId == roleId && u.ControllerId == controllerId
                                select u).ToList();
                    if (list == null) return "";
                    foreach (var action in list)
                    {
                        actionList = (actionList == "" ? action.ActionId : (actionList + "|" + action.ActionId));
                    }
                
                return actionList;
            }
            catch (Exception ex)
            {
                LogHelper.Error("AuthorizationRepository:GetRights: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return "";
            }
        }

        //get controler
        public List<ControllerModel> GetControler(string namespaces)
        {
            var ass = Assembly.GetExecutingAssembly();
            IEnumerable<Type> types =
                ass.GetTypes()
                    .Where(t => typeof(Controller).IsAssignableFrom(t) && t.Namespace.Contains(namespaces))
                    .OrderBy(x => x.Name);
            var listControler = (from t in types
                                 let attr = t.GetCustomAttributes(typeof(DisplayNameAttribute), false)
                                 select new ControllerModel()
                                 {
                                     //lấy lên tên display của controller
                                     ControllerId = t.Name,
                                     ControllerName = attr.Length > 0 ? ((DisplayNameAttribute)attr[0]).DisplayName : t.Name
                                 }).ToList();
            return listControler;
        }

        //get actions in controler
        public List<ActionModel> GetActions(string namespaces, string controllerId)
        {
            //get list controller
            var ass = Assembly.GetExecutingAssembly();
            IEnumerable<Type> types =
                ass.GetTypes()
                    .Where(t => typeof(Controller).IsAssignableFrom(t) && t.Namespace.Contains(namespaces))
                    .OrderBy(x => x.Name);
            var controller = types.FirstOrDefault(t => t.Name == controllerId);

            if (controller == null)
                return null;
            //get action via controller
            IEnumerable<MemberInfo> memInfo =
                controller.GetMethods(BindingFlags.Instance | BindingFlags.DeclaredOnly | BindingFlags.Public)
                    .Where(
                        m =>
                            !m.GetCustomAttributes(
                                typeof(System.Runtime.CompilerServices.CompilationRelaxationsAttribute), true).Any()
                                && !m.IsDefined(typeof(AllowAnonymousAttribute))//bỏ ra những hàm anonymous
                                )
                    .OrderBy(x => x.Name);

            return (from memberInfo in memInfo
                    let attr = memberInfo.GetCustomAttributes(typeof(DisplayNameAttribute), false)
                    where memberInfo.ReflectedType != null && (memberInfo.ReflectedType.IsPublic && !memberInfo.IsDefined(typeof(NonActionAttribute)))
                    select new ActionModel()
                    {
                        ControllerId = controller.Name,
                        ActionId = memberInfo.Name,
                        ActionName = attr.Length > 0 ? ((DisplayNameAttribute)attr[0]).DisplayName : memberInfo.Name,
                        IsAllow = false
                    }).ToList();
        }

    }
}