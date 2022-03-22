/*Created by: Akhila
  Description: A3SHCRSF3-111 
  as per this story we are using this class to get list of lead record id's whose status is 'Qualified' & isConverted should be false.*/

trigger convertLeads on Lead (after insert, after update) {
    List<lead> leadList = trigger.new;
    Set<ID> leadIds= new Set<ID>();
    for(lead leadRecord : leadList) {
        if (leadRecord.Status =='Qualified' && leadRecord.isConverted ==false){
              
             leadIds.add(leadRecord.Id);
        }
    //system.debug('size'+ leadIds.size());
    if(leadIds.size()  > 0){
              //ConvertLeads.LeadAssign(leadIds);
    }
}
}