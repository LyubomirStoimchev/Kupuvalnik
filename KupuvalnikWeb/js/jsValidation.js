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