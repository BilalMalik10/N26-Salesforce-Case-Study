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
@isTest
public with sharing class ProductInfoRESTResourceTest {
    @testSetup
    private static void initailizeTestData () {
        Product2 prod = new Product2(Name = 'Black');
        insert prod;
        
        //Creating Services
        Service__c service1 =new Service__c(Name = 'Cost per Calendar Month');
        Service__c service2 =new Service__c(Name = 'ATM Fee in other currencies');
        Service__c service3 =new Service__c(Name = 'Card Replacement Cost');        
        
        insert new List<Service__c>{service1,service2, service3};
            
            Service_Charge__c serviceCharge1 = new Service_Charge__c(Product__c = prod.Id,
                                                                     Service__c = service1.Id,
                                                                     Cost__c = 99.26,
                                                                     Is_Free_of_Cost__c = false,
                                                                     Currency_Code__c = 'EUR',
                                                                     Country__c = 'DE',
                                                                     Is_Active__c = true);
        Service_Charge__c serviceCharge2 = new Service_Charge__c(Product__c = prod.Id,
                                                                 Service__c = service2.Id,
                                                                 Is_Free_of_Cost__c = true,
                                                                 Currency_Code__c = 'EUR',
                                                                 Country__c = 'DE',
                                                                 Is_Active__c = true);
        Service_Charge__c serviceCharge3 = new Service_Charge__c(Product__c = prod.Id,
                                                                 Service__c = service3.id,
                                                                 Cost__c = 3.0,
                                                                 Is_Free_of_Cost__c = false,
                                                                 Currency_Code__c = 'EUR',
                                                                 Country__c = 'DE',
                                                                 Is_Active__c = true);
        
        insert new List<Service_Charge__c>{serviceCharge1, serviceCharge2, serviceCharge3};
            
        Contact  con = new Contact(lastname = 'Test',
                                    email = 'testuser@mail.com',
                                    Product__c = prod.Id,
                                    UUID__c = '258200',
                                    Home_Country__c = 'DE');
        insert con;
        
        Case c = new Case(Subject = 'Test Case PI',
                          Status = 'New',
                          Origin = 'Email',
                          ContactId = con.Id);
        insert c;
        
    }
    private static testmethod void missingUUIDHttpGet() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ProductInfo/'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductInfoWrapper productInfoWrapper = ProductInfoRESTResource.getProductInfoByUUID();
        Test.stopTest();
        
        System.assertEquals('Bad request. Customer UUID parameter is missing.', productInfoWrapper.Status.message, 'Customer UUID Missing');
        System.assertEquals(400, productInfoWrapper.Status.code, 'Status code should be 400');
    }
    
    private static testmethod void noCustomerFoundHttpGet() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ProductInfo/5564'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductInfoWrapper productInfoWrapper = ProductInfoRESTResource.getProductInfoByUUID();
        Test.stopTest();
        
        System.assertEquals('No customer found against this UUID.', productInfoWrapper.Status.message, 'Customer Found');
        System.assertEquals(200, productInfoWrapper.Status.code, 'Status code should be 200');
    }
    private static testmethod void productInfoHttpGet() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ProductInfo/258200'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductInfoWrapper productInfoWrapper = ProductInfoRESTResource.getProductInfoByUUID();
        Test.stopTest();
        
        System.assertEquals('success', productInfoWrapper.Status.message, 'success');
        System.assertEquals(200, productInfoWrapper.Status.code, 'Status code should be 200');
        System.assertEquals('Black', productInfoWrapper.productName, 'Product Name should be Black for this customer');
        System.assertEquals(3, productInfoWrapper.services.size(), 'services should be 3');
    }

    private static testmethod void noProductInfoHttpGet() {

        Contact contactToUpdate = [SELECT Id, Product__c 
                                    FROM Contact 
                                    WHERE UUID__c = '258200'
                                    LIMIT 1];
        
        contactToUpdate.Product__c = null;
        update contactToUpdate;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ProductInfo/258200'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CustomerProductInfoWrapper productInfoWrapper = ProductInfoRESTResource.getProductInfoByUUID();
        Test.stopTest();
        
        System.assertEquals('This customer do not have any products.', productInfoWrapper.Status.message, 'No product');
        System.assertEquals(200, productInfoWrapper.Status.code, 'Status code should be 200');
    }
}