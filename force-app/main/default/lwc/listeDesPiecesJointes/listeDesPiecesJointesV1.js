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
        
        label: 'Modifié par',
        fieldName: 'LastModifiedByName',
        type: 'text'
        
    },
];

export default class ListeDesPiecesJointes extends LightningElement {

    @api recordId;
    wiredAide;
    files;
    error;
    columns = columns;
  
    @wire(getFile, { recordId: "$recordId" })
wiredPrimes({ error, data }) {
    this.files = [];
    if (data) {
        data = JSON.parse(JSON.stringify(data));
        data.forEach(res => {
            res.fileLink = '/lightning/r/ContentDocument/' + res.Id + '/view';
            // Mapping pour "Modifié par"
            res.LastModifiedByName = res.LastModifiedBy?.Name || 'Inconnu';
        });
        this.files = data;
        this.error = undefined;
    } else if (error) {
        this.error = error.body.message;
        this.files = undefined;
        this.showToast(
            'error',
            'Une erreur est survenue dans la récupération des pièces jointes',
            error.body?.message
        );
    }
}
}