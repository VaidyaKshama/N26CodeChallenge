global virtual with sharing class buildContactWrapper{
    /**
   * @description  return consolidated contactDetails based on UUID
   **/
    global virtual List<dataDTO.contactData> sendContactData(List<string> uuid) {
        List<contact> conList = new list<contact>();
        map<Id, product2> products;
       List<string> countriesList = new List<string>();
       List<string> productIdList = new List<string>();
        map<id,contact> contactProductMap = new map<id,contact>();
        if (uuid.isEmpty()) {
            throw new customException('UUID is not set');
        }
        for (contact con : [select id,Home_Country__c,Product__c,email,Phone,uuid__c from Contact where uuid__c in :uuid]) {
            contactProductMap.put(con.Product__c,con);
            countriesList.add(con.Home_Country__c);
            productIdList.add(con.Product__c);
        }
        if(contactProductMap.isEmpty()) throw new customException('Product is not set for requested contact(s)');
        if(countriesList.isEmpty())  throw new customException('Country is not set for requested contact(s)');
        products  = new Map<ID, product2>([select Name, id, IsActive, Description, (select id from Contacts__r),(select id, ATM_Fee_In_Other_Currencies__c, Car_Replacemnet_Cost__c, Cost_Per_Calender_Month__c,Home_Country__c from Product_Prices__r where Home_Country__c in : countriesList) from product2 where id in :productIdList]);
        if(products.isEmpty()) throw new customException('Product is not available');
        return formatData(products,contactProductMap);
    }
    /**
   * @description  returns contact data along with its product details wrapped in a class object
   **/
    global virtual List<dataDTO.contactData> formatData(map<Id, product2> productMap, map<id,contact> contactProductMap) {
        List<dataDTO.contactData> contacts = new List<dataDTO.contactData>();
        for (contact con : contactProductMap.values()) {
            dataDTO.contactData contactObject = new dataDTO.contactData();
            product2 prod = productMap.get(con.Product__c);
            List<Product_Price__c> productPriceList = prod?.Product_Prices__r!=null?prod.Product_Prices__r:null;
            contactObject.uuid = con.uuid__c;
            contactObject.email = con.Email;
            contactObject.homeCountry = con.Home_Country__c;
            contactObject.phone = con.Phone;
            if(prod != null){
                contactObject.productData = new dataDTO.product();
                contactObject.productData = formatProduct(prod);
            }
            if(productPriceList != null){
                contactObject.productData.productPrices = new List<dataDTO.productPrice>();
                contactObject.productData.productPrices.addAll(formatProductPrices(productPriceList));
            }
            contacts.add(contactObject);
        }
        return contacts;
    }
    /**
   * @description  return product details wrapped in class object
   **/
    global virtual dataDTO.product formatProduct(product2 product) {
        dataDTO.product prod = new dataDTO.product();       
        prod.productName = product.Name;
        prod.isActive = product.IsActive;
        prod.description = product.Description;
        return prod;
    }
     /**
   * @description  return product price details wrapped in class object
   **/
    global virtual List<dataDTO.productPrice> formatProductPrices(List<Product_Price__c> productPriceList) {
        List<dataDTO.productPrice> prices = new List<dataDTO.productPrice>();
        for (Product_Price__c price : productPriceList) {
            dataDTO.productPrice p = new dataDTO.productPrice();
            p.atmFeeInOtherCountries = price.ATM_Fee_In_Other_Currencies__c;
            p.carReplacementCost = price.Car_Replacemnet_Cost__c;
            p.costperCalenderMonth = price.Cost_Per_Calender_Month__c;
            p.pricehomeCountry = price.Home_Country__c;
            prices.add(p);
        }
        return prices;
    }
}