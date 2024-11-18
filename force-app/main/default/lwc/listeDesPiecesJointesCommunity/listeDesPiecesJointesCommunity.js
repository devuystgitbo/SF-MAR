import { api, LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFile from '@salesforce/apex/ViewFileController.getFile';


const columns = [
    { 
        label: 'Nom du fichier',
        fieldName: 'fileLink',
        type: 'url',
        typeAttributes: { label: { fieldName: 'Title' }, target: '_blank' }
    },
    { 
        label: 'Ajouté le',
        fieldName: 'CreatedDate',
        type: "date",
        typeAttributes:{month: "2-digit",day: "2-digit",year:"numeric"}
    },
    { 
        
        label: 'Créé par',
        fieldName: 'fileCreator'       
    },
];

export default class ListeDesPiecesJointesCommunity extends LightningElement {

    @api recordId;
    wiredAide;
    files;
    error;
    columns = columns;
  
    @wire(getFile, { recordId: "$recordId" } )
    wiredPrimes({ error, data }) {
        this.files = [];
        if (data) {
            data = JSON.parse(JSON.stringify(data));
            data.forEach(res => {
                res.fileLink ='/partner/s/contentdocument/'+res.Id;
                res.fileCreator = res.CreatedBy.Name;
            });
            this.files = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.files = undefined;
            this.showToast('error', 'Une erreur est survenue dans la récupération des pieces jointes', result.error.body?.message);

        }
    } 

    showToast(variant, title, message){
        this.dispatchEvent(new ShowToastEvent({variant, title, message}));
    }
}