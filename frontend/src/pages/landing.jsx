import React from 'react';


export default class Landing extends React.Component {
    // Define your events array
    events=[
        // ways to format the data
        {title: 'Goon', start: '2024-04-10T10:00:00', end: '2024-04-10T12:00:00', color: '#ff9f89'},
        {title: 'test day', date: '2024-04-13', color: '#ff9f89'},
    ]

    render() {
        return (
            <div>
                <h1>Home</h1>
            </div>
        );
    }
}
