/**************************************************************************************************************************
* 
* Description : Custom Extension for the Customer Survey VF page.
*                Create Customer Survey record associated to case.
* 
* Test class  : TestSurveyPageExtension
* -----------------------------------------------------------------------------------------------------------------------
* 
* ***********************************************************************************************************************/

public class SurveyPageExtension {
    
    public Case case_Obj {get;set;}
    public Customer_Survey__c customer_survey_Obj {get;set;}
    public String surveyId;
    public String OwnerSubString {get;set;}
    public String OwnerLastName;
    
    public SurveyPageExtension(ApexPages.StandardController acon) { 
        OwnerSubString = '';
        OwnerLastName = '';
        String recordID = System.currentPageReference().getParameters().get('id');
        System.debug('******** Record Id '+recordID);
        
        if( recordID != null && recordID != ''){
            System.debug('recordID'+recordID);
            case_Obj = new case();
            case_Obj = [Select id, AR_Customer_Userdef__c, Company__c, owner.name,owner.FirstName from Case where id =: recordID Limit 1][0];
            if(case_Obj!=null){
                system.debug('**** Case obj '+case_Obj);
                system.debug('**** Case obj '+case_Obj.owner.name);
                OwnerLastName = case_Obj.owner.name.Substring(case_Obj.owner.name.indexOf(' ')+1,case_Obj.owner.name.length());
            	OwnerSubString = case_Obj.owner.name.Substring(0,case_Obj.owner.name.indexOf(' ')) + ' ' + OwnerLastName.Substring(0,1);
            }
            else{
                system.debug('**** Case obj NULL');
                OwnerLastName = 'Smart';
            	OwnerSubString = 'Home';
            }
            System.debug('*****OwnerSubString***'+OwnerSubString);
            
            customer_survey_Obj = new Customer_Survey__c();
            customer_survey_Obj.name = 'Test';
            customer_survey_Obj.Case__c = case_Obj.id;
            
            list<Customer_Survey__c> surveylist = new list<Customer_Survey__c>();
            
            surveylist =  [Select id, Additional_comments_or_feedback_for_us__c, Day_to_day_functionality_of_the_product__c,
                           Ease_of_use__c, Experience_with_billing_and_accounting__c, Friendliness_of_the_Customer_Care_team__c,
                           Helpfulness_of_the_Customer_Care_team__c, How_likely_are_you_to_recommend_A3_Smart__c,
                           How_satisfied_are_you_with_A3_Smart_Home__c, Reasons_for_your_score__c,Responsiveness_of_the_Customer_Care_team__c,
                           Satisfaction_with_Customer_Care_team__c from Customer_Survey__c where Case__c =: case_Obj.id Limit 1];
            System.debug('*****test***');
            if( surveylist != null && !surveylist.isEmpty()){
                customer_survey_Obj = surveylist[0];
                surveyId = surveylist[0].Id;    
            }
            
        } 
        
    }
    
    
    public PageReference updateCaseData(){
        if( surveyId != null ){
            customer_survey_Obj.id = surveyId;
            upsert customer_survey_Obj ;
        }
        else{
             surveyId = customer_survey_Obj.id ;
            insert customer_survey_Obj;
        }
        PageReference pageRef;
        if(case_Obj.AR_Customer_Userdef__c == 'AAA')
            pageRef = new PageReference('https://smarthome.calstate.aaa.com/');
        else if(case_Obj.AR_Customer_Userdef__c == 'A3')
            pageRef = new PageReference('https://a3smarthome.com/');
        else
            pageRef = new PageReference('https://gmail.com/');
        
        return pageRef;
    }
    
    
}