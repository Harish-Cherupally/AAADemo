/**
 * @author Tushar Kumawat [CriticalRiver]
 * @date 11 March 2022
 * @description MergeBatchClass
 * @version 1.0
 */
public with sharing class MergeBatchClass implements Database.Batchable<String> {
    public final List<String> listUniqueIds;
    public final String strObjectName;
    public final String strFieldName;

    public MergeBatchClass(String strObjectName, String strFieldName, List<String> listUniqueIds) {
        this.listUniqueIds = listUniqueIds;
        this.strObjectName = strObjectName;
        this.strFieldName = strFieldName;
    }

    public Iterable<String> start(Database.BatchableContext bc) {
        return listUniqueIds;
    }

    public void execute(Database.BatchableContext bc, List<String> uniqueIdList) {
        List<SObject> listObjectsToDelete = new List<SObject>();
        List<SObject> listObjectsToUpdate = new List<SObject>();
        Map<String, String> mapRelationToField = new Map<String, String>();
        Map<String, List<SObject>> mapUniqueIdToSObjects = new Map<String, List<SObject>>();
        SavePoint savePoint = Database.setSavepoint();
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(strObjectName).getDescribe();
        String strQuery = 'SELECT Id, ' + strFieldName + ',  ';
        
        for(Schema.ChildRelationship relation : objectDescribe.getChildRelationships()) {
            String strRelationshipName = relation.getRelationshipName();

            if(String.isNotBlank(strRelationshipName)) {
                strQuery = strQuery + ' SELECT Id, ' + relation.getField() + ' FROM ' + strRelationshipName + ') ';
                mapRelationToField.put(strRelationshipName, relation.getField().getDescribe().getName());
            }
        }

        strQuery = strQuery + ' FROM ' + strObjectName + ' WHERE ' + strFieldName + ' IN : uniqueIdList ORDER BY CreatedDate DESC';

        for(SObject currObject : Database.query(strQuery)) {
            String strUniqueId = (String) currObject.get(strFieldName);

            if(!mapUniqueIdToSObjects.containsKey(strUniqueId)) {
                mapUniqueIdToSObjects.put(strUniqueId, new List<SObject>());
            }

            mapUniqueIdToSObjects.get(strUniqueId).add(currObject);
        }

        for(String strUniqueId : mapUniqueIdToSObjects.keySet()) {
            if(mapUniqueIdToSObjects.get(strUniqueId).size() > 1) {
                SObject masterRecord = mapUniqueIdToSObjects.get(strUniqueId).get(0);

                for(Integer index = 1; index < mapUniqueIdToSObjects.get(strUniqueId).size(); index++) {
                    for(String strRelationshipName : mapRelationToField.keySet()) {
                        for(SObject currSObject : mapUniqueIdToSObjects.get(strUniqueId).get(index).getSObjects(strRelationshipName)) {
                            currSObject.put(mapRelationToField.get(strRelationshipName), masterRecord.Id);
                            listObjectsToUpdate.add(currSObject);
                        }
                    }

                    listObjectsToDelete.add(mapUniqueIdToSObjects.get(strUniqueId).get(index));
                }
            }
        }

        try {
            if(!listObjectsToDelete.isEmpty()) {
                update listObjectsToUpdate;
                delete listObjectsToDelete;
            }
        }
        catch(Exception ex) {
            Database.rollback(savePoint);
        }
    }

    public void finish(Database.BatchableContext bc) {
    }
}