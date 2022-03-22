/**
 * @author Tushar Kumawat [CriticalRiver]
 * @date 4 March 2022
 * @description Service/Helper to search related records to parent account's Site records 
 * @version 1.0
 */
public with sharing class SiteSearchService {
    // Static variable to configure Objects to Display on UI
    public static Map<String, RelatedItem> MAP_OBJECT_CONFIG = new Map<String, RelatedItem> {
        'Account' => new RelatedItem('Site Accounts', 'Account', 'ParentId', new List<Column> {
            new Column('Account Name', 'Name'),
            new Column('Account Number', 'AccountNumber')
        }),
        'Contacts' => new RelatedItem('Contacts', 'Contacts', 'AccountId', new List<Column> {
            new Column('First Name', 'FirstName'),
            new Column('Last Name', 'LastName'),
            new Column('Email', 'Email')
        }),
        'Cases' => new RelatedItem('Cases', 'Cases', 'AccountId', new List<Column> {
            new Column('Case Number', 'CaseNumber'),
            new Column('Subject', 'Subject'),
            new Column('Status', 'Status'),
            new Column('Created Date', 'CreatedDate')

        }),
        'Opportunities' => new RelatedItem('Opportunities', 'Opportunities', 'AccountId', new List<Column> {
            new Column('Opportunity Name', 'Name'),
            new Column('Account', 'Account.Name'),
            new Column('Stage Name', 'StageName'),
            new Column('Amount', 'Amount'),
            new Column('Installation Type', 'Installation_Type__c'),
            new Column('Close Date', 'CloseDate')
        }),
        'WorkOrders' => new RelatedItem('Work Orders', 'WorkOrders', 'AccountId', new List<Column> {
            new Column('Work Order Number', 'WorkOrderNumber'),
            new Column('Status', 'Status'),
            new Column('Email', 'Email__c'),
            new Column('Created Date', 'CreatedDate'),
            new Column('Last Modified Date', 'LastModifiedDate')
        }),
        'ServiceAppointments' => new RelatedItem('Service Appointments', 'ServiceAppointments', 'AccountId', new List<Column> {
            new Column('Appointment Number', 'AppointmentNumber'),
            new Column('Status', 'Status'),
            new Column('Created Date', 'CreatedDate'),
            new Column('Last Modified Date', 'LastModifiedDate')
        })
    };

    /**
     * @description Search Site account and related records based on input fields
     * @version 1.0
     * @params 1. strObjectName : Object Name
     *         2. strSiteFieldName : Site Account Lookup Field Name
     *         3. strRecordId : Current Record Id
     */
    public static RelatedRecords getReatedRecords(String strObjectName, String strSiteFieldName, String strRecordId) {
        RelatedRecords response = new RelatedRecords();
        List<Id> listSiteAccountIds = getSiteAccountIds(strObjectName, strSiteFieldName, strRecordId);

        response.listRelatedItems = parseQueryResponse(
            Database.query(generateQuery(listSiteAccountIds))
        );
        
        return response;
    }

    /**
     * @description parse SOQL query response and mat to List<RelatedItem> Data Type
     */
    public static List<RelatedItem> parseQueryResponse(List<SObject> listSObjects) {
        List<RelatedItem> parsedList = new List<RelatedItem>();
        Boolean isPrimary = true;
        // String strPrimaryObject;
        // Set<String> setRelationNames = new Set<String>();

        for(String strObject : MAP_OBJECT_CONFIG.keySet()) {
            if(isPrimary) {
                MAP_OBJECT_CONFIG.get(strObject).listData = listSObjects;
                parsedList.add(MAP_OBJECT_CONFIG.get(strObject));
                // strPrimaryObject = strObject;
                isPrimary = false;
            }
            else {
                for(SObject currSObject : listSObjects) {
                    if(currSObject.getSObjects(MAP_OBJECT_CONFIG.get(strObject).strRelationName) != NULL) {
                        MAP_OBJECT_CONFIG.get(strObject).listData.addAll(currSObject.getSObjects(MAP_OBJECT_CONFIG.get(strObject).strRelationName));
                    }
                }

                parsedList.add(MAP_OBJECT_CONFIG.get(strObject));
                // setRelationNames.add(MAP_OBJECT_CONFIG.get(strObject).strRelationName);
            }
        }

        /* for(SObject currSObject : MAP_OBJECT_CONFIG.get(strPrimaryObject).listData) {
            for(String strRelationName : setRelationNames) {
                currSObject.put(strRelationName, new List<SObject>());
            }
        } */
        
        return parsedList;
    }

    /**
     * @description Generate Query based on MAP_OBJECT_CONFIG
     */
    public static String generateQuery(List<Id> listSiteAccountIds) {
        String strQuery = 'SELECT Id, ';
        String strPrimaryObject;
        Boolean isPrimary = true;

        for(String strObject : MAP_OBJECT_CONFIG.keySet()) {
            if(isPrimary) {
                for(Column currColumn : MAP_OBJECT_CONFIG.get(strObject).listColumns) {
                    strQuery = strQuery + currColumn.fieldName + ', ';
                }

                strQuery = strQuery.removeEnd(', ');
                strPrimaryObject = MAP_OBJECT_CONFIG.get(strObject).strRelationName;
                isPrimary = false;
            }
            else {
                strQuery += ', (SELECT Id, ' + MAP_OBJECT_CONFIG.get(strObject).strDefaultFieldName + ', ';

                for(Column currColumn : MAP_OBJECT_CONFIG.get(strObject).listColumns) {
                    strQuery = strQuery + currColumn.fieldName + ', ';
                }

                strQuery = strQuery.removeEnd(', ');
                strQuery = strQuery + ' FROM ' + MAP_OBJECT_CONFIG.get(strObject).strRelationName + ')';
            }
        }

        strQuery = strQuery + ' FROM ' + strPrimaryObject + ' WHERE Id IN : listSiteAccountIds';

        return strQuery;
    }

    /**
     * @description Search for site accounts and return List of Site Accounts
     * @params 1. strObjectName : Object Name
     *         2. strSiteFieldName : Site Account Lookup Field Name
     *         3. strRecordId : Current Record Id
     */
    public static List<Id> getSiteAccountIds(String strObjectName, String strSiteFieldName, String strRecordId) {
        List<Id> listSiteAccountIds = new List<Id>();
        String strSiteRecordTypeId = getRecordTypeId(Account.getSObjectType(), 'SiteAccount');
        //String.escapeSingleQuotes(strQuery);
          
        if(strObjectName == 'Case'){
            String strQuery = 'SELECT Id FROM Account WHERE RecordTypeId =: strSiteRecordTypeId AND ParentId IN ' 
                        + '(SELECT ' + strSiteFieldName + ' FROM ' + strObjectName + ' WHERE Id =: strRecordId)';
            
            for(SObject currSObject : Database.query(strQuery)) {
                listSiteAccountIds.add(currSObject.Id);
            }            
        }
        else{
            listSiteAccountIds.add(strRecordId);
        }    
        
        return listSiteAccountIds;
    }

    /**
     * @description Return Record Type Id
     * @params 1. sObjectType : sObjectType Describe Result
     *         2. strRecordTypeName : Record Type Name
     */
    public static String getRecordTypeId(SObjectType sObjectType, String strRecordTypeName) {
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();
        return recordTypeInfo.containsKey(strRecordTypeName) ? recordTypeInfo.get(strRecordTypeName).getRecordTypeId() : null;
    }

    /**
     * @description Base response class
     */
    public virtual class BaseResponse {
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String strMessage;
    }

    /**
     * @description Default response on component load
     */
    public class RelatedRecords extends BaseResponse {
        @AuraEnabled public List<RelatedItem> listRelatedItems;
    }

    /**
     * @description Related item single record
     */
    public class RelatedItem {
        @AuraEnabled public String strTableName;
        @AuraEnabled public List<Column> listColumns;
        @AuraEnabled public List<SObject> listData;
        public String strRelationName;
        public String strDefaultFieldName;

        public RelatedItem(String strTableName, String strRelationName, String strDefaultFieldName, List<Column> listColumns) {
            this.strTableName = strTableName;
            this.strRelationName = strRelationName;
            this.strDefaultFieldName = strDefaultFieldName;
            this.listColumns = listColumns;
            this.listData = new List<SObject>();
        }
    }

    /**
     * @description Column definition
     */
    public class Column {
        @AuraEnabled public String label;
        @AuraEnabled public String fieldName;

        public Column(String label, String fieldName) {
            this.label = label;
            this.fieldName = fieldName;
        }
    }
}