﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace Security___Material.Hubs
{
    public class NotificationHub : Hub
    {
        public void Shownotification(string name, string message)
        {
            Clients.All.addNewMessagetoPage(name, message);
        }
    }
}