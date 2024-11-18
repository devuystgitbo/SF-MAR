//covered by ViewFileController_Test
public class ViewFileController {

    @AuraEnabled(cacheable=true)
    public static List<ContentDocument> getFile(String recordId) {

        List<ContentDocument> files= new List<ContentDocument>();
        // Récupérer les ContentDocumentLinks
        List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];

        // Récupérer les fichiers associés
        if (!links.isEmpty()) {
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink link : links) {
                contentDocumentIds.add(link.ContentDocumentId);
            }
            files = [SELECT Id, Title, CreatedDate, CreatedBy.Name FROM ContentDocument WHERE Id IN :contentDocumentIds];
        } else {
            files = new List<ContentDocument>();
        }
        return files;
    }
}