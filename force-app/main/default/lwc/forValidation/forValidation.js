import { LightningElement, track } from 'lwc';

export default class SimpleCalculator extends LightningElement {
  @track firstNumber;
  @track secondNumber;
  @track currentResult;
  @track operatorUsed;

  

 
  onNumberChange(event) {
    //Getting input field name
    const inputFieldName = event.target.name;
    if (inputFieldName === "firstName") {
      //value of first number has changed, modifying the property value
      this.firstNumber = event.target.value;
    } else if(inputFieldName === "secondName") {
      //value of second number has changed, modifying the property value
      this.secondNumber = event.target.value;
    }
  }

  
  onAdd() {
    this.currentResult = parseInt(this.firstNumber) + parseInt(this.secondNumber);
    this.operatorUsed = '+';
   
  }
 
  onSub() {
    this.currentResult = parseInt(this.firstNumber) - parseInt(this.secondNumber);
    this.operatorUsed = '-';
   
  }
  
  onMultiply() {
    this.currentResult = parseInt(this.firstNumber) * parseInt(this.secondNumber);
    this.operatorUsed = '*';
    
  }
 
  onDivide() {
    this.currentResult = parseInt(this.firstNumber) / parseInt(this.secondNumber);
    this.operatorUsed = '%';
  
  }

 
  get result() {
    
    if(this.currentResult === 0 || this.currentResult){
      return `Result of ${this.firstNumber} ${this.operatorUsed} ${this.secondNumber} is ${this.currentResult}`;
    } else{
      return '';
    }
  }
}