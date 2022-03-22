({
	doInit : function(component, event, helper) {
		let tableData = component.get("v.tableData");
		let recordsPerPage = component.get("v.recordsPerPage");
		let maxPageNumber = parseInt(tableData.length / recordsPerPage);
        
        if(maxPageNumber * recordsPerPage < tableData.length) {
            maxPageNumber++;
        }

		component.set("v.showPagination", (maxPageNumber > 0));
		component.set("v.maxPageNumber", maxPageNumber);
        helper.getRecords(component, event, helper);
	},

	next : function(component, event, helper) {
		let pageNumber = component.get("v.pageNumber");
		pageNumber++;
		component.set("v.pageNumber", pageNumber);
        helper.getRecords(component, event, helper);
	},

	previous : function(component, event, helper) {
		let pageNumber = component.get("v.pageNumber");
		pageNumber--;
		component.set("v.pageNumber", pageNumber);
        helper.getRecords(component, event, helper);
	},

	openRecordDetail : function(component, event, helper) {
		let row = event.getParam('row');
		$A.get("e.force:navigateToSObject").setParams({
			"recordId": row.Id
		}).fire();
	},

	getTableClick : function(component, event, helper) {
		console.log('Table Event ::: ', event);
	}
})