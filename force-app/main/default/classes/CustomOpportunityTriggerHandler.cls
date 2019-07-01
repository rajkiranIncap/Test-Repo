public without sharing class CustomOpportunityTriggerHandler {
    public static void closeTask(Set<ID> opportunityList){
        List<Task> taskList = [select Id, Subject, Status from Task where WhatId in : opportunityList
                              and Subject = 'Get Approval'];
        
        if(taskList.size() > 0){
            for(Task task : taskList){
                task.Status = 'Completed';
            }
            update taskList;
        }
    }
    
    public static void sendRejectionTask(List<Opportunity> opportunityList){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
        Set<Id> leadSet = new Set<Id>();
        
        for(Opportunity opportunity : opportunityList){
            leadSet.add(opportunity.Converted_LeadID__c);
        }
        
        Map<Id, Lead> leadMap = new Map<Id, Lead>([select Id, CreatedBy.Email, CreatedBy.Name from Lead where id in : leadSet]);
        
        for(Opportunity opportunity : opportunityList){
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            
            Lead lead = leadMap.get(opportunity.Converted_LeadID__c);
            
            sendTo.add(lead.CreatedBy.Email);
            
            mail.setToAddresses(sendTo);
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject('Opportunity '+ opportunity.Name +' - Proposal Rejected');
            
            String body = 'Dear ' + lead.CreatedBy.Name + ', ';
            body += '</br> </br>' + 'For more details, please review the opportunity HERE: ';
            body += '<a href="'+URL.getSalesforceBaseUrl()+'/'+opportunity.id+'">'+opportunity.Name+'</a>';
            body += '<br/><br/>Thank you, ';
            body += '<br/>Travelers New Business team';
            body +=  '</body></html>';
            mail.setHtmlBody(body);
            
            String textbody = 'Dear ' + lead.CreatedBy.Name + ', ';
            textbody += '\n\n' + 'For more details, please review the opportunity HERE: ' + opportunity.id;
            //textbody += '<a href="'+URL.getSalesforceBaseUrl()+'/'+opportunity.id+'">'+opportunity.Name+'</a>';
            textbody += '\n\nThank you, ';
            textbody += '\nTravelers New Business team';
            mail.setPlainTextBody(textbody);
            
            // Step 5. Add your email to the master list
            mailList.add(mail);
        }
        
        
        if(mailList.size() > 0){
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mailList);
        }
    }
    
    public static void createCase(List<Opportunity> opportunityList){
        List<Case> caseList = new List<Case>();
        
        for(Opportunity opportunity : opportunityList){
            Case caseDetail = new Case();
            caseDetail.Subject = 'QC - ' + opportunity.Name;
            caseDetail.Status = 'New';
            caseDetail.Opportunity_to_QC__c = opportunity.Id;
            caseDetail.Origin = 'Web';
            caseDetail.Skill__c = 'QC';
            caseList.add(caseDetail);
        }
        
        insert caseList;
    }
    
    public static void createActionPlan(List<Opportunity> opportunityList){        
        /*List<Opportunity> opportunityCoverageList = [select Id, StageName, Product__c, (select Id, Product_Coverage__c from Opportunity_Coverages__r)
                                             from Opportunity where Id in : opportunityList];*/
        
        List<Action_Plan_Template_Assignment__c> actionPlanTemplateList = [select Id, Name, Action_Plan_Template_Version__r.Name, Action_Plan_Template_Version__r.Id, Product__c, ProductCoverage__c, Stage__c
                                                                          from Action_Plan_Template_Assignment__c limit 1000];
        //List<ActionPlan> actionPlanList = new List<ActionPlan>();
        
        Set<Id> productCoverageSet = new Set<Id>();
        
        for(Opportunity opportunity : opportunityList){
            productCoverageSet = new Set<Id>();
            /*if(opportunity.Opportunity_Coverages__r != null){
                for(Opportunity_Coverage__c opportunityCoverage : opportunity.Opportunity_Coverages__r){
                    productCoverageSet.add(opportunityCoverage.Product_Coverage__c);
                }
            }*/
            for(Action_Plan_Template_Assignment__c actionPlanTemplate : actionPlanTemplateList){
                if(opportunity.StageName == actionPlanTemplate.Stage__c && opportunity.Product__c == actionPlanTemplate.Product__c && 
                   (productCoverageSet.size() == 0 || productCoverageSet.contains(actionPlanTemplate.ProductCoverage__c))){
                       /*ActionPlan actionPlans = new ActionPlan();
                       actionPlans.Name = actionPlanTemplate.Action_Plan_Template_Version__r.Name;
                       actionPlans.TargetId = string.valueof(opportunity.Id);
                       actionPlans.ActionPlanTemplateVersionId = actionPlanTemplate.Action_Plan_Template_Version__r.Id;
                       actionPlans.ActionPlanType = 'Industries';
                       actionPlans.IsUsingHolidayHours = true;
                       actionPlans.StartDate = date.today();
                       actionPlans.OwnerId = UserInfo.getUserId();
                       actionPlanList.add(actionPlans);*/
                       
                       /*Opportunity_Action_Plan__e oppActionPlan = new Opportunity_Action_Plan__e();
                       oppActionPlan.Name__c = actionPlanTemplate.Action_Plan_Template_Version__r.Name;
                       oppActionPlan.Opportunity_ID__c = opportunity.Id;
                       oppActionPlan.Action_Template_Version_ID__c = actionPlanTemplate.Action_Plan_Template_Version__r.Id;
                       actionPlanList.add(oppActionPlan);*/
                       opportunity.Action_Plan_ID_to_Apply__c = string.valueof(actionPlanTemplate.Action_Plan_Template_Version__r.Id);
                       
                       system.debug('fabien: ' + opportunity.Action_Plan_ID_to_Apply__c);
                   }
            }
        }
        
        //system.debug('actionPlanList: ' + actionPlanList);
        
/*         if(actionPlanList.size() > 0){
            update opportunityList;
            //EventBus.publish(actionPlanList);
        }
*/        
    }
}