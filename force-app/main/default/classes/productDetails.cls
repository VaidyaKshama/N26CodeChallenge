public with sharing class productDetails {
    /*Description: Method to fetch all products related to contact based on home country
      Parameters:  Case Id
    */
    @AuraEnabled(cacheable=true)
    public static  apexResponse getproducts(id caseId){
        List<product2> products = new List<product2>();
        try{
            case currentCase = [select id, contact.Product__c, contact.Home_Country__c from case where id =:caseId];
            if(currentCase != null){
                products  = [select Name, id, (select id, ATM_Fee_In_Other_Currencies__c, Car_Replacemnet_Cost__c, 	Cost_Per_Calender_Month__c from Product_Prices__r where Home_Country__c =: currentCase.contact.Home_Country__c) from product2 where id =:currentCase.contact.Product__c];
                system.debug(products);
                system.debug(products[0].Product_Prices__r);
            }  
            return apexResponse.ok(products);          
        }
        catch (Exception ex) {
            return apexResponse.fail(ex);
        }
    }
}