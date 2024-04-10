import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import listPlugin from '@fullcalendar/list';

export default function Calendar({ events }) {
    return (
        <>
        <FullCalendar
            plugins={[dayGridPlugin]}
            initialView="dayGridMonth"
            events={events}
        />
        <FullCalendar
            plugins={[listPlugin]}
            initialView="listWeek"
            events={events}    
        />
        </>
    );
}