import { LightningElement, api, track } from 'lwc';
import userId from '@salesforce/user/Id';
import searchRecords from '@salesforce/apex/TagController.searchRecords';
import getRecents from '@salesforce/apex/TagController.getRecents';
export default class CustomLookupLWC extends LightningElement {

    /* public property */
    /* these public property will be used when using this component inside other component for the lookup functionality */
    /* objectName is the name of the Object which is parent either master-detail or lookup */
    /* fieldName is the field of parent object in which text needs to be searched */
    /* iconname - icon to display in the list and after selection of the record */
    /* label - to show the label for the lookup */
    /* parentidfield - the apiname of lookup/matser-detail in the child object this field is useful to indentify which parent record has been select if there are multiple lookup for a single child record */
    @api objectName = 'Account';
    @api fieldName  = 'Name';
    @api iconname   = 'standard:record';
    @api label      = 'Account';
    @api parentidfield = 'AccountId';
    @api placeholder;
    @track appliedTags;
    loggedInUserId = userId;
    searchTerm;
    addTagLabel;

    @api
    focusInput(){
        console.log('customLookupLWC focus input');
        this.template.querySelector('c-custom-search').focusSearch();
    }

    @api
    setAppliedTags(tags) {
        console.log(tags);
        let tagNames = [];
        for (let t in tags) {
            tagNames.push(tags[t].label);
        }
        this.appliedTags = tagNames;
        console.log(this.appliedTags);
    }

    /* private property */
    @track records;
    @track selectedRecord;
    @track highlightedIndex = 0;

    connectedCallback() {
    }

    handleSearch(event) {
        this.searchTerm = event.detail.value;

        if (this.searchTerm == undefined || this.searchTerm == '' || this.searchTerm.length < 2) {
            this.selectedRecordId = undefined;
            this.records = undefined;
            this.searchTerm = undefined;
            let recordsFoundEvent = new CustomEvent('recordsfound',{
                detail : {
                    searchTerm : '',
                    numRecords : 0,
                    records: []
                }
            });
            this.dispatchEvent(recordsFoundEvent);
        }

        if ( this.searchTerm && this.searchTerm.length >= 2 ) {
            searchRecords({
                objName   : this.objectName,
                fieldName : this.fieldName,
                searchKey : this.searchTerm
            })
            .then( data => {
                if ( data ) {
                    let parsedResponse = JSON.parse(data);
                    let searchRecordList = parsedResponse[0];
                    for (let r in searchRecordList) {
                        //searchRecordList[r].Type__c == 'Private' &&
                        if (( searchRecordList[r].CreatedById != this.loggedInUserId) || this.appliedTags.includes(searchRecordList[r].Name)) {
                            searchRecordList.splice(r,1);
                        }
                    }
                    if (searchRecordList.length == 0) {
                        let recordsFoundEvent = new CustomEvent('recordsfound',{
                            detail : {
                                searchTerm : this.searchTerm,
                                numRecords : 0,
                                records : null
                            }
                        });
                        this.dispatchEvent(recordsFoundEvent);
                    }
                    for ( let i=0; i < searchRecordList.length; i++ ) {
                        let record = searchRecordList[i];
                        record.Name = record[this.fieldName];
                    }
                    if (searchRecordList.length > 0) {
                        this.records = searchRecordList;
                        this.records[this.highlightedIndex].highlight = true;
                    } else {
                        this.addTagLabel = `Create '${this.searchTerm}' tag`;
                        this.records = undefined;
                    }
                    let recordsFoundEvent = new CustomEvent('recordsfound',{
                        detail : {
                            searchTerm : this.searchTerm,
                            numRecords : this.records == undefined ? 0 : this.records.length,
                            records: searchRecordList
                        }
                    });
                    this.dispatchEvent(recordsFoundEvent);
                }
            })
            .catch( error => {
                window.console.log(' error ', error);
            });
        }
    }

