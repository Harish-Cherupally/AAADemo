@isTest(SeeAllData=True)
private class TestSurveyPageExtension {
    static testMethod void testSurveyPageMethod(){
        
        Case case_obj = new Case();
        case_obj.AR_Customer_Userdef__c = 'AAA';
        case_obj.Status='New';
        case_obj.Origin ='Email'; 
        //case_obj.OwnerId = [Select id from user limit 1][0].id;
        insert case_obj;
        system.debug('****# '+case_Obj.Owner.name);
        
        ApexPages.StandardController controller_Obj = new ApexPages.StandardController(case_obj);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(case_obj.Id));
        SurveyPageExtension obj = new SurveyPageExtension(controller_Obj);
			obj.updateCaseData();
        
    }
     static testMethod void testSurveyPageMethod2(){
        
        Case case_obj = new Case();
        case_obj.AR_Customer_Userdef__c = 'A3';
        case_obj.Status='New';
        case_obj.Origin ='Email'; 
        //case_obj.OwnerId = [Select id from user limit 1][0].id;
        insert case_obj;
        system.debug('****# '+case_Obj.Owner.name);
        
        ApexPages.StandardController controller_Obj = new ApexPages.StandardController(case_obj);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(case_obj.Id));
        SurveyPageExtension obj = new SurveyPageExtension(controller_Obj);
			obj.updateCaseData();
        
    }
    
}