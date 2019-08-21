({


        doInit: function(component, event, helper) {
            var action = component.get("c.wrapperClass");
            action.setCallback(this, function(result) {
                var state = result.getState();
                if (component.isValid() && state === "SUCCESS"){
                    var resultData = result.getReturnValue();
                    if(resultData.length > 0){
                        component.set('v.columns', [
                          {label: 'Name', fieldName: 'RecordURL', type: 'url',sortable: true,initialWidth: 100, typeAttributes: {label: { fieldName: 'RecordName',target: '_self'}}},
                          {label: 'Submitter', fieldName: 'Submitter', type: 'text',sortable: true,initialWidth: 100, cellAttributes: {"class": {"fieldName": "showClass"}}},
                          {label: 'Date Submitted', fieldName: 'CreatedDate', type: 'date',sortable: true, initialWidth: 100, cellAttributes: {"class": {"fieldName": "showClass"}}},
                          {label: 'Status', fieldName: 'Status', type: 'text',initialWidth: 100, cellAttributes: {"class": {"fieldName": "showClass"}}},
                          {label: 'Record Type', fieldName: 'RecordType', type: 'text',sortable: true,initialWidth: 150, cellAttributes: {"class": {"fieldName": "showClass"}}},
                          {label: 'Other Info', fieldName: 'MiscInfo', type: 'text',initialWidth: 200,sortable: true, cellAttributes: {"class": {"fieldName": "showClass"}}},
                          {label: 'Comments', fieldName: 'Comments', type: 'text',sortable: true, initialWidth: 230, cellAttributes: {"class": {"fieldName": "showClass"}}}
                        ]);
                        component.set("v.DataList", resultData);
                        component.set("v.totalRecords", resultData.length);
                        var totalRecordsToDisplayVar = component.get("v.totalRecordsToDisplay");
                        var vDataList = [];
                        for(var i=0; i<totalRecordsToDisplayVar; i++){
                            vDataList.push(resultData[i]);
                        }
                        component.set("v.PagedData", vDataList);
                    }
                    else{
                         component.set("v.showNoRecordMessage", true);
                    }
            }

            });
        $A.enqueueAction(action);
        },
    loadMore: function(component, event, helper) {
        var DataListVar = component.get("v.DataList");
        if(DataListVar.length > 0){
             var currentPageData = component.get("v.PagedData");
             var lengthOfRecords = component.get("v.PagedData").length;
             var totalRecordsToDisplayVar = component.get("v.totalRecordsToDisplay");
             component.set("v.spinner",true);
             var vDataList = [];
             for(var i=lengthOfRecords; i< lengthOfRecords + totalRecordsToDisplayVar; i++){
                    if(DataListVar[i] != undefined){
                        vDataList.push(DataListVar[i]);
                    }
             }
             var concatData = currentPageData.concat(vDataList);
             setTimeout(function(){
             component.set("v.spinner",false)
             component.set("v.PagedData",concatData);
             event.getSource().set("v.isLoading", false);
             }, 1000);
        }
    },
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
})