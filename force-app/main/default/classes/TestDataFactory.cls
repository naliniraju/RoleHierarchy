@isTest
public class TestDataFactory {
    public static EMS_Employee__c createEmployee(Boolean insertEmp) {
        EMS_Employee__c emp = new EMS_Employee__c(
            EMS_Work_Email__c = 'test@cittacore.com',
            EMS_Type__c = 'Full Time'
        );
        if (insertEmp) {
            insert emp;
        }
        return emp;
    }

    public static User createUser(EMS_Employee__c emp, Boolean insertUser) {
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
        if (insertUser) {
            insert u;
        }
        return u;
    }

    public static UserRole createRole(String name, String parentRoleId, Boolean insertRole) {
        UserRole role = new UserRole(Name = name);
        if (parentRoleId != null) {
            role.ParentRoleId = parentRoleId;
        }
        if (insertRole) {
            insert role;
        }
        return role;
    }

    public static void updateUser(User u, Boolean updateUser) {
        UserRole role = [SELECT Id FROM UserRole WHERE Name = 'Role 2' LIMIT 1];
        u.UserRoleId = role.Id;
        if (updateUser) {
            update u;
        }
    }
  public static List<Event> getEvents(Boolean insertEvents) {
        List<Event> events = new List<Event>{
            new Event(Subject='Meeting', StartDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)), EndDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)))
                };
       if (insertEvents) {
            insert events;
        }
        return events;
    }

}