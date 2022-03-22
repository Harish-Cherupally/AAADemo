/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/29/2021
* @Description   : This apex class is calling from process builder i.e. Update Actual duration. 
*				   This is used to aggregate all the values from service appointment actual duration value.
* 				   This class calls A3SH_UpdateActualDurationOnOppty class to update the actual duration on Opportunity
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
public class A3SH_UpdateActualDurationFromSA {
	private static final string NEW_INSTALLATION = 'New Installation';
    private static final string COMPLETED = 'Completed';
    /**********************************************************************************************************
     * @Description : This method is calling from  Update Actual duration. This is used to aggregate all the values
     * 				  from service appointment actual duration value. Update the value on Opportunity "Actual_Duration__c" field.
     * @Parameters  : List<String> saIds
     * @Return Type : 
     * ********************************************************************************************************/
    @InvocableMethod
    public static void updatActualDurationOnOpptyFromSA(List<String> saIds){
        List<ServiceAppointment> serviceAppointmentList = [Select Id,Opportunity__c from ServiceAppointment Where Service_Type__c=:NEW_INSTALLATION AND 
                                                           Opportunity__c != null AND ID IN :saIds AND Status= :COMPLETED];
        List<Id> opportunityIds = new List<Id>();
        if(serviceAppointmentList != null && !serviceAppointmentList.isEmpty()){
            for(ServiceAppointment saObj : serviceAppointmentList){
                opportunityIds.add(saObj.Opportunity__c);
            }
            
            if(!opportunityIds.isEmpty()){
                A3SH_UpdateActualDurationOnOppty.updatActualDurationOnOppty(opportunityIds);
            }
        }
    }
}