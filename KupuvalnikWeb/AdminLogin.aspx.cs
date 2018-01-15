using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KupuvalnikWeb {
    public partial class AdminLogin :System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!this.Page.User.Identity.IsAuthenticated)
            //{
                
            //    FormsAuthentication.RedirectToLoginPage();

            //}
        }

        protected void ValidateUser(object sender, EventArgs e)
        {
            int userId = 0;
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("Validate_User"))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", UserName.Text);
                    cmd.Parameters.AddWithValue("@Password", Password.Text);
                    cmd.Connection = con;
                    con.Open();
                    userId = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                }
                switch (userId)
                {
                    case -1: case -2:
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myFailModal", "$('#myFailModal').modal();", true);
                        alertFailModal.Update();
                        break;
                    default:
                        FormsAuthentication.RedirectFromLoginPage(UserName.Text, false);
                        break;
                }
            }
        }

    }
}