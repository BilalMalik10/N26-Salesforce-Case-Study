import { api, LightningElement, track, wire } from 'lwc';
import getCaseInfo from '@salesforce/apex/ProductInfoController.getCaseInfo';

export default class ProductInfoLWC extends LightningElement {
    @track showSpinner = false;
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
            //Disabling the loading spinner
            this.showSpinner = false;
        })
        .catch(error => {
            this.case = undefined;
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