global class SchedulerClassTest implements Schedulable {

    global void execute(SchedulableContext sc) {
    
        CheckBatchProcess cbp = new CheckBatchProcess();
        Id batchId = Database.executeBatch(cbp);
    
    }

}