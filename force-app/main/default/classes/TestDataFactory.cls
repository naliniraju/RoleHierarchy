@isTest
public class TestDataFactory {
// method to create an employee record
    public static EMS_Employee__c createEmployee(Boolean insertEmp) {
        // create a new employee record with some default values
        EMS_Employee__c emp = new EMS_Employee__c(
            EMS_Work_Email__c = 'test@cittacore.com', // set the work email
            EMS_Type__c = 'Full Time' // set the employment type
        );
        // if insertEmp is true, insert the record into the database
        if (insertEmp) {
            insert emp;
        }
        // return the employee record
        return emp;
    }

    // method to create a user record
    public static User createUser(EMS_Employee__c emp, Boolean insertUser) {
        // create a new user record with some default values
        User u = new User(
            Email = emp.EMS_Work_Email__c, // set the email to the employee's work email
            LastName = 'Test', // set the last name to "Test"
            Alias = 'tuser', // set the alias to "tuser"
            Username = 'test@cittacore.com', // set the username to the employee's work email
            TimeZoneSidKey = 'America/Los_Angeles', // set the timezone
            LanguageLocaleKey='en_US', // set the language
            LocaleSidKey = 'en_US', // set the locale
            EmailEncodingKey = 'UTF-8', // set the email encoding
            ProfileId = UserInfo.getProfileId() // set the user's profile to the current user's profile
        );
        // if insertUser is true, insert the record into the database
        if (insertUser) {
            insert u;
        }
        // return the user record
        return u;
    }

    // method to create a role record
    public static UserRole createRole(String name, String parentRoleId, Boolean insertRole) {
        // create a new role record with a given name
        UserRole role = new UserRole(Name = name);
        // if a parent role ID is provided, set it on the role record
        if (parentRoleId != null) {
            role.ParentRoleId = parentRoleId;
        }
        // if insertRole is true, insert the record into the database
        if (insertRole) {
            insert role;
        }
        // return the role record
        return role;
    }

    // method to update a user record
    public static void updateUser(User u, Boolean updateUser) {
        // query for a role with the name "Role 2"
        UserRole role = [SELECT Id FROM UserRole WHERE Name = 'Role 2' LIMIT 1];
        // set the user's role to the queried role ID
        u.UserRoleId = role.Id;
        // if updateUser is true, update the record in the database
        if (updateUser) {
            update u;
        }
    }

    // method to get a list of event records
    public static List<Event> getEvents(Boolean insertEvents) {
        // create a list of events with some default values
        List<Event> events = new List<Event>{
            new Event(Subject='Meeting', StartDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)), EndDateTime=DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0)))
                };
       if (insertEvents) {
            insert events;
        }
        return events;
    }

}