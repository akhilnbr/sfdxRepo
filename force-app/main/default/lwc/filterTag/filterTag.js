import { LightningElement } from 'lwc';

export default class FilterTag extends LightningElement {
    
    tagsApplied=[]; 
    handleselectTag(e){
        console.log('HEYAAAA')
       if(e.detail.add){
        tagsApplied.push(e.detail);
        this.template(c-customlwclookup).applyTag(this.tagsApplied);
       }

    }

    handleRemove(ev){
        console.log(ev);

    }
}