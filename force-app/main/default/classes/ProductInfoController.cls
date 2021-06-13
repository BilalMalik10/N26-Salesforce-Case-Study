/**
 * @description       : Backend Apex controller class for "ProductInfoLWC" Lightning Web Component to show
 *                      the product information on the case page layout of the customer related to the case which is being viewed
 * @author            : Bilal Malik
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : Bilal Malik
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   06-13-2021   Bilal Malik   Initial Version
**/
public with sharing class ProductInfoController {
    
    /**
    * @description : Method to get case record along with contact's fields
    * @author Bilal Malik | 06-14-2021 
    * @param caseId 
    * @return Case record
    **/
    @AuraEnabled(cacheable=true)
    public static Case getCaseInfo(Id caseId){
        Case caseObj;
        try {
            caseObj = [SELECT Id, ContactId, Contact.Home_Country__c,
                       Contact.Product__c,Contact.Product__r.name
                       FROM Case
                       WHERE Id =:caseId];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return caseObj;
    }

    /**
    * @description : This method will return the active product information against country and product Id
    * @author Bilal Malik | 06-14-2021 
    * @param case object 
    * @return List<Service_Charge__c> 
    **/
    @AuraEnabled
    public static List<Service_Charge__c> getProductInfo(Case caseObj){
        List<Service_Charge__c> productCharges = new List<Service_Charge__c>();
        try {
            if(caseObj != null && caseObj.ContactId != null &&  caseObj.Contact.Home_Country__c != null && caseObj.Contact.Product__c != null){
                productCharges = [SELECT Id, Service__c, Service__r.Name, Product__c, Product__r.Name, Cost__c, Percent_Cost__c,
                                  Is_Free_of_Cost__c, Country__c, Has_Percent_Cost__c, Currency_Code__c
                                  FROM Service_Charge__c
                                  WHERE Product__c =: caseObj.Contact.Product__c
                                  AND Country__c =: caseObj.Contact.Home_Country__c
                                  AND Is_Active__c = True];
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return productCharges;
    }
}