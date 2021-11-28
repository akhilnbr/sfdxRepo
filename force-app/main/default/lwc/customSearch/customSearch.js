import { LightningElement, api, track } from 'lwc';

export default class CustomSearch extends LightningElement {

    @track searckKeyword;
    @api isrequired = 'false';
    @api searchLabel = 'Search Account';
    @api showLabel   = 'true';
    @api placeholder;

    focusSearch(e) {
        let key = e.key;
        console.log(key);
        if (key == 'Meta' || key == 'Control') {
            this.controlButtonHeld = true;
        }
        if (this.controlButtonHeld == true && key == 'u') {
            this.template.querySelector('lightning-input').focus();
        }
    }

    connectedCallback() {
        console.log('customSearch connectedCallback');
        window.addEventListener('keydown', this.focusSearch.bind(this));

        window.addEventListener('keyup', function(e) {

        });
    }

    /* Check the isrequired prop is true then set the prop to true*/
    renderedCallback() {
        if ( this.isrequired === "false" )
            return;
        if ( this.isrequired === "true") {
            let picklistInfo = this.template.querySelector('lightning-input');
            picklistInfo.required = true;
            this.isrequired = "false";
        }
        
    }

    handleChange(event) {
        var keyword = event.target.value;
        /* Create & dispatch the event to parent component with the search keyword */
        let searchEvent = new CustomEvent('search',{
            detail : { value : keyword }
        });
        this.dispatchEvent(searchEvent);
        
    }

    handleKeyPress(event) {
        var key = event.key;
        if (key == 'ArrowDown' || key == 'ArrowUp' || key == 'Enter') {
            event.preventDefault();
            let focusListEvent = new CustomEvent('focuslist',{
                detail : key
            });
            this.dispatchEvent(focusListEvent);
        }
    }

    showRecents(event) {
        let showRecentsEvent = new CustomEvent('showrecents', {

        });
        this.dispatchEvent(showRecentsEvent);
    }
}