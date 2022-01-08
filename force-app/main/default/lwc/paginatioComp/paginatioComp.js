import {wire, LightningElement } from 'lwc';
import getAccounts from '@salesforce/apex/paginationApexClass.retrieveAccount';
const columns = [
    {label: 'Name', fieldName: 'Name'}
];


export default class PaginatioComp extends LightningElement {
    
    //private variables
    accountList = [];
    columns = columns;
    dataLimit = 5;//pagination only applies only if there are more than 5 data.
    dataStorage= [];
    tempStorage= [];
    endPoint=4;  
    startPoint=0;
    trackRecordCounter=1;
    @wire(getAccounts)
    wiredAccountList(value){
        console.log('----------result--------',value);

        const {data,error} = value; //destructuring the values
        if(data){
            this.accountList = data;
            this.dataStorage =  data;
            if(this.accountList.length > this.dataLimit){
                //show prev/next
                //doing pagination
               this.prepareRecordsForNext();  
                
            }
        }
       
    }

    //navigate to next page
    goToNextPage(){
        console.log('--->')
        this.prepareRecordsForNext();
        
    }
    //Navigate to prev page
    gotoPrePage(){
        
        let getRecordId = this.tempStorage[0].Id;
        let index = this.accountList.findIndex(x=>x.Id==getRecordId);
        //prevent navigating to the prev record.
        if(index!=0){
            this.endPoint = index-1;
            this.startPoint = index - 5;
            this.tempStorage = [];
            this.prepareRecordsForPrev();
        }

    }

    //checking the records
    prepareRecordsForNext(){

        console.log('-------------prepareRecords--------------------')
        if(this.endPoint !=this.accountList.length-1){
            if(this.tempStorage.length!=0){
                let lastAccId  =this.tempStorage[this.tempStorage.length-1].Id;
                let index = this.accountList.findIndex(x=>x.Id==lastAccId);
                this.startPoint = index+1;
                this.endPoint = index+5;
                this.tempStorage=[];   
            }
            for(var i=this.startPoint;i<=this.endPoint;i++){
                if(this.accountList[i] != undefined)
                this.tempStorage.push(this.accountList[i]);
            }
            this.dataStorage = this.tempStorage;
        }
    }

    prepareRecordsForPrev(){
        console.log('-------------prepareRecords--------------------');
        for(var i=this.startPoint;i<=this.endPoint;i++){

            if(this.accountList[i] != undefined)
            this.tempStorage.push(this.accountList[i]);
        }
        this.dataStorage = this.tempStorage;
        console.log('tempStorage',this.tempStorage)
    }
    
}