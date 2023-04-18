import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
import getTreeData from '@salesforce/apex/RoleHierarchy.getTreeData';
export default class roleHierarchy extends LightningElement  {
    @api recordId;
     @track treeItems;
     @track error;
    @wire(getTreeData, {recordId:'$recordId'})
     wireTreeData({
         error,
         data
     }) {
         if (data) {
             this.treeItems = data;
            // console.log("DATA :"+JSON.stringify(data, null, '\t'));
         } else {
             this.error = error;
         }
     }
}
