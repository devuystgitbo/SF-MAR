@isTest
public class ViewFileController_Test {
    @isTest
    static void testProjetFilesController() {
        // Créer des données de test pour Projet__c
        Projet__c testProjet = new Projet__c(Name = 'Test Projet');
        insert testProjet;
        
        // Créer un document de contenu de test
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test content')
        );
        insert contentVersion;
        
        // Obtenir l'ID de ContentDocument lié
        List<ContentVersion> listContentVersion =  [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        Id IdContentDocument = listContentVersion.get(0).ContentDocumentId; 

        
        // Créer un lien entre le projet et le document
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = testProjet.Id,
            ContentDocumentId = IdContentDocument,
            ShareType = 'I'
        );
        insert contentDocumentLink;
        List<ContentDocument> files=ViewFileController.getFile(testProjet.Id);
        System.assertNotEquals(0,files.size(), 'La liste des fichiers ne doit pas être vide');
        
        // Vérifier que le fichier récupéré est correct
        ContentDocument retrievedFile =files[0];
        System.assertEquals(IdContentDocument , retrievedFile.Id, 'L\'ID du fichier récupéré doit correspondre à celui du document lié');
        System.assertEquals('Test Document', retrievedFile.Title, 'Le titre du fichier doit être "Test Document"');
    }

    @isTest
    static void testProjetFilesControllerNoFiles() {
        // Créer des données de test pour Projet__c sans fichier lié
        Projet__c testProjetNoFiles = new Projet__c(Name = 'Test Projet Sans Fichiers');
        insert testProjetNoFiles;

        List<ContentDocument> files=ViewFileController.getFile(testProjetNoFiles.Id);
        // Vérifications
        System.assertEquals(0,files.size(), 'La liste des fichiers doit être vide');
    }
}