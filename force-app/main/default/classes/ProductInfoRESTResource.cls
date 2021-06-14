/**
 * @description       : 
 * @author            : Bilal Malik
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : Bilal Malik
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   06-14-2021   Bilal Malik   Initial Version
**/
@RestResource(urlMapping='/ProductInfo/*')
global with sharing class ProductInfoRESTResource {
    
    /**
    * @description : GET request to get customer and product info by passing customer's UUID parameter in URL
    * @author Bilal Malik | 06-14-2021 
    * @return CustomerProductInfoWrapper JSON response
    **/
    @HttpGet
    global static CustomerProductInfoWrapper getProductInfoByUUID() {
        RestRequest request = RestContext.request;
        //Grab the UUID from the end of the URL
        String contactUUID = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        system.debug('request.requestURI --> ' + request.requestURI);
        system.debug('contactUUID --> ' + contactUUID);
        CustomerProductInfoWrapper productInfoWrapper = createProductInfoResponse(contactUUID);
        return productInfoWrapper;
    }

    /**
    * @description : Method to process and create product services response for GET request
    * @author Bilal Malik | 06-14-2021 
    * @param contactUUID 
    * @return CustomerProductInfoWrapper 
    **/
    private static CustomerProductInfoWrapper createProductInfoResponse(String contactUUID){

        CustomerProductInfoWrapper productInfoWrapper = new CustomerProductInfoWrapper();
        CustomerProductInfoWrapper.Status requestStatus = new CustomerProductInfoWrapper.Status();
        requestStatus.message = 'success';
        requestStatus.code = 200;
        try {
            //if request doesn't have an Id parameter
            if(contactUUID == null || String.isEmpty(contactUUID)){
                requestStatus.message = 'Bad request. Customer UUID parameter is missing.';
                requestStatus.code = 400;
            }else{
                productInfoWrapper.uuid = contactUUID;                
                List<Contact> customers = [SELECT Id, Name, Product__c, Product__r.Name,
                                           Home_Country__c, Email, UUID__c  
                                           FROM Contact 
                                           WHERE UUID__c  =: contactUUID];
                
                //If no customer found against UUID
                if(customers.isEmpty()){
                    requestStatus.message = 'No customer found against this UUID.';
                }else{
                    productInfoWrapper.customer = customers[0];
                    if(customers[0].Product__c != null && customers[0].Home_Country__c != null){
                        productInfoWrapper.productName = customers[0].Product__r.Name;
                        productInfoWrapper.services = new List<Service_Charge__c>();
                        productInfoWrapper.services = [SELECT Id, Service__c, Service__r.Name, Product__c, Product__r.Name, 
                                                       Country__c, Cost__c, Percent_Cost__c, Is_Free_of_Cost__c,
                                                       Has_Percent_Cost__c, Currency_Code__c, Is_Active__c
                                                       FROM Service_Charge__c 
                                                       WHERE Product__c =: customers[0].Product__c 
                                                       AND Country__c =: customers[0].Home_Country__c
                                                       AND Is_Active__c = true];
                    }else{
                        //No products
                        requestStatus.message = 'This customer do not have any products.';
                    }
                }
            }

        } catch (Exception e) {
            //Internal server error
            requestStatus.message = e.getMessage();
            requestStatus.code = 500;
        }
        productInfoWrapper.status = requestStatus;
        return productInfoWrapper;
    }
}