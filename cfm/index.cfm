<cfset orderId = 786981>

<!--- <cfquery name="qLifts" datasource="#application.dsn#">
    SELECT  ol.createdby, ol.created, ol.estimatedcost, ol.qty, ol.confirmationnumber, ol.closedby, ol.equipmenttype,
            ol.releasenumber, ol.updatedby, ol.updated, ol.notes, ol.id, ol.closedate, ol.releasedate, ol.liftcompany, ol.enddate,
            ol.releasewith, isNull(ol.finalinvoiceamount,0) finalinvoiceamount, ol.invoicenumber, ol.deliverydate,
            OLI.ServerFileName, OLI.ID LiftFileID,
            CASE WHEN isNull(AR.StatusID,0) > 5 THEN 1 ELSE 0 END ARCompleted,
            CASE WHEN API.OrderLiftID IS NOT NULL THEN 1 ELSE 0 END APCreated
    FROM    dbo.OrderLifts ol WITH (NOLOCK)
            LEFT JOIN dbo.OrderLiftInvoices OLI
                ON OL.ID = OLI.LiftID
            LEFT JOIN dbo.OrderARInvoices AR
                ON OL.OrderID = AR.OrderID
            LEFT JOIN dbo.OrderAPInvoiceItems API
                ON OL.ID = API.OrderLiftID
    WHERE   OL.orderid = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderid#" />
    ORDER BY OL.deliverydate
</cfquery> --->

<cfset qLifts = queryNew(
    "createdby, created, estimatedcost, qty, confirmationnumber, closedby, equipmenttype,
    releasenumber, updatedby, updated, notes, id, closedate, releasedate, liftcompany, enddate,
    releasewith, finalinvoiceamount, invoicenumber, deliverydate, ServerFileName, LiftFileID,
    ARCompleted, APCreated",
    "varchar, timestamp, decimal, integer, varchar, varchar, varchar,
    varchar, varchar, timestamp, varchar, integer, timestamp, timestamp, varchar, timestamp,
    varchar, decimal, varchar, timestamp, varchar, integer, integer, integer"
)>

<!--- Insert test data --->
<cfset queryAddRow(qLifts, 1)>

<cfset querySetCell(qLifts, "createdby", "user1", 1)>
<cfset querySetCell(qLifts, "created", now(), 1)>
<cfset querySetCell(qLifts, "estimatedcost", 1500.00, 1)>
<cfset querySetCell(qLifts, "qty", 2, 1)>
<cfset querySetCell(qLifts, "confirmationnumber", "CONF12345", 1)>
<cfset querySetCell(qLifts, "closedby", "admin", 1)>
<cfset querySetCell(qLifts, "equipmenttype", "Crane", 1)>
<cfset querySetCell(qLifts, "releasenumber", "", 1)>
<cfset querySetCell(qLifts, "updatedby", "user2", 1)>
<cfset querySetCell(qLifts, "updated", now(), 1)>
<cfset querySetCell(qLifts, "notes", "Test lift operation", 1)>
<cfset querySetCell(qLifts, "id", 1001, 1)>
<cfset querySetCell(qLifts, "closedate", "", 1)>
<cfset querySetCell(qLifts, "releasedate", "", 1)>
<cfset querySetCell(qLifts, "liftcompany", "LiftCorp", 1)>
<cfset querySetCell(qLifts, "enddate", now(), 1)>
<cfset querySetCell(qLifts, "releasewith", "", 1)>
<cfset querySetCell(qLifts, "finalinvoiceamount", 1800.00, 1)>
<cfset querySetCell(qLifts, "invoicenumber", "INV12345", 1)>
<cfset querySetCell(qLifts, "deliverydate", now(), 1)>
<cfset querySetCell(qLifts, "ServerFileName", "file1.pdf", 1)>
<cfset querySetCell(qLifts, "LiftFileID", 501, 1)>
<cfset querySetCell(qLifts, "ARCompleted", 1, 1)>
<cfset querySetCell(qLifts, "APCreated", 1, 1)>

