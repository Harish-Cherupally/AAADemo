/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/25/2021
* @Description   : This apex on task is used to call the Future method on A3SH_SendSMSUsingTwilioAPI to send SMS whenever
*                  a reminder/confirmation/booking email has been sent to customer for a service appointment.
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
trigger SendSMSTrigger on Task (after insert) {
    Task taskObj = Trigger.New[0];
    if(taskObj.whatId != null && String.valueOf(taskObj.whatId).startsWith('08p')){
        A3SH_SendSMSUsingTwilioAPI.sendSMS(taskObj.Id);
    }
}