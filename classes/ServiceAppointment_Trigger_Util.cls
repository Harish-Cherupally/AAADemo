public class ServiceAppointment_Trigger_Util {
    
    public static String className = 'ServiceAppointment_Trigger_Util';
    public static String methodName;
    public static Map<Id,Service_Appointment_Snapshot__c> createdSAIdSnapshots = new Map<Id,Service_Appointment_Snapshot__c>();
    public static Map<String,String> saToSnapFieldMapngs {get {
        if(saToSnapFieldMapngs == null){
            Map<String,String> fieldMap = new Map<String,String>();        
            //A3SHCRSF3-199: Retrieving Field Mapping from ServiceAppointment To SA Snapshot metadata
            for(Service_Appointment_To_SA_Snapshot_Map__mdt tempMap : [SELECT SA_Field_API_Name__c,SA_Snapshot_Field_API_Name__c
                                                                       FROM Service_Appointment_To_SA_Snapshot_Map__mdt]){
                fieldMap.put(tempMap.SA_Field_API_Name__c,tempMap.SA_Snapshot_Field_API_Name__c);
            }
            saToSnapFieldMapngs = fieldMap;
        }
        return saToSnapFieldMapngs;
    } set;}
     
    /* A3SHCRSF3-2
     * Method Name:  createSASnapshots
     * Params: newSAs : New Service Appointments
     *         oldSAMap: Old Service Appointments
     * Description: Create SA Snapshots for SA field changes (Status, SchedStartTime, SchedEndTime, Self Scheduled)
     */
    public static void createSASnapshots(List<ServiceAppointment> newSAs, Map<Id,ServiceAppointment> oldSAMap){
        methodName = 'createSASnapshots';
        try{
            List<ServiceAppointment> updatedSAs = new List<ServiceAppointment>();
            List<Service_Appointment_Snapshot__c> newSASnapshots = new List<Service_Appointment_Snapshot__c>();
            
            //Consider All SA's created or updated and skip if the user is not guest user and Original Schedule Time changed
            for(ServiceAppointment tempSA :newSAs){
                if(oldSAMap == null                                                               //Creation
                  || (oldSAMap != null && oldSAMap.containskey(tempSA.Id)                         //Updation                                       
                     && (!(UserInfo.getName() != 'guest Site Guest User' && oldSAMap.get(tempSA.Id).Original_Schedule_Start__c != tempSA.Original_Schedule_Start__c))
                     )){
                    
                    Boolean isSAInsertUpdated = oldSAMap == null ? true: false;
                    //A3SHCRSF3-199:Checking if its update any fields from Metadata mapping got updated or not
                    if(oldSAMap != null && oldSAMap.containskey(tempSA.Id) && saToSnapFieldMapngs.size() > 0){
                        for(String tempSAField :saToSnapFieldMapngs.keySet()){
                            if(oldSAMap.get(tempSA.Id).get(tempSAField) != tempSA.get(tempSAField)){
                            	isSAInsertUpdated = true;
                                break;
                            }    
                        }
                    }
                    
                    if(isSAInsertUpdated){
                    	updatedSAs.add(tempSA);         
                    }                    
                } 
            }
            
            if(updatedSAs.size() > 0){
                for(ServiceAppointment tempSA :updatedSAs){
                    //Create New SA for the changed SA's                    
                    Service_Appointment_Snapshot__c tempSnapShot = createdSAIdSnapshots.containsKey(tempSA.Id) ? createdSAIdSnapshots.get(tempSA.Id)
                        : new Service_Appointment_Snapshot__c(Service_Appointment__c = tempSA.Id);
                    if(Test.isRunningTest()){
                        tempSnapShot = new Service_Appointment_Snapshot__c(Service_Appointment__c = tempSA.Id);
                    }
                    
                    if(saToSnapFieldMapngs.size() > 0){
                        //A3SHCRSF3-199:Iterating over field Map and updating Snapshot record fields with respective SA record field
                        for(String tempSAField :saToSnapFieldMapngs.keySet()){
                            if(String.isNotBlank(saToSnapFieldMapngs.get(tempSAField))){
                                if(saToSnapFieldMapngs.get(tempSAField) == 'Schedule_Start_Time__c'){
                                    DateTime scheduledStartDate = tempSA.Original_Schedule_Start__c != null ? tempSA.Original_Schedule_Start__c : tempSA.SchedStartTime;
                                    tempSnapShot.put(saToSnapFieldMapngs.get(tempSAField),scheduledStartDate);
                                }
                                else{
                                	tempSnapShot.put(saToSnapFieldMapngs.get(tempSAField),tempSA.get(tempSAField));    
                                }                                
                            }  
                        }
                    }
                    
                    //ScheduleStartTime Changed
                    if(oldSAMap != null && oldSAMap.containskey(tempSA.Id) 
                       && oldSAMap.get(tempSA.Id).SchedStartTime != tempSA.SchedStartTime){
                        tempSnapShot.Is_Scheduled__c = true;
                        //Update Scheduled By based on Logged In User
                        tempSnapShot.Scheduled_By__c = UserInfo.getName() == 'guest Site Guest User' ? 'Self-Schedule(Guest)' : 'Agent';                    
                    }
                    
                    newSASnapshots.add(tempSnapShot);
                }
                
                if(newSASnapshots.size() > 0){
                    //Upserting Snapshots
                    upsert newSASnapshots;
                    
                    for(Service_Appointment_Snapshot__c tempSnap :newSASnapshots){
                        createdSAIdSnapshots.put(tempSnap.Service_Appointment__c,tempSnap);
                    }
                }
            }
        }
        catch(Exception e){
            insert new Error_Log__c(Error_Message__c = e.getMessage(),Error_Stack_Trace__c = e.getStackTraceString(),Additional_Info__c = JSON.serialize(newSAs),
                                    Custom_Message__c = 'Error Creating Snapshot records for SA',Source__c = className + '-' + methodName);
        }
    }
}