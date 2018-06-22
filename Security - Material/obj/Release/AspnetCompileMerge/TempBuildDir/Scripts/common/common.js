//commmon variable

var _dateFormat = "yyyy.mm.dd";
var _dateFormatKendo = "yyyy.MM.dd";
var _minDate = new Date(2000, 01, 01);
var _maxDate = new Date(2990, 01, 01);
var _$preloader;



$(document).ready(function () {
    _$preloader = $("#divPreloader");
    var href = $(location).attr("pathname");
    $.each($("#main-menu").find("li"), function (index, item) {
        $(item).removeClass("active");
        if (href.indexOf($(item).attr("data-href")) != -1) {
            $(item).addClass("active");
            $(item).parent().parent().addClass("active");
        }
    });
   
});

//common css
var _headerAttributes = { "style": "text-align: center; padding-left: 0" };

function _isValidDate(source, dateDefault) {
    if (dateDefault === undefined || dateDefault === null)
        dateDefault = new Date();
    var comp = source.split('.');
    if (comp.length !== 3)
        return dateDefault;
    var y = parseInt(comp[0], 10);
    var m = parseInt(comp[1], 10);
    var d = parseInt(comp[2], 10);
    var date = new Date(y, m - 1, d);
    if (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d) {
        return date;
    } else {
        return dateDefault;
    }
}

function _isEmailValid(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}

function SetHeight(element, value) {
    element.css({
        height: value,
        "max-height": value,
        overflow: "auto"
    });
}

//check empty, conflict
function _fnCheckEmpty($element, mess) {
    if ($element.val() === "") {
        showNotification("Hyosung Portal", mess, "gray error");
        $element.focus();
        return false;
    }
    return true;
}

function showNotification(feeownTitle, feeownMess, feeownStyle) {
    //STYLE:   smokey, gray, osx, simple    
    //OPTION: autoHide_bool, autoHideDelay_int_ms, classes_array, prepend_bool
    var title = feeownTitle;
    var message = feeownMess;
    var opts = {};
    opts.classes = [feeownStyle]; //style
    opts.prepend = false;
    opts.autoHide = true;
    opts.autoHideDelay = 6000;
    var container = '#freeow-tr';
    opts.classes.push("slide");
    opts.hideStyle = {
        opacity: 0,
        left: "400px"
    };
    opts.showStyle = {
        opacity: 1.5,
        left: 0
    };
    $(container).freeow(title, message, opts);
}

function confirmDelete(lang, operator) {
    if (lang === undefined || lang === null)
            lang = "vi";
    if (operator === undefined || operator === null) {
        switch (lang) {
            case "vi": operator = "xóa đi"; break;
            case "en": operator = "delete"; break;
            default:
        }
    }
    var mess = "";
    switch (lang) {
        case "vi":
            mess = "Bạn có thật sự muốn " + operator+" dữ liệu này không?";
            break;
        case "en":
            mess = "Do you really want to " + operator+" this data?"
            break;
        default:
            mess = "Bạn có thật sự muốn " + operator+" dữ liệu này không?";
    };
    return confirm(mess);
}

//check empty, conflict
function fnCheckEmpty($element, mess) {
    if ($element.val() === "") {
        showNotification("Hyosung Portal", mess, "gray error");
        $element.focus();
        return false;
    }
    return true;
}


