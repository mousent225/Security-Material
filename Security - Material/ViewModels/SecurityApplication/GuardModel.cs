using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels.SecurityApplication
{
    public class GuardModel
    {
        public string GuardId { get; set; }
        public string Name { get; set; }
        public string Password { get; set; }
        public string PasswordEncrypt { get; set; }
        public string Gate { get; set; }
        public string GateName { get; set; }
        public string Vendor { get; set; }
        public string VendorName { get; set; }
        public string Remark { get; set; }
        public bool? IsActive { get; set; }
        public string IsActiveString { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreateUid { get; set; }
        public string CreateName { get; set; }
        public DateTime UpdateDate { get; set; }
        public string UpdateUId { get; set; }
        public DateTime DeleteDate { get; set; }
        public string DeleteUid { get; set; }
    }
}