# N26CodeChallenge
Challenge 1: Display products on case record page
Components Used:

## Objects and fields
Contact: Standard object
    field:  Home_country__c - New field to store Country details
            Product__c - New lookup field on product2 

Product: Standard Object
To maintain product details

Product_price__c: Custom field
Child object of product object to maintain fee and charges details with country
    field: ATM_Fee_In_Other_Currencies__c, Car_Replacemnet_Cost__c, Cost_Per_Calender_Month__c

## LWC: productDetails
Renders products by calling apex function using wire method
Process product and display in grid view along with product prices 
Component is exposed on case flexipage

## Apex: productDetails
Apex class with Auraenabled method
Query case records using caseid parameter and related contacts
Query product records related to contact object and home country same as in contact record
return List of products
Used apexResponse class structure to maintain uniform request and response model through out system.

## Challenge 2: API to sendContact details and its related product details

## Apex: 
## dataService
Service class with HTTP Get method
accepts UUID in parameters, and call buildContactWrapper class for processing

## buildContactWrapper
Query Contact records and its related product and product prices records
Loop through each contact record and capture data in a DTO object -> dataDTO
return List of contactDTO as reponse

## dataDTO
Data transfer object to send contact and product information in consolidated object.