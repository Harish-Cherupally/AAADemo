({
	getReatedRecords : function(component, event, helper) {
		let action = component.get("c.getReatedRecords");

        action.setParams({
			strObjectName : component.get("v.strObjectName"),
            strSiteFieldName : component.get("v.strSiteFieldName"),
            strRecordId : component.get("v.recordId")
		});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
				let result = response.getReturnValue();
				let listRelatedItems = result.listRelatedItems;

                listRelatedItems.forEach(function(relatedItem) {
                    relatedItem.listColumns.push({type: 'action', typeAttributes: {rowActions: [{label: 'Show details', name: 'show_details'}]}});

                    relatedItem.listData.forEach(function(data) {
                        Object.keys(data).forEach(function(dataKey) {
                            if(typeof data[dataKey] === 'object' && data[dataKey]) {
                                Object.keys(data[dataKey]).forEach(function(childRecordKey, index) {
                                    const columnKey = dataKey + '.' + childRecordKey;
                                    data[columnKey] = data[dataKey][childRecordKey];
                                });
                            }
                        });
                    });
                });

				component.set("v.listRelatedItems", listRelatedItems);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
	}
})