    showRecents(event) {
        console.log(event);

        getRecents({
            appliedTagNames : this.appliedTags
        }).then( data => {
            if ( data ) {
                let parsedResponse = JSON.parse(data);
                let searchRecordList = parsedResponse[0];
                for (let r in searchRecordList) {
                    if (this.appliedTags.includes(searchRecordList[r].Name)) {
                        searchRecordList.splice(r,1);
                    }
                }
                if (searchRecordList.length == 0) {
                    let recordsFoundEvent = new CustomEvent('recordsfound',{
                        detail : {
                            searchTerm : null,
                            numRecords : 0,
                            records : null
                        }
                    });
                    this.dispatchEvent(recordsFoundEvent);
                }
                for ( let i=0; i < searchRecordList.length; i++ ) {
                    let record = searchRecordList[i];
                    record.Name = record[this.fieldName];
                }
                if (searchRecordList.length > 0) {
                    console.log(searchRecordList);
                    this.records = searchRecordList;
                    this.records[this.highlightedIndex].highlight = true;
                } else {
                    this.addTagLabel = `Create '${this.searchTerm}' tag`;
                    this.records = undefined;
                }
                let recordsFoundEvent = new CustomEvent('recordsfound',{
                    detail : {
                        searchTerm : null,
                        numRecords : this.records == undefined ? 0 : this.records.length,
                        records: searchRecordList
                    }
                });
                this.dispatchEvent(recordsFoundEvent);
            }
        })
        .catch( error => {
            window.console.log(' error ', error);
        });
    }

    handleSelect(event) {
        var selectedVal = event.detail.selRec;
        this.selectedRecord =  selectedVal;
        let finalRecEvent = new CustomEvent('select',{
            detail : { selectedRecordId : this.selectedRecord.Id, parentfield : this.parentidfield, add : true}
        });
        this.dispatchEvent(finalRecEvent);
        this.handleRemove();
    } 

    handleRemove() {
        this.selectedRecord =  undefined;
        this.records = undefined;
        this.searchTerm = '';
        let recordsFoundEvent = new CustomEvent('recordsfound',{
            detail : {
                searchTerm : this.searchTerm,
                numRecords : 0,
                records : null
            }
        });
        this.dispatchEvent(recordsFoundEvent);
        let finalRecEvent = new CustomEvent('select',{
            detail : { selectedRecordId : undefined, parentfield : this.parentidfield, add : false }
        });
        this.dispatchEvent(finalRecEvent);
    }

    handleKeyPress(evt) {
        console.log(evt);
    }
    
    handleFocusList(event) {
        console.log('key==>'+event.detail);
        console.log('highlighted index==>'+this.highlightedIndex);
        if (event.detail == 'ArrowUp' ) {
            if (this.highlightedIndex == null) {
                this.highlightedIndex = this.records.length-1;
                this.records[this.highlightedIndex].highlight = true;  
                let highlightButtonEvent = new CustomEvent('highlightbutton',{
                    detail: false
                });
                this.dispatchEvent(highlightButtonEvent);      
            } else if (this.highlightedIndex > 0) {
                this.records[this.highlightedIndex].highlight = false;
                this.highlightedIndex--;
                this.records[this.highlightedIndex].highlight = true;
            }
        } else if (event.detail == 'ArrowDown') {
            if (this.highlightedIndex == null) {

            } else if (this.highlightedIndex == 0 && this.records == undefined) {
                let highlightButtonEvent = new CustomEvent('highlightbutton',{
                    detail: true
                });
                this.dispatchEvent(highlightButtonEvent);                
            } else if (this.highlightedIndex < this.records.length-1) {
                this.records[this.highlightedIndex].highlight = false;
                this.highlightedIndex++;
                this.records[this.highlightedIndex].highlight = true;
            } else if (this.highlightedIndex == this.records.length-1) {
                this.records[this.highlightedIndex].highlight = false;
                this.highlightedIndex = null;
                let highlightButtonEvent = new CustomEvent('highlightbutton',{
                    detail: true
                });
                this.dispatchEvent(highlightButtonEvent);
            } 
        } else if (event.detail == 'Enter') {
            if (this.highlightedIndex == null || (this.highlightedIndex == 0 && this.records == undefined)) {
                let addTagEvent = new CustomEvent('addtag',{});
                this.dispatchEvent(addTagEvent);
            } else if (this.highlightedIndex != null) {
                this.handleSelect({detail:{selRec:this.records[this.highlightedIndex]}});
            } 
        }
    }

    resetHighlighting() {
        this.highlightedIndex = 0;
        let highlightButtonEvent = new CustomEvent('highlightbutton',{
            detail: false
        });
        this.dispatchEvent(highlightButtonEvent);
    }
}