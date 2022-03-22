/**
 * @author Tushar Kumawat [CriticalRiver]
 * @date 5 March 2022
 * @description Custom datatable component
 * @version 1.0
 */
import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CustomDatatable extends NavigationMixin(LightningElement) {
    @api tableData;
    @api columns;
    @api recordsPerPage = 10;
    @api hideCheckboxColumn = false;
    @api action = {};
    @api recordId = '';

    @track pageData = [];
    @track pageNumber = 1;
    @track maxPageNumber = 0;
    @track showPrevious = false;
    @track showNext = false;
    @track showPagination = false;
    
    connectedCallback() {
        this.maxPageNumber = parseInt(this.tableData.length / this.recordsPerPage);
        
        if(this.maxPageNumber * this.recordsPerPage < this.tableData.length) {
            this.maxPageNumber++;
        }

        this.showPagination = (this.maxPageNumber > 0);
        this.getRecords();
    }

    next() {
        this.pageNumber++;
        this.getRecords();
    }

    previous() {
        this.pageNumber--;
        this.getRecords();
    }

    getRecords() {
        this.pageData = this.tableData.slice((this.pageNumber - 1) * this.recordsPerPage, this.pageNumber * this.recordsPerPage);
        this.checkPrevious();
        this.checkNext();
    }

    checkPrevious() {
        this.showPrevious = (this.pageNumber > 1);
    }

    checkNext() {
        this.showNext = (this.pageNumber < this.maxPageNumber);
    }

    executeRowAction(event) {
        const action = event.target.dataset.action;
        const recordId = event.target.dataset.id;
        
        switch(action) {
            case 'show_details':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: recordId,
                        actionName: 'view'
                    }
                });
            break;
        }
    }

    toggleDropDown(event) {
        console.log('event ::: ', event);
        const elementId = event.target.getAttribute("data-id");
        console.log('::: ', typeof (this.template.querySelector("[data-dropdown='"+elementId+"']").classList));
        this.template.querySelector("[data-dropdown='"+elementId+"']").classList.remove('dropDownCss');
        console.log('::: ', this.template.querySelector("[data-dropdown='"+elementId+"']").classList.contains('dropDownCss'));
        console.log('::: ', this.template.querySelector("[data-dropdown='"+elementId+"']").classList.includes('dropDownCss'));
        if(this.template.querySelector("[data-dropdown='"+elementId+"']").classList.includes('dropDownCss')) {
            this.template.querySelector("[data-dropdown='"+elementId+"']").classList.remove('dropDownCss');
        }
        else {
            this.template.querySelector("[data-dropdown='"+elementId+"']").classList.add('dropDownCss');
        }
    }

    rowClicked(event) {
        this.recordId = event.currentTarget.getAttribute("data-id");
        this.dispatchEvent(new CustomEvent('rowclick', { 
            recordId : this.recordId
        }));
    }
}