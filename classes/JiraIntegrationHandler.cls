/******************************
 * @File Name          : JiraIntegrationHandler.cls
 * @Author             : Sumit Choubey
 * @Visualforce Page   : JIRAIntegration.vf
 * @Testclass          : 
 * @Last Modified By   : 
 * @Last Modified On   : 
 * @Modification Log   : 
 * @Description        : 
 * Ver       Date                Author     	    Modification
 * 1.0       Feb-03-2020                            Initial Version
**/

public with sharing class JiraIntegrationHandler {
  
  /**
   * @JSON FIELD INITIALIZERS
   **/
  public String expand;
  public List<Issues> issues;
    
  public class Fields {
    public String created;
    public String key;
    public String summary;
    public Status status;
    public Priority priority;
    public cls_resolution resolution;
    public cls_assignee assignee;
  }
  public class Issues {
    public String expand;
    public String id;
    public String self;
    public String key;
    public Fields fields;
  }
  public class Priority {
    public String self;
    public String iconUrl;
    public String name;
    public String id;
  }
  public class Status {
    public String self;
    public String description;
    public String iconUrl;
    public String name;
    public String id;
  }
  class cls_resolution {
  }
  class cls_assignee {
    public String self; 
    public String name; 
    public String key;  
    public String accountId;    
    public String displayName;  
    public boolean active;
    public String timeZone; 
    public String accountType;  
  }
  
  /** 
   * @THE CONSTRUCTOR OF THE CLASS 
   **/
  public JiraIntegrationHandler(ApexPages.StandardController controller) {
 
  }
   
  public static PageReference getJIRARecord() {
    
    Integer startAt = 0;
    Integer maxResults= 10;
   
    /** @SALESFORCE THIS CASE ID **/
    String caseId = ApexPages.CurrentPage().getParameters().get('caseId');
    
    /**  @THIS IS AN REFERENCE ID FOR JIRA RECORD **/
    String jiraRefId = ApexPages.CurrentPage().getParameters().get('jiraRefId');

    List<JIRA_Issue__c> supportIssueList = new List<JIRA_Issue__c>();

    /** @JIRA END POINT URL @YOU MAY USE NAMED CREDENTIALS HERE **/
    string jira_host = 'https://YourJIRAInstanceURL.atlassian.net/rest/api/2/search?jql=';
    
    /** @METADATA RECORD FOR USERNAME AND PASSWORD  
        @NOTE:- FOR THE PASSWORD, PLEASE USE API TOKEN
    **/
    String JIRA_CN = 'MDT NAME';
    JIRA_Credentials__mdt JIRA_mdt = [SELECT Id, 
                                            MasterLabel, 
                                            Username__c, 
                                            Password__c 
                                      FROM JIRA_Credentials__mdt 
                                      WHERE DeveloperName =: JIRA_CN LIMIT 1];
    
    string username = JIRA_mdt.Username__c;
    string password = JIRA_mdt.Password__c;   
    
    string fieldsQuery = 'key,'+
                         'created,'+
                         'resolution'+    
                         'assignee,'+
                         'project,'+
                         'summary,'+
                         'updated,'+
                         'priority,'+
                         'status';
      
    String auth_header = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
    string url = jira_host  + 
                            '\"USM%20CR%20or%20FT%20Tkt\"~' + jiraRefId +
                            '&fields=' + fieldsQuery + 
                            '&startAt='+ startAt +
                            '&maxResults='+maxResults;
    
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Accept','application/json');
    req.setHeader('Authorization', auth_header);
    req.setHeader('X-Atlassian-Token', 'nocheck');
    req.setMethod('GET');
    req.setEndpoint(url);
    HttpResponse res = http.send(req);
    
    String JSONContent = res.getBody();
    JSONParser parserJira = JSON.createParser(JSONContent);
    while (parserJira.nextToken() != null) {
      if (parserJira.getCurrentToken() == JSONToken.START_ARRAY) {
        while (parserJira.nextToken() != null) {
          if ((parserJira .getCurrentToken() == JSONToken.START_OBJECT)) {
            Issues jiraIssue = (Issues)parserJira.readValueAs(Issues.class);
            JIRA_Issue__c supportIssue = new JIRA_Issue__c();
            supportIssue.Case__c = caseId;
            supportIssue.JIRA_Issue_Name__c = jiraIssue.key;
            supportIssue.JIRA_Issue_Summary__c = jiraIssue.fields.summary;
            supportIssue.JIRA_Status__c = jiraIssue.fields.status.name;
            supportIssueList.add(supportIssue);
          }
        }
      }
    } 
    Upsert supportIssueList JIRA_Issue_Name__c; 
    return new PageReference('/'+caseId);
  }       
}
