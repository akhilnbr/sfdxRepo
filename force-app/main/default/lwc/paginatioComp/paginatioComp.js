import {wire, LightningElement } from 'lwc';
import getAccounts from '@salesforce/apex/Pagination.retrieveAccount';
const columns = [
    {label: 'Name', fieldName: 'Name'}
];


export default class PaginatioComp extends LightningElement {
    
    //private variables
    accountList = [];
    columns = columns;
    dataStorage= [];
    tempStorage= [];
    endPoint=4;  //defines the no of records per page
    startPoint=0;
    selectedPageSize=5;
    pageCount;
    @wire(getAccounts)
    wiredAccountList(value){
        const {data,error} = value; //destructuring the values
        if(data){
            this.accountList = data;
            this.dataStorage =  data;
            if(this.accountList.length > this.selectedPageSize){
                //doing pagination
                this.calculatePage();
                this.loadAccount();  
            }
        }
        else if(error){
            console.log('error',error)
        }
       
    }

    //navigate to next page
    goToNextPage(){
        console.log('--->')
        if(this.tempStorage.length!=0){
            let noOfRecordsPerPage= this.selectedPageSize;
            let lastAccId  =this.tempStorage[this.tempStorage.length-1].Id;
            let index = this.accountList.findIndex(x=>x.Id==lastAccId);
            if(index == this.accountList.length-1)
                return;
            this.startPoint = index+1;
            this.endPoint = index+ noOfRecordsPerPage;
            this.loadAccount();   
        }
        
    }
    //Navigate to prev page
    gotoPrePage(){
        
        let getRecordId = this.tempStorage[0].Id;
        let index = this.accountList.findIndex(x=>x.Id==getRecordId);
        //prevent navigating to the prev record.
        if(index!=0){
            let noOfRecordsPerPage= this.selectedPageSize; // defines the no of record per page
            this.endPoint = index-1;
            this.startPoint = index - noOfRecordsPerPage;
            this.loadAccount();
        }

    }

    //load account to display
    loadAccount(){
        this.tempStorage=[];
        for(var i=this.startPoint;i<=this.endPoint;i++){

            if(this.accountList[i] != undefined)
            this.tempStorage.push(this.accountList[i]);
        }
        this.dataStorage = this.tempStorage;
    }
    
    //change the number of items to dsiplay
    onPageSizeChange(event){
        this.startPoint = 0;
        this.endPoint =  parseInt(event.detail)-1; 
        this.selectedPageSize = parseInt(event.detail);
        this.loadAccount();
        this.calculatePage();
    }

    //shows the number of pages available for pagination
    calculatePage(){
        const reminder = this.accountList.length % this.selectedPageSize;
        const quotient = this.accountList.length / this.selectedPageSize;
        let totalPageCount = reminder ==0?quotient:Math.trunc(quotient)+1;
        const pageCountArray = [];
        for(let i=1;i<=totalPageCount;i++){
            pageCountArray.push(
                {label:''+i, value:''+i }
                );
        }
        this.pageCount = JSON.stringify(pageCountArray);

    }

    //calls whenever there is a change in page.
    onPageChange(e){
        const selectedPage = parseInt(e.detail);
        this.endPoint = (this.selectedPageSize * selectedPage)-1;
        this.startPoint= (this.endPoint-this.selectedPageSize)+1;
        if(this.tempStorage.length!=0){
            this.loadAccount();
        }
    }
}