using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SSO_Material.ViewModels
{
    public class ForgetCardModel
    {
        public int? Id { get; set; }

        public string EmpId { get; set; }
        public string EmpName { get; set; }
        public string JobTitle { get; set; }
        public string Position { get; set; }
        public string JoinDate { get; set; }
        public string DeptFullName { get; set; }
        public DateTime WorkDate { get; set; }
        public string TimeIn { get; set; }
        public string TimeOut { get; set; }
        public int DeptId { get; set; }
        public byte[] ImageBinary { get; set; }
        public string Image { get; set; }
        public string SecurityName { get; set; }

        public string GateNumber { get; set; }
        public string GateName { get; set; }
        public string TemporaryCard { get; set; }

        public string OrgName { get; set; }
        public int Org { get; set; }
        public string PlantName { get; set; }
        public string DeptName { get; set; }
        public string SectName { get; set; }
        public string DeptPrint { get; set; }

        public string Reason { get; set; }
        public string ReasonName { get; set; }
        public string ReasonOthers { get; set; }
        public string WorkShift { get; set; }

        public bool IsCheckIn { get; set; }
    }
}