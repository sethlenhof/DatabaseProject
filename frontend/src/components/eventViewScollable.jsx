import React from 'react';
import PropTypes from 'prop-types';
import Button from './button';

const EventViewScrollable = ({events}) => {
    const userId = localStorage.getItem('user');

    const handleGetDetails = (eventId, eventName) => {
        //update for get by id
        fetch('/api/events/', {
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

            }
        })
    };

    const headerStyle = {
        marginBottom: '20px',
        paddingBottom: '10px',
        borderBottom: '2px solid #ccc'
    };

    return (
        <div style={{
            backgroundColor: "white",
            border: "5px",
            flex: "fit-content",
            margin: "0 auto",
            borderRadius: "10px",
            overflowY: "scroll",
            overflowX: "hidden",
            height: "70vh",
            boxShadow: "24px 24px 24px rgba(0, 0, 0, 0.1)",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            padding: "1rem",
            minWidth: "300px",
            width: '45vw', }}>
            <h1 style={headerStyle}>Upcoming Events</h1>
            {events.map(event => (
                <div key={event.EVENT_ID} style={{
                    padding: '10px',
                    margin: '10px',
                    borderRadius: '5px',
                    border: '1px solid',
                    borderColor: 'blue',
                    fontSize: '16px',
                    width: '100%'
                }}>
                    <h4>{event.EVENT_NAME}</h4>
                    <p>{event.EVENT_DESCRIPTION}</p>
                    <p>Location: {event.EVENT_LOCATION}</p>
                    <p>Starts: {event.EVENT_START}</p>
                    <p>Ends: {event.EVENT_END}</p>
                    <Button onClick={() => handleGetDetails(event.EVENT_ID)}>
                        View More
                    </Button>
                </div>
            ))}
        </div>
    );
};
EventViewScrollable.propTypes = {
    events: PropTypes.array.isRequired 
};

export default EventViewScrollable;
