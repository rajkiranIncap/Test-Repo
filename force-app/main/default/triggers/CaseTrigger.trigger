trigger CaseTrigger on Case (After Insert) {
    if(Trigger.isInsert && Trigger.IsAfter){
        SkillBasedRoutingPOCCase.createPendingServiceRouting(Trigger.New);
    }
}