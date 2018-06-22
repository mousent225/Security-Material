using Security___Material.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels
{
    public class AuthorizationModel
    {
        public int id { get; set; }
        public string sID { get; set; }
        public string Action { get; set; }
        public string Controller { get; set; }
        public bool IsAllowed { get; set; }
        public DateTime? CreateDate { get; set; }
        public string CreateUID { get; set; }
        public DateTime? ModifyDate { get; set; }
        public string ModifyUID { get; set; }
        public string Owner { get; set; }
        public List<SysAuthorization> ListAuthorization { get; set; }
    }
}