/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/29/2021
* @Description   : This apex class is calling from different process builders. WO_UpdateActualDurationOnOpportunity and 
*				   Update Actual duration. This is used to aggregate all the values from service appointment actual duration value.
* 				   Update the value on Opportunity "Actual_Duration__c" field.
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
public class A3SH_UpdateActualDurationOnOppty {
    private static final string NEW_INSTALLATION = 'New Installation';
    private static final string COMPLETED = 'Completed';
    /**********************************************************************************************************
     * @Description : This method is calling from  WO_UpdateActualDurationOnOpportunity and 
     *				  Update Actual duration. This is used to aggregate all the values from service appointment 
	 *                actual duration value. Update the value on Opportunity "Actual_Duration__c" field.
     * @Parameters  : List<String> oppIds
     * @Return Type : 
     * ********************************************************************************************************/
    @InvocableMethod
    public static void updatActualDurationOnOppty(List<String> oppIds){
        Map<Id,Decimal> actualDurationMap = new Map<Id,Decimal>();
        List<Opportunity> updateOpportunityList = new List<Opportunity>();
        for(WorkOrder woObj : [SELECT Id,Opportunity__c,(Select Id,ActualDuration FROM ServiceAppointments WHERE Service_Type__c=:NEW_INSTALLATION AND 
                                                        Status = :COMPLETED) 
                               FROM WorkOrder WHERE Service_Type__c = :NEW_INSTALLATION AND Opportunity__c IN :oppIds])
        {
            Decimal actutalDurationForOppty = 0.00;
            if(woObj.ServiceAppointments != null && !woObj.ServiceAppointments.isEmpty()){
                for(ServiceAppointment saObj : woObj.ServiceAppointments){
                    if(saObj.ActualDuration != null){
                        actutalDurationForOppty+=saObj.ActualDuration;
                    }
                }
            }
            if(actualDurationMap.containsKey(woObj.Opportunity__c)){
                actualDurationMap.put(woObj.Opportunity__c,actualDurationMap.get(woObj.Opportunity__c) + actutalDurationForOppty);
            }else{
                actualDurationMap.put(woObj.Opportunity__c,actutalDurationForOppty);
            }
        }
        for(Id oppId : actualDurationMap.keySet()){
            Opportunity updateObj = new Opportunity(Id=oppId,Actual_Duration__c=actualDurationMap.get(oppId) != null ? actualDurationMap.get(oppId).setScale(2):null);
            updateOpportunityList.add(updateObj);
        }
        if(!updateOpportunityList.isEmpty()){
            Database.update(updateOpportunityList);
        }
    }
}