# Salesforce and ServiceNow Integration

This SFDX App gather sample assets to integrate Salesforce and ServiceNow.
Each time a case is created in Salesforce, an incident is created in ServiceNow
Only the Case Description is set on the ServiceNow Short Description
The Incident Number and the Service Now Sys Id is set on the Salesforce case as an external Id
This external Id is used as a direct link to the incident from the case layout

## Dev, Build and Test
- Get a SFDX Dev Hub accounts to be able to create scratch orgs
- Ensure that you have SFDX CLI installed
- then Open a Terminal Window and :
```
git clone https://github.com/stevecorbelsfdc/servicenow-integration.git
cd servicenow-integration/
sfdx force:auth:web:login -d -a DevHub
sfdx force:org:create -f config/project-scratch-def.json -a servicenow --setdefaultusername
sfdx force:source:push
sfdx force:org:open
````

- Create a case and enjoy !

## Resources


## Description of Files and Directories


## Issues
The ServiceNow credentials are hard coded right now
for my ServiceNow dev instance 
get a ServiceNow account if you want to change it

This project is not yet packaged, it is used mainly to show rapidely the technical integration with ServiceNow 

Any issues contact me directly scorbel@salesforce.com (Steve Corbel)
