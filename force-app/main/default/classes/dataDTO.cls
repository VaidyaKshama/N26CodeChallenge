 /**
   * @description  Data Transfer Object class for contact deatils
   **/
global with sharing class dataDTO {
    global class contactData{
    global String uuid;
    global string contactName;
    global string homeCountry;
    global string email;
    global string phone;
    global product productData;
    }
    global class product{
        global string productName;
        global Boolean isActive;
        global string description;
        global List<productPrice> productPrices;
    }
    global class productPrice{
        global Decimal carReplacementCost;
        global Decimal costperCalenderMonth;
        global Decimal atmFeeInOtherCountries;
        global string pricehomeCountry;
    }
}