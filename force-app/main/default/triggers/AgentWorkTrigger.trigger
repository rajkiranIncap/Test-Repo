trigger AgentWorkTrigger on AgentWork (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
    	AgentWorkTriggerHandler.handleLeadAgentWork(Trigger.New);
    }
}