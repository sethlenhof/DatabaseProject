import React, { useState } from 'react';
import Strings from '../constants/strings.jsx';
import Button from '../components/button.jsx';
import TextBox from '../components/textBox.jsx';
import CustomDateInput from './customDateInput.jsx';
import CustomTimeInput from './customTimeInput.jsx';
import DatePicker from 'react-datepicker';
import '../styles/datepicker.css';
import ErrorMessage from './errorMessage.jsx';

const EventForm = () => {
    const [eventData, setEventData] = useState({
        name: '',
        category: '',
        description: '',
        startTime: null,
        endTime: null,
        date: null,
        location: '',
        contactPhone: '',
        contactEmail: ''
    });
    
    const [errors, setErrors] = useState({});
    

    const handleChange = (e) => {
        setEventData({ ...eventData, [e.target.name]: e.target.value });
    };

    // Separate handlers for date and time pickers
    const handleDateChange = (selectedDate) => {
        setEventData(prev => ({ ...prev, date: selectedDate }));
    };

    const handleStartTimeChange = (selectedStartTime) => {
        setEventData(prev => ({ ...prev, startTime: selectedStartTime }));
    };

    const handleEndTimeChange = (selectedEndTime) => {
        setEventData(prev => ({ ...prev, endTime: selectedEndTime }));
    };

    const validateForm = () => {
        let newErrors = {};
        // Check each field and add errors accordingly
        if (!eventData.name) newErrors.name = "Event name is required.";
        if (!eventData.date) newErrors.date = "Event date is required.";
        if (!eventData.startTime) newErrors.startTime = "Start time is required.";
        if (!eventData.endTime) newErrors.endTime = "End time is required.";
        if (!eventData.location) newErrors.location = "Location is required.";
        if (!eventData.contactPhone) newErrors.contactPhone = "Contact phone is required.";
        if (!eventData.contactEmail) newErrors.contactEmail = "Contact email is required.";

    
        // Set a general error message if more than two fields are missing
        const numberOfErrors = Object.keys(newErrors).length;
        if (numberOfErrors > 1) {
            newErrors.general = "Missing fields";
        }
        setErrors(newErrors);
        return numberOfErrors === 0; // Return true if no errors
    };
    
    

    const handleSubmit = (e) => {
        e.preventDefault();

        console.log('Submitting event data:', eventData);
        // Validate the form data
        if (validateForm() === false) {
            //error
            console.log('Missing fields');
            return;
        }

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
            className='form-container'
        >
            {/* {errors.name && <ErrorMessage error={errors.name} />} */}
            <TextBox
                placeholder="Event Name"
                name="name"
                value={eventData.name}
                onChange={handleChange}
            />
            {/* {errors.category && <ErrorMessage error={errors.category} />} */}
            <TextBox
                placeholder="Category"
                name="category"
                value={eventData.category}
                onChange={handleChange}
            />
            {/* {errors.description && <ErrorMessage error={errors.description} />} */}
            <TextBox
                placeholder="Description"
                name="description"
                value={eventData.description}
                onChange={handleChange}
            />
            {/* {errors.date && <ErrorMessage error={errors.date} />} */}
            <label>Date:</label>
            <DatePicker
                selected={eventData.date}  // Bind to eventData
                onChange={handleDateChange}  // Use the new handler
                customInput={<CustomDateInput />}  // Using custom input component
            />
            {/* {errors.startTime && <ErrorMessage error={errors.startTime} />} */}
            <label>Start Time:</label>
            <DatePicker
                selected={eventData.startTime}  // Bind to eventData
                onChange={handleStartTimeChange}  // Use the new handler
                showTimeSelect
                showTimeSelectOnly
                timeIntervals={15}
                timeCaption="Time"
                dateFormat="h:mm aa"
                customInput={<CustomTimeInput />}  // Using custom time input component
            />
            {/* {errors.endTime && <ErrorMessage error={errors.endTime} />} */}
            <label>End Time:</label>
            <DatePicker
                selected={eventData.endTime}  // Bind to eventData
                onChange={handleEndTimeChange}  // Use the new handler
                showTimeSelect
                showTimeSelectOnly
                timeIntervals={15}
                timeCaption="Time"
                dateFormat="h:mm aa"
                customInput={<CustomTimeInput />}  // Using custom time input component
            />
            {/* {errors.location && <ErrorMessage error={errors.location} />} */}
            <TextBox
                placeholder="Location"
                name="location"
                value={eventData.location}
                onChange={handleChange}
            />
            {/* {errors.contactPhone && <ErrorMessage error={errors.contactPhone} />} */}
            <TextBox
                placeholder="Contact Phone"
                name="contactPhone"
                value={eventData.contactPhone}
                onChange={handleChange}
            />
            {/* {errors.contactEmail && <ErrorMessage error={errors.contactEmail} />} */}
            <TextBox
                placeholder="Contact Email"
                name="contactEmail"
                value={eventData.contactEmail}
                onChange={handleChange}
            />
            <Button type="submit">Create Event</Button>
            {errors.general && <ErrorMessage error={errors.general} />}
        </form>
        </>
    );
};

export default EventForm;
