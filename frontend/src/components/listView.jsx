import FullCalendar from '@fullcalendar/react';
import listPlugin from '@fullcalendar/list';

export default function ListView({ events }) {
    return (
        <FullCalendar
            plugins={[listPlugin]}
            initialView="listWeek"
            events={events}    
        />
    );
}
