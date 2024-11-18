trigger TriggerNamingDocument on ContentVersion (before insert) {
    
 String idDoc; 
 String idProjet;
 String idProv;
    
 ContentVersion doc = new ContentVersion();
        
   
    for(ContentVersion cv: Trigger.New){
            
          
        cv.Title = cv.TypeDeDocument__c + ' ' + cv.DateDuDocument__c + ' ' + cv.NomDuClient__c ;
        
        idDoc = cv.ContentDocumentId;
        doc = cv;
   
    }
    
 
   
   //  ContentDocumentLink cdl = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN (:idDoc) ORDER BY LinkedEntityId desc limit 1];
     
   // for(ContentDocumentLink dl:cdl){
   //     idProv= dl.LinkedEntityId;
   //     if(idProv.startsWithIgnoreCase('a0u')){
   //         idProjet =idProv;
   //     }
   // }
        
  //  Projet__c projet = [SELECT Id, AvisDImposition__c, CniOuPasseport__c, ClientMar__c FROM Projet__c WHERE Id =:cdl.LinkedEntityId];   
    
//  doc.NomDuClient__c = projet.ClientMar__c ;   
    
 //   if(doc.TypeDeDocument__c == 'AvisdImposition') {
//      projet.AvisDImposition__c = true; 
//    } 
 //   if(doc.TypeDeDocument__c == 'PiecedIdentite') {
//      projet.CniOuPasseport__c  = true; 
//    }
    
//    Update projet;
    
}