using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KupuvalnikWeb {
    public partial class AdminPanel :System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!this.Page.User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.RedirectToLoginPage();

                }
                this.CreateOrdersChart();
                this.CreateCategoriesChart();
                
            }
        }

        private void CreateOrdersChart()
        {
            DataTable dsChartData = new DataTable();
            StringBuilder strScript = new StringBuilder();

            try
            {
                dsChartData = GetChartData("GetChartOrders");

                strScript.Append(@"  
                    <script>  
                    google.charts.load('current', {'packages':['line', 'corechart']});
                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {     
                        var chartDiv = document.getElementById('chart_div1');
                        var data = new google.visualization.DataTable();
                        data.addColumn('date', 'Time');
                        data.addColumn('number', 'Orders');
                        data.addRows([");

                foreach (DataRow row in dsChartData.Rows)
                {
                    strScript.Append("[new Date(" + row["Year"] + ", " + row["Month"] + "), " + row["Count"] + "],");
                }
                strScript.Remove(strScript.Length - 1, 1);
                strScript.Append("]);");
                strScript.Append(@"
                        var materialOptions = {
                        pointSize: 5,
                        chart: {
                            title: 'Orders'
                        },
                        legend: {position: 'none'},
                        series: {
                            // Gives each series an axis name that matches the Y-axis below.
                            0: {axis: 'Orders'},
                            1: {axis: 'Time'}
                        },
                        axes: {
                          // Adds labels to each axis; they don't have to match the axis names.
                          y: {
                            Orders: {label: 'Orders'},
                            Time: {label: 'Time'}
                          }
                        }
                     };
                     function drawMaterialChart() {
                        var materialChart = new google.charts.Line(chartDiv);
                        materialChart.draw(data, materialOptions);
                     }
                     drawMaterialChart();
                     }
                     </script>");

                ltScripts1.Text = strScript.ToString();
            }
            catch
            {
            }
            finally
            {
                dsChartData.Dispose();
                strScript.Clear();
            }
        }

        private void CreateCategoriesChart()
        {
            DataTable dsChartData = new DataTable();
            StringBuilder strScript = new StringBuilder();

            try
            {
                dsChartData = GetChartData("GetChartCategories");

                strScript.Append(@"  
                    <script>  
                    google.charts.load('current', {'packages':['corechart']});
                    google.charts.setOnLoadCallback(drawChart);

                    function drawChart() {     
                        var data = google.visualization.arrayToDataTable([
                        ['Categories', 'Count'],");

                foreach (DataRow row in dsChartData.Rows)
                {
                    strScript.Append("['" + row["Category"] + "', " + row["Count"] + "],");
                }
                strScript.Remove(strScript.Length - 1, 1);
                strScript.Append("]);");
                strScript.Append(@"
                        var options = {
                            title: 'Orders By Categories'
                        };
                        var chart = new google.visualization.PieChart(document.getElementById('chart_div2'));

                        chart.draw(data, options);
                     }
                     </script>");

                ltScripts2.Text = strScript.ToString();
            }
            catch
            {
            }
            finally
            {
                dsChartData.Dispose();
                strScript.Clear();
            }
        }

        private DataTable GetChartData(string procName)
        {
            DataSet dsData = new DataSet();
            try
            {
                SqlConnection sqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);
                SqlDataAdapter sqlCmd = new SqlDataAdapter(procName, sqlCon);
                sqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

                sqlCon.Open();

                sqlCmd.Fill(dsData);

                sqlCon.Close();
            }
            catch
            {
                throw;
            }
            return dsData.Tables[0];
        }

        protected void OpenModal(object sender, EventArgs e)
        {
       
            switch ((sender as System.Web.UI.HtmlControls.HtmlAnchor).ID.ToString())
            {
                case "anchorProcessOrders":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myProcessNewOrdersModal", "$('#myProcessNewOrdersModal').modal();", true);
                    processNewOrdersModal.Update();
                    break;
                case "anchorAllOrders":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myShowAllOrdersModal", "$('#myShowAllOrdersModal').modal();", true);
                    showAllOrdersModal.Update();
                    break;
                case "anchorNewItem":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myNewItemModal", "$('#myNewItemModal').modal();", true);
                    newItemModal.Update();
                    LoadCatInList();
                    break;
                case "anchorNewCategory":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myNewItemCategoryModal", "$('#myNewItemCategoryModal').modal();", true);
                    newItemCategoryModal.Update();
                    break;
            }
        }

        private void LoadCatInList()
        {

            string QueryString = "select * from Categories";

            SqlConnection myConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);
            SqlDataAdapter myCommand = new SqlDataAdapter(QueryString, myConnection);
            DataSet ds = new DataSet();
            myCommand.Fill(ds, "Categories");

            newItemInputCategory.DataSource = ds;
            newItemInputCategory.DataTextField = "Name";
            newItemInputCategory.DataValueField = "Id";
            newItemInputCategory.DataBind();
        }

        protected void CreateNewItem(object sender, EventArgs e)
        {
            string result = "";
            result = CreateNewItemInDatabase();
            switch (result)
            {
                case "123":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "mySuccessNewItemModal", "$('#mySuccessNewItemModal').modal();", true);
                    alertSuccessNewItemModal.Update();
                    break;

                default:
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myFailNewItemModal", "$('#myFailNewItemModal').modal();", true);
                    alertFailNewItemModal.Update();
                    break;
            }
        }

        protected string CreateNewItemInDatabase()
        {

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Create_Item";

                    cmd.Parameters.AddWithValue("@ItemName", txtItemName.Text);
                    cmd.Parameters.AddWithValue("@ItemDescr", txtItemDescription.Text);
                    cmd.Parameters.AddWithValue("@ItemPrice", txtItemPrice.Text);
                    cmd.Parameters.AddWithValue("@ItemCat", newItemInputCategory.Value);

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

        protected void DeliverOrder(object sender, EventArgs e)
        {
            GridViewRow gvRow = (GridViewRow)(sender as Control).Parent.Parent;
            string orderId = gvRow.Cells[0].Text;
            string itemName = gvRow.Cells[1].Text;
            string totalPrice = gvRow.Cells[3].Text;
            string custName = gvRow.Cells[4].Text;
            string custEmail = gvRow.Cells[7].Text;

            ChangeOrderStatusInDatabase(orderId);

            GridView1.DataBind();
            GridView3.DataBind();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#myProcessNewOrdersModal').modal('hide');", true);

            string result = MailSender.SendMail(custName, custEmail, itemName, totalPrice);

            switch (result)
            {
                case "pass":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "mySuccessOrder", "$('#mySuccessOrder').modal();", true);
                    alertSuccessOrder.Update();
                    break;
                default:
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myFailOrder", "$('#myFailOrder').modal();", true);
                    alertFailOrder.Update();
                    break;
            }

        }

        protected void ChangeOrderStatusInDatabase(string orderId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "DeliverOrder";
                    cmd.Parameters.AddWithValue("@OrdId", orderId);

                    cmd.Connection = con;
                    con.Open();
                    cmd.ExecuteNonQuery();

                    con.Close();
                }
            }
        }

        protected void CreateNewCategory(object sender, EventArgs e)
        {
            string result = "";
            result = CreateNewCategoryInDatabase();
            switch (result)
            {
                case "123":
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "mySuccessNewCatModal", "$('#mySuccessNewCatModal').modal();", true);
                    alertSuccessNewCatModal.Update();
                    break;

                default:
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myFailNewCatModal", "$('#myFailNewCatModal').modal();", true);
                    alertFailNewCatModal.Update();
                    break;
            }
        }

        protected string CreateNewCategoryInDatabase()
        {

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Create_Category";

                    cmd.Parameters.AddWithValue("@CatName", txtCatName.Text);

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