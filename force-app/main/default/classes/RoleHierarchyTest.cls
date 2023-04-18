@isTest
private class RoleHierarchyTest {
    static testMethod void testGetTreeData() {
        // Create test data using the factory class
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole ur = TestDataFactory.createUserRole('CEO1', null);
        UserRole ur2 = TestDataFactory.createUserRole('CFO1', ur.Id);
        User u = TestDataFactory.createUser('tesi', 'tesi@test.com', p.Id, ur.Id);
        User u1 = TestDataFactory.createUser('tess', 'tess@test.com', p.Id, ur2.Id);
       

        // Run test as a user without permissions to modify setup objects
        System.runAs(u) {
             EMS_Employee__c e = TestDataFactory.createEmployee(ur2.Id, u1.Email);
            // Call the method being tested
            List<RoleHierarchy.TreeNode> nodes = RoleHierarchy.getTreeData(e.Id);
            
            // Assert results
            RoleHierarchy.TreeNode node = nodes[0];
            System.assertEquals(ur.Name, node.name);
            System.assertEquals(ur.Name, node.label);
            System.assertEquals(true, node.expanded);
            System.assertEquals(1, node.items.size());
            RoleHierarchy.TreeNode childNode = node.items[0];
            System.assertEquals(ur2.Name, childNode.name);
            System.assertEquals(ur2.Name, childNode.label);
            System.assertEquals(true, childNode.expanded);
            System.assertEquals(1, childNode.items.size());
        }
    }
}