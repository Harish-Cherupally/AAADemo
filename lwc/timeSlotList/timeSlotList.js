import { LightningElement, track, api, wire } from 'lwc';
//import getTimeZone from '@salesforce/apex/TimeSlotJSON_FromLWC.getOPTimeZone';
//import USER_TIMEZONE from '@salesforce/i18n/"America/New_York"';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';


const ITEM_CLASS = 'slds-item';
const DAY_SPACING_CLASS = 'slds-p-top_small';
const SELECTED_CLASS = 'selected';
const DOT = '.';
const VALIDATION_MESSAGE = 'Please select a slot.'
export default class TimeSlotList extends LightningElement {

@track slotJSON;
 @track data;
@track error;
@api slotJSON1;
@api slotJSON2;
@track startdate;
@track finishtime;
@api timeZone;
//@wire(getTimeZone, { operatingHoursId: '$timeZone' }) operatingTimeZone;
@api error;

    @api startTime;
    @api endTime;
@track showAddSlots;
    //@api slots = [];
    @track selectedSlot;
  showInGroupsOf = 4;
    numberToDisplay = this.showInGroupsOf;
connectedCallback(){
  
       console.log('entered connected callback>> '+this.slotJSON2.length);
      
     // const jsonvalue = this.slotJSON2;
            
        
        //const jsonParsed = JSON.parse(jsonvalue);
       // this.slotJSON2 = jsonParsed;
        
        let tempSlots = [];

        for (let i=0; i<this.slotJSON2.length; i++) {
            let jsonSlotTemp = this.slotJSON2[i];
            
            let tempSlot = {
                index: i,
                firstInDay: i===0 || new Date(this.slotJSON2[i].start).getUTCDay() !== new Date(this.slotJSON2[i-1].start).getUTCDay(),
                get spaceClass() {                    
                     return this.firstInDay && i ? DAY_SPACING_CLASS : null
                }                                
            }            
            console.log('this.slotJSON2[i].start '+this.slotJSON2[i].start);
            console.log('this.slotJSON2[i].finish >> '+this.slotJSON2[i].finish);
             //var startdateFormatted = new Date(this.slotJSON2[i].start);
             
           //var finishtimeformatted = new Date(this.slotJSON2[i].finish);
          //console.log('startdateFormatted>> '+new Date(this.slotJSON2[i].start).getTimezone());
           //console.log('finishtimeformatted>> '+new Date(this.slotJSON2[i].finish).getTimezoneOffset());
           //this.slotJSON2[i].start = startdateFormatted;
           //this.slotJSON2[i].finish = finishtimeformatted;
           
            tempSlots.push(Object.assign(tempSlot, this.slotJSON2[i]));                          
        }        
        this.slotJSON2 =tempSlots;
        
}  

 get displayedSlots() {
        return this.slotJSON2.slice(0, this.numberToDisplay);
    }

 /*get userTimezone() {
        return USER_TIMEZONE;
    }*/

get selectedSlotIndex() {
        return this._selectedSlotIndex;
    }
    set selectedSlotIndex(value) {
        this._selectedSlotIndex = value;
        this.selectedSlot = value ? this.slotJSON2[value] : null;
    }
    _selectedSlotIndex;

    get showAddSlots() {
        return this.displayedSlots.length < this.slotJSON2.length;
    }

    @api
    validate() {
        if (this.selectedSlot) {
            return { isValid: true };
        } else {
            return { 
                isValid: false ,
                errorMessage: VALIDATION_MESSAGE
            };
        }
    }

    handleItemClick(event) {
        let index = event.currentTarget.dataset.index;
        if (this.selectedSlotIndex === index)
            this.selectedSlotIndex = null;
        else
            this.selectedSlotIndex = index;

        for (let item of this.template.querySelectorAll(DOT + ITEM_CLASS)) {
            if (item.dataset.index === this.selectedSlotIndex)
                item.classList.add(SELECTED_CLASS);
            else
                item.classList.remove(SELECTED_CLASS);
        }
        //this.selectedSlot = this.slotJSON1[index];
        console.log('this.selectedSlot.start'+this.slotJSON2[0].start);
        console.log('this.selectedSlot.finish > '+this.slotJSON2[0].finish);
        console.log('start time >> '+this.selectedSlot.start);
        console.log('end time >> '+this.selectedSlot.finish);
        this.dispatchEvent(new FlowAttributeChangeEvent('startTime', this.selectedSlot.start));
        this.dispatchEvent(new FlowAttributeChangeEvent('endTime', this.selectedSlot.finish));
        //this.dispatchEvent(new FlowAttributeChangeEvent('endTime', this.slotJSON1[0].finish));
        

    }

    showMoreSlots() {
        this.numberToDisplay += this.showInGroupsOf;
    }

}