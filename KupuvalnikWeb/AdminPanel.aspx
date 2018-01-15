<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Kupuvalnik.Master" CodeBehind="AdminPanel.aspx.cs" Inherits="KupuvalnikWeb.AdminPanel" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    
    <script>
        function HideModal() {
            $('#myProcessNewOrdersModal').modal('hide');
        }
    </script>

    <style>
        .btn-sq-lg {
            width: 150px !important;
            height: 150px !important;
        }

        .btn-sq {
            width: 100px !important;
            height: 100px !important;
            font-size: 10px;
        }

        .btn-sq-sm {
            width: 50px !important;
            height: 50px !important;
            font-size: 10px;
        }

        .btn-sq-xs {
            width: 25px !important;
            height: 25px !important;
            padding: 2px;
        }

        .chart {
            width: 100%;
            min-height: 450px;
        }

        .modal-header-success {
            color: #fff;
            padding: 9px 15px;
            border-bottom: 1px solid #eee;
            background-color: #5cb85c;
            -webkit-border-top-left-radius: 5px;
            -webkit-border-top-right-radius: 5px;
            -moz-border-radius-topleft: 5px;
            -moz-border-radius-topright: 5px;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

        .modal-header-danger {
            color: #fff;
            padding: 9px 15px;
            border-bottom: 1px solid #eee;
            background-color: #d9534f;
            -webkit-border-top-left-radius: 5px;
            -webkit-border-top-right-radius: 5px;
            -moz-border-radius-topleft: 5px;
            -moz-border-radius-topright: 5px;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

        .hiddencol {
            display: none;
        }
    </style>

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="body">
    <div class="row">
        <div class="col-xl-3 col-sm-6 mb-3">
            <div class="card text-white bg-success o-hidden h-100">
                <div class="card-body">
                    <div class="card-body-icon">
                        <i class="fa fa-fw fa-shopping-cart"></i>
                    </div>
                    <div class="mr-5">Process New Orders</div>
                </div>
                <a id="anchorProcessOrders" class="card-footer text-white clearfix small z-1" href="#" runat="server" onserverclick="OpenModal">
                    <span class="float-left">View Details</span>
                    <span class="float-right">
                        <i class="fa fa-angle-right"></i>
                    </span>
                </a>
            </div>
        </div>

        <div class="col-xl-3 col-sm-6 mb-3">
            <div class="card text-white bg-info o-hidden h-100">
                <div class="card-body">
                    <div class="card-body-icon">
                        <i class="fa fa-fw fa-list"></i>
                    </div>
                    <div class="mr-5">View All Orders</div>
                </div>
                <a id="anchorAllOrders" class="card-footer text-white clearfix small z-1" href="#" runat="server" onserverclick="OpenModal">
                    <span class="float-left">View Details</span>
                    <span class="float-right">
                        <i class="fa fa-angle-right"></i>
                    </span>
                </a>
            </div>
        </div>

        <div class="col-xl-3 col-sm-6 mb-3">
            <div class="card text-white bg-warning o-hidden h-100">
                <div class="card-body">
                    <div class="card-body-icon">
                        <i class="fa fa-fw fa-cube"></i>
                    </div>
                    <div class="mr-5">Create New Item</div>
                </div>
                <a id="anchorNewItem" class="card-footer text-white clearfix small z-1" href="#" runat="server" onserverclick="OpenModal">
                    <span class="float-left">View Details</span>
                    <span class="float-right">
                        <i class="fa fa-angle-right"></i>
                    </span>
                </a>
            </div>
        </div>

        <div class="col-xl-3 col-sm-6 mb-3">
            <div class="card text-white bg-warning o-hidden h-100">
                <div class="card-body">
                    <div class="card-body-icon">
                        <i class="fa fa-fw fa-cubes"></i>
                    </div>
                    <div class="mr-5">Create New Category</div>
                </div>
                <a id="anchorNewCategory" class="card-footer text-white clearfix small z-1" href="#" runat="server" onserverclick="OpenModal">
                    <span class="float-left">View Details</span>
                    <span class="float-right">
                        <i class="fa fa-angle-right"></i>
                    </span>
                </a>
            </div>
        </div>
    </div>

    <asp:Literal ID="ltScripts1" runat="server"></asp:Literal>
    <asp:Literal ID="ltScripts2" runat="server"></asp:Literal>
    <div class="row">
        <div class="clearfix"></div>
        <div class="col-md-6">
            <div id="chart_div1" class="chart"></div>
        </div>
        <div class="col-md-6">
            <div id="chart_div2" class="chart"></div>
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

    <!-- #region Success message modal -->
    <div class="modal fade" id="mySuccessNewItemModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertSuccessNewItemModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="modal-content">
                        <div class="modal-header modal-header-success">
                            <h1>Item created</h1>
                        </div>
                        <div class="modal-body">
                            <h3>The new item has been sucessfully created.</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!-- #endregion -->

    <!-- #region Fail message modal -->
    <div class="modal fade" id="myFailNewItemModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertFailNewItemModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header modal-header-danger">
                            <h1>Creation failed</h1>
                        </div>
                        <div class="modal-body">
                            <h3>There was a problem with creating the new item.</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!-- #endregion -->

    <!-- #region Success message modal -->
    <div class="modal fade" id="mySuccessNewCatModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertSuccessNewCatModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="modal-content">
                        <div class="modal-header modal-header-success">
                            <h1>Category created</h1>
                        </div>
                        <div class="modal-body">
                            <h3>The category has been sucessfully created.</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!-- #endregion -->

    <!-- #region Fail message modal -->
    <div class="modal fade" id="myFailNewCatModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertFailNewCatModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header modal-header-danger">
                            <h1>Creation failed</h1>
                        </div>
                        <div class="modal-body">
                            <h3>There was a problem with creating the new category.</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!-- #endregion -->
    
    
    <!-- #region Success message modal -->
    <div class="modal fade" id="mySuccessOrder" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertSuccessOrder" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="modal-content">
                        <div class="modal-header modal-header-success">
                            <h1>Order sent!</h1>
                        </div>
                        <div class="modal-body">
                            <h3>Order has been sent for delivery.</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!-- #endregion -->

    <!-- #region Fail message modal -->
    <div class="modal fade" id="myFailOrder" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertFailOrder" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header modal-header-danger">
                            <h1>Order not sent!</h1>
                        </div>
                        <div class="modal-body">
                            <h3>There was a problem with delivering the order.</h3>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!-- #endregion -->

    <div class="modal fade" id="myNewItemModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="newItemModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="lblModalTitle" runat="server" Text=""></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div class="input-group md-3" style="margin-bottom: 2px">
                                <div class="input-group-prepend">
                                    <span id="basic-addon1" class="input-group-text md-3" style="width: 150px;">Name</span>
                                </div>
                                <asp:TextBox ID="txtItemName" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>

                            <div class="input-group md-3" style="margin-bottom: 2px">
                                <div class="input-group-prepend">
                                    <span id="basic-addon1" class="input-group-text md-3" style="width: 150px;">Description</span>
                                </div>
                                <asp:TextBox ID="txtItemDescription" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>

                            <div class="input-group md-3" style="margin-bottom: 2px">
                                <div class="input-group-prepend">
                                    <span id="basic-addon1" class="input-group-text md-3" style="width: 150px;">Price</span>
                                </div>
                                <asp:TextBox ID="txtItemPrice" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>

                            <div class="input-group" style="width: 100%;">
                                <div class="input-group-prepend">
                                    <span id="basic-addon1" class="input-group-text md-3" style="width: 150px;">Category</span>
                                </div>
                                <select class="form-control" id="newItemInputCategory" runat="server">
                                </select>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-info" data-dismiss="modal" aria-hidden="true" runat="server" onserverclick="CreateNewItem">Add New Item</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
    </div>

    <div class="modal fade" id="myNewItemCategoryModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="newItemCategoryModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label1" runat="server" Text=""></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div class="input-group md-3" style="margin-bottom: 2px">
                                <div class="input-group-prepend">
                                    <span id="basic-addon1" class="input-group-text md-3" style="width: 150px;">Category Name</span>
                                </div>
                                <asp:TextBox ID="txtCatName" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-info" data-dismiss="modal" aria-hidden="true" runat="server" onserverclick="CreateNewCategory">Add New Category</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="modal fade" id="myProcessNewOrdersModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <asp:UpdatePanel ID="processNewOrdersModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label2" runat="server" Text=""></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-hover table-striped table-bordered" DataSourceID="SqlDataSource1">
                                <Columns>
                                    <asp:BoundField DataField="Id" HeaderText="Order Id" SortExpression="Id" ItemStyle-CssClass="hiddencol"  HeaderStyle-CssClass="hiddencol" />
                                    <asp:BoundField DataField="Name" HeaderText="Item Name" SortExpression="Name" />
                                    <asp:BoundField DataField="ItemQuantity" HeaderText="Quantity" SortExpression="ItemQuantity" />
                                    <asp:BoundField DataField="ItemTotalPrice" HeaderText="Total Price" SortExpression="ItemTotalPrice" />
                                    <asp:BoundField DataField="CustName" HeaderText="Cust Name" SortExpression="CustName" />
                                    <asp:BoundField DataField="CustAddress" HeaderText="Cust Address" SortExpression="CustAddress" />
                                    <asp:BoundField DataField="CustPhone" HeaderText="Cust Phone" SortExpression="CustPhone" />
                                    <asp:BoundField DataField="CustEmail" HeaderText="Cust Email" SortExpression="CustEmail" />
                                    <asp:TemplateField ItemStyle-Width="30px" HeaderText="Process">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" CssClass="btn btn-info" runat="server" Text="Send" CommandName="Select" OnClick="DeliverOrder"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-info" data-dismiss="modal" aria-hidden="true" runat="server">Close</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="modal fade" id="myShowAllOrdersModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <asp:UpdatePanel ID="showAllOrdersModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label3" runat="server" Text=""></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <asp:GridView ID="GridView3" runat="server" CssClass="table table-hover table-striped table-bordered" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="SqlDataSource3">
                                <Columns>
                                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                                    <asp:BoundField DataField="ItemQuantity" HeaderText="Quantity" SortExpression="ItemQuantity" />
                                    <asp:BoundField DataField="ItemTotalPrice" HeaderText="Total Price" SortExpression="ItemTotalPrice" />
                                    <asp:BoundField DataField="CustName" HeaderText="Cust Name" SortExpression="CustName" />
                                    <asp:BoundField DataField="CustAddress" HeaderText="Cust Address" SortExpression="CustAddress" />
                                    <asp:BoundField DataField="CustPhone" HeaderText="Cust Phone" SortExpression="CustPhone" />
                                    <asp:BoundField DataField="CustEmail" HeaderText="Cust Email" SortExpression="CustEmail" />
                                    <asp:BoundField DataField="Order Status" HeaderText="Order Status" SortExpression="Order Status" />
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-info" data-dismiss="modal" aria-hidden="true" runat="server">Close</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:conStr %>" SelectCommand="SELECT o.Id, i.Name, o.ItemQuantity, o.ItemTotalPrice, o.CustName, o.CustAddress, o.CustPhone, o.CustEmail FROM Orders AS o INNER JOIN Items AS i ON i.Id = o.ItemId WHERE (o.OrderStatus = @OrderStatus)">
        <SelectParameters>
            <asp:Parameter DefaultValue="1" Name="OrderStatus" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:conStr %>" SelectCommand="SELECT i.Name, o.ItemQuantity, o.ItemTotalPrice, o.CustName, o.CustAddress, o.CustPhone, o.CustEmail, os.Name AS 'Order Status' FROM Orders AS o INNER JOIN Items AS i ON i.Id = o.ItemId INNER JOIN OrderStatuses AS os ON os.Id = o.OrderStatus"></asp:SqlDataSource>
</asp:Content>
