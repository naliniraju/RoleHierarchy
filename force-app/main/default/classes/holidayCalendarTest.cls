@isTest
private class holidayCalendarTest {
@testSetup 
    static void setup() {
        List<Event> events = TestDataFactory.getEvents();
        insert events;
    }
    
    @isTest 
    static void testGetEvents() {
        Test.startTest();
        // Call the method being tested
        List<Event> result = holidayCalender.getEvents(Date.today(), Date.today().addDays(2));

        Test.stopTest();
        
        // Verify the results
        List<Event> expectedEvents = [SELECT Id, StartDateTime, EndDateTime FROM Event];
        
        System.assertEquals(expectedEvents.size(), result.size(), 'Expected ' + expectedEvents.size() + ' events but found ' + result.size() + ' events.');
        for (Integer i = 0; i < expectedEvents.size(); i++) {
            System.assertEquals(expectedEvents[i].Id, result[i].Id, 'Expected Event Id ' + expectedEvents[i].Id + ' but found ' + result[i].Id);
            System.assertEquals(expectedEvents[i].StartDateTime, result[i].StartDateTime, 'Expected StartDateTime ' + expectedEvents[i].StartDateTime + ' but found ' + result[i].StartDateTime);
            System.assertEquals(expectedEvents[i].EndDateTime, result[i].EndDateTime, 'Expected EndDateTime ' + expectedEvents[i].EndDateTime + ' but found ' + result[i].EndDateTime);

        }
    }
}