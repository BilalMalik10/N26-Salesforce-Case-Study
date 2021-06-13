import { api, LightningElement, track, wire } from 'lwc';
import getCaseInfo from '@salesforce/apex/ProductInfoController.getCaseInfo';
import getProductInfo from '@salesforce/apex/ProductInfoController.getProductInfo';

export default class ProductInfoLWC extends LightningElement {
    @track showSpinner = false;
    @track productCharges = [];
    @track hasProducts = false;
    @api recordId;
    case = {};

    //lifecycle hook fires when a component is inserted into the DOM
    connectedCallback(){
        //Enabling loading spinner
        this.showSpinner = true;
        getCaseInfo({caseId : this.recordId})
        .then(result => {
            this.case = result;
            console.log('case --> ' + JSON.stringify(this.case));
            return getProductInfo({caseObj : this.case});
            
        })
        .then(result => {
            this.productCharges = result;
            console.log('productCharges --> ' + JSON.stringify(this.productCharges));
            if(this.productCharges.length > 0) this.hasProducts = true;
            //Disabling the loading spinner
            this.showSpinner = false;
        })
        .catch(error => {
            console.log('error --> ' + JSON.stringify(error));
            this.case = undefined;
            this.productCharges = [];
            this.hasProducts = false;
            //show error in toast notification.
            this.showToast('Error', error, 'error');
            //Disabling the loading spinner
            this.showSpinner = false;
        });
    }

    showToast(toastTitle, toastMessage, toastType){
        this.dispatchEvent(
            new ShowToastEvent({
                title: toastTitle,
                message: toastMessage,
                variant: toastType,
            }),
        );
    }
}