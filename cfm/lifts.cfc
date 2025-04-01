<cfcomponent>
    <cffunction name="getLiftInfo" output="false" access="remote" returntype="struct">
        <cfargument name="liftid" type="numeric" required="true" />

        <!--- <cfquery name="qLifts" datasource="#application.dsn#">
            SELECT  ol.createdby, ol.created, ol.estimatedcost,  ol.qty, ol.confirmationnumber,  ol.closedby, ol.equipmenttype,
                    ol.releasenumber, ol.updatedby, ol.updated, ol.notes, ol.id, ol.closedate, ol.releasedate, ol.liftcompany, ol.enddate,
                    ol.releasewith, ol.finalinvoiceamount, ol.invoicenumber, ol.deliverydate,
                    ol.orderid, O.CustomerID, cs.customerSiteId, isNull(ol.isFieldTech,0) isFieldTech,
                    ol.LiftVendorID
            FROM    orderLifts ol
                    JOIN Orders O
                        ON OL.OrderID = O.OrderID
                    JOIN customerSite cs
                        ON cs.rowId = o.customerSiteRowId
            WHERE   OL.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.liftid#" />
        </cfquery> --->

        <cfset qLifts = queryNew(
            "createdby, created, estimatedcost, qty, confirmationnumber, closedby, equipmenttype,
            releasenumber, updatedby, updated, notes, id, closedate, releasedate, liftcompany, enddate,
            releasewith, finalinvoiceamount, invoicenumber, deliverydate, ServerFileName, LiftFileID,
            ARCompleted, APCreated, OrderID, CustomerID, CustomerSiteID, LiftVendorID, isFieldTech",
            "varchar, timestamp, decimal, integer, varchar, varchar, varchar,
            varchar, varchar, timestamp, varchar, integer, timestamp, timestamp, varchar, timestamp,
            varchar, decimal, varchar, timestamp, varchar, integer, integer, integer, integer, integer, integer, integer, integer"
        )>

        
        <!--- Insert test data --->
        <cfset queryAddRow(qLifts, 3)>

        <cfset querySetCell(qLifts, "createdby", "user1", 1)>
        <cfset querySetCell(qLifts, "created", now(), 1)>
        <cfset querySetCell(qLifts, "estimatedcost", 1500.00, 1)>
        <cfset querySetCell(qLifts, "qty", 2, 1)>
        <cfset querySetCell(qLifts, "confirmationnumber", "CONF12345", 1)>
        <cfset querySetCell(qLifts, "closedby", "", 1)>
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
        <cfset querySetCell(qLifts, "ARCompleted", 0, 1)>
        <cfset querySetCell(qLifts, "APCreated", 0, 1)>
        <cfset querySetCell(qLifts, "OrderID", 786981, 1)>
        <cfset querySetCell(qLifts, "CustomerID", 1, 1)>
        <cfset querySetCell(qLifts, "CustomerSiteID", 1, 1)>
        <cfset querySetCell(qLifts, "LiftVendorID", 1, 1)>
        <cfset querySetCell(qLifts, "isFieldTech", 1, 1)>

        <cfset local.liftinfo = structnew() />
        <cfset local.liftinfo.id = qLifts.id />
        <cfset local.liftinfo.qty = numberformat(qLifts.qty,"0") />
        <cfset local.liftinfo.estimatedcost = qLifts.estimatedcost />
        <cfset local.liftinfo.notes = qLifts.notes />
        <cfset local.liftinfo.confirmationnumber = qLifts.confirmationnumber />
        <cfset local.liftinfo.releasenumber = qLifts.releasenumber />
        <cfset local.liftinfo.releasedate = dateformat(qLifts.releasedate,"mm/dd/yyyy") />
        <cfset local.liftinfo.liftcompany = qLifts.liftcompany />
        <cfset local.liftinfo.enddate = dateformat(qLifts.enddate,"mm/dd/yyyy") />
        <cfset local.liftinfo.equipmenttype = qlifts.equipmenttype />
        <cfset local.liftinfo.releasewith = qlifts.releasewith />
        <cfset local.liftinfo.finalinvoiceamount = numberformat(qlifts.finalinvoiceamount,"0.00") />
        <cfset local.liftinfo.invoicenumber = qlifts.invoicenumber />
        <cfset local.liftinfo.deliverydate = dateformat(qLifts.deliverydate,"mm/dd/yyyy") />
        <cfset local.liftinfo.OrderID = qLifts.OrderID />
        <cfset local.liftinfo.CustomerID = qLifts.CustomerID />
        <cfset local.liftinfo.CustomerSiteID = qLifts.CustomerSiteID />
        <cfset local.liftinfo.LiftVendorID = qLifts.LiftVendorID />
        <cfset local.liftinfo.isFieldTech = qLifts.isFieldTech />

        <cfif qLifts.closedate NEQ "">
            <cfset local.liftinfo.closed = 1 />
        <cfelse>
            <cfset local.liftinfo.closed = 0 />
        </cfif>

        <cfreturn local.liftinfo />
    </cffunction>

    <cffunction name="editLift" output="false" access="remote" returntype="struct">
        <cfargument name="id" type="numeric" required="true" />
        <cfargument name="orderid" type="numeric" required="true" />
        <cfargument name="quantity" type="numeric" default="0"  required="false"/>
        <cfargument name="estimatedcost" type="numeric" default="0"  required="false"/>
        <cfargument name="notes" type="string" default=""  required="false" />
        <cfargument name="confirmationnumber" default=""  required="false" />
        <cfargument name="releasenumber" default=""  required="false" />
        <cfargument name="closeout" default="0" required="false" />
        <cfargument name="releasedate" required="false" />
        <cfargument name="liftcompany" type="string" default="" required="true" />
        <cfargument name="liftvendorid" type="numeric" default="" required="true" />
        <cfargument name="isFieldTech" type="numeric" default="" required="true" />
        <cfargument name="enddate" type="date"  default="" />
        <cfargument name="releasewith" type="string"  default="" required="true" />
        <cfargument name="finalinvoiceamount" type="string"  default="" required="true" />
        <cfargument name="ProgressBilling" type="numeric" required="yes" />
        <cfargument name="invoicenumber" type="string"  default="" required="true" />
        <cfargument name="equipmenttype" type="numeric" default="" required="true" />
        <cfargument name="deliverydate" type="date"  default=""/>

        <cfset var output = structnew() />
        <cfset output.error = false />
        <cfset output.message = "Lift updated successfully." />

        <cftry>
            <!--- <cfstoredproc datasource="#application.dsn#" procedure="Order_EditLift">
                <cfprocparam dbVarName="@id" value="#arguments.id#" cfsqltype="CF_SQL_INTEGER" />
                <cfprocparam dbVarName="@orderid" value="#arguments.orderid#" cfsqltype="CF_SQL_INTEGER" />
                <cfprocparam dbVarName="@quantity" value="#arguments.quantity#" cfsqltype="CF_SQL_INTEGER" />
                <cfprocparam dbVarName="@estimatedcost" value="#arguments.estimatedcost#" cfsqltype="CF_SQL_MONEY" null="#yesNoFormat(NOT len(trim(arguments.estimatedcost)))#" />
                <cfprocparam dbVarName="@notes" value="#arguments.notes#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(trim(arguments.notes)))#" />
                <cfprocparam dbVarName="@confirmationnumber" value="#arguments.confirmationnumber#" cfsqltype="CF_SQL_VARCHAR" />
                <cfprocparam dbVarName="@releasenumber" value="#arguments.releasenumber#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(trim(arguments.releasenumber)))#"/>
                <cfprocparam dbVarName="@updatedby" value="#client.username#" cfsqltype="CF_SQL_VARCHAR" />
                <cfprocparam dbVarName="@closeout" value="#arguments.closeout#" cfsqltype="CF_SQL_INTEGER" />
                <cfprocparam dbVarName="@releasedate" value="#arguments.releasedate#" cfsqltype="CF_SQL_DATE" null="#yesNoFormat(NOT len(trim(arguments.releasedate)))#"  />
                <cfprocparam dbVarName="@liftcompany" value="#arguments.liftcompany#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(trim(arguments.liftcompany)))#"/>
                <cfprocparam dbVarName="@liftvendorid" value="#arguments.liftvendorid#" cfsqltype="CF_SQL_INTEGER" />
                <cfprocparam dbVarName="@isFieldTech" value="#arguments.isFieldTech#" cfsqltype="CF_SQL_BIT" />
                <cfprocparam dbVarName="@enddate" value="#arguments.enddate#" cfsqltype="CF_SQL_DATE" null="#yesNoFormat(NOT len(trim(arguments.enddate)))#"/>
                <cfprocparam dbVarName="@releasewith" value="#arguments.releasewith#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(trim(arguments.releasewith)))#"/>
                <cfprocparam dbVarName="@finalinvoiceamount" value="#arguments.finalinvoiceamount#" cfsqltype="CF_SQL_MONEY" null="#yesNoFormat(NOT len(trim(arguments.finalinvoiceamount)))#" />
                <cfprocparam dbVarName="@ProgressBilling" value="#arguments.ProgressBilling#" cfsqltype="CF_SQL_INTEGER" />
                <cfprocparam dbVarName="@invoicenumber" value="#arguments.invoicenumber#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(trim(arguments.invoicenumber)))#"/>
                <cfprocparam dbVarName="@equipmenttype" value="#arguments.equipmenttype#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(trim(arguments.equipmenttype)))#"/>
                <cfprocparam dbVarName="@deliverydate" value="#arguments.deliverydate#" cfsqltype="CF_SQL_DATE" null="#yesNoFormat(NOT len(trim(arguments.deliverydate)))#"/>
            </cfstoredproc> --->

            <cfcatch>
                <cfinvoke method="onError" component="application" exception="#cfcatch#">
                <cfset output.error = true />
                <cfset output.message = cfcatch.message & "\n" & cfcatch.detail />
            </cfcatch>
        </cftry>

        <cfreturn output />
    </cffunction>
</cfcomponent>