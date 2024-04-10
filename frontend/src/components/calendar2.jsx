import React from 'react';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';

export default class MyCalendar extends React.Component {
    render() {
      return (
        <FullCalendar
          plugins={[dayGridPlugin, timeGridPlugin, interactionPlugin]}
          initialView="dayGridMonth"
          headerToolbar={{
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
          }}
          events={[
            { 
              title: 'Event 1',
              start: '2024-04-10T10:00:00', // Specify the start time
              end: '2024-04-10T12:00:00', // Specify the end time
              color: '#ff9f89' // Customize the event color
            },
            // Add more events here
          ]}
          // Enable some interaction features:
          selectable={true}
          editable={true}
        />
      );
    }
  }
  