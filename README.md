# JIRA-Salesforce-Integration

This piece of code will help you to get JIRA record from Salesforce.

In this below code block, we have used the Visualforce page to perform this task, using the Visualforce page button we are passing two parameters(CaseId, JIRA record reference Id) to apex Handler, which will do a callout operation to JIRA Server and fetches the related record, then it creates a new record in the Salesforce JIRA issue object related to the case object.  

Before Implementing this Integration we have to complete these below steps.
```
Step 1: Create Remote site setting.
        
        Remote Site Name: You can give any name to it        
        Remote Site URL: Your JIRA instance URL
```
```
Step 2: Create Detail Page Button on Case Object. 

        Label            Name            Content Source	        Content                                     
        Sync JIRA        Sync_JIRA       Visualforce Page       JIRAIntegration         
```  
```
Step 3: Create one Field on Case Object. 

        Field                         API Name                                  Type                      
        Jira ref Id                   Jira_ref_Id__c                            Text(255)
```      
```        
Step 4: Create JIRA Issue Object and Fields.
        
        Object                        API Name
        JIRA Issue                    JIRA_Issue__c 
        
        Field                         API Name                                  Type 
        Case                          Case__c                                   Master-Detail(Case)
        JIRA Issue Name               JIRA_Issue_Name__c                        Text(255) (External ID)    
        JIRA Issue Summary            JIRA_Issue_Name__c                        Long Text Area(131072)
        JIRA Status                   JIRA_Issue_Name__c                        Text(255)
 ```        
For more information or question, you can reach out me, through my email address.

Email:- sumitchoubey247@gmail.com
