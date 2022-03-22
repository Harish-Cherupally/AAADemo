import { LightningElement, api, track } from 'lwc';

export default class CellValue extends LightningElement {
    @api tableRow;
    @api column;

    @track data;

    connectedCallback() {
        this.data = this.tableRow[this.column.fieldName];
    }
}