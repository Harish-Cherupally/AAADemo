import { LightningElement, track } from 'lwc';
export default class First_LWC extends LightningElement {
     @track greeting = 'First LWC';
    changeHandler(event) {
        console.log('hello'+event.target.value);
        this.greeting = event.target.value;

        const value = 
            [{
              "grade": 100,
              "interval": {
                "start": "2022-01-10 08:00:00",
                "finish": "2022-01-10 10:00:00"
              }
            },
            { "grade":100, "interval": { "start": "2022-02-07 15:00:00", "finish": "2022-02-07 17:00:00" } }];
        const result = JSON.stringify(value);
        /*var jsonString= json.parse(json.stringify([
            {
              "grade": 100,
              "interval": {
                "start": "2022-01-10 08:00:00",
                "finish": "2022-01-10 10:00:00"
              }
            }
        ]));*/
        const response=JSON.parse(result);
        console.log('jsonString....'+ result[0]);
        console.log('jsonString....'+ result);
        console.log('response....'+ response);
        console.log('response 0....'+ response[0].grade);
        console.log('response....'+ response.length);
        var jsonlength=response.length;
        for(var i=0; i<jsonlength; i++){
        console.log('response....'+ response[i].grade);
        console.log('hello');
        }
        //console.log('jsonString....'+ jsonString.interval.finish);
    }
}