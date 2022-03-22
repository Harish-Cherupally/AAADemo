({
	getRecords : function(component, event, helper) {
		let tableData = component.get("v.tableData");
		let pageNumber = component.get("v.pageNumber");
		let recordsPerPage = component.get("v.recordsPerPage");
		let pageData = tableData.slice((pageNumber - 1) * recordsPerPage, pageNumber * recordsPerPage);
		component.set("v.pageData", pageData);
		helper.checkPrevious(component, event, helper);
		helper.checkNext(component, event, helper);
	},

	checkPrevious : function(component, event, helper) {
		let showPrevious = component.get("v.showPrevious");
		let pageNumber = component.get("v.pageNumber");
		showPrevious = pageNumber > 1;
		component.set("v.showPrevious", showPrevious);
	},

	checkNext : function(component, event, helper) {
		let showNext = component.get("v.showNext");
		let pageNumber = component.get("v.pageNumber");
		let maxPageNumber = component.get("v.maxPageNumber");
		showNext = pageNumber < maxPageNumber;
		component.set("v.showNext", showNext);
	}
})