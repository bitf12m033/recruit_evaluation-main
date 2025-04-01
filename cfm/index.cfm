<cfset orderId = 786981>
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

<!--- Row 1 --->
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

<!--- Create qliftcompanies query --->
<cfset qliftcompanies = queryNew(
    "ID, companyname, companyphone, accountnumber, WebsiteURL",
    "integer, varchar, varchar, varchar, varchar"
)>

<!--- Insert test data for lift companies --->
<cfset queryAddRow(qliftcompanies, 3)>

<cfset querySetCell(qliftcompanies, "ID", 1, 1)>
<cfset querySetCell(qliftcompanies, "companyname", "LiftCorp", 1)>
<cfset querySetCell(qliftcompanies, "companyphone", "555-1234", 1)>
<cfset querySetCell(qliftcompanies, "accountnumber", "ACCT001", 1)>
<cfset querySetCell(qliftcompanies, "WebsiteURL", "https://www.liftcorp.com", 1)>

<cfset querySetCell(qliftcompanies, "ID", 2, 2)>
<cfset querySetCell(qliftcompanies, "companyname", "CraneCo", 2)>
<cfset querySetCell(qliftcompanies, "companyphone", "555-5678", 2)>
<cfset querySetCell(qliftcompanies, "accountnumber", "ACCT002", 2)>
<cfset querySetCell(qliftcompanies, "WebsiteURL", "https://www.craneco.com", 2)>

<cfset querySetCell(qliftcompanies, "ID", 3, 3)>
<cfset querySetCell(qliftcompanies, "companyname", "Hoist Solutions", 3)>
<cfset querySetCell(qliftcompanies, "companyphone", "555-9876", 3)>
<cfset querySetCell(qliftcompanies, "accountnumber", "ACCT003", 3)>
<cfset querySetCell(qliftcompanies, "WebsiteURL", "https://www.hoistsolutions.com", 3)>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Lift Management System - Manage and track lift operations">
    <meta name="keywords" content="lift management, equipment tracking, construction lifts">
    <meta name="author" content="Your Company Name">
    <meta name="robots" content="index, follow">

    <!--- Stylesheets --->
    <link rel="stylesheet" href="assets/styles.css">
    <!--- JavaScript --->
    <script src="assets/app.js"></script>
    <!---
        <cfoutput>
            <link rel="stylesheet" type="text/css" href="assets/jquery-ui-1.8.16.custom.css">
            <link rel="stylesheet" type="text/css" href="assets/table_jui.css?v=2"/>
            <link rel="stylesheet" type="text/css" href="assets/TableTools_JUI.css"/>
            <script language="javascript" src="assets/jquery-1.7.2.min.js"></script>
            <script language="javascript" src="assets/jquery-ui-1.8.18.custom.min.js"></script>
            <script type="text/javascript" language="javascript" src="assets/jquery.dataTables.min.js"></script>
            <script type="text/javascript" charset="utf-8" src="assets/TableTools.min.js"></script>
        </cfoutput>
    --->
