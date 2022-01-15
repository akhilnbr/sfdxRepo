import { LightningElement, api } from 'lwc';

export default class LoadPageSize extends LightningElement {

    size='5';
    page='1';
    @api listOfPages;
    get pagesize(){
        return [
            {label:'5', value:'5' },
            {label:'10', value:'10'},
            {label:'15' , value:'15'}
        ]
    }

    renderedCallback(){
        if(this.listOfPages && typeof this.listOfPages != 'object')
        this.listOfPages = JSON.parse(this.listOfPages);
        console.log(this.listOfPages);

    }
   //sending selected page size the parent component
    changeListSize(e){
        this.page = '1';
        this.size =  e.detail.value;
        console.log('changeListSize'); 
        const event = new CustomEvent('selectedsize',{
            detail :this.size
        });
        this.dispatchEvent(event);
    }
    //sending selected page the parent component
    changePage(e){
        this.page= e.detail.value;
        const event =  new CustomEvent('selectpage',{
            detail:this.page
        })
        this.dispatchEvent(event);
    }
}