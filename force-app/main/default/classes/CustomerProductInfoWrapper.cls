/**
 * @description       : Wrapper class to create a response for REST API call
 * @author            : Bilal Malik
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : Bilal Malik
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   06-14-2021   Bilal Malik   Initial Version
**/
global class CustomerProductInfoWrapper {
    
    public Contact customer {get; set;}
    public String uuid { get; set; }
    public string productName { get; set; }
    public List<Service_Charge__c> services { get; set; }
    public Status status {get; set;}
    
    
    public class Status{
        public Integer code { get; set; }
        public string message { get; set; }
    }
}