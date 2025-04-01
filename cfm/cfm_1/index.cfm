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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Lift Management System - Manage and track lift operations">
    <meta name="keywords" content="lift management, equipment tracking, construction lifts">
    <meta name="author" content="Your Company Name">
    <meta name="robots" content="index, follow">
    
    <title>Lift Management System</title>
    
    <!--- Favicon --->
    <link rel="icon" type="image/png" href="assets/favicon.png">
    
    <!--- Stylesheets --->
    <link rel="stylesheet" href="assets/styles.css">
    
    <!--- Preload critical assets --->
    <link rel="preload" href="assets/app.js" as="script">
    
    <!--- Open Graph Meta Tags for Social Sharing --->
    <meta property="og:title" content="Lift Management System">
    <meta property="og:description" content="Manage and track lift operations efficiently">
    <meta property="og:type" content="website">
    
    <!--- Twitter Card Meta Tags --->
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="Lift Management System">
    <meta name="twitter:description" content="Manage and track lift operations efficiently">
</head>
<body>
    <div class="container">
        <header class="page-header">
            <h1>Lift Management System</h1>
        </header>

        <main class="main-content">
            <div class="lifts-container">
                <div class="lifts-header">
                    <h2>Lift Operations</h2>
                    <button id="add_lift_btn" class="btn btn-primary">Add New Lift</button>
                </div>

                <div class="lifts-table-container">
                    <table id="lifts_table" class="data-table">
                        <thead>
                            <tr>
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
                            <cfoutput query="qLifts">
                                <tr>
                                    <td>#liftcompany#</td>
                                    <td>#equipmenttype#</td>
                                    <td>#dateTimeFormat(deliverydate, "mm/dd/yyyy")#</td>
                                    <td>#dateTimeFormat(enddate, "mm/dd/yyyy")#</td>
                                    <td>#notes#</td>
                                    <td>
                                        <cfif len(invoicenumber)>
                                            <a href="##" onclick="viewInvoice('#invoicenumber#')">#invoicenumber#</a>
                                        </cfif>
                                    </td>
                                    <td>#dollarFormat(finalinvoiceamount)#</td>
                                    <td>#dateTimeFormat(releasedate, "mm/dd/yyyy")#</td>
                                    <td>#releasenumber#</td>
                                    <td>#releasewith#</td>
                                    <td>#dateTimeFormat(created, "mm/dd/yyyy")#</td>
                                    <td>#createdby#</td>
                                    <td>
                                        <div style="float:left" class="ui-state-default ui-corner-all" title="Edit Lift">
                                            <a href="##" onclick="editLift(#id#)">
                                                <span class="ui-icon ui-icon-pencil"></span>
                                            </a>
                                        </div>
                                        <div style="float:left; margin-left:10px" class="ui-state-default ui-corner-all" title="Cancel Lift">
                                            <a href="##" onclick="deleteLift(#id#)">
                                                <span class="ui-icon ui-icon-close"></span>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Add/Edit Lift -->
    <div id="lift_modal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modal_title">Add New Lift</h2>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="lift_form" class="lift-form">
                    <div class="form-group">
                        <label for="lift_company">Lift Company</label>
                        <select id="lift_company" name="lift_company" required>
                            <cfoutput query="qVendors">
                                <option value="#VendorNumber#">#Name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="equipment_type">Equipment Type</label>
                        <input type="text" id="equipment_type" name="equipment_type" required>
                    </div>

                    <div class="form-group">
                        <label for="delivery_date">Delivery Date</label>
                        <input type="date" id="delivery_date" name="delivery_date" required>
                    </div>

                    <div class="form-group">
                        <label for="estimated_cost">Estimated Cost</label>
                        <input type="number" id="estimated_cost" name="estimated_cost" step="0.01" required>
                    </div>

                    <div class="form-group">
                        <label for="quantity">Quantity</label>
                        <input type="number" id="quantity" name="quantity" required>
                    </div>

                    <div class="form-group">
                        <label for="notes">Notes</label>
                        <textarea id="notes" name="notes" rows="4"></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Save</button>
                        <button type="button" class="btn btn-secondary" id="cancel_btn">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="assets/app.js"></script>
</body>
</html>
