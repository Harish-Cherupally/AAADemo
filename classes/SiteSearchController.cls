/**
 * @author Tushar Kumawat [CriticalRiver]
 * @date 4 March 2022
 * @description Controller to search related records to parent account's Site records 
 * @version 1.0
 */
public with sharing class SiteSearchController {
    /**
     * @description Search Site account and related records based on input fields
     * @version 1.0
     * @params 1. strObjectName : Object Name
     *         2. strSiteFieldName : Site Account Lookup Field Name
     *         3. strRecordId : Current Record Id
     */
    @AuraEnabled
    public static SiteSearchService.RelatedRecords getReatedRecords(String strObjectName, String strSiteFieldName, String strRecordId) {
        SiteSearchService.RelatedRecords response = new SiteSearchService.RelatedRecords();

        try {
            response = SiteSearchService.getReatedRecords(strObjectName, strSiteFieldName, strRecordId);
            response.isSuccess = true;
        }
        catch(Exception ex) {
            response.isSuccess = false;
            response.strMessage = ex.getMessage();
        }

        return response;
    }
}