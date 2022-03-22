//This class is Utility class which will have all reusable methods
public class GlobalUtil {
    
    /* A3SHCRSF3-10
     * Method Name:  getSObjectName
     * Params: sObjectIds : SObjectId 
     * Return: String: It will return Object API Name   
     * Description: It will retrieve the Object API Name based on the SObjectId
     */
    public static String getSObjectName(List<Id> sObjectIds){
        String objectName;
        if(sObjectIds.size() > 0){
            objectName = String.valueOf(sObjectIds[0].getSobjectType());
        }
        return objectName;
    }
}