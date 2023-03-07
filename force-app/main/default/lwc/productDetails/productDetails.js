import { LightningElement, track, api, wire} from 'lwc';
import getproducts from "@salesforce/apex/productDetails.getproducts";
const columns = [
  { label: "Name", fieldName: "Name",type: 'text' },
  { label: "ATM Fee In Other Currencies", fieldName: "ATM_Fee_In_Other_Currencies__c",type: 'number' },
  { label: "Car Replacemnet Cost", fieldName: "Car_Replacemnet_Cost__c",type: 'number' },
  { label: "Cost Per Calender Month", fieldName: "Cost_Per_Calender_Month__c",type: 'number' }
  
];
export default class ProductDetails extends LightningElement {
    columnData = columns;
    error;
    @api recordId;
    @track products = [];
    @wire(getproducts,{ caseId: '$recordId' })              // Get products and product prices related current case
    fetchedProducts({ error, data }) {
        if (data) {
          if (data.status == 200){ 
            let productArray =[];
            let value = JSON.parse(JSON.stringify(JSON.parse(data.data)));
            for (let i = 0; i < value.length; i++) {
                var childarray =[];
                var tempProduct ={};       
                var childValues = value[i]['Product_Prices__r']['records'];
                for (let k = 0; k < childValues.length; k++) {  // Process Product prices
                    var tempchild ={};
                    tempchild.ATM_Fee_In_Other_Currencies__c = childValues[k]['ATM_Fee_In_Other_Currencies__c'];
                    tempchild.Car_Replacemnet_Cost__c = childValues[k]['Car_Replacemnet_Cost__c'];
                    tempchild.Cost_Per_Calender_Month__c = childValues[k]['Cost_Per_Calender_Month__c'];
                    childarray.push(tempchild);
                }               
                tempProduct.Name = value[i]['Name'];    // product product details
                tempProduct._children = childarray;             
                productArray.push(tempProduct);
            }
            this.products =productArray;                // Final list of products
            console.log('Products--->',JSON.stringify(this.products));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.products = undefined;
            console.log('error',this.error);
        }
    }
    }
}