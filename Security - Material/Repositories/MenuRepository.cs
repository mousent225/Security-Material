using Security___Material.Models;
using SSO_Material.Utilities;
using SSO_Material.ViewModels.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.Repositories
{
    public class MenuRepository
    {
        PortalEntities _db = new PortalEntities();
                public IEnumerable<MenuModel> GetAllMenuViaMasterMenu(string id)
        {
            throw new NotImplementedException();
        }

        public MenuModel GetMenu(string id)
        {
            try
            {
                var model = (from u in _db.SysMenu
                                where u.ID.ToString() == id
                                from mm in _db.SysMenu.Where(m => m.ID == u.ParentID).DefaultIfEmpty()
                                orderby u.Sequence
                                select new MenuModel
                                {
                                    ID = u.ID.ToString(),
                                    Name = u.Name,
                                    Controller = u.Controller,
                                    Action = u.Action,
                                    Sequence = u.Sequence,
                                    ParentID = u.ParentID.ToString(),
                                    Param = u.Param,
                                    ParentName = mm.Name,
                                    Icon = u.Icon,
                                    Actived = u.Actived,
                                    //MasterMenu = u.MasterMenu.ToString()
                                }).FirstOrDefault();
                return model;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("MenuRepository GetMenu: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }

        public bool InsertMenu(MenuModel model)
        {
            try
            {
                
                var mn = new SysMenu
                {
                    ID = Guid.NewGuid(),
                    Name = model.Name,
                    //MasterMenu = new Guid(model.MasterMenu)
                };
                if (model.ParentID != null)
                    mn.ParentID = new Guid(model.ParentID);
                mn.Sequence = model.Sequence;
                mn.Controller = model.Controller;
                mn.Action = model.Action;
                mn.Actived = true;
                mn.CreateUID = new Guid(model.ModifyUID);
                mn.CreateDate = DateTime.Now;
                mn.Icon = model.Icon;
                mn.Param = model.Param;
                _db.SysMenu.Add(mn);
                _db.SaveChanges();
                return true;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("MenuRepository insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public bool UpdateMenu(MenuModel model)
        {
            try
            {
                
                var mn = _db.SysMenu.FirstOrDefault(m => m.ID.ToString() == model.ID);
                mn.Name = model.Name;
                //mn.MasterMenu = new Guid(model.MasterMenu);
                if (model.ParentID != null)
                    mn.ParentID = new Guid(model.ParentID);
                mn.Sequence = model.Sequence;
                mn.Controller = model.Controller;
                mn.Action = model.Action;
                mn.Actived = true;
                mn.ModifyUID = new Guid(model.ModifyUID);
                mn.ModifyDate = DateTime.Now;
                mn.Icon = model.Icon;
                mn.Param = model.Param;
                _db.SaveChanges();
                return true;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("MenuRepository insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public bool DeleteMenu(string id)
        {
            try
            {
               
                var mn = _db.SysMenu.FirstOrDefault(m => m.ID.ToString() == id);
                _db.SysMenu.Remove(mn);
                _db.SaveChanges();
                return true;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("MenuRepository insert: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return false;
            }
        }

        public IEnumerable<MenuTreeViewModel> GetMenuTreeView(string id)
        {
            try
            {
                
                var list = (from u in _db.SysMenu
                            where u.ParentID == null //&& u.MasterMenu.ToString() == id
                            from mm in _db.SysMenu.Where(m => m.ID == u.ParentID).DefaultIfEmpty()
                            orderby u.Sequence
                            select new MenuTreeViewModel
                            {
                                Id = u.ID.ToString(),
                                Name = u.Name,
                                HasChildren = _db.SysMenu.Any(m => m.ParentID == u.ID),
                                Controller = u.Controller,
                                Action = u.Action,
                                Sequence = u.Sequence,
                                ParentID = u.ParentID.ToString(),
                                Param = u.Param,
                                ParentName = mm.Name
                            }).ToList();
                return list;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("MenuRepository GetMenu: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }


        public IEnumerable<MenuModel> GetActiveMenuViaMasterMenuUser(string id, string role, int systemId)
        {
            if (string.IsNullOrEmpty(id))
                return null;
            try
            {
                
                var list = (from u in _db.SP_GetMenu_Via_MasterMenu_User_System(id, role, systemId)
                            select new MenuModel
                            {
                                ID = u.ID.ToString(),
                                Name = u.NAME,
                                Action = u.ACTION,
                                Controller = u.CONTROLLER,
                                Param = u.PARAM,
                                Icon = u.ICON,
                                ParentID = u.PARENTID.ToString(),
                                Sequence = u.SEQUENCE
                            }).ToList();
                return list;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error("MenuRepository GetActiveMenuViaMasterMenuUser: " + ex.Message + " Inner Exception: " + ex.InnerException.Message);
                return null;
            }
        }
    }
}