public with sharing class holidayCalender {
    
        @AuraEnabled(cacheable=true)
        public static List<Event> getEvents(Date startDate, Date endDate) {
            return [SELECT Id, Subject, StartDateTime,EndDateTime FROM Event Order by StartDateTime]; 
        }
        
    }