</head>
<body>
    

    <main class="main-content">
        <div class="lifts-container">
            
            <div class="lifts-table-container">
                <table id="lifts_table" class="data-table">
                <thead>
                    <tr>
                        <th>Lift ID</th>
                        <th>Lift Company</th>
                        <th>Equip Type</th>
                        <th>Delivery Date</th>
                        <th>End Date</th>
                        <th>Notes</th>
                        <th>Inv #</th>
                        <th>Inv Amt</th>
                        <th>Release Date</th>
                        <th>Release #</th>
                        <th>Released By</th>
                        <th>Created</th>
                        <th>Created By</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="qLifts" group="ID">
                        <tr id="tr_#currentrow#">
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
                            <td align="center">
                                <div class="action-buttons">
                                    <button class="action-btn edit-btn" data-lift-id="#qLifts.id#" title="Edit Lift">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                    </button>
                                    <button class="action-btn delete-btn" data-lift-id="#qLifts.id#" title="Cancel Lift">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M3 6h18"></path>
                                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>
                                            <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
                </table>
            </div>
        </div>
    </main>

    <div id="lift_info">
        <div class="background-container">
            <div id="lift_closed" class="alert"></div>
            <div>
                <fieldset class="fs">
                    <legend class="leg">Lift</legend>
                    <table class="table-layout">
                    <tr>
                        <td class="table__cell--label">Lift Company</td>
                        <td class="table__cell--full">
                            <select id="lift_company" class="form-select" onChange="displayPhone(this.value)">
                                <option value="" class="select-option">- Select -</option>
                                <cfoutput query="qliftcompanies">
                                    <option class="select-option" value="#qliftcompanies.companyname#" data-liftvendorid="#qliftcompanies.ID#" data-phone="#qliftcompanies.companyphone#"
                                                data-acctno="#qliftcompanies.accountnumber#" data-weburl="#qliftcompanies.WebsiteURL#">
                                        #qliftcompanies.companyname#
                                    </option>
                                </cfoutput>
                                <cfif qVendors.recordcount>
                                    <option class="select-option" value="FieldTech">Field Tech</option>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td id="lift_phone" class="table__cell--phone" colspan="2"></td>
                    </tr>
                    <tr id="disp_vendor">
                        <td class="table__cell--label">Field-Tech:</td>
                        <td class="table__cell--full">
                            <select id="lift_vendor" class="form-select">
                                <option value="" class="select-option">- Select -</option>
                                <cfoutput query="qVendors">
                                    <option class="select-option" value="#qVendors.Name#" data-liftvendorid="#qVendors.VendorNumber#">
                                        #qVendors.Name#
                                    </option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="table__cell--label">Equipment Type:</td>
                        <td class="table__cell--full">
                            <select id="equipment_type" class="form-select">
                                <option value="" class="select-option">- Select -</option>
                                <option value="1" class="select-option">19' Scissor Lift STD</option>
                                <option value="2" class="select-option">20' Scissor Lift STD</option>
                                <option value="3" class="select-option">26' Scissor Lift STD</option>
                                <option value="4" class="select-option">20' Articulating Boom</option>
                                <option value="5" class="select-option">34' Articulating Boom</option>
                                <option value="6" class="select-option">Other - Specify in Notes</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="table__cell--label">Quantity:</td>
                        <td class="table__cell--full">
                            <input id="qty" type="text" value="1" class="form-input input-width-50" disabled />
                        </td>
                    </tr>
                    <tr>
                        <td class="table__cell--label">Estimated Cost:</td>
                        <td class="table__cell--full">
                            <input id="est_cost" type="text" value="" class="form-input input-width-80" oninput="formatEstCost(this)" />
                        </td>
                    </tr>
                    <tr>
                        <td class="table__cell--label">Confirmation #:</td>
                        <td class="table__cell--full">
                            <input id="conf_number" type="text" value="" class="form-input input-width-120" />
                        </td>
                    </tr>
                    <tr>
                        <td class="table__cell--label">Delivery Date</td>
                        <td class="table__cell--full">
                            <input id="delivery_date" type="text" value="" class="form-input input-width-80" readonly />
                        </td>
                    </tr>
                    <tr>
                        <td class="table__cell--label">End Date</td>
                        <td class="table__cell--full">
                            <input id="end_date" type="text" value="" class="form-input input-width-80" readonly />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Lift Order Notes:<br>
                            <textarea id="notes" class="textarea-notes"></textarea>
                        </td>
                    </tr>
                    </table>
                </fieldset>
            </div>

            <div class="lift-detail">
                <fieldset class="fs">
                    <legend class="leg">Release Lift</legend>
                    <div class="release-lift">
                        <div class="release-lift__row">
                            <div class="release-lift__group">
                                <label class="release-lift__label">Release Date:</label>
                                <input id="rls_date" type="text" value="" class="form-input release-lift__input" readonly />
                            </div>
                            <div class="release-lift__group">
                                <label class="release-lift__label">Release With:</label>
                                <input id="release_with" type="text" value="" class="form-input release-lift__input" />
                            </div>
                        </div>
                        <div class="release-lift__row rls">
                            <div class="release-lift__group">
                                <label class="release-lift__label">Release #:</label>
                                <input id="release_number" type="text" value="" class="form-input release-lift__input--full" />
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
        <input type="hidden" id="closeout" value="0" />
    </div>


</body>
</html>
