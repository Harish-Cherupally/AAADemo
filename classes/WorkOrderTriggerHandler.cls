/*******
* Created By : CR Team
* Cerated Date : 11th march 2022
* Description :When SA is In Progress then Assigned Dealer should not be changed.
* JIRA Story : A3SHCRSF3-88
* Modified History:
* 
* *******/

public class WorkOrderTriggerHandler {
/*JIRA Num: A3SHCRSF3-88
* Method Name: restrictChangeAssignedDealer
* @param: trigger.newMap, trigger.oldMap
* @return: Void
* Description: When SA is In Progress then Assigned Dealer should not be changed
* Modification History: 
*/
    public static void restrictChangeAssignedDealer(Map<Id,WorkOrder> wosNew, Map<Id,WorkOrder> wosOld){
        String saStatus; 
        String errorMessage = 'Assigned Dealer cannot be changed if SA is ';
        List<WorkOrder> woList = [SELECT Id, Assigned_Dealer__c,(SELECT Id, Status, Service_Type__c FROM ServiceAppointments) FROM WorkOrder WHERE Id =:wosOld.keyset()];
        if(woList != null && woList.size() > 0){
            for(WorkOrder wo : woList){                
                if(wo.Assigned_Dealer__c != wosNew.get(wo.Id).Assigned_Dealer__c){                 
                    if(wo.ServiceAppointments != null && wo.ServiceAppointments.size() > 0 ){
                        for(ServiceAppointment sa : wo.ServiceAppointments){
                            if((sa.Service_Type__c == 'New Installation' || sa.Service_Type__c == 'Service Appointment') && (sa.Status == 'In Progress' || sa.Status == 'Completed' || sa.Status == 'Departed' || sa.Status == 'Archive - Closed' || sa.Status == 'Cannot Complete - Resolved' || sa.Status == 'Closed - Call Back')){
                                errorMessage += sa.Status;
                                wosNew.get(wo.Id).addError(errorMessage);  
                            }
                        }
                    }
                }
            }
        }
    }
}