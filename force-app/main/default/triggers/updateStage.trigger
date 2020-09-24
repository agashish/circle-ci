trigger updateStage on Opportunity (Before Insert, Before Update) {

    List<Opportunity> newOpp = null;
    Boolean isValidToExecute = false;
    Boolean result = null;
    
    // SETUP CUSTOM META DATA INTO SET AND MAPS
    List<SystemDD_For_Opportunity__mdt> opprtunityMeta = [
        Select 
            Id, 
            Percentage__c, 
            Stages__c, 
            Steps__c 
        FROM 
            SystemDD_For_Opportunity__mdt
    ];
    
    Set<String> stages = new Set<String>();
    /*stages.add('Prospecting');
    stages.add('Qualification');
    stages.add('Needs Analysis');
    stages.add('Value Proposition');
    stages.add('Id. Decision Makers');
    stages.add('Perception Analysis');
    stages.add('Proposal/Price Quote');
    stages.add('Negotiation/Review');
    stages.add('Closed Won');
    stages.add('Closed Lost');*/
    
    Map<String, Integer> percentages = new Map<String, Integer>();
    /*percentages.put('Prospecting', 10);
    percentages.put('Qualification', 10);
    percentages.put('Needs Analysis', 20);
    percentages.put('Value Proposition', 50);
    percentages.put('Id. Decision Makers', 60);
    percentages.put('Perception Analysis', 70);
    percentages.put('Proposal/Price Quote', 75);
    percentages.put('Negotiation/Review', 90);
    percentages.put('Closed Won', 100);
    percentages.put('Closed Lost', 0);*/
    
    Map<String, Integer> steps = new Map<String, Integer>();
    /*steps.put('Prospecting', 8);
    steps.put('Qualification', 7);
    steps.put('Needs Analysis', 6);
    steps.put('Value Proposition', 5);
    steps.put('Id. Decision Makers', 4);
    steps.put('Perception Analysis', 3);
    steps.put('Proposal/Price Quote', 2);
    steps.put('Negotiation/Review', 1);
    steps.put('Closed Won', 0);
    steps.put('Closed Lost', -1);*/
    
    // TRAVERSE AND MAKE THE SET AND MAPS UNIQUE DATA AS WE NEED TO USE UNDERNEATH
    for(SystemDD_For_Opportunity__mdt oppMeta: opprtunityMeta) {
    
        stages.add(oppMeta.Stages__c);
        percentages.put(oppMeta.Stages__c, (Integer)oppMeta.Percentage__c);
        steps.put(oppMeta.Stages__c, (Integer)oppMeta.Steps__c);
    }
    
    System.debug(stages);
    System.debug(percentages);
    System.debug(steps);
        
    // EXECUTE BEFORE AND INSERTION CASE
    if(Trigger.isBefore && Trigger.isInsert) {
        
        System.debug('Insertion case involved');
        isValidToExecute = true;
        newOpp = Trigger.New;            
    
    }
    
    // BEFORE AND UPDATE 
    if(Trigger.isBefore && Trigger.isUpdate) {
        
        System.debug('Updating case involved');
        newOpp = Trigger.New;
        isValidToExecute = true;
    
    }
    
    if(isValidToExecute) {
    
         // EXECUTION LOOK UP    
        for(Opportunity opp: newOpp) {
        
            if(opp.StageName != null && opp.Probability != null) {
            
                Integer inc = -2;
                String stage = null;
            
                // WITHOUT MAP COLLECTION
                /*if(opp.StageName == 'Prospecting') {
                    
                    inc = 8;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);
                                    
                }
                
                if(opp.StageName == 'Qualification') {
                
                    inc = 7;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);
                
                }
                
                if(opp.StageName == 'Needs Analysis') {
                
                    inc = 6;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);       
                
                }
                
                                
                if(opp.StageName == 'Value Proposition') {
                
                    inc = 5;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc); 
                
                }
                
                if(opp.StageName == 'Id. Decision Makers') {
                
                     inc = 4;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);
                
                }
                
                if(opp.StageName == 'Perception Analysis') {
                
                     inc = 3;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);
                
                }
                
                if(opp.StageName == 'Proposal/Price Quote') {
                
                     inc = 2;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);
                
                }
                
                if(opp.StageName == 'Negotiation/Review') {
                
                     inc = 1;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage  + '--' + inc);
                
                }
                
                if(opp.StageName == 'Closed Won') {
                
                    inc = 0;
                    stage = opp.StageName  + ' is ' + opp.Probability;
                    System.debug('-----------' + stage + '--' + inc);
                
                }*/
                
                // FULLY LOADED MAP COLLECTION
                if(stages.contains((String)opp.StageName)) {
                
                    System.debug( '---------- Matched ' + opp.StageName);
                    inc = steps.get(opp.StageName);
                    stage = opp.StageName  + ' is ' + percentages.get(opp.StageName);
                    System.debug('---------- ' + stage );
                
                }
                
                
                if(inc > -2) {
                   
                    if((Trigger.oldMap != null) && (opp.StageName != Trigger.oldMap.get(opp.Id).StageName)) {
                    
                        System.debug('Invoked to execute and update accordingly.');
                        System.debug('-----------' + stage  + '-<>-' + inc);  
                        opp.Probability_Stage__c = stage;  
                        opp.CloseDate = System.today() + inc; 
                        System.debug('-----------' + stage  + '-<>-' + inc);               
                        System.debug(opp);
                    
                    } else {
                      
                        if(Trigger.oldMap == null) {
                    
                            System.debug('Invoked to execute and insert accordingly.');
                            System.debug('-----------' + stage  + '--' + inc);  
                            opp.Probability_Stage__c = stage;  
                            opp.CloseDate = System.today() + inc;                
                            System.debug(opp);
                        
                        }
                    
                    }
                
                }           
            
            }
        
        }   
    
    } else {
    
        System.debug('Cant execute, error in find the event');
        System.debug('False Execution');
    
    }  

}