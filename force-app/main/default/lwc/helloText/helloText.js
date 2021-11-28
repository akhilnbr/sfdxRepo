import { LightningElement,track } from 'lwc';

export default class HelloText extends LightningElement {
    
    greeting='world';
    handleChange(event){
        console.log('ve',event.target.value)
        this.greeting = event.target.value;
    }
}