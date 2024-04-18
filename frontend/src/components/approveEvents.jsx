import React, { useEffect, useState } from 'react';
import Button from './button';

const ApproveEvents = () => {
    const [events, setEvents] = useState([]);
    const userId = localStorage.getItem('user');

    if(!userId) {
        //show toast
        window.showToast({title: "Error", message: "Must sign in to join RSO", type: "error", autoHide: false});
    }

    useEffect(() => {
        if (userId) {
            fetch(`/api/events/unapproved?userId=${userId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        window.showToast({title: "Error", message: data.error, type: "error", autoHide: true});
                    } else{
                        setEvents(data.events)
                    }
                }
            ).catch(error => console.error('Error fetching Unnapproved data:', error));
        }
     }, [userId]);

    const handleApproveEvent = (eventId, eventName) => {
        fetch('/api/events/approve', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ userId, eventId }) // Sending both userId and rsoId
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                window.showToast({title: "Error", message: data.error, type: "error", autoHide: true});

            } else {
                window.showToast({title: "Success", message: `Approved Event ${eventName}`, type: "success", autoHide: true});
            }
        })
    };

    const headerStyle = {
        marginBottom: '20px',
        paddingBottom: '10px',
        borderBottom: '2px solid #ccc'
    };

    const buttonStyle = {
        padding: '10px 20px',
        border: 'none',
        borderRadius: '5px',
        boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
        cursor: 'pointer',
        backgroundColor: 'green',
        color: 'white',
    };

    return (
        <div style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            padding: "1rem",
            minWidth: "300px",
            width: '60vw',
            margin: 'auto' }}>
            <h1 style={headerStyle}>Unnapproved Events</h1>
            {events.map(event => (
                <div key={event.EVENT_ID} style={{
                    padding: '10px',
                    margin: '10px',
                    borderRadius: '5px',
                    border: '1px solid',
                    borderColor: 'blueviolet',
                    fontSize: '16px',
                    width: '100%'
                }}>
                    <h4>{event.EVENT_NAME}</h4>
                    <p>{event.EVENT_DESCRIPTION}</p>
                    <p>Location: {event.EVENT_LOCATION}</p>
                    <p>Starts: {event.EVENT_START}</p>
                    <p>Ends: {event.EVENT_END}</p>
                    <Button onClick={() => handleApproveEvent(event.EVENT_ID, event.EVENT_NAME)}>
                        Approve
                    </Button>
                </div>
            ))}
        </div>
    );
};

export default ApproveEvents;
