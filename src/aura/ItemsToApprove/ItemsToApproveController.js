({
	loadData: function(component, event, helper) {
      var action = component.get('c.wrapperClass');
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {

          component.set('v.columns', [
            {label: 'Name', fieldName: 'RecordURL', type: 'url',sortable: true,initialWidth: 100, typeAttributes: {label: { fieldName: 'RecordName',target: '_self'}}},
              {label: 'Submitter', fieldName: 'ApproverName', type: 'text',initialWidth: 100, cellAttributes: {"class": {"fieldName": "showClass"}}},   
            {label: 'Date Submitted', fieldName: 'CreatedDate', type: 'date', initialWidth: 100, cellAttributes: {"class": {"fieldName": "showClass"}}},   
            {label: 'Comments', fieldName: 'Comments', type: 'text', initialWidth: 230, cellAttributes: {"class": {"fieldName": "showClass"}}},   
            {label: 'Status', fieldName: 'Status', type: 'text',initialWidth: 100, cellAttributes: {"class": {"fieldName": "showClass"}}},   
            {label: 'Record Type', fieldName: 'RecordType', type: 'text',initialWidth: 150, cellAttributes: {"class": {"fieldName": "showClass"}}},   
            {label: 'Other Info', fieldName: 'MiscInfo', type: 'text',initialWidth: 200, cellAttributes: {"class": {"fieldName": "showClass"}}}  
        ]);
            
                // store the account list in records variable
                var records = response.getReturnValue();
                // iterate each records with forEach loop
                records.forEach(function(record){ 
                        // based on VIP Account field value set the icon and style class to each record 
                        //if(record.ElapsedHours){
                            record.showClass = (record.ElapsedHours > 48 ? 'redcolor' : 'blackcolor');
                        //}
                        //else{
                            record.showClass = (record.ElapsedHours == null ? 'redcolor' : 'blackcolor');
                        //}
                    
                });
         component.set('v.wrapperList', response.getReturnValue());

        }
      });
      $A.enqueueAction(action);
    },
})