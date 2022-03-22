@IsTest
private class absenceHandlerForAssignedServicesTest{
    static testMethod void testMethod1() {
                
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        ServiceAppointment sa = new ServiceAppointment();
        sa.Status = 'Scheduled';
        sa.SchedStartTime = system.now().addHours(-5);
        sa.SchedEndTime = system.now().addHours(2);
        sa.ParentRecordId = acc.Id;
        insert sa;
        
        ServiceResource sr = new ServiceResource();
        sr.Name = 'Test User';
        sr.RelatedRecordId = Userinfo.getUserId();
        sr.IsActive = true;
        insert sr;
        
        OperatingHours objOH = new OperatingHours();
        objOH.Name = '9 To 5';
        objOH.TimeZone = 'Asia/Kolkata';
        insert objOH; 
        
        ServiceTerritory objST = new ServiceTerritory();
        objST.Name = 'Test Territory';
        objST.OperatingHoursId = objOH.Id;
        objST.IsActive = TRUE;
        insert objST;
        
        ServiceTerritoryMember objSTM = new ServiceTerritoryMember();
        objSTM.TerritoryType = 'P';
        objSTM.ServiceTerritoryId = objST.Id;
        objSTM.ServiceResourceId = sr.Id;
        objSTM.EffectiveStartDate = Date.today().addYears(-1);
        objSTM.EffectiveEndDate = Date.today().addYears(2);
        insert objSTM;
        
        AssignedResource ar = new AssignedResource();
        ar.ServiceAppointmentId = sa.Id;
        ar.ServiceResourceId = sr.Id;
        insert ar;
        
        Test.startTest();
            ResourceAbsence ra = new ResourceAbsence();
            ra.ResourceId = sr.Id;
            ra.Start = system.now().addHours(-6);
            ra.End = system.now().addHours(3);
            insert ra;
        Test.stopTest();
    }
}