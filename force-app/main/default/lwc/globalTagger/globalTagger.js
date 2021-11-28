import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import userId from '@salesforce/user/Id';
import loadAccountTags from '@salesforce/apex/TagController.getObjectTags';

export default class Basic extends NavigationMixin(LightningElement) {
    @api recordId;
    loggedInUserId = userId;
    tags;
    error;
    queryTerm;
    searchTerm;
    searchTimer;
    privateIcon = 'utility:lock';
    publicIcon = 'utility:world';
    workflowIcon = 'utility:strategy';
    @track noRecordsFound = false; // add button should be available when searchTerm.length >= 2 and no exact match found
    @track showAddTagButton = false;
    @track createTagLabel;
    @track createTagVariant = 'neutral';
    @track controlButtonHeld = false;

    @wire(loadAccountTags, { lookupFieldApiName: 'Company__c', recordId: '$recordId' })
    wiredTags({ error, data }) {
        if (data) {
            console.log(data);
            let tags = [];
            for (let i in data) {
                let iconName;
                if (data[i].RecordType.Name == 'Company') {
                    iconName = this.publicIcon;
                } else if (data[i].RecordType.Name == 'Workflow') {
                    iconName = this.workflowIcon;
                } else {
                    iconName = this.privateIcon;
                }
                let t = {
                    type: 'icon',
                    iconName: iconName,
                    label: data[i].Name,
                    name: data[i].Id,
                    variant: 'circle',
                    alternativeText: 'Tagged with ' + data[i].Name,
                    isLink: true,
                    href: this.goToTag(data[i].Name)
                };
                tags.push(t);       
            }
            this.tags = tags;
            this.template.querySelector('c-custom-lookup-l-w-c').setAppliedTags(this.tags);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.tags = undefined;
        }
    }

    connectedCallback() {

    }

    handleRecordsFound(evt) {
        let exactMatch = false;
        if (evt.detail != null) {
            if (evt.detail.searchTerm) {
                this.searchTerm = evt.detail.searchTerm;
            } else {
                this.searchTerm = null;
            }
            this.createTagLabel = `Create new tag '${this.searchTerm}'`;
            if (evt.detail.numRecords == 0) {
                this.noRecordsFound = true;
                this.createTagLabel = `Create new tag '${this.searchTerm}'`;
                this.records = undefined;
            } else {
                if (evt.detail.searchTerm != null) {
                    for (let i in evt.detail.records) {
                        if (evt.detail.records[i].Name.toLowerCase() == evt.detail.searchTerm.toLowerCase()) {
                            exactMatch = true;
                            break;
                        }
                    }
                }
            }
            if (evt.detail.searchTerm != null) {
                if (evt.detail.searchTerm.length >= 2 && exactMatch == false) {
                    this.showAddTagButton = true;
                } else {
                    this.showAddTagButton = false;
                }
            }
        }
    }

    handleSelection(evt) {
        if (evt.detail.add) {
            insertTag({
                recordId : this.recordId,
                tagId: evt.detail.selectedRecordId
            }).then(response => {
                console.log(response);
                let iconName;
                if (response.RecordType.Name == 'Company') {
                    iconName = this.publicIcon;
                } else if (response.RecordType.Name == 'Workflow') {
                    iconName = this.workflowIcon;
                } else {
                    iconName = this.privateIcon;
                }
                let newTag = {
                    type: 'icon',
                    iconName: iconName,
                    label: response.Name,
                    name: response.Id,
                    variant: 'circle',
                    alternativeText: 'Tagged with ' + response.Name,
                    isLink: true,
                    href: this.goToTag(response.Name)
                };
                this.tags = [...this.tags, newTag];
                this.template.querySelector('c-custom-lookup-l-w-c').setAppliedTags(this.tags);
            }).catch(function(error) {
                console.log(error);
            });
        } else {
            console.log('clear tag search...');
        }

    }

    createTag() {
        console.log('create tag...');
        insertNewTag({
            recordId : this.recordId,
            name: this.searchTerm
        }).then(response => {
            console.log(response);
            let iconName;
            if (response.RecordType.Name == 'Company') {
                iconName = this.publicIcon;
            } else if (response.RecordType.Name == 'Workflow') {
                iconName = this.workflowIcon;
            } else {
                iconName = this.privateIcon;
            }
            let newTag = {
                type: 'icon',
                iconName: iconName,
                label: response.Name,
                name: response.Id,
                variant: 'circle',
                alternativeText: 'Tagged with ' + response.Name,
                isLink: true,
                href: this.goToTag(response.Name)
            };
            this.tags = [...this.tags, newTag];
            this.template.querySelector('c-custom-lookup-l-w-c').setAppliedTags(this.tags);
            this.highlightButton({detail:false});
        }).catch(function(error) {
            console.log(error);
        });
    }

    goToTag(tagName) {
        /* for now clicking a tag will navigate to a pre-set report with a filter for that tag
        * this will need to be changed to:
        * (1) when on the company page, navigate to smart dash filtered for that tag
        * (2) when already on smart dash, filter the tag column for the tag
        */
        let tagReportId = '00O2D000000kKgEUAU';
        let url = '/lightning/r/Report/' + tagReportId + '/view?reportFilters=%5B%7B%22operator%22%3A%22equals%22%2C%22value%22%3A%22' + tagName + '%22%2C%22column%22%3A%22CUST_NAME%22%7D%5D';
        let reportPageRef = {
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        };
        return url;
    }

    viewAllTags() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Tag__c',
                actionName: 'home'
            },
            state: {
                filterName: 'All'
            }
        }).then(url => { window.open(url) });
    }

    handleItemRemove(evt) {
        console.log(evt.detail);
        const id = evt.detail.item.name;
        const index = evt.detail.index;
        deleteTag({
            recordId: id
        }).then(response => {
            this.tags.splice(index, 1);
            this.tags = [...this.tags];
            this.template.querySelector('c-custom-lookup-l-w-c').setAppliedTags(this.tags);
        }).catch(error => {
            console.log('Could not delete tag');
        })
    }

    handleKeyUp(evt) {
        let v = evt.target.value;
        //console.log(v);
        clearTimeout(this.searchTimer);
        this.searchTimer = setTimeout(() => {
            this.queryTerm = v;
        }, 500);
    }

    highlightButton(evt) {
        console.log(evt);
        if (evt.detail == true) {
            this.createTagVariant = 'brand';
        } else {
            this.createTagVariant = 'neutral';
        }
    }
}