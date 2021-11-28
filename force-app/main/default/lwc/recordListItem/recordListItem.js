import { LightningElement, api, track } from 'lwc';

export default class RecordList extends LightningElement {
    /* Public Property to pass the single record & iconname */
    @api rec;
    @api iconname = 'standard:account';
    @track isPublic = false;
    @track isPrivate = false;
    @track isWorkflow = false;

    connectedCallback() {
        // if (this.rec.RecordType.Name == 'Company') {
        //     this.iconname = 'utility:world';
        //     this.isPublic = true;
        //     this.isPrivate = false;
        //     this.isWorkflow = false;
        // } else if (this.rec.RecordType.Name == 'Private') {
        //     this.iconname = 'utility:lock';
        //     this.isPublic = false;
        //     this.isPrivate = true;
        //     this.isWorkflow = false;
        // } else if (this.rec.RecordType.Name == 'Workflow') {
        //     this.iconname = 'utility:flow_alt';
        //     this.isPublic = false;
        //     this.isPrivate = false;
        //     this.isWorkflow = true;
        // }
    }

    handleSelect(  ) {
        let selectEvent = new CustomEvent('select',{
            detail : { selRec : this.rec }
        });
        this.dispatchEvent( selectEvent );
    }

    get itemClass() {
        let itemClass = "slds-listbox__item slds-p-top_xx-small";
        if (this.rec.highlight == true) {
            itemClass += " highlighted";
        }
        return itemClass;
    }

    get iconClass() {
        let iconClass = "";
        if (this.rec.highlight == true) {
            iconClass += "highlighted-icon";
        }
        return iconClass;
    }

    handleRemove(  ) {
        let selectEvent = new CustomEvent('select',{
            detail : { selRec : undefined }
        });
        this.dispatchEvent( selectEvent );
    }
}