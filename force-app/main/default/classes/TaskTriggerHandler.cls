public class TaskTriggerHandler {
    public static void createRecordAction(List<Task> taskList){
        Set<string> taskNameSet = new Set<string>();
        List<RecordAction> recordActionList = new List<RecordAction>();
        Set<Id> OpportunitySet = new Set<Id>();
        
        for(Task task : taskList){
            taskNameSet.add(task.Subject);
            OpportunitySet.add(task.WhatId);
        }
        
        List<Task_Guided_Action_Assignment__c> taskGuidedActionList = [select Id, Flow_API_Name__c, Task_Subject__c from 
                                                                       Task_Guided_Action_Assignment__c where Task_Subject__c in : taskNameSet];
        
        system.debug('taskGuidedActionList: ' + taskGuidedActionList);
        
        Map<string, Task_Guided_Action_Assignment__c> taskGuidedActionMap = new Map<string, Task_Guided_Action_Assignment__c>();
        
        for(Task_Guided_Action_Assignment__c taskGuidedAction : taskGuidedActionList){
            taskGuidedActionMap.put(taskGuidedAction.Task_Subject__c, taskGuidedAction);
        }
        
        system.debug('taskGuidedActionMap: ' + taskGuidedActionMap);
        
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([select Id, Name, (Select TeamMemberRole,UserId, User.Email, User.Name From OpportunityTeamMembers where TeamMemberRole = 'NB Intake Associate') from Opportunity 
                                                                        where id in : opportunitySet]);
        
        system.debug('opportunityMap : ' + opportunityMap);
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Task task : taskList){
            if(taskGuidedActionMap.containsKey(task.Subject)){
                RecordAction recordAction = new RecordAction(RecordId = task.WhatId, ActionDefinition=taskGuidedActionMap.get(task.Subject).Flow_API_Name__c, Order=1, ActionType='Flow');
            	system.debug('recordAction: ' + recordAction);
                recordActionList.add(recordAction);
            }
            
            if(task.Subject == 'UnderWrite'){
                system.debug('1');
                Opportunity opportunity = opportunityMap.get(task.WhatId);
                system.debug('opportunity: ' + opportunity);
                
                if(opportunity != null){
                    List<OpportunityTeamMember> oppContactMemberList = opportunity.OpportunityTeamMembers;
                	
                    system.debug('oppContactMemberList: ' + oppContactMemberList);
                    
                    for(OpportunityTeamMember oppContactMember : oppContactMemberList){
                        // Step 1: Create a new Email
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        // Step 2: Set list of people who should get the email
                        List<String> sendTo = new List<String>();
                        
                        sendTo.add(oppContactMember.User.Email);
                        
                        //sendTo.add('nshah@incapsulate.com');
                        
                        mail.setToAddresses(sendTo);
                        
                        // Step 4. Set email contents - you can use variables!
                        mail.setSubject('Opportunity '+ opportunity.Name +' - Underwriting Complete');
                        
                        String body = 'Dear ' + oppContactMember.User.Name + ', ';
                        body += '</br> </br>' + 'For more details, please review the opportunity HERE: ';
                        body += '<a href="'+URL.getSalesforceBaseUrl()+'/'+opportunity.id+'">'+opportunity.Name+'</a>';
                        body += '<br/><br/>Thank you, ';
                        body += '<br/>Travelers New Business team';
                        body +=  '</body></html>';
                        mail.setHtmlBody(body);
                        
                        String textbody = 'Dear ' + oppContactMember.User.Name + ', ';
                        textbody += '\n\n' + 'For more details, please review the opportunity HERE: ' + opportunity.id;
                        //textbody += '<a href="'+URL.getSalesforceBaseUrl()+'/'+opportunity.id+'">'+opportunity.Name+'</a>';
                        textbody += '\n\nThank you, ';
                        textbody += '\nTravelers New Business team';
                        mail.setPlainTextBody(textbody);
                        
                        // Step 5. Add your email to the master list
                        mailList.add(mail);
                    }
                }
            }
        }
        
        try {
            if(recordActionList.size() > 0){
                insert recordActionList;
            }
        } catch (DMLException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        
        system.debug('mailList: ' + mailList);
        
        if(mailList.size() > 0){
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mailList);
        }
    }
}