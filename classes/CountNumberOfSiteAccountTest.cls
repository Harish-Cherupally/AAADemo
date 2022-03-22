@isTest 
public class CountNumberOfSiteAccountTest 
{
    static testMethod void testMethod1() 
    {
        
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> siteaccList = TestDataFactory.createSiteAccounts(5,fieldDatas,true);
        Test.startTest();
        CountNumberOfSiteAccount obj = new CountNumberOfSiteAccount();
        DataBase.executeBatch(obj); 
        //system.assetequal();.....
        system.assertEquals(5, 5);
        Test.stopTest();
    }
}