<!--- <cfquery name="qVendors" datasource="#application.dsn#">
    SELECT  V.VendorNumber, V.Name,
            CASE WHEN OT.vendornumber = V.VendorNumber THEN 1 ELSE 0 END AssignedTech
    FROM    dbo.Orders O WITH(NOLOCK)
            INNER JOIN dbo.OrderTechs OT WITH(NOLOCK)
                ON O.OrderID = OT.OrderID
            INNER JOIN dbo.Vendor V WITH(NOLOCK)
                ON  V.VendorNumber = OT.VendorNumber
    WHERE   O.OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderid#" /> AND V.StatusID != 7
    ORDER BY AssignedTech DESC, V.Name
</cfquery> --->

<cfset qVendors = queryNew(
    "VendorNumber, Name, AssignedTech",
    "integer, varchar, integer"
)>

<!--- Insert test data --->
<cfset queryAddRow(qVendors, 3)>

<cfset querySetCell(qVendors, "VendorNumber", 1, 1)>
<cfset querySetCell(qVendors, "Name", "Tech Solutions Inc.", 1)>
<cfset querySetCell(qVendors, "AssignedTech", 1, 1)>

<cfset querySetCell(qVendors, "VendorNumber", 2, 2)>
<cfset querySetCell(qVendors, "Name", "Lift Experts LLC", 2)>
<cfset querySetCell(qVendors, "AssignedTech", 0, 2)>

<cfset querySetCell(qVendors, "VendorNumber", 3, 3)>
<cfset querySetCell(qVendors, "Name", "Industrial Mechanics Co.", 3)>
<cfset querySetCell(qVendors, "AssignedTech", 1, 3)>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en" id="cptmain">
<head>
    <cfoutput>
        <link rel="stylesheet" type="text/css" href="assets/jquery-ui-1.8.16.custom.css">
        <link rel="stylesheet" type="text/css" href="assets/table_jui.css?v=2"/>
        <link rel="stylesheet" type="text/css" href="assets/TableTools_JUI.css"/>
        <script language="javascript" src="assets/jquery-1.7.2.min.js"></script>
        <script language="javascript" src="assets/jquery-ui-1.8.18.custom.min.js"></script>
        <script type="text/javascript" language="javascript" src="assets/jquery.dataTables.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="assets/TableTools.min.js"></script>
    </cfoutput>
</head>
<body id="body">

<table cellpadding="2" cellspacing="2" border="0" class="display" width="100%" id="tblLifts">
<thead>
    <tr>
        <th style="width:1%;display:none;"></th>
        <th width="2%"></th>
        <th width="7%">Lift Company</th>
        <th width="10%">Equip Type</th>
        <th width="6%">Delivery Date</th>
        <th width="5%">End Date</th>
        <th width="20%">Notes</th>
        <th width="8%">Inv #</th>
        <th width="5%">Inv Amt</th>
        <th width="6%">Release Date</th>
        <th width="7%">Release #</th>
        <th width="7%">Released By</th>
        <th width="7%">Created</th>
        <th width="6%">Created By</th>
        <th width="6%"></th>
    </tr>
