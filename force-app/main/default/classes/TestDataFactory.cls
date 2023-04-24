@isTest
public class TestDataFactory {
         

public static EMS_Employee__c createEmployee() {
        EMS_Employee__c emp = new EMS_Employee__c(
            EMS_Work_Email__c = 'test@cittacore.com',
            EMS_Type__c = 'Full Time'
        );
    	insert emp;
    	return emp;
    }
    
    public static User createUser(EMS_Employee__c emp) {
        User u = new User(
            Email = emp.EMS_Work_Email__c,
            LastName = 'Test', 
            Alias = 'tuser', 
            Username = 'test@cittacore.com', 
            TimeZoneSidKey = 'America/Los_Angeles',
            LanguageLocaleKey='en_US',
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8',
            ProfileId = UserInfo.getProfileId()
        );
        insert u;
        return u;
    }
    
    public static UserRole createRole(String name, String parentRoleId) {
        UserRole role = new UserRole(Name = name);
        if (parentRoleId != null) {
            role.ParentRoleId = parentRoleId;
        }
        insert role;
        return role;
    }

  /* public static void updateUser(User u) {
        u.LastName = 'UpdatedTest';
        update u;
    }*/
    ///Calender class to get events
     public static List<Event> getEvents() {
        List<Event> events = new List<Event>{
            new Event(Subject='Meeting', StartDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)), EndDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)))
                };
        return events;
    }
}