trigger LeadTrigger on Lead (After Insert) {
    if(Trigger.isInsert && Trigger.IsAfter){
        SkillBasedRoutingPOC.createPendingServiceRouting(Trigger.New);
        
        
    }
    
}