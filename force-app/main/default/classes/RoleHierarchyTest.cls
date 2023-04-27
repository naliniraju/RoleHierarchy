@isTest
private class RoleHierarchyTest {

       static testMethod void testGetTreeData_Positive() {

        // Create a test employee record
        EMS_Employee__c emp = TestDataFactory.createEmployee(true);
        User testUser = TestDataFactory.createUser(emp,true);
        
        System.runAs(testUser){// Set up test data
            UserRole role1 = TestDataFactory.createRole('Role 1',null,true);
            UserRole role2 = TestDataFactory.createRole('Role 2', role1.Id,true);
            TestDataFactory.updateUser(testUser,true);
            //testUser.UserRoleId = role2.Id;
           // update testUser;
        
        // Call the method with a valid recordId
        	List<RoleHierarchy.TreeNode> result = RoleHierarchy.getTreeData(emp.Id);
        
            // Assert that the result is not null and contains the expected number of top-level nodes
            System.assertEquals(1, result.size());
            System.assertNotEquals(null, result[0]);
            System.assertNotEquals(null, result[0].name);
            System.assertEquals(role1.Name, result[0].name);
            System.assertEquals(role1.Name, result[0].label);
            System.assertEquals(true, result[0].expanded);
            System.assertEquals(1, result[0].items.size());
            System.assertNotEquals(null, result[0].items[0]);
            System.assertNotEquals(null, result[0].items[0].name);
            System.assertEquals(role2.Name, result[0].items[0].name);
            System.assertEquals(role2.Name, result[0].items[0].label);
            System.assertEquals(true, result[0].items[0].expanded);
            System.assertEquals(1, result[0].items[0].items.size());
            System.assertNotEquals(null, result[0].items[0].items[0]);
            System.assertNotEquals(null, result[0].items[0].items[0].name);
            System.assertEquals(testUser.LastName, result[0].items[0].items[0].name);
            System.assertEquals(testUser.LastName, result[0].items[0].items[0].label);
            System.assertEquals(false, result[0].items[0].items[0].expanded);
            System.assertEquals(0, result[0].items[0].items[0].items.size());
        }
        
    }
    
   // @isTest
    static testMethod void testGetTreeData_Negative() {
        // Call the method with an invalid recordId
        try{
            List<RoleHierarchy.TreeNode> result = RoleHierarchy.getTreeData('invalid_record_id');

        }
        catch(RoleHierarchy.myCustomException ex){
        	System.assertEquals('no emp record exists', ex.getMessage());
        }
    }
}