import React, { useState } from 'react';
import Strings from '../constants/strings.jsx';
import Button from '../components/button.jsx';
import TextBox from '../components/textBox.jsx';

const EventForm = () => {
    const [eventData, setEventData] = useState({
        name: '',
        category: '',
        description: '',
        time: '',
        date: '',
        location: '',
        contactPhone: '',
        contactEmail: ''
    });

    const handleChange = (e) => {
        setEventData({ ...eventData, [e.target.name]: e.target.value });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        console.log('Submitting event data:', eventData);
        // Here you would usually handle the submission, e.g., sending data to a server
    };

    return (
        <>
        <h1>Create Event</h1>
        <form
            style={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                gap: "1rem",
                minWidth: "20rem",
                fontSize: "1.25rem",
                padding: "1rem",
            }}
            onSubmit={handleSubmit}
        >
            <TextBox
                placeholder="Event Name"
                name="name"
                value={eventData.name}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Category"
                name="category"
                value={eventData.category}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Description"
                name="description"
                value={eventData.description}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Time"
                type="time"
                name="time"
                value={eventData.time}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Date"
                type="date"
                name="date"
                value={eventData.date}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Location"
                name="location"
                value={eventData.location}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Contact Phone"
                name="contactPhone"
                value={eventData.contactPhone}
                onChange={handleChange}
            />
            <TextBox
                placeholder="Contact Email"
                name="contactEmail"
                value={eventData.contactEmail}
                onChange={handleChange}
            />
            <Button type="submit">Submit Event</Button>
        </form>
        </>
    );
};

export default EventForm;
