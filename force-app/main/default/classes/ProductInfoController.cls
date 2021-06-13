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
    @AuraEnabled(Callable=true)
    public static Case getCaseInfo(Id caseId){
        Case currentCase;
        try {
            currentCase = [SELECT Id, ContactId, Contact.Home_Country__c,
                            Contact.Product__c,Contact.Product__r.name
                            FROM Case
                            WHERE Id =:caseId];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return currentCase;
    }
}