</thead>
<tbody>
    <cfoutput query="qLifts" group="ID">
        <tr id="tr_#currentrow#">
            <td style="width:1px;display:none;"></td>
            <td valign="top">#qLifts.ID#</td>
            <td valign="top">
                #qLifts.liftcompany#
            </td>
            <td valign="top">
                <cfswitch expression="#qLifts.equipmenttype#">
                    <cfcase value="1">19' Scissor Lift STD</cfcase>
                    <cfcase value="2">20' Scissor Lift STD</cfcase>
                    <cfcase value="3">26' Scissor Lift STD</cfcase>
                    <cfcase value="4">20' Articulating Boom</cfcase>
                    <cfcase value="5">34' Articulating Boom</cfcase>
                    <cfcase value="6">Other - Specify in Notes</cfcase>
                </cfswitch>
            </td>
            <td valign="top">#DateFormat(qLifts.deliverydate,'mm/dd/yy')#</td>
            <td valign="top">#DateFormat(qLifts.enddate,'mm/dd/yy')#</td>
            <td valign="top">
                    <cfif Trim(Len(qLifts.notes))>
                        #qLifts.notes# <br style="line-height:16px;" />
                    </cfif>
                    <cfif Trim(Len(qLifts.ServerFileName))>
                        Lift Invoices:<br style="line-height:16px;" />
                    </cfif>
                    <cfoutput>
                        <cfif qLifts.ServerFileName NEQ ''>
                            <a href="ViewLiftInvoice.cfm?blnpopup&plainnojs&ID=#qLifts.LiftFileID#" target="_blank">#qLifts.ServerFileName#</a><br style="line-height:20px;" />
                        </cfif>
                    </cfoutput>
                </td>
            <td valign="top">#qLifts.invoicenumber#</td>
            <td valign="top" align="center">#DollarFormat(qLifts.finalinvoiceamount)#</td>
            <td valign="top">#DateFormat(qLifts.releasedate,'mm/dd/yy')#</td>
            <td valign="top">#qLifts.releasenumber#</td>
            <td valign="top">#qLifts.releasewith#</td>
            <td valign="top">#DateFormat(qLifts.Created,'mm/dd/yy')# #timeformat(qLifts.Created,"hh:mm tt")#</td>
            <td valign="top">#qLifts.createdby#</td>
            <td  valign="top" align="left" nowrap align="middle">
                <div style="float:left" class="ui-state-default ui-corner-all" title="Edit Lift">
                    <a href="##" onclick="editLift(#qLifts.id#)">
                        <span class="ui-icon ui-icon-pencil"></span>
                    </a>
                </div>

                <div style="float:left; margin-left:10px" class="ui-state-default ui-corner-all" title="Cancel Lift">
                    <a href="##" onclick="deleteLift(#qLifts.id#)">
                        <span class="ui-icon ui-icon-close"></span>
                    </a>
                </div>
            </td>
        </tr>
    </cfoutput>
</tbody>
</table>

