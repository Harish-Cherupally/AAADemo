import { LightningElement, track } from 'lwc';
//import getContactList from '@salesforce/apex/customSearchSobjectLWC.getContactList';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getRecords from '@salesforce/apex/customSearchSobjectLWC.fetchRecords';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'Show details', name: 'show_details' }
];

export default class GlobalSearchForVirtualPros extends NavigationMixin(LightningElement) {
    
    @track contactsRecord;
    
    @track inputRecord = {};
    @track selectedObjectName = 'Account';
    @track data;
    showSpinner = false;
    isLoading = false;
    isDatableChanged = false;
    @track objectNameWiseFields = {
        'Account' : 
            {
            'filterOn' : [{'name':'Name', 'value':'', 'label':'Name'}, {'name':'AccountNumber', 'value':'', 'label':'Account Number'}],
            'displayFields' : ['Name', 'AccountNumber'],
            'columns' : [
                { type: 'action', typeAttributes: { rowActions: actions, } },
                { label: 'Name', fieldName: 'Name' },
                { label: 'Account Number', fieldName: 'AccountNumber'}
            ]
        },
        'Contact' : 
            {
            'filterOn' : [{'name':'FirstName', 'value':'', 'label':'First Name'}, {'name':'LastName', 'value':'', 'label':'Last Name'}, {'name':'Email', 'value':'', 'label':'Email'}],
            'displayFields' : ['FirstName', 'LastName','Email'],
            'columns' : [
                { type: 'action', typeAttributes: { rowActions: actions, } },
                { label: 'First Name', fieldName: 'FirstName' },
                { label: 'Last Name', fieldName: 'LastName'},
                { label: 'Email', fieldName: 'Email'}
            ]
        },
        'Case' : 
            {
            'filterOn' : [{'name':'CaseNumber', 'value':'', 'label':'Case Number'},{'name':'Subject', 'value':'', 'label':'Subject'}],
            'displayFields' : ['CaseNumber', 'Subject'],
            'columns' : [
                { type: 'action', typeAttributes: { rowActions: actions, } },
                { label: 'Case Number', fieldName: 'CaseNumber' },
                { label: 'Subject', fieldName: 'Subject'}
            ]
        },
        'WorkOrder' : 
            {
            'filterOn' : [{'name':'WorkOrderNumber', 'value':'', 'label':'Work Order Number'}, {'name':'Email__c', 'value':'', 'label':'Email'}],
            'displayFields' : ['Email__c', 'WorkOrderNumber'],
            'columns' : [
                { type: 'action', typeAttributes: { rowActions: actions, } },
                { label: 'Work Order Number', fieldName: 'WorkOrderNumber' },
                { label: 'Email__c', fieldName: 'Email__c', type: 'email' }
            ]
        }
    }

    @track recordEditFormFields = []

    get objectOptions() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Case', value: 'Case' },
            { label: 'Work Order', value: 'WorkOrder' }
        ];
    }

    get isNoResults(){
        return !this.showDatatable && (this.data && this.data.length == 0);
    }

    get showDatatable(){

        return !this.isLoading && this.isDatableChanged && (this.data && this.data.length > 0);
    }
    
    connectedCallback(){
        this.inputRecord = {};
        this.showObjectRecordForm();
    }

    handleObjectNameChange(event) {
        this.selectedObjectName = event.detail.value;
        this.showObjectRecordForm();
        this.isDatableChanged = false;
    }

    showObjectRecordForm(){
        if( this.selectedObjectName ){
            this.inputRecord[this.selectedObjectName] = {};
            this.recordEditFormFields = [];
            this.recordEditFormFields = this.objectNameWiseFields[this.selectedObjectName].filterOn;
        }
    }

    get isCaseObject(){
        return (this.selectedObjectName == 'Case');
    }

    get isWorkOrderObject(){
        return (this.selectedObjectName == 'WorkOrder');
    }
    

    handleSearchClick(event){
        //this.buildQuery();
        this.fetchApexRecords();
        this.isDatableChanged = true;
    }

    inputFieldHandleChange(event){
        //debugger;
        //console.log(event.currentTarget.dataset.name);
        //console.log(event.target.value);
        this.inputRecord[this.selectedObjectName][event.currentTarget.dataset.name] = event.target.value;

        console.log('this.inputRecord:::'+JSON.stringify(this.inputRecord));
    }

    get query(){
        let q = 'SELECT Id, '+ this.objectNameWiseFields[this.selectedObjectName].displayFields.join(', ') +' FROM ' + this.selectedObjectName;
        console.log('this.inputRecord:::'+this.inputRecord[this.selectedObjectName]);
        let whereClauseList = []
        for (var fieldAPIName in this.inputRecord[this.selectedObjectName]) {
            whereClauseList.push( ' '+fieldAPIName+'  LIKE \'%' + this.inputRecord[this.selectedObjectName][fieldAPIName] +'%\'' );
        }

        if( whereClauseList.length > 0 ){
            q+= ' WHERE ' + whereClauseList.join(' AND ');
        }
        q += ' LIMIT 5';
        console.log('q:::'+q);
        return q;
    }

    get columns(){
        return this.objectNameWiseFields[this.selectedObjectName].columns;
    }

    fetchApexRecords(){
        console.log('query:::'+this.query);
        this.showSpinner = true;
        this.isLoading = true;
        getRecords({
            query: this.query
        })
        .then(result => {
            this.showSpinner = false;
            this.isLoading = false;
            // set @track contacts variable with return contact list from server  
            console.log('this.inputRecord:::'+JSON.stringify(result));
            this.data = result;
        })
        .catch(error => {
            this.showSpinner = false;
            this.isLoading = false;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message,
            });
            this.dispatchEvent(event);
            // reset var with null   
            
        });
    }

    navigateToRecordViewPage(event) {
        let record = event.detail.row;
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: record.Id,
                //objectApiName: 'Lead', // objectApiName is optional
                actionName: 'view'
            }
        });
    }
    /*
    searchValue = '';
 
    // update searchValue var when input field value change
    searchKeyword(event) {
        this.searchValue = event.target.value;
        //console.log('searchValue>>>'+searchValue);
    }
 
    // call apex method on button click 
    handleSearchKeyword() {
        
        if (this.searchValue !== '') {
            getContactList({
                    searchKey: this.searchValue
                })
                .then(result => {
                    // set @track contacts variable with return contact list from server  
                    alert('some value');
                    this.contactsRecord = result;
                })
                .catch(error => {
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                    // reset contacts var with null   
                    this.contactsRecord = null;
                });
        } else {
            // fire toast event if input field is blank
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Search text missing..',
            });
            this.dispatchEvent(event);
        }
    }
    */
}