trigger absenceHandlerForAssignedServices on ResourceAbsence (after insert, after update) {
    if(trigger.size==1){ //not intended for bulk.
        list<serviceappointment> sasToUpdate = new list<serviceappointment>();
        list<id> iteratedIds = new list<id>(); //hold service appointment ids that have been modified (marked as in jeopardy and unscheduled) when their assigned resource records have been iterated
        for(resourceabsence ra : trigger.new){
            list<assignedresource> ars = new list <assignedresource>();
            //get assigned resource records associated with jobs that intersect with absences
            ars = [select id, serviceappointmentid from assignedresource where serviceresourceid =: ra.resourceid and
                   (
                       (serviceappointment.schedstarttime >=: ra.start and serviceappointment.schedstarttime <=: ra.end) OR
                       (serviceappointment.schedstarttime <=: ra.start and serviceappointment.schedendtime >=: ra.end) OR
                       (serviceappointment.schedstarttime <=: ra.start and serviceappointment.schedendtime >=: ra.start)
                   )
                  ];         
            for(assignedresource ar: ars){
                if(!iteratedIds.contains(ar.ServiceAppointmentId)){ //don't touch the service appointment if it has been previously touched when iterating over a different assigned resource record (in the event multiple assigned resources exist for a single service, such as when a job is assigned to a crew and it's respective members)
                    serviceappointment sa = new serviceappointment();
                    sa = [select id, status, FSL__InJeopardy__c, statuscategory from serviceappointment where statuscategory in('Scheduled','Dispatched') and id =: ar.serviceappointmentid];
                    if(sa<>null){ //only touch a service appointment if it was retrieved (is scheduled or dispatched - 
                        //you probably don't want to do this when job is in progress (due to status transitions
                        //and any other logic (E.g. tech is working the job, it's completed, canceled, etc.)
                        sa.FSL__InJeopardy__c = true;
                        sa.Status = 'None';
                        sasToUpdate.add(sa);
                        iteratedIds.add(sa.id);
                    }     
                }
            }            
        }
        update sasToUpdate;
    }
}