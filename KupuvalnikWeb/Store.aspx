<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Kupuvalnik.Master" CodeBehind="Store.aspx.cs" Inherits="KupuvalnikWeb.Store" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        var txtTotalPrice = null;
        var txtUnitPrice = null;
        var txtQuantity = null;

        $(window).on('shown.bs.modal', function () {
            $('#code').modal('show');
        });

        $(window).on('shown.bs.modal', function () {
            $('#code').modal('show');
            debugger;
            ValidateCustName(document.getElementById('<%= txtCustName.ClientID %>'));
            ValidateCustPhone(document.getElementById('<%= txtCustPhone.ClientID %>'));
            ValidateCustEmail(document.getElementById('<%= txtCustEmail.ClientID %>'));
            ValidateCustAddress(document.getElementById('<%= txtCustAddress.ClientID %>'));
        });

        function HideModal() {
            $('#myModal').modal('hide');
        };

        function ValidateCustName(control) {
            var regex = /^[a-zA-Z ]{2,30}$/;
            var hiddenCustname = document.getElementById('<%= hiddenName.ClientID %>');
            if (regex.test(control.value)) {
                control.style["background-color"] = "#fff";
                hiddenCustname.value = true;
            }
            else {
                control.style["background-color"] = "#fb757580";
                hiddenCustname.value = false;
            }
            ValidateSaveButton();
        };

        function ValidateCustAddress(control) {
            var hiddenCustaddr = document.getElementById('<%= hiddenAddress.ClientID %>');
            if (control.value == null || control.value == "") {
                control.style["background-color"] = "#fb757580";
                hiddenCustaddr.value = false;
            } else {
                control.style["background-color"] = "#fff";
                hiddenCustaddr.value = true;
            }
            ValidateSaveButton();
        };

        function ValidateCustPhone(control) {
            var regexPlus = /^\+?(359)\)?[-. ]?([0-9]{9})$/;
            var regexZero = /^0?([0-9]{2})?[-. ]?([0-9]{3})?[-. ]?([0-9]{4})$/;
            var hiddenCustphone = document.getElementById('<%= hiddenPhone.ClientID %>');
            if (regexPlus.test(control.value) || regexZero.test(control.value)) {
                control.style["background-color"] = "#fff";
                hiddenCustphone.value = true;
            } else {
                control.style["background-color"] = "#fb757580";
                hiddenCustphone.value = false;
            }
            ValidateSaveButton();
        };

        function ValidateCustEmail(control) {
            var regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            var hiddenCustemail = document.getElementById('<%= hiddenEmail.ClientID %>');
            if (regex.test(control.value)) {
                control.style["background-color"] = "#fff";
                hiddenCustemail.value = true;
            } else {
                control.style["background-color"] = "#fb757580";
                hiddenCustemail.value = false;
            }
            ValidateSaveButton();
        };

        function ValidateSaveButton() {
            var hidName = document.getElementById('<%= hiddenName.ClientID %>');
            var hidPhone = document.getElementById('<%= hiddenPhone.ClientID %>');
            var hidEmail = document.getElementById('<%= hiddenEmail.ClientID %>');
            var hidAddress = document.getElementById('<%= hiddenAddress.ClientID %>');

            var isNameValid = (hidName.value == 'true');
            var isPhoneValid = (hidPhone.value == 'true');
            var isEmailValid = (hidEmail.value == 'true');
            var isAddressValid = (hidAddress.value == 'true');

            if (isNameValid && isPhoneValid && isEmailValid && isAddressValid) {
                document.getElementById('<%= btnCreateOrder.ClientID %>').disabled = false;
            } else {
                document.getElementById('<%= btnCreateOrder.ClientID %>').disabled = true;
            }
        };

        function LoadControls() {
            txtTotalPrice = document.getElementById('<%= txtItemTotalPrice.ClientID %>');
            txtUnitPrice = document.getElementById('<%= txtItemUnitPrice.ClientID %>');
            txtQuantity = document.getElementById('<%= txtItemQuantity.ClientID %>');
        };

        function ChangeQuanitity(bIsIncrement) {
            LoadControls();

            if (bIsIncrement) {
                UpQuantity();
            } else {
                DownQuantity();
            }

            UpdateTotalValue();
        };

        function UpQuantity() {
            var q = parseInt(txtQuantity.value);
            txtQuantity.value = q + 1;
        };

        function DownQuantity() {
            var q = parseInt(txtQuantity.value);
            if (q <= 1) {
                return;
            }
            txtQuantity.value = q - 1;
        };

        function UpdateTotalValue() {
            var quantity = parseInt(txtQuantity.value);
            var unitPrice = parseFloat(txtUnitPrice.value);
            var totalPrice = quantity * unitPrice;
            txtTotalPrice.value = parseFloat(totalPrice).toFixed(2);;
        };
    </script>

    <style type="text/css">
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
    </style>