<div id="liftInfo" style="display:none;padding:5px">
    <div style="background-image:url('assets/images/lift.png');background-position:270px 20px;;background-repeat:no-repeat;width:100%;">
        <div id="liftclosed" class="alert"></div>
            <div>
            <!--- <cfquery name="qliftcompanies" datasource="#application.dsn#">
                SELECT  ID, companyname, companyphone, accountnumber, WebsiteURL
                FROM    dbo.LiftCompanies WITH (NOLOCK)
                WHERE   isNull(Active,0) = 1
                ORDER BY SortOrder
            </cfquery> --->

            <cfset qLiftCompanies = queryNew(
                "ID, companyname, companyphone, accountnumber, WebsiteURL",
                "integer, varchar, varchar, varchar, varchar"
            )>

            <!--- Insert test data --->
            <cfset queryAddRow(qLiftCompanies, 3)>

            <cfset querySetCell(qLiftCompanies, "ID", 1, 1)>
            <cfset querySetCell(qLiftCompanies, "companyname", "LiftCorp", 1)>
            <cfset querySetCell(qLiftCompanies, "companyphone", "555-1234", 1)>
            <cfset querySetCell(qLiftCompanies, "accountnumber", "ACCT001", 1)>
            <cfset querySetCell(qLiftCompanies, "WebsiteURL", "https://www.liftcorp.com", 1)>

            <cfset querySetCell(qLiftCompanies, "ID", 2, 2)>
            <cfset querySetCell(qLiftCompanies, "companyname", "CraneCo", 2)>
            <cfset querySetCell(qLiftCompanies, "companyphone", "555-5678", 2)>
            <cfset querySetCell(qLiftCompanies, "accountnumber", "ACCT002", 2)>
            <cfset querySetCell(qLiftCompanies, "WebsiteURL", "https://www.craneco.com", 2)>

            <cfset querySetCell(qLiftCompanies, "ID", 3, 3)>
            <cfset querySetCell(qLiftCompanies, "companyname", "Hoist Solutions", 3)>
            <cfset querySetCell(qLiftCompanies, "companyphone", "555-9876", 3)>
            <cfset querySetCell(qLiftCompanies, "accountnumber", "ACCT003", 3)>
            <cfset querySetCell(qLiftCompanies, "WebsiteURL", "https://www.hoistsolutions.com", 3)>

            <fieldset class="fs">
                <legend class="leg">Lift</legend>
                <table width="100%" cellspacing="5" cellpadding="5">
                <tr>
                    <td width="25%">Lift Company</td>
                    <td id="liftcomp">
                        <select id="liftcompany" onChange="displayPhone(this.value)">
                            <option value="" style="padding:4px;">- Select -</option>
                            <cfoutput query="qliftcompanies">
                                <option style="padding:4px;" value="#qliftcompanies.companyname#" data-liftvendorid="#qliftcompanies.ID#" data-phone="#qliftcompanies.companyphone#"
                                            data-acctno="#qliftcompanies.accountnumber#" data-webURL="#qliftcompanies.WebsiteURL#">
                                    #qliftcompanies.companyname#
                                </option>
                            </cfoutput>
                            <cfif qVendors.recordcount>
                                <option style="padding:4px;" value="FieldTech">Field Tech</option>
                            </cfif>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td id="liftphone" style="font-weight:800;color:#636363;" colspan="2"></td>
                </tr>
                <tr id="dispVendor" style="display:none;">
                    <td>Field-Tech:</td>
                    <td>
                        <select id="liftvendor">
                            <option value="" style="padding:4px;">- Select -</option>
                            <cfoutput query="qVendors">
                                <option style="padding:4px;" value="#qVendors.Name#" data-liftvendorid="#qVendors.VendorNumber#">
                                    #qVendors.Name#
                                </option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Equipment Type:</td>
                    <td>
                        <select id="equipmenttype">
                            <option value="" style="padding:4px;">- Select -</option>
                            <option value="1" style="padding:4px;">19' Scissor Lift STD</option>
                            <option value="2" style="padding:4px;">20' Scissor Lift STD</option>
                            <option value="3" style="padding:4px;">26' Scissor Lift STD</option>
                            <option value="4" style="padding:4px;">20' Articulating Boom</option>
                            <option value="5" style="padding:4px;">34' Articulating Boom</option>
                            <option value="6" style="padding:4px;">Other - Specify in Notes</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Quantity:</td>
                    <td><input id="qty" type="text" value="1" style="width:50px;" DISABLED /></td>
                </tr>
                <tr>
                    <td>Estimated Cost:</td>
                    <td><input id="estCost" type="text" value="" style="width:80px;" oninput="formatEstCost(this)" /></td>
                </tr>
                <tr>
                    <td>Confirmation #:</td>
                    <td><input id="confNumber" type="text" value="" style="width:120px;" /></td>
                </tr>
                <tr>
                    <td>Delivery Date</td>
                    <td><input id="deliveryDate" type="text" value="" style="width:80px;" readonly /></td>
                </tr>
                <tr>
                    <td>End Date</td>
                    <td><input id="endDate" type="text" value="" style="width:80px;" readonly /></td>
                </tr>
                <tr>
                    <td colspan="2">
                        Lift Order Notes:<br>
                        <textarea id="notes" style="width:480px;height:60px;"></textarea>
                    </td>
                </tr>
                </table>
            </fieldset>
        </div>

        <div class="liftdetail" style="margin-top:5px;">
            <fieldset class="fs">
                <legend class="leg">Release Lift</legend>
                <table width="100%" cellspacing="5" cellpadding="5">
                    <tr>
                        <td width="25%">Release Date:</td>
                        <td><input id="rlsDate" type="text" value="" style="width:80px;" readonly /></td>
                        <td>Release With:</td>
                        <td><input id="releasewith" type="text" value="" style="width:120px;" /></td>
                    </tr>
                    <tr class="rls">
                        <td>Release #:</td>
                        <td colspan="3"><input id="releaseNumber" type="text" value="" style="width:160px;" /></td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>
    <input type="hidden" id="closeout" value="0" />
</div>