function fnGetCateValueViaCateId(cateId, isFilter, control, selectedValue) {
    if (selectedValue === undefined || selectedValue === null)
        selectedValue = "";
    $.ajax({
        type: "POST",
        url: "/Category/GetListValueViaCate",
        data: JSON.stringify({
            category: cateId,
            isFilter: isFilter
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        success: function (result) {
            $.each(result, function (index, item) {                
                control.append($("<option>", { value: item.ID, text: item.Name, selected: item.ID === selectedValue }));
            });
        },
        error: function () {
            return [];
        }
    });
}

function fnGetCateValueViaParent(cateId, isFilter, control, parentId, selectedValue) {
    if (selectedValue === undefined || selectedValue === null)
        selectedValue = "";
    $.ajax({
        type: "POST",
        url: "/Category/GetListValuesViaParent",
        data: JSON.stringify({
            category: cateId,
            isFilter: isFilter,
            parentId: parentId
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        success: function (result) {
            $.each(result, function (index, item) {
                control.append($("<option>", { value: item.ID, text: item.Name, selected: item.ID === selectedValue }));
            });
        },
        error: function () {
            return [];
        }
    });
}
var _employeeInfor;
function _fnGetEmployeeInfor(sender, elements) {
    var empId = $(sender).val();
    $.ajax({
        type: "POST",
        url: "/Common/GetEmployeeInfor",
        data: JSON.stringify({ deptCode: 0, userId: empId, userName: empId, status: "", nation: "", sex: "", hasEmail: null }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        success: function (result) {
            var resultData = result;
            if (resultData.length === 1) {
                _fnSetValueForElementEmployeeInfor(elements, resultData[0]);
            } else {
                _employeeInfor = elements;                
                $("#mdEmpInfor").modal("show");
                $("#hdfMdEmpInforEmpId").val(empId);
            }
        },
        error: function () {
            return [];
        }
    });
}

function _fnSetValueForElementEmployeeInfor(elements, data) {
    $(elements[0]).val(data.LoginID);
    $(elements[1]).val(data.Name);

    $(elements[2]).val(data.HandPhoneNumber);
    $(elements[3]).val(data.PhoneNumber);

    $(elements[4]).val(data.OrganizeName);
    $(elements[5]).val(data.PlantName);
    $(elements[6]).val(data.DeptName);
    $(elements[7]).val(data.SectionName);
    $(elements[8]).val(data.DeptId);
}

function _fnGetVendorInfor(sender, elements, vendorType) {
    var value = $(sender).val();
    $.ajax({
        type: "POST",
        url: "/Vendor/FindVendor",
        data: JSON.stringify({ value: value, vendorType: vendorType}),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        success: function (result) {
            var resultData = result;
            console.log(resultData);
            switch (resultData.length) {
                case 0:
                    if (confirm("Dont have this vendor. Do you want to add this new vendor?")) {
                        $("#mdVendor").modal("show");
                    }

                    break;
                case 1:
                    _fnSetValueForElementVendorInformation(elements, resultData[0]);
                    break;
                default:
                    _vendorModel = elements;
                    $("#mdVendorList").modal("show");
                    break;
            }
            return;
        },
        error: function () {
            return [];
        }
    });
}
function _fnSetValueForElementVendorInformation(elements, data) {
    $(elements[0]).val(data.TaxCode);
    $(elements[1]).val(data.CompanyName);
    $(elements[2]).val(data.ContactPerson);
    $(elements[3]).val(data.Email);
    $(elements[4]).val(data.PhoneNumber);
    $(elements[5]).val(data.Address);
    $(elements[6]).val(data.Id);
}

function _handleTabShow(tab, navigation, index, wizard) {
    var total = navigation.find('li').length;
    var current = index + 0;
    var percent = (current / (total - 1)) * 100;
    var percentWidth = 100 - (100 / total) + '%';

    navigation.find('li').removeClass('done');
    //hàm prevAll, tìm tất cả những thằng li nào phí sau thằng li có class active, add thêm class done vào
    navigation.find('li.active').prevAll().addClass('done');

    wizard.find('.progress-bar').css({ width: percent + '%' });
    $('.form-wizard-horizontal').find('.progress').css({ 'width': percentWidth });
};

function _fnConvertJsonToString(jsonData, item, char) {
    var result = jsonData.map(function (d) { return d[item] }).join(char);
    return result;
}

function _fnRandomPassword(length) {
    var chars = "abcdefghijklmnopqrstuvwxyz!@#$%^&*()-+<>ABCDEFGHIJKLMNOP1234567890";
    var pass = "";
    for (var x = 0; x < length; x++) {
        var i = Math.floor(Math.random() * chars.length);
        pass += chars.charAt(i);
    }
    return pass;
}

//Card
function _fnToggleCardCollapse(card, duration) {
    console.log(card);
    duration = typeof duration !== 'undefined' ? duration : 400;
    var dispatched = false;
    card.find('.nano').slideToggle(duration);
    card.find('.card-body').slideToggle(duration, function () {
        if (dispatched === false) {
            $('#COLLAPSER').triggerHandler('card.bb.collapse', [!$(this).is(":visible")]);
            dispatched = true;
        }
    });
    card.toggleClass('card-collapsed');
};