</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="body" runat="server">

    <!-- #region GridView all items -->
    <div class="panel panel-default">
        <asp:GridView ID="gridViewItems" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="sqlDataSourceGetAllItems" CssClass="table table-hover table-striped table-bordered" AllowPaging="True" AllowSorting="True">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" />
                <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category" />
                <asp:TemplateField ItemStyle-Width="30px" HeaderText="CustomerID">
                    <ItemTemplate>
                        <asp:Button ID="lnkEdit" CssClass="btn btn-primary" runat="server" Text="Buy Now" OnClick="BuyItemClick"></asp:Button>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="sqlDataSourceGetAllItems" runat="server" ConnectionString="<%$ ConnectionStrings:conStr %>" SelectCommand="SELECT [Id], [Name], [Description], [Price], [Category] FROM [Items]"></asp:SqlDataSource>
    </div>
    <!-- #endregion -->

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>

    <!-- #region Success message modal -->
    <div class="modal fade" id="mySuccessModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertSuccessModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="modal-content">
                        <div class="modal-header modal-header-success">
                            <h1>Order created</h1>
                        </div>
                        <div class="modal-body">
                            <h3>Your order has been sucessfully created.</h3>
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
    <div class="modal fade" id="myFailModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="alertFailModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                <ContentTemplate>

                    <div class="modal-content">
                        <div class="modal-header modal-header-danger">
                            <h1>Order failed</h1>
                        </div>
                        <div class="modal-body">
                            <h3>There was a problem with creating your order.</h3>
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


    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <div class="modal fade bd-example-modal-lg " id="myModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <asp:UpdatePanel ID="upModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                        <ContentTemplate>

                            <div class="modal-content">

                                <div class="modal-header">
                                    <h5 class="modal-title">
                                        <asp:Label ID="lblModalTitle" runat="server" Text=""></asp:Label>
                                    </h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>

                                <!-- #region Order modal body -->
                                <div class="modal-body">

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Item</span>
                                        </div>
                                        <asp:TextBox ID="txtItemName" CssClass="form-control" runat="server" ReadOnly="True"></asp:TextBox>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Description</span>
                                        </div>
                                        <asp:TextBox ID="txtItemDescription" CssClass="form-control" runat="server" ReadOnly="True"></asp:TextBox>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Unit Price</span>
                                        </div>
                                        <asp:TextBox ID="txtItemUnitPrice" CssClass="form-control" runat="server" ReadOnly="True"></asp:TextBox>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Quanitiy</span>
                                        </div>
                                        <asp:TextBox ID="txtItemQuantity" CssClass="form-control" runat="server" ReadOnly="True" Style="margin-right: 4px;">1</asp:TextBox>

                                        <span class="input-group-btn" style="width: 20%;">
                                            <button class="btn btn-danger bootstrap-touchspin-down" type="button" runat="server" style="width: 100%; margin-left: -2px;" onclick="javascript: ChangeQuanitity(false);">-</button>
                                        </span>

                                        <span class="input-group-btn" style="width: 20%;">
                                            <button class="btn btn-success bootstrap-touchspin-up" type="button" runat="server" style="width: 100%;" onclick="javascript: ChangeQuanitity(true);">+</button>
                                        </span>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Total Price</span>
                                        </div>
                                        <asp:TextBox ID="txtItemTotalPrice" CssClass="form-control" runat="server" ReadOnly="True"></asp:TextBox>
                                    </div>

                                    <br />
                                    <br />

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Name</span>
                                        </div>
                                        <asp:TextBox ID="txtCustName" CssClass="form-control" runat="server" ControlToValidate="txtCustName" onchange="javascript: ValidateCustName(this);"></asp:TextBox>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Address</span>
                                        </div>
                                        <asp:TextBox ID="txtCustAddress" CssClass="form-control" runat="server" ControlToValidate="txtCustAddress" onchange="javascript: ValidateCustAddress(this);"></asp:TextBox>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Phone</span>
                                        </div>
                                        <asp:TextBox ID="txtCustPhone" CssClass="form-control" runat="server" ControlToValidate="txtCustPhone" onchange="javascript: ValidateCustPhone(this);"></asp:TextBox>
                                    </div>

                                    <div class="input-group md-3" style="margin-bottom: 2px">
                                        <div class="input-group-prepend">
                                            <span id="basic-addon1" class="input-group-text md-3" style="width: 200px;">Email</span>
                                        </div>
                                        <asp:TextBox ID="txtCustEmail" CssClass="form-control" runat="server" ControlToValidate="txtCustEmail" onchange="javascript: ValidateCustEmail(this);"></asp:TextBox>
                                    </div>

                                    <asp:HiddenField ID="hiddenName" runat="server" Value="false" />
                                    <asp:HiddenField ID="hiddenPhone" runat="server" Value="false" />
                                    <asp:HiddenField ID="hiddenEmail" runat="server" Value="false" />
                                    <asp:HiddenField ID="hiddenAddress" runat="server" Value="false" />

                                </div>
                                <!-- #endregion -->

                                <div class="modal-footer">
                                    <button id="btnCreateOrder" data-dismiss="modal" class="btn btn-info" type="button" aria-hidden="true" runat="server" onserverclick="CreateOrderClick">Buy</button>
                                </div>
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>

