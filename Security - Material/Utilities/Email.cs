using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web;

namespace SSO_Material.Utilities
{
    public class Email
    {
        //properties
        public string Subject { get; set; }
        public string Body { get; set; }
        public string From { get; set; }
        public string Password { get; set; }
        public string smtp { get; set; }
        public int port { get; set; }
        public List<string> To { get; set; }
        public List<string> CC { get; set; }
        public List<string> BCC { get; set; }

        public Email()
        {
            AppSettingsReader reader = new AppSettingsReader();
            To = new List<string>();
            CC = new List<string>();
            BCC = new List<string>();
            From = (string)reader.GetValue("Email", typeof(String));
            Password = (string)reader.GetValue("Password", typeof(String));
            smtp = (string)reader.GetValue("SMTP", typeof(String));
            port = (int)reader.GetValue("SMTPPort", typeof(int));
        }

        public async Task Send()
        {
            try
            {
                var message = new MailMessage();
                foreach (var to in To)
                {
                    message.To.Add(to);
                }
                foreach (var cc in CC)
                {
                    message.CC.Add(cc);
                }
                foreach (var bcc in BCC)
                {
                    message.Bcc.Add(bcc);
                }
                message.Subject = Subject;
                message.Body = Body;
                message.BodyEncoding = System.Text.Encoding.UTF8;
                message.From = new MailAddress(From);
                message.SubjectEncoding = System.Text.Encoding.UTF8;
                message.IsBodyHtml = true;
                message.Priority = MailPriority.High;
                var smtpClient = new SmtpClient();
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials = new NetworkCredential(From, Password);
                smtpClient.Host = smtp;
                smtpClient.Port = port;
                smtpClient.EnableSsl = true;
                await smtpClient.SendMailAsync(message);

                smtpClient.Dispose();
                message.Dispose();
            }
            catch (Exception ex)
            {
                LogHelper.Error("Send Email Error: " + ex.Message+" Inner Exception: "+ex.InnerException.Message);
                return;
            }
        }

        public static string bodyTheme(string header, string title, string userName, string dtCreate, string projectNm, string url)
        {
            string domainurl = HttpContext.Current.Request.Url.Authority;
            var body = "<table border='0' cellpadding='0' cellspacing='20' bgcolor='#e6e6e6' align='center'>";
            body += "<tbody>";
            body += "<tr>";
            body += "<td>";
            body += "<table width='554' height='82' border='0' cellpadding='0' cellspacing='0' background='http://" + domainurl + "/Resources/email/approval_bg_top.gif'>";
            body += "<tbody>";
            body += "<tr>";
            body += "<td>";
            body += "<table width='85%' border='0' align='center' cellpadding='0' cellspacing='0'>";
            body += "<tbody>";
            body += "<tr>";
            body += "<td height='30' valign='bottom' style='font-size: 9pt; color: #333333'><strong style='color: #FFFFFF'>" + header + "</strong></td>";
            body += "</tr>";
            body += "</tbody>";
            body += "</table>";
            body += "</td>";
            body += "</tr>";
            body += "</tbody>";
            body += "</table>";
            body += "<table width='554' height='82' border='0' cellpadding='0' cellspacing='0' background='http://" + domainurl + "/Resources/email/approval_bg_middle.gif'>";
            body += "<tbody>";
            body += "<tr>";
            body += "<td>";
            body += "<table width='85%' border='0' align='center' cellpadding='10' cellspacing='1' bgcolor='#F2F2F2'>";
            body += "<tbody>";
            body += "<tr valign='top' bgcolor='#FFFFFF' style='font-size: 9pt; color: #333333'>";
            body += "<td width='30%' align='center'><b>Title</b></td>";
            body += "<td>" + title + "</td>";
            body += "</tr>";
            body += "<tr valign='top' bgcolor='#FFFFFF' style='font-size: 9pt; color: #333333'>";
            body += "<td width='30%' align='center'><b>Creator</b></td>";
            body += "<td>" + userName + "</td>";
            body += "</tr>";
            body += "<tr valign='top' bgcolor='#FFFFFF' style='font-size: 9pt; color: #333333'>";
            body += "<td align='center'><b>Create Date</b></td>";
            body += "<td valign='top'>";
            body += "<div>" + dtCreate + "</div>";
            body += "</td>";
            body += "</tr>";
            body += "<tr valign='top' bgcolor='#FFFFFF' style='font-size: 9pt; color: #333333'>";
            body += "<td align='center'><b>Project</b></td>";
            body += "<td valign='top'>";
            body += "<div>" + projectNm + "</div>";
            body += "</td>";
            body += "</tr>";
            body += "<tr valign='top' bgcolor='#FFFFFF' style='font-size: 9pt; color: #333333'>";
            body += "<td colspan='2' align='center'>";
            body += "<p style='color: #023aa0; font: 11px Arial;'>Click the button bellow you can view approval</p>";
            body += "<p style='width: 110px; font: bold 11px Arial; text-decoration: none; background-color: #EEEEEE; color: #333333; padding: 2px 6px 2px 6px; border-top: 1px solid #CCCCCC; border-right: 1px solid #333333; border-bottom: 1px solid #333333; border-left: 1px solid #CCCCCC;'>";
            body += "<a href='http://" + domainurl + "/" + url + "' target='_blank'>Click View Detail</a>";
            body += "</p>";
            body += "</td>";
            body += "</tr>";
            body += "</tbody>";
            body += "</table>";
            body += "</td>";
            body += "</tr>";
            body += "</tbody>";
            body += "</table>";
            body += "<table width='554' height='53' border='0' cellpadding='0' cellspacing='0'>";
            body += "<tbody>";
            body += "<tr>";
            body += "<td>";
            body += "<img src='http://" + domainurl + "/Resources/email/approval_bg_bottom.gif'></td>";
            body += "</tr>";
            body += "</tbody>";
            body += "</table>";
            body += "</td>";
            body += "</tr>";
            body += "</tbody>";
            body += "</table>";
            return body;
        }
    }
}