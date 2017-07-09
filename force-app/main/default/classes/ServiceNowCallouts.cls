public class ServiceNowCallouts {

    @InvocableMethod(label='Create ServiceNow Ticket' description='Create a ticket passing the description')
    public static void createTicket(List<Id> caseIds) {
        
        List<Case> cases=[SELECT Id,Description FROM Case WHERE id IN :caseIds];
        
        for (Case thecase : cases) {
            calloutMethod(thecase.Description);
        }
    }
    
    @Future(callout=true)
    public static void calloutMethod(String description){
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
            System.debug(response.getBody());
        }
    }

}