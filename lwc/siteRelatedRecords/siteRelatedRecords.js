/**
 * @author Tushar Kumawat [CriticalRiver]
 * @date 4 March 2022
 * @description Component to search and display related records to parent account's Site records 
 * @version 1.0
 */
import { LightningElement, api, track } from 'lwc';
// import { NavigationMixin } from 'lightning/navigation';
import getReatedRecords from '@salesforce/apex/SiteSearchController.getReatedRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SiteRelatedRecords extends LightningElement {
    @api recordId;
    @track strObjectName = 'Case';
    @track strSiteFieldName = 'AccountId';
    @track listRelatedItemsClone = [];
    @track listRelatedItems = [];
    accountId = '';
    @track action = {type: 'action', typeAttributes: {rowActions: [{label: 'Show details', name: 'show_details'}]}};

    connectedCallback() {        
        this.fetchSiteRelatedRecords();        
    }

    fetchSiteRelatedRecords() {
        this.listRelatedItems = [];
        getReatedRecords({
            strObjectName : this.accountId ? 'Account' : this.strObjectName,
            strSiteFieldName : this.strSiteFieldName,
            strRecordId : this.accountId ? this.accountId : this.recordId
        })
        .then(result => {
            if(result.isSuccess) {                
                this.listRelatedItemsClone = result.listRelatedItems;
                this.flattenRecords(result.listRelatedItems);
            }
            else {
                this.showToastMessage('Error', result.strMessage, 'error');
            }
        })
        .catch(error => {
            console.log('error ::: ', error);
            this.showToastMessage('Error', error, 'error');
        });
    }

    flattenRecords(listRelatedItems) {        
        listRelatedItems.forEach(function(relatedItem) {
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

        this.listRelatedItems = listRelatedItems;
        console.log(this.listRelatedItems);
    }

    filterRecords(event) {        
        this.accountId = event.currentTarget.recordId;     
        this.fetchSiteRelatedRecords();        
    }

        /* let listRelatedItems = JSON.parse(JSON.stringify(this.listRelatedItemsClone));

        listRelatedItems.forEach(function(relatedItem) {
            relatedItem.listDataClone = JSON.parse(JSON.stringify(relatedItem.listData));
            relatedItem.listData = [];

            relatedItem.listDataClone.forEach(function(data) {
                if(!data.Id.startsWith('001')) {
                    if(JSON.stringify(data).includes(accountId)) {
                        relatedItem.listData.push(data);
                    }
                }
            });

            delete relatedItem.listDataClone;
        });

        this.flattenRecords(listRelatedItems); */
    

    showToastMessage(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        }));
    }

    refreshRelatedList(){
        this.accountId = undefined;     
        this.fetchSiteRelatedRecords();
    }
}