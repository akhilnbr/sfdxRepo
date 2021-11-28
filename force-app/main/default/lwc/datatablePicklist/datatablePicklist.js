/*
MIT License

Copyright (c) 2020 Playground, https://www.playg.app

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import { LightningElement, api,wire, track } from 'lwc';
// import baseNavigation  from 'lightning/datatableKeyboardMixins';
// import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import Current_Customer from '@salesforce/schema/Portfolio_Company_Customers__c.Current_Customer__c';
// import template from './datatablePicklist.html';

//  baseNavigation(LightningElement) 
export default class DatatablePicklist extends  LightningElement {
    @track picklist
    @api label;
    @api placeholder;
    @api options;
    @api value;
    @api context;
    @track show = false;
    // render() {
    //     return template;
    // }

    // areDetailsVisible = false;
    // @wire(getPicklistValues, { recordTypeId: '0120W0000026BtjQAE', fieldApiName: Current_Customer })
    // wiredPickListValues(data,error){
    //     if (data){
    //         console.log('picklist values ',data.Values);
    //         this.picklist = data.Values;
    //         this.error = undefined;
    //     }
    //     else if(error){
    //         this.error = error;
    //         this.picklist = undefined;
           
    //     }
    // }

    handleChange(event) {
        //show the selected value on UI
        this.value = event.detail.value;
        console.log('51',event.detail.value);
        this.picklist = this.value; 
        //console.log('52>>>',event.target.checked);
        //this.areDetailsVisible = event.target.checked;
       // console.log('52>>>',this.areDetailsVisible);
        //console.log('52>>>',this.context);
        //fire event to send context and selected value to the data table
       
        this.dispatchEvent(new CustomEvent('edit', {
            composed: true,
            bubbles: true,
            cancelable: true,
            
            detail: {
                data: { context: this.context, value: this.value }
            }
        }));
        console.log('This.Value',this.value);
    }
    fireEditRow() {

        console.log('inside of button');
        this.show = true;
        console.log('this.show',this.show);
    }
    showEditRow(){
        this.show = false;
    }

}