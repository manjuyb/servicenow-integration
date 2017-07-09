public class ServiceNowCallouts {

    @InvocableMethod(label='Create ServiceNow Ticket' description='Create a ticket passing the description')
    public static void createTicket(List<Id> caseIds) {
        
        List<Case> cases=[SELECT Id,Description FROM Case WHERE id IN :caseIds];
        
        for (Case thecase : cases) {
            calloutMethod(thecase.Description,thecase.Id);
        }
    }
    
    @Future(callout=true)
    public static void calloutMethod(String description, String id){
        String incidentNumber='';
        String incidentSysId='';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://dev19041.service-now.com/api/now/table/incident');
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic YWRtaW46UGFibG8yMTA3');
        // Set the body as a JSON object
        request.setBody('{"short_description":"'+description+'","priority":"1","due_date":"2017-07-31 00:00"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
        } else {
            //System.debug(response.getBody());
            JSONParser parser = JSON.createParser(response.getBody());
            boolean numberfound = false;
            boolean sysidfound = false;
            boolean found = false;
            //while ((parser.nextToken() != null) && (!numberfound) && (!sysidfound)) {
            while ((parser.nextToken() != null) && (!found)) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    if (parser.getText() == 'number') {
                        // Get the value.
                	    parser.nextToken();
                	    System.debug('The Incident Number is : '+parser.getText());
                        incidentNumber = parser.getText();
                        numberfound = true;
                    } else if (parser.getText() == 'sys_id') {
                        // Get the value.
                	    parser.nextToken();
                	    // Compute the grand total price for all invoices.
                	    System.debug('The Incident Sys Id is : '+parser.getText());
                        incidentSysId = parser.getText();
                        sysidfound = true;
                    }    
                }
                // I have found the two JSON elements I am looking 
                // Will set found to true to exit loop
                if ((numberfound) && (sysidfound)) {
                    found = true;
                }
			} // end while
            //will update the external id of the Salesforce case
            Case caseToUpdate;
            try {
                 // Update case.
                caseToUpdate = [SELECT Service_Now_Incident_Number__c,Service_Now_Sys_Id__c FROM Case WHERE Id=:id LIMIT 1];
                // Update the Service_Now_Incident_Number__c.
                caseToUpdate.Service_Now_Incident_Number__c = incidentNumber;
                caseToUpdate.Service_Now_Sys_Id__c = incidentSysId;
                // Make the update call.
                update caseToUpdate;
            } catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            } 
        }
    }
/**
{
    "result": {
        "parent": "",
        "made_sla": "true",
        "caused_by": "",
        "watch_list": "",
        "upon_reject": "cancel",
        "sys_updated_on": "2017-07-09 15:47:57",
        "child_incidents": "0",
        "approval_history": "",
        "number": "INC0010017",
        "resolved_by": "",
        "sys_updated_by": "admin",
        "opened_by": {
            "link": "https://dev19041.service-now.com/api/now/table/sys_user/6816f79cc0a8016401c5a33be04be441",
            "value": "6816f79cc0a8016401c5a33be04be441"
        },
        "user_input": "",
        "sys_created_on": "2017-07-09 15:47:57",
        "sys_domain": {
            "link": "https://dev19041.service-now.com/api/now/table/sys_user_group/global",
            "value": "global"
        },
        "state": "1",
        "sys_created_by": "admin",
        "knowledge": "false",
        "order": "",
        "calendar_stc": "",
        "closed_at": "",
        "cmdb_ci": "",
        "delivery_plan": "",
        "impact": "3",
        "active": "true",
        "work_notes_list": "",
        "business_service": "",
        "priority": "5",
        "sys_domain_path": "/",
        "rfc": "",
        "time_worked": "",
        "expected_start": "",
        "rejection_goto": "",
        "opened_at": "2017-07-09 15:47:57",
        "business_duration": "",
        "group_list": "",
        "work_end": "",
        "caller_id": "",
        "resolved_at": "",
        "approval_set": "",
        "subcategory": "",
        "wf_activity": "",
        "work_notes": "",
        "short_description": "Test Integration New",
        "close_code": "",
        "correlation_display": "",
        "delivery_task": "",
        "work_start": "",
        "assignment_group": "",
        "additional_assignee_list": "",
        "business_stc": "",
        "description": "",
        "calendar_duration": "",
        "close_notes": "",
        "notify": "1",
        "sys_class_name": "incident",
        "closed_by": "",
        "follow_up": "",
        "parent_incident": "",
        "sys_id": "bc6ac522db333200223efcdfbf9619ca",
        "contact_type": "phone",
        "incident_state": "1",
        "urgency": "3",
        "problem_id": "",
        "company": "",
        "reassignment_count": "0",
        "activity_due": "",
        "assigned_to": "",
        "severity": "3",
        "comments": "",
        "approval": "not requested",
        "sla_due": "",
        "comments_and_work_notes": "",
        "due_date": "2017-07-31 00:00:00",
        "sys_mod_count": "0",
        "reopen_count": "0",
        "sys_tags": "",
        "escalation": "0",
        "upon_approval": "proceed",
        "correlation_id": "",
        "location": "",
        "category": "inquiry"
    }
}
**/
}