import React from 'react';
import MyCalendar from '../components/calendar.jsx';
import ListView from '../components/listView.jsx';


export default class Test extends React.Component {
    // Define your events array
    events=[
        { title: 'Fucking pistachio', date: '2024-04-10' },
        // { title: 'event 2', date: '2024-04-02' },
        {title: 'Goon',
            start: '2024-04-10T10:00:00', // Specify the start time
            end: '2024-04-10T12:00:00', // Specify the end time
            color: '#ff9f89' // Customize the event color
                },
            {title: 'test day',
            date: '2024-04-13', // Specify the start time
            color: '#ff9f89' // Customize the event color
            },
            {title: 'test',
            start: '2024-04-13T12:00:00', // Specify the start time
            end: '2024-04-13T24:00:00', // Specify the end time
            color: 'red' // Customize the event color
                },
                {title: 'test',
            start: '2024-04-13T14:00:00', // Specify the start time
            end: '2024-04-13T16:00:00', // Specify the end time
            color: 'blue' // Customize the event color
                },
                {title: 'test',
            start: '2024-04-13T15:00:00', // Specify the start time
            end: '2024-04-13T1:00:00', // Specify the end time
            color: 'blue' // Customize the event color
                },
                {title: 'test',
            start: '2024-04-13T15:00:00', // Specify the start time
            end: '2024-04-13T1:00:00', // Specify the end time
            color: 'red' // Customize the event color
                }
    ]

    render() {
        return (
            <>
            <div style={{height:'80vh', width: '45vw', alignContent:'center', position: 'fixed', top:'100px', left: '20px'}}>
                <MyCalendar events={this.events}/>
            </div>
            <div style={{height:'80vh', width: '45vw', alignContent:'center', position: 'fixed', top:'100px', right: '20px'}}>
                <ListView events={this.events}/>
            </div>
            </>
        );
    }
}
