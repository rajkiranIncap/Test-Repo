trigger InsurancePartnerTrigger on insurance_partner__e (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        InsurancePartnerTriggerHandler.createInsurancePolicy(trigger.new);
    }
}