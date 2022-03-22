({
	invoke : function(component, event, helper) {
		var quoteId = component.get('v.recordId');
        var navService = component.find("navService");
        
        var pageReference = {type: 'standard__webPage',
                             attributes: {
                                url: '/apex/SBQQ__sb?scontrolCaching=1&id='+quoteId+'#quote/le?qId='+quoteId
                            }};
        navService.navigate(pageReference);     
	}
})