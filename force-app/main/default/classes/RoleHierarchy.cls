public with sharing class RoleHierarchy {
    @AuraEnabled(cacheable=true)
    public static List<TreeNode> getTreeData(String recordId){
        // Create maps to hold nodes for roles and users
        Map<Id, TreeNode> roleNodes = new Map<Id, TreeNode>();
        Map<Id, TreeNode> userNodes = new Map<Id, TreeNode>();
        System.debug(recordId);
        // Query the employee record with the given ID to get the employee's email address
        EMS_Employee__c emp = [Select Id, EMS_Work_Email__c from EMS_Employee__c where Id =:recordId];
        System.debug(emp);
        String email = emp.EMS_Work_Email__c;
        System.debug(email);
        User u1 = [Select Id from User where Email =: email LIMIT 1];
        System.debug(u1);
        
        // Query the User record again to get the user's role and the role hierarchy
        User insertedUser = [SELECT UserRoleId FROM User WHERE Id =:u1.Id];
        String userRoleId = insertedUser.UserRoleId;
        List<User> users = [SELECT Id, Name, UserRoleId, UserRole.Name FROM User WHERE Id =:u1.Id];
        System.debug(users);
        Map<Id,UserRole> userRoles = new Map<Id,UserRole>([SELECT Id, Name, ParentRoleId FROM UserRole 
                                                           WHERE Id <=: userRoleId]);
        // Traverse the role hierarchy and build a list of roles in ascending order
        List<UserRole> roles = new List<UserRole>();
        UserRole currentRole = userRoles.get(Id.valueOf(userRoleId));
        roles.add(currentRole);
        Id parentId = currentRole.parentRoleId;
        while(parentId!=null){
            UserRole parentRole = userRoles.get(parentId);
            roles.add(parentRole);
            parentId = parentRole.parentRoleId;
        }
        roles.sort();
        
        
        // Build role nodes
        for (UserRole r : roles) {
            TreeNode roleNode = new TreeNode(r.Name, r.Name, true, new List<TreeNode>());
            roleNodes.put(r.Id, roleNode);
        }
        
        // Build user nodes
        for (User u : users) {
            TreeNode userNode = new TreeNode(u.Name, u.Name, false, new List<TreeNode>());
            userNodes.put(u.Id, userNode);
        }
        
        // Build hierarchy
        for (UserRole r : roles) {
            if (r.ParentRoleId != null) {
                System.debug(roleNodes.get(r.ParentRoleId));
                roleNodes.get(r.ParentRoleId).items.add(roleNodes.get(r.Id));
            }
        }
        
        for (User u : users) {
            if (roleNodes.containsKey(u.UserRoleId)) {
                roleNodes.get(u.UserRoleId).items.add(userNodes.get(u.Id));
            }
        }
        
        // Return top-level nodes (root user role nodes)
        List<TreeNode> topLevelNodes = new List<TreeNode>();
        for (UserRole r : roles) {
            if (r.ParentRoleId == null) {
                topLevelNodes.add(roleNodes.get(r.Id));
            }
        }
        
        return topLevelNodes;
    } 
    // Define a custom TreeNode class to represent a node in the hierarchy
    public class TreeNode {
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public Boolean expanded{get;set;}
        @AuraEnabled
        public List<TreeNode> items{get;set;}
        // Constructor for the TreeNode class
        public TreeNode(String name, String label, Boolean expanded, List<TreeNode> items){
            this.name = name;
            this.label = label;
            this.expanded = expanded;
            this.items = items;
        }
    }
}