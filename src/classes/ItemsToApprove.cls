/**********************************************************************
Name: ItemsToApprove
======================================================
======================================================
Purpose:
-------
Controller to get the list of pending approvals for the current user
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
1.0   Melissa Shepard 8/11/2019 Initial development
1.0   Roy King        8/20/2019 Converted to Datatable, added Infinite Scroll, and sort

**********************************************************************/

public class ItemsToApprove {
    
    @AuraEnabled
    public static List<Wrapperclass> wrapperClass() {
        List<Wrapperclass> wrapList = new List<Wrapperclass>();
        for (ProcessInstance pi: [SELECT Id, Status, TargetObjectId, TargetObject.Name, CreatedDate, CreatedById,
                (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, Comments, ElapsedTimeInHours, ProcessNode.Name, CreatedDate
                 FROM StepsAndWorkitems where ActorId=:userinfo.getuserId() ORDER By CreatedDate DESC LIMIT 1)
                FROM ProcessInstance WHERE status='Pending' ] ) {
                    for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) {
                        Wrapperclass pendingApprovalWrap = new Wrapperclass();
                        pendingApprovalWrap.Status = pi.Status;
                        pendingApprovalWrap.ElapsedHours = pih.ElapsedTimeInHours;
                        pendingApprovalWrap.CreatedDate = String.valueof(pi.createddate).split(' ')[0];
                        pendingApprovalWrap.RecordName = String.valueOf(pi.TargetObject.Name);
                        pendingApprovalWrap.RecordId = String.valueOf(pi.TargetObjectId);
                        pendingApprovalWrap.RecordURL = '/one/one.app?#/sObject/'+ String.valueOf(pi.TargetObjectId) + '/view';
                        pendingApprovalWrap.RecordObject = String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0];
                        pendingApprovalWrap.Submitter = String.ValueOf(getObjectField('Name','user','id=\''+pi.CreatedById+'\''));
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
        @AuraEnabled public String Submitter {get; set;}
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