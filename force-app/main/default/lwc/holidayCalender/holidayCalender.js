import { LightningElement, wire } from 'lwc';
import getCalendarEvents from '@salesforce/apex/holidayCalender.getEvents';
const columns = [
    { label: 'Holiday', fieldName: 'Subject' },
    { label: 'Date', fieldName: 'StartDateTime', type: 'date' },
];
export default class HolidayCalender extends LightningElement {
    events = [];
    startDate;
    endDate;

    connectedCallback() {
        // Get current year start date and end date
        const currentYear = new Date().getFullYear();
        this.startDate = currentYear + '-01-01';
        this.endDate = currentYear + '-12-31';
    }

    @wire(getCalendarEvents, { startDate: '$startDate', endDate: '$endDate' })
    wiredEvents({ error, data }) {
        if (data) {
            this.events = data.map(event => {
                return {
                    id: event.Id,
                    Subject: event.Subject,
                    StartDateTime: event.StartDateTime,
                };
            });
        } else if (error) {
            console.error(error);
        }
    }

    get columns() {
        return columns;
    }
}