using System;
using System.ComponentModel.DataAnnotations;

namespace SSO_Material.ViewModels
{
    public class LoginModel
    {
        [Required(ErrorMessage = "required")]
        [Display(Name = "Login ID")]
        public string LoginID { get; set; }
        [Required(ErrorMessage = "required")]
        [Display(Name = "Password")]
        public string Password { get; set; }
        public bool Remember { get; set; }
    }

    public class LogHistoryModel
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public int? IpAddress { get; set; }
        public DateTime? LogTime { get; set; }
        public string OperatingSystem { get; set; }
        public string PcName { get; set; }
        public string PcBrowser { get; set; }
        public string StringIpAddress { get; set; }
        public string OrganizeName { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectionName { get; set; }
        public string Name { get; set; }

        public int CountLogin { get; set; }
    }
}