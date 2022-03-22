global class StagesBatScheduleClass implements Schedulable {
    global void execute(SchedulableContext sc) {
        A3SH_StagesCalloutBatchClass stg = new A3SH_StagesCalloutBatchClass(); 
        database.executebatch(stg , 1);
    }
}