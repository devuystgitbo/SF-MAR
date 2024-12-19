import { api, LightningElement, wire } from 'lwc';
import getFile from '@salesforce/apex/ViewFileController.getFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ListeDesPiecesJointes extends LightningElement {
    @api recordId;
    files = [];
    error;
    wiredFilesResult; // Stocker le résultat du wire pour refreshApex

    // Configuration des colonnes pour lightning-datatable
    columns = [
        { 
            label: 'Nom du fichier',
            fieldName: 'fileLink',
            type: 'url',
            typeAttributes: { label: { fieldName: 'Title' }, target: '_blank' }
        },
        { 
            label: 'Ajouté le',
            fieldName: 'CreatedDate',
            type: 'date',
            typeAttributes: { month: '2-digit', day: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' } // Inclure l'heure
        },
        { 
            label: 'Créé par',
            fieldName: 'fileCreator'       
        },
    ];

    // Tri par défaut
    sortedBy = 'CreatedDate';
    sortDirection = 'desc';

    // Wire pour récupérer les fichiers liés à l'enregistrement
    @wire(getFile, { recordId: "$recordId" })
    wiredFiles(result) {
        this.wiredFilesResult = result; // Stocker le résultat pour refreshApex
        if (result.data) {
            console.log('Données récupérées : ', result.data);
            this.processFiles(result.data); // Traiter et trier les fichiers
        } else if (result.error) {
            this.error = result.error;
            this.files = [];
        }
    }

    // Traiter les fichiers renvoyés par l'Apex
    processFiles(data) {
        const tempData = data.map(file => ({
            ...file,
            fileLink: `/lightning/r/ContentDocument/${file.Id}/view`, // Générer le lien vers le fichier
            fileCreator: file.CreatedBy?.Name || 'Inconnu', // Gérer le cas où le créateur est null
            CreatedDate: file.CreatedDate || 'N/A' // Gérer le cas où CreatedDate est null
        }));

        // Tri par 'CreatedDate' en ordre décroissant (date et heure)
        this.files = tempData.sort((a, b) => new Date(b.CreatedDate) - new Date(a.CreatedDate));
        console.log('Fichiers triés : ', this.files);
        this.error = undefined;
    }

    // Gestion du tri dynamique (onsort)
    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortDirection = sortDirection;

        // Trier dynamiquement les fichiers en fonction de la colonne et de la direction
        this.files = [...this.files].sort((a, b) => {
            const valA = a[fieldName] || '';
            const valB = b[fieldName] || '';
            return sortDirection === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA);
        });
    }

    // Rafraîchir les données avec refreshApex
    handleRefresh() {
        refreshApex(this.wiredFilesResult)
            .then(() => {
                this.showToast('success', 'Succès', 'Les pièces jointes ont été rafraîchies.');
            })
            .catch(error => {
                console.error('Erreur lors du rafraîchissement : ', error);
                this.showToast('error', 'Erreur', 'Impossible de rafraîchir les pièces jointes.');
            });
    }

    // Afficher les notifications
    showToast(variant, title, message) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
}