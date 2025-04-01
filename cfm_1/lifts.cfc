<cfcomponent displayname="Lifts" output="false" hint="Handles all lift-related operations">
    
    <!--- Initialize component --->
    <cfset this.version = "1.0.0">
    
    <!--- Constructor --->
    <cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
        <cfreturn this>
    </cffunction>

    <!--- Get lift information --->
    <cffunction name="getLiftInfo" output="false" access="remote" returntype="struct" hint="Retrieves lift information by ID">
        <cfargument name="liftid" type="numeric" required="true" hint="The ID of the lift to retrieve">
        
        <cfset var result = {
            success = false,
            message = "",
            data = {}
        }>
        
        <cftry>
            <!--- Validate input --->
            <cfif arguments.liftid LTE 0>
                <cfthrow type="InvalidArgument" message="Invalid lift ID provided">
            </cfif>
            
            <!--- Simulated query data --->
            <cfset var qLifts = queryNew(
                "createdby, created, estimatedcost, qty, confirmationnumber, closedby, equipmenttype,
                releasenumber, updatedby, updated, notes, id, closedate, releasedate, liftcompany, enddate,
                releasewith, finalinvoiceamount, invoicenumber, deliverydate, ServerFileName, LiftFileID,
                ARCompleted, APCreated, OrderID, CustomerID, CustomerSiteID, LiftVendorID, isFieldTech",
                "varchar, timestamp, decimal, integer, varchar, varchar, varchar,
                varchar, varchar, timestamp, varchar, integer, timestamp, timestamp, varchar, timestamp,
                varchar, decimal, varchar, timestamp, varchar, integer, integer, integer, integer, integer, integer, integer, integer"
            )>

            <!--- Insert test data --->
            <cfset queryAddRow(qLifts, 1)>
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
            <cfset querySetCell(qLifts, "id", arguments.liftid, 1)>
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
            <cfset querySetCell(qLifts, "OrderID", 786981, 1)>
            <cfset querySetCell(qLifts, "CustomerID", 12345, 1)>
            <cfset querySetCell(qLifts, "CustomerSiteID", 67890, 1)>
            <cfset querySetCell(qLifts, "LiftVendorID", 1, 1)>
            <cfset querySetCell(qLifts, "isFieldTech", 0, 1)>

            <cfset result.success = true>
            <cfset result.data = queryToArray(qLifts)[1]>
            
            <cfcatch type="any">
                <cfset result.success = false>
                <cfset result.message = "Error retrieving lift information: #cfcatch.message#">
                <!--- Log the error --->
                <cflog file="lifts" type="error" text="Error in getLiftInfo: #cfcatch.message# #cfcatch.detail#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <!--- Edit lift --->
    <cffunction name="editLift" output="false" access="remote" returntype="struct" hint="Updates lift information">
        <cfargument name="id" type="numeric" required="true" hint="The ID of the lift to update">
        <cfargument name="lift_company" type="string" required="true" hint="The lift company name">
        <cfargument name="equipment_type" type="string" required="true" hint="The type of equipment">
        <cfargument name="delivery_date" type="date" required="true" hint="The delivery date">
        <cfargument name="estimated_cost" type="numeric" required="true" hint="The estimated cost">
        <cfargument name="quantity" type="numeric" required="true" hint="The quantity">
        <cfargument name="notes" type="string" default="" hint="Additional notes">
        
        <cfset var result = {
            success = false,
            message = ""
        }>
        
        <cftry>
            <!--- Validate inputs --->
            <cfif arguments.id LTE 0>
                <cfthrow type="InvalidArgument" message="Invalid lift ID provided">
            </cfif>
            
            <cfif arguments.estimated_cost LT 0>
                <cfthrow type="InvalidArgument" message="Estimated cost cannot be negative">
            </cfif>
            
            <cfif arguments.quantity LT 1>
                <cfthrow type="InvalidArgument" message="Quantity must be at least 1">
            </cfif>
            
            <!--- In a real application, this would update the database --->
            <cfset result.success = true>
            <cfset result.message = "Lift updated successfully">
            
            <cfcatch type="any">
                <cfset result.success = false>
                <cfset result.message = "Error updating lift: #cfcatch.message#">
                <!--- Log the error --->
                <cflog file="lifts" type="error" text="Error in editLift: #cfcatch.message# #cfcatch.detail#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <!--- Delete lift --->
    <cffunction name="deleteLift" output="false" access="remote" returntype="struct" hint="Deletes a lift">
        <cfargument name="liftid" type="numeric" required="true" hint="The ID of the lift to delete">
        
        <cfset var result = {
            success = false,
            message = ""
        }>
        
        <cftry>
            <!--- Validate input --->
            <cfif arguments.liftid LTE 0>
                <cfthrow type="InvalidArgument" message="Invalid lift ID provided">
            </cfif>
            
            <!--- In a real application, this would delete from the database --->
            <cfset result.success = true>
            <cfset result.message = "Lift deleted successfully">
            
            <cfcatch type="any">
                <cfset result.success = false>
                <cfset result.message = "Error deleting lift: #cfcatch.message#">
                <!--- Log the error --->
                <cflog file="lifts" type="error" text="Error in deleteLift: #cfcatch.message# #cfcatch.detail#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <!--- Helper function to convert query to array --->
    <cffunction name="queryToArray" output="false" access="private" returntype="array" hint="Converts a query to an array of structs">
        <cfargument name="q" type="query" required="true" hint="The query to convert">
        
        <cfset var result = []>
        <cfset var columns = listToArray(q.columnList)>
        
        <cfloop from="1" to="#q.recordCount#" index="i">
            <cfset var row = {}>
            <cfloop array="#columns#" index="col">
                <cfset row[col] = q[col][i]>
            </cfloop>
            <cfset arrayAppend(result, row)>
        </cfloop>
        
        <cfreturn result>
    </cffunction>
</cfcomponent>