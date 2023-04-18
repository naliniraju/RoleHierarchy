public class TestDataFactory {
   public static UserRole createUserRole(String name, Id parentRoleId) {
        UserRole ur = new UserRole(Name=name, parentRoleId=parentRoleId);
        insert ur;
        return ur;
    }

    public static User createUser(String alias, String email, Id profileId, Id userRoleId) {
        User u = new User(Alias=alias, Email=email,
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId=profileId, TimeZoneSidKey='America/Los_Angeles',
            UserName=email, UserRoleId=userRoleId);
        insert u;
        return u;
    }

    public static EMS_Employee__c createEmployee(Id userRoleId, String email) {
        date doj = date.parse('4/3/2023');
        EMS_Employee__c e = new EMS_Employee__c(EMS_Work_Email__c=email,EMS_Type__c='Full Time');
        insert e;
        return e;
    }
    ///Calender class to get events
     public static List<Event> getEvents() {
        List<Event> events = new List<Event>{
            new Event(Subject='Meeting', StartDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)), EndDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)))
                };
        return events;
    }
}