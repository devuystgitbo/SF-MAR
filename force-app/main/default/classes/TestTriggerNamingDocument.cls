@isTest 
public class TestTriggerNamingDocument {
    /* 
    static testMethod void validateTriggerNamingDocument() {

       ContentVersion cv = new ContentVersion(TypeDeDocument__c='AvisdImposition' , NomDuClient__c = 'MARIE');

       System.debug('Type before inserting new cv: ' + cv.TypeDeDocument__c);
     //  System.debug('Date before inserting new cv: ' + cv.DateDuDocument__c);
       System.debug('Nom before inserting new cv: ' + cv.NomDuClient__c);



       // Insert ContentVersion

       insert cv;

    

       // Retrieve the new ContentVersion

       cv = [SELECT TypeDeDocument__c,  NomDuClient__c FROM ContentVersion WHERE Id =:cv.Id];

       System.debug('Type after trigger fired: ' + cv.TypeDeDocument__c);
    //   System.debug('Date after trigger fired: ' + cv.DateDuDocument__c);
       System.debug('Nom after trigger fired: ' + cv.NomDuClient__c);



       // Test that the trigger correctly updated the infos

       System.assertEquals('AvisdImposition', cv.TypeDeDocument__c);
     //  System.assertEquals((2024,07,11), cv.DateDuDocument__c);
       System.assertEquals('MARIE', cv.NomDuClient__c);

    }
*/
}