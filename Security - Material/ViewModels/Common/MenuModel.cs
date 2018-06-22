using Security___Material.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels.Common
{
    public class MenuModel
    {
        public string ID { get; set; }
        [Required(ErrorMessage = "Required!")]
        [Display(Name = "Name")]
        public string Name { get; set; }
        public string ParentID { get; set; }
        public string Action { get; set; }
        public string Controller { get; set; }
        public string Param { get; set; }
        public string Icon { get; set; }
        public byte? Sequence { get; set; }
        public string Dictionary { get; set; }
        public string DictionaryName { get; set; }
        public string ParentName { get; set; }
        public bool Actived { get; set; }
        public string MasterMenu { get; set; }
        public string ModifyUID { get; set; }
        public DateTime? ModifyDate { get; set; }
    }
    public class MenuTreeViewModel
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public bool HasChildren { get; set; }
        public string Controller { get; set; }
        public string Action { get; set; }
        public string ParentID { get; set; }
        public string ParentName { get; set; }
        public string Dictionary { get; set; }
        public string DictionaryName { get; set; }
        public int? Sequence { get; set; }
        public string Param { get; set; }
        public string MasterMenu { get; set; }

        private IEnumerable<MenuTreeViewModel> _Children;

        public IEnumerable<MenuTreeViewModel> Children
        {
            get
            {
                if (HasChildren)
                {
                    using (var db = new PortalEntities())
                    {
                        var list = (from u in db.SysMenu
                                    where u.ParentID.ToString() == Id
                                    from mm in db.SysMenu.Where(m => m.ID == u.ParentID).DefaultIfEmpty()
                                    orderby u.Sequence
                                    select new MenuTreeViewModel
                                    {
                                        Id = u.ID.ToString(),
                                        Name = u.Name,
                                        HasChildren = db.SysMenu.Any(m => m.ParentID == u.ID),
                                        Controller = u.Controller,
                                        Action = u.Action,
                                        Sequence = u.Sequence,
                                        ParentID = u.ParentID.ToString(),
                                        Param = u.Param,
                                        ParentName = mm.Name
                                    }).ToList();
                        return list;
                    }
                }
                return null;
            }
            set { _Children = value; }
        }

    }
}