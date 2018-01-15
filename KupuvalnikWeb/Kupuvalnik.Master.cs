using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KupuvalnikWeb {
    public partial class Kupuvalnik :System.Web.UI.MasterPage {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!this.Page.User.Identity.IsAuthenticated)
                {
                    btnSignOut.Visible = false;
                    liAdminPanel.Visible = false;
                    liAdminLogin.Visible = true;
                }
                else
                {
                    btnSignOut.Visible = true;
                    liAdminPanel.Visible = true;
                    liAdminLogin.Visible = false;
                }
            }
        }

        protected void LogoutClick(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("/AdminLogin.aspx");
        }
    }
}