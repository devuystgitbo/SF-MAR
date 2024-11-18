public class ProjetFilesController {
    public Projet__c projet { get; set; }
    public List<ContentDocument> files { get; set; }

    public ProjetFilesController(ApexPages.StandardController controller) {
        this.projet = (Projet__c)controller.getRecord();

        // Récupérer les ContentDocumentLinks
        List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :projet.Id];

        // Récupérer les fichiers associés
        if (!links.isEmpty()) {
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink link : links) {
                contentDocumentIds.add(link.ContentDocumentId);
            }
            
            // Inclure LastModifiedBy.Name dans la requête
            this.files = [
                SELECT Id, Title, CreatedDate, LastModifiedBy.Name, LastModifiedDate 
                FROM ContentDocument 
                WHERE Id IN :contentDocumentIds
            ];
        } else {
            this.files = new List<ContentDocument>();
        }
    }
}
