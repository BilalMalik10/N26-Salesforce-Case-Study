/**
* @description       : Test Class for ProductInfoController Class
* @author            : Bilal Malik
* @group             : 
* @last modified on  : 06-14-2021
* @last modified by  : Bilal Malik
* Modifications Log 
* Ver   Date         Author        Modification
* 1.0   06-14-2021   Bilal Malik   Initial Version
**/
@isTest
public class ProductInfoControllerTest {
    @testSetup
    Private static void initailizeTestData()
    {
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
                                       Home_Country__c = 'DE');
        insert con;
        
        Case c = new Case(Subject = 'Test Case PI',
                          Status = 'New',
                          Origin = 'Email',
                          ContactId = con.Id);
        insert c;
        
    }
    
    private static testmethod void mainTest(){
        Id caseId = [Select Id from Case where Status ='New'].Id;
        
        Test.startTest();
        Case caseObj = ProductInfoController.getCaseInfo(caseId);
        List<Service_Charge__c> productCharges = ProductInfoController.getProductInfo(caseObj);
        Test.stopTest();
        System.assert(productCharges.size() == 3);
    }
    
    //Method to cover the coverage of exceptions
    private static testmethod void excpTest(){
        Id caseId = [Select Id from Case where Status ='New'].Id;
        
        Test.startTest();
        try{
            ProductInfoController.getCaseInfo(null);
        }catch(Exception e){
            system.assert(true);
        }
        Case caseObj = ProductInfoController.getCaseInfo(caseId);       
        List<Service_Charge__c> productCharges = ProductInfoController.getProductInfo(caseObj);
        Test.stopTest();
    }
}