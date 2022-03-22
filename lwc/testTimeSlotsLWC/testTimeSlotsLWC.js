import { LightningElement, track} from 'lwc';

export default class TestTimeSlotsLWC extends LightningElement {
    @track name;


    /*connectedCallback(){
        //do something
        alert('hi');
        console.log('jsonString...test call back.');
        /*var jsonString= json.parse(json.stringify([
            {
              "grade": 100,
              "interval": {
                "start": "2022-01-10 08:00:00",
                "finish": "2022-01-10 10:00:00"
              }
            }
        ]));
        console.log('jsonString....', jsonString[1]);
        console.log('jsonString....', jsonString.interval.finish);



   }  */  

   nameChange(event){
       console.log('123');
        this.name = event.target.value;
        console('name...'+this.name);

        /*var jsonString= json.parse(json.stringify([
                {
                "grade": 100,
                "interval": {
                    "start": "2022-01-10 08:00:00",
                    "finish": "2022-01-10 10:00:00"
                }
                }
        ]));*/
        //console.log('jsonString....', jsonString[1]);
        //console.log('jsonString....', jsonString.interval.finish);
    }
}