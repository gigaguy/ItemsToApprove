public class ItemsToApprove {
    
    @AuraEnabled
    public static List<Wrapperclass> wrapperClass() {
        List<Wrapperclass> wrapList = new List<Wrapperclass>();
        for (ProcessInstance pi: [SELECT Id, Status, TargetObjectId, TargetObject.Name, CreatedDate,  
                (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, Comments, ElapsedTimeInHours, ProcessNode.Name, CreatedDate FROM StepsAndWorkitems where OriginalActorId=: userinfo.getuserId()) 
                FROM ProcessInstance WHERE status='Pending' ORDER BY TargetObjectId] ) {
                    for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) {
                        Wrapperclass pendingApprovalWrap = new Wrapperclass();
                        pendingApprovalWrap.Status = pih.StepStatus;
                        pendingApprovalWrap.ElapsedHours = pih.ElapsedTimeInHours;
                        pendingApprovalWrap.CreatedDate = String.valueof(pih.createddate).split(' ')[0];
                        pendingApprovalWrap.RecordName = String.valueOf(pi.TargetObject.Name);
                        pendingApprovalWrap.RecordId = String.valueOf(pi.TargetObjectId);
                        pendingApprovalWrap.RecordURL = '/one/one.app?#/sObject/'+ String.valueOf(pi.TargetObjectId) + '/view';
                        pendingApprovalWrap.RecordObject = String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0];
                        pendingApprovalWrap.AssignedToName = String.valueOf(pih.OriginalActor.Name);
                        pendingApprovalWrap.ApproverName = pih.Actor.Name;
                        pendingApprovalWrap.Comments = pih.Comments;
                                                
                        // Store the object name so it can be used in queries                                           
                        String obj = String.valueOf(pi.TargetObjectId.getSObjectType());
				
                        // Lookup Record Type ID and Name
                        String rtID = String.ValueOf(getObjectField('RecordTypeid',obj,'id=\''+pi.TargetObjectId+'\''));                            
                        pendingApprovalWrap.RecordType = String.ValueOf(getRecordTypeName(obj,rtID));
                        
                        // Lookup Misc Info Dyanmically
                        pendingApprovalWrap.MiscInfo = null;
                        List<ItemsToApprove__mdt> a = [Select field__c from itemstoapprove__mdt where object__c= :obj LIMIT 1];
                        if(a.size() > 0){
                            pendingApprovalWrap.MiscInfo = String.valueOf(getObjectField(a[0].field__c,obj,'name=\''+ pi.TargetObject.Name+'\'')); 
                        }
                        // Add everything to the returned results
                        wrapList.add(pendingApprovalWrap);
                    }          
                }
        return wrapList;
    }
    
    public class wrapperClass{
        @AuraEnabled public String Status {get; set;}
        @AuraEnabled public Decimal ElapsedHours {get; set;}
        @AuraEnabled public String CreatedDate {get; set;}
        @AuraEnabled public String RecordName {get; set;}
        @AuraEnabled public String RecordType {get; set;}
        @AuraEnabled public String RecordId {get; set;}
        @AuraEnabled public String RecordURL {get; set;}
        @AuraEnabled public String RecordObject {get; set;}        
        @AuraEnabled public String AssignedToName {get; set;}
        @AuraEnabled public String ApproverName {get; set;}
        @AuraEnabled public String Comments {get; set;}
        @AuraEnabled public String MiscInfo {get; set;}
    }
    
    public static String getObjectField(String fieldString, String objString, String whereString){
    	String sQuery = 'Select ' + fieldString +' From ' + objString + ' where '+ whereString +' LIMIT 1';
        sObject a = Database.query(sQuery);
        return String.ValueOf(a.get(fieldString));
    }
       
    public static String getRecordTypeName(String obj, String rtID){
        return Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosById().get(rtID).getName();
    }
    
}