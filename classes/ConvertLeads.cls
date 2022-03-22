Public class ConvertLeads
{
    @InvocableMethod(label='Passvaribale' description='Need to Pass data') 
    public static void LeadConvertion(List<FlowInputs> request) {
        Id leadID =request[0].leadID;
        Id accId =request[0].accId;
        
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus 
                                 WHERE  IsConverted=true Limit 1];
        system.debug(CLeadStatus);
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        
        
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId ( leadID );                
        Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
        MassLeadconvert.add(Leadconvert);
        
        system.debug(MassLeadconvert);
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
            system.debug(lcr);
        }  
        
    }
    
    public class FlowInputs{
        
        @InvocableVariable
        public Id leadID;
        
        @InvocableVariable
        public Id accId;
        
    }
    
    
    
}