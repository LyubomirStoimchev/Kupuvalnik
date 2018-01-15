<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Kupuvalnik.Master" CodeBehind="AdminLogin.aspx.cs" Inherits="KupuvalnikWeb.AdminLogin" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css" />
    
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
    <!-- Page level plugin CSS-->
<%--    <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet"/>--%>
    <!-- Custom styles for this template-->
    <link href="css/sb-admin.css" rel="stylesheet"/>


    <<style type="text/css">
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
     </style>

</asp:Content>

<asp:Content ContentPlaceHolderID="body" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>


    <div class="container">
        <form class="form-horizontal" role="form" method="POST" action="/login">
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <h2>Admin Login</h2>
                    <hr>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <div class="form-group has-danger">
                        <label class="sr-only" for="email">E-Mail Address</label>
                        <div class="input-group mb-2 mr-sm-2 mb-sm-0">
                            <div class="input-group-prepend">
                                <span id="basic-addon1" class="input-group-text md-3" style="width: 120px;">Username</span>
                            </div>
                            <asp:TextBox ID="UserName" runat="server" CssClass="form-control" placeholder="Enter Username"
                                required />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="sr-only" for="password">Password</label>
                        <div class="input-group mb-2 mr-sm-2 mb-sm-0">
                            <div class="input-group-prepend">
                                <span id="basic-addon1" class="input-group-text md-3" style="width: 120px;">Password</span>
                            </div>
                            <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control"
                                placeholder="Enter Password" required />
                        </div>
                    </div>
                </div>

            </div>
            <div class="row" style="padding-top: 1rem">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <asp:Button ID="LoginButton" Text="Login" runat="server" OnClick="ValidateUser" Class="btn btn-primary btn-block" />
                </div>
            </div>

        </form>
    </div>

    <!-- #region Fail message modal -->
    <div class="modal fade" id="myFailModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertFailModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header modal-header-danger">
                            <h1>Authentication problem!</h1>
                        </div>
                        <div class="modal-body">
                            <h3>Incorrect username and/or password!</h3>
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
</asp:Content>
