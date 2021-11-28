import { LightningElement } from 'lwc';

export default class GlobalTagComp extends LightningElement {
    tagsApplied=[]; 
    tagsAdded = false;
    //iconname
    iconname   = 'standard:record';
    handleAccountSelection(e){
        console.log('HEYAAAA',e.detail.value.selectedRecordId);
        console.log('HEYAAAA',e.detail.value.add);
        console.log('HEYAAAA',e.detail.value.selectedRecord);
       if(e.detail.value.add){
        this.tagsApplied.push({Name:e.detail.value.selectedRecord,
                                Id:e.detail.value.selectedRecordId});
        //this.template.querySelector('c-customlwclookup').callchildmethod(this.tagsApplied);
       }
       this.tagsAdded  = false;
       this.tagsAdded  =true;

    }



    handleRemove(ev){
        console.log(ev);

    }
    get tagsAddedOrRemoved(){
        
       return this.tagsAdded;
    }
}