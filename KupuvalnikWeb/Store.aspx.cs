using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web.Services;


namespace KupuvalnikWeb {
    public partial class Store :System.Web.UI.Page {
        private String strConnString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gridViewItems.UseAccessibleHeader = true;
                gridViewItems.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }


        protected void BuyItemClick(object sender, EventArgs e)
        {
            txtCustName.Text = "";
            txtCustAddress.Text = "";
            txtCustEmail.Text = "";
            txtCustPhone.Text = "";
                    
            using (GridViewRow row = (GridViewRow)((Button)sender).Parent.Parent)
            {
                lblModalTitle.Text = row.Cells[0].Text;
                txtItemName.Text = row.Cells[1].Text;
                txtItemDescription.Text = row.Cells[2].Text;
                txtItemUnitPrice.Text = row.Cells[3].Text;
                txtItemTotalPrice.Text = row.Cells[3].Text;
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myModal", "$('#myModal').modal();", true);
            upModal.Update();
        }

        protected void CreateOrderClick(object sender, EventArgs e)
        {
            bool isCustNameValid = Convert.ToBoolean(hiddenName.Value);
            bool isCustPhoneValid = Convert.ToBoolean(hiddenPhone.Value);
            bool isCustEmailValid = Convert.ToBoolean(hiddenEmail.Value);

            string result = "";

            if (isCustNameValid && isCustPhoneValid && isCustEmailValid)
            {
                result = CreateOrderInDatabase();
            }

            switch (result)
            {
                case "123":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "mySuccessModal", "$('#mySuccessModal').modal();", true);
                    alertSuccessModal.Update();
                    break;

                default:
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myFailModal", "$('#myFailModal').modal();", true);
                    alertFailModal.Update();
                    break;
            }
        }
  
        protected string CreateOrderInDatabase()
        {

            using (SqlConnection con = new SqlConnection(strConnString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Create_Order";

                    cmd.Parameters.AddWithValue("@ItemId", lblModalTitle.Text);
                    cmd.Parameters.AddWithValue("@ItemQuantity", txtItemQuantity.Text);
                    cmd.Parameters.AddWithValue("@ItemTotalPrice", txtItemTotalPrice.Text);
                    cmd.Parameters.AddWithValue("@CustName", txtCustName.Text);
                    cmd.Parameters.AddWithValue("@CustAddress", txtCustAddress.Text);
                    cmd.Parameters.AddWithValue("@CustPhone", txtCustPhone.Text);
                    cmd.Parameters.AddWithValue("@CustEmail", txtCustEmail.Text);

                    var returnParameter = cmd.Parameters.Add("@ReturnVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    cmd.Connection = con;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    var result = returnParameter.Value;
                    con.Close();

                    return result.ToString();

                }

            }

        }

    }
}