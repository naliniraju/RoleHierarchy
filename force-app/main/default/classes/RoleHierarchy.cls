public with sharing class RoleHierarchy {
    
    public class myCustomException Extends Exception{}
    
    @AuraEnabled(cacheable=true)
    public static List<TreeNode> getTreeData(String recordId){
        // Create maps to hold nodes for roles and users
        Map<Id, TreeNode> roleNodes = new Map<Id, TreeNode>();
        Map<Id, TreeNode> userNodes = new Map<Id, TreeNode>();
        // Query the employee record with the given ID to get the employee's email address
        EMS_Employee__c[] emp = [Select Id, EMS_Work_Email__c from EMS_Employee__c where Id =:recordId];
        if(emp.size()<=0){
            throw new myCustomException('no emp record exists');
        }
        User loggedInEmployee = [Select Id, Name, UserRoleId, UserRole.Name from User where Email =: emp[0].EMS_Work_Email__c LIMIT 1];
        String insertedUserRoleId = loggedInEmployee.UserRoleId;
        Map<Id,UserRole> userRoles = new Map<Id,UserRole>([SELECT Id, Name, ParentRoleId FROM UserRole]);
        // Traverse the role hierarchy and build a list of roles in ascending order
        List<UserRole> roles = new List<UserRole>();
        UserRole currentRole = userRoles.get(Id.valueOf(insertedUserRoleId));
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
        TreeNode userNode = new TreeNode(loggedInEmployee.Name, loggedInEmployee.Name, false, new List<TreeNode>());
        userNodes.put(loggedInEmployee.Id, userNode);
        
        
        // Build hierarchy
        for (UserRole r : roles) {
            if (r.ParentRoleId != null) {
                roleNodes.get(r.ParentRoleId).items.add(roleNodes.get(r.Id)); 
            }
        }
        
        if (roleNodes.containsKey(loggedInEmployee.UserRoleId)) {
            roleNodes.get(loggedInEmployee.UserRoleId).items.add(userNodes.get(loggedInEmployee.Id));
        }
        
        // Return top-level nodes (root user role nodes)
        List<TreeNode> topLevelNodes = new List<TreeNode>();
        for (UserRole r : roles) {
            if (r.ParentRoleId == null) {
                topLevelNodes.add(roleNodes.get(r.Id));
            }
        }
        System.debug('top level nodes ' + topLevelNodes);
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