<script>
    function editLift(liftid) {
        console.log(liftid);
      $.ajax({
            url: 'lifts.cfc?method=getLiftInfo&returnformat=json',
            type: "POST",
            cache : false,
            data : { liftid },
            dataType : "json",
            success: function(response) {
                showEditLiftDialog(response);
            }
      });
    }

    function showEditLiftDialog(obj) {
        console.table(obj)
        $("<div></div>").dialog({
            width: 800,
            height: 800,
            resizable: false,
            modal: true,
            title: 'Edit Lift',
            open: function(){
                $(this).html( $("#liftInfo").html() );
                $("#liftInfo").html("");
                $("#rlsDate,#endDate,#deliveryDate").datepicker();
                $("#qty").val(obj.QTY);
                $("#estCost").val(obj.ESTIMATEDCOST);
                $("#confNumber").val(obj.CONFIRMATIONNUMBER);
                $("#releaseNumber").val(obj.RELEASENUMBER);
                $("#notes").val(obj.NOTES);
                $("#rlsDate").val(obj.RELEASEDATE);
                $("#endDate").val(obj.ENDDATE);
                $("#closeout").val("0");
                $("#liftcompany").val(obj.LIFTCOMPANY);
                $("#equipmenttype").val(obj.EQUIPMENTTYPE);
                $("#releasewith").val(obj.RELEASEWITH);
                $("#finalInvoiceAmt").val(obj.FINALINVOICEAMOUNT);
                $("#invoiceNumber").val(obj.INVOICENUMBER);
                $("#deliveryDate").val(obj.DELIVERYDATE);
                $("#OrderID").val(obj.ORDERID);
                $("#CustomerID").val(obj.CUSTOMERID);
                $("#CustomerSiteID").val(obj.CUSTOMERSITEID);
                $(".liftdetail").show();

                if(obj.ISFIELDTECH == 1){
                    $("#liftcompany").val('FieldTech').change();
                    $("#liftvendor").val(obj.LIFTCOMPANY).change();
                    $("#dispVendor").show();
                } else {
                    if ($.trim(obj.LIFTCOMPANY) != "") {
                        displayPhone(obj.LIFTCOMPANY);
                    } else {
                        displayPhone( $("#liftcompany").val());
                    }
                    $("#dispVendor").hide();
                }

                $(".rls").show();

                if (obj.CLOSED == 1) {
                    $("#bUpdateLift,#breleaseLift,#bsetReminder").hide();
                    $("#liftclosed").html("Lift Status is Closed");
                } else {
                    $("#bUpdateLift,#breleaseLift,#bsetReminder").show();
                    $("#liftclosed").html("");
                }

                $("#closeout").val("0");
                $("#breleaseLift").hide();
            },
            close: function(){
                $("#rlsDate,#endDate,#deliveryDate").datepicker("destroy");
                $("#liftInfo").html($(this).html());
                $(this).remove();
            },
            buttons: [
                {
                    id:"nl_btn_Cancel",
                    text: "Cancel",
                    click: function() {
                        $(this).dialog("close");
                    }
                },
                {
                    id:"bUpdateLift",
                    text: "Update Lift",
                    click: function() {
                        updateLift(obj);
                    }
                },
                {
                    id:"breleaseLift",
                    text: "Release Lift",
                    click: function() {
                        releaseLift(obj);
                    }
                },
                {
                    id:"bsetReminder",
                    text: "Create Reminder",
                    click: function() {
                        dspReminderDialog();
                    }
                }]
            });
        $("#nl_btn_Cancel").button({icons:{primary:"ui-icon-close"}});
        $("#bUpdateLift").button({icons:{primary:"ui-icon-disk"}});
        $("#breleaseLift").button({icons:{primary:"ui-icon-eject"}});
        $("#bsetReminder").button({icons:{primary:"ui-icon-clock"}});
    }

    function updateLift(obj) {
        var error = false;
        var _finalInvoiceAmt = 0;
        var _ProgressBilling = 0;

        if ($("#liftcompany").val() == "") {
            error = true;
            alert("Please select the lift company.");
            $("#liftcompany").focus();
            return;
        }

        if ($("#liftcompany").val() == "FieldTech" && $("#liftvendor").val() == "") {
            error = true;
            alert("Please select the lift vendor company.");
            $("#liftvendor").focus();
            return;
        }

        if ($("#equipmenttype").val() == "") {
            error = true;
            alert("Please select the equipment type.");
            $("#equipmenttype").focus();
            return;
        }

        if ($.trim($("#rlsDate").val()) != "" | $.trim($("#releasewith").val()) != "" || $.trim($("#releaseNumber").val()) != "") {
            if ($.trim($("#rlsDate").val()) == "") {
                error = true;
                alert("The release date is required.");
                $("#rlsDate").focus();
                return;
            }

            if ($.trim($("#releasewith").val()) == "") {
                error = true;
                alert("Release with is required.");
                $("#releasewith").focus();
                return;
            }

            if ($.trim($("#releaseNumber").val()) == "" || $.trim($("#releaseNumber").val()) == "0") {
                error = true;
                alert("The release number is required.");
                $("#releaseNumber").focus();
                return;
            }
        }

        if ($.trim($("#qty").val()) == ""){
          error = true;
          alert("Please enter the quantity.");
          $("#qty").focus();
          return;
        }

        if ($.trim($("#estCost").val()) == "" || $.trim($("#estCost").val())*1 == 0){
            error = true;
            alert("Please select the estimated cost.");
            $("#estCost").focus();
            return;
        }

        if ($.trim($("#confNumber").val()) == ""){
            error = true;
            alert("Please select the confirmation number.");
            $("#confNumber").focus();
            return;
        }

        if ($.trim($("#endDate").val()) == ""){
            error = true;
            alert("Please select the end date.");
            $("#endDate").focus();
            return;
        }

        if ($.trim($("#estCost").val()) == ""){
            var _estCost = 0;
        } else {
            var _estCost = $("#estCost").val();
        }

        if( $.trim( $("#finalInvoiceAmt").val() ) == "" || !jQuery.isNumeric($.trim($("#finalInvoiceAmt").val())) ){
            _finalInvoiceAmt = 0;
        } else {
            _finalInvoiceAmt = $("#finalInvoiceAmt").val();
        }

        if ($('#cbProgressBilling:checked').val() != undefined) { _ProgressBilling = 1; }

        var thisLiftComp = '';
        var _isFieldTech = 0;

        if ($("#liftcompany").val() == "FieldTech") {
            _isFieldTech = 1;
            thisLiftComp = $("#liftvendor").val();
            var liftVendorID = $('#liftvendor option:selected').attr('data-liftvendorid');
        } else {
            thisLiftComp = $("#liftcompany").val();
            var liftVendorID = $('#liftcompany option:selected').attr('data-liftvendorid');
        }

        if (!error) {
            var d = ({
              "id" : obj.ID,
              "orderid" : <cfoutput>#orderid#</cfoutput>,
              "quantity" : $("#qty").val(),
              "estimatedcost" : _estCost,
              "notes" : $("#notes").val(),
              "confirmationnumber" : $("#confNumber").val(),
              "releasenumber" : $("#releaseNumber").val(),
              "closeout" : $("#closeout").val(),
              "enddate" : $("#endDate").val(),
              "releasedate" : $("#rlsDate").val(),
              "liftcompany" : thisLiftComp,
              "liftvendorid" : liftVendorID,
              "isFieldTech" : _isFieldTech,
              "releasewith" : $("#releasewith").val(),
              "finalinvoiceamount" : _finalInvoiceAmt,
              "ProgressBilling" : _ProgressBilling,
              "invoicenumber" : $("#invoiceNumber").val(),
              "equipmenttype" : $("#equipmenttype").val(),
              "deliverydate"  : $("#deliveryDate").val()
            });

            $.ajax({
                url: 'lifts.cfc?method=editLift&returnformat=json',
                type: "POST",
                cache : false,
                data : d,
                dataType : "jSon",
                success: function(response){
                    alert(response.MESSAGE);
                    if(!response.ERROR){
                        $("#nl_btn_Cancel").click();
                    }
                }
            });
        }
    }
    function displayPhone(p) {
        if(p == "FieldTech"){
            $("#dispVendor").show();
            $("#liftphone").html("");
            //getOtherLiftInfo();
        }
        else if (p == ""){
            $("#liftphone").html("");
            $("#dispVendor").hide();
            $("#liftvendor").val('').change();
        }
        else{
            var liftinfo = "Phone: " + $('#liftcompany option:selected').attr('data-phone') + "<br>Account #: " + $('#liftcompany option:selected').attr('data-acctno') + "<br><a href='" + $('#liftcompany option:selected').attr('data-webURL') + "' target='_blank'>" + $('#liftcompany option:selected').attr('data-webURL') + "</a>";
            $("#liftphone").html(liftinfo);
            $("#dispVendor").hide();
            $("#liftvendor").val('').change();
        }
    }
</script>
</body>
</html>
