trigger TaskTrigger on Task (after update, after insert) {
    List<Task> taskList = new List<Task>();
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        for(Task task : trigger.new){
            if(task.Status == 'Completed' && trigger.oldMap != null && task.Status <> trigger.oldMap.get(task.Id).Status){
                taskList.add(task);
            }
        }
    }
    
    system.debug('taskList: ' + taskList);
    
    if(taskList.size() > 0){
        TaskTriggerHandler.createRecordAction(taskList);
    }
}