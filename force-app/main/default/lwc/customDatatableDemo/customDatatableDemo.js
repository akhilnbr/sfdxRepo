import { LightningElement, wire, track,api } from 'lwc';
import fetchCustomerdetails from '@salesforce/apex/CustomDataTable.fetchCustomerdetails';

import { updateRecord } from 'lightning/uiRecordApi';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CustomDatatableDemo extends LightningElement {

    @track data = [];
    //@api show = false;
   // @track size;
    @wire(fetchCustomerdetails)
   // wiredCustomerResult;
    wiredResult({error, data}) {
        this.wiredCustomerResult = data;
        this.columns = [
            { label: 'Portfolio Company ', fieldName: 'Name',sortable: true,cellAttributes: { alignment: 'left' },editable: true/*,initialWidth: 70editable: true*/ },
            { label: 'Savings Discount', fieldName: 'AnnualRevenue', type: 'Currency',cellAttributes: { alignment: 'left' },sortable: true,editable: true },
            {
                label: 'Current Customer', fieldName: 'Active__c', type: 'picklist',editable: true, typeAttributes: {
                     options: [
                        { label: 'Yes', value: 'Yes' },
                        { label: 'No', value: 'No' }
                        
                    ], // list of all picklist options
                    value: { fieldName: 'Active__c' } // default value for picklist
                    // context: { fieldName: 'Current_Customer__c' } // binding account Id with context variable to be returned back
                }
            },
            { label: 'Redeemed Discount', fieldName: 'AccountSource', type: 'picklist',editable: true, typeAttributes: {
                     options: [
                        { label: 'Yes', value: 'Yes' },
                        { label: 'No', value: 'No' }
                        
                    ], // list of all picklist options
                    value: { fieldName: 'AccountSource' }// default value for picklist
                    //, context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
                }
            }
        ];
        if(data != undefined) {
            console.log('data: '+data);
            
            this.data = JSON.parse(JSON.stringify(data));
            console.log('47>>>',JSON.parse(JSON.stringify(data)));
            console.log('57>>>',this.data.length);
            //this.size = this.data.length;
            //console.log('59>>>',size);
            var res = this.data;
            res.sort((a, b) => (a.Company_Name__c > b.Company_Name__c) ? 1 : -1);
            console.log('this.data: '+res);
            console.log('this.data: '+this.data);
         //   this.cc = this.data.Current_Customer__c;
           // console.log('this.cc: '+this.cc.Current_Customer__c);
           // datalist.push(data);
            //console.log('datalist',JSON.stringify(datalist))
            this.error = undefined;
        } else if(error) {
            console.log('>>>>>>>>');
            this.error = error;
            console.log('>>>error>>>>>',error);
            this.data = undefined;
        }

    }
    // handleEdit(event){
    //     this.show = true;
    //     console.log('>>>>>>>>78'+this.show);
    // }
    handleSave(event) {
        //console.log('draftValues61',draft-values);
        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            console.log('fields64',fields);
            return { fields };
        });
        console.log('recordInputs67',recordInputs);
        //console.log('recordInputs68',recordInputs.Id);
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        console.log('promises69',promises);
        Promise.all(promises).then(PCC => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record Updated',
                    variant: 'success'
                })
            );
             // Clear all draft values
             this.draftValues = [];
   
             // Display fresh data in the datatable 
            //  refresh() {
            //     return refreshApex(this.data); 
            // }
            console.log('96');
            refreshApex(this.data);

            //console.log('85>>>>>>>>>',refreshApex(this.data));
            //return refreshApex(this.data);
            console.log('99');
           //window.realod()
          // eval("$A.get('e.force:refreshView').fire();");
        }).catch(error => {
            // Handle error
            console.log('Error',error);
        });
    }

    picklistChanged(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        console.log('dataRecieved',dataRecieved);
        this.data.forEach(element => {
            if (element.Id === dataRecieved.context) {
                console.log('element.Id',element.Id);
                console.log('dataRecieved.context',dataRecieved.context);
                element.StageName = dataRecieved.value;
            }
            else{
                console.log('element.Id');
            }
        });
    }
    //sorting Function
    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.data));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.data = parseData;

    }
}