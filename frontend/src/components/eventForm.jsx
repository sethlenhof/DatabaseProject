import React, { useState, useEffect } from 'react';
import Button from './button.jsx';
import DatePicker from 'react-datepicker';
import '../styles/datepicker.css';
import ErrorMessage from './errorMessage.jsx';
import { FormField } from './formField.jsx';

const EventForm = () => {
    const id = localStorage.getItem('user');
    const [eventData, setEventData] = useState({
        name: '',
        type: '',
        category: '',
        description: '',
        startTime: new Date(),
        endTime: new Date(),
        date: new Date(),
        location: '',
        contactPhone: '',
        contactEmail: '',
        rsoId: null,
        uniId: null
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
        if (!eventData.name) newErrors.name = "Event name is required.";
        if (!eventData.category) newErrors.category = "Category is required.";
        if (!eventData.description) newErrors.description = "Description is required.";
        if (!eventData.date) newErrors.date = "Event date is required.";
        if (!eventData.startTime) newErrors.startTime = "Start time is required.";
        if (!eventData.endTime) newErrors.endTime = "End time is required.";
        if (!eventData.location) newErrors.location = "Location is required.";
        if (!eventData.contactPhone) newErrors.contactPhone = "Contact phone is required.";
        if (!eventData.contactEmail) newErrors.contactEmail = "Contact email is required.";
        
        if (Object.keys(newErrors).length > 1) {
            newErrors.general = "Missing fields";
        }
        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    useEffect(() => {
        fetchRSOId();
        fetchUniId();
    }, [id]);  // Adding 'id' as a dependency since it's used inside fetchRSOId and fetchUniId
    

    const fetchRSOId = async () => {
        try {
            const response = await fetch(`/api/rso/id?userId=${id}`);
            const data = await response.json();
            if (data.rsoId) {
                setEventData(prev => ({ ...prev, rsoId: data.rsoId }));
            }
        } catch (error) {
            console.error('Failed to fetch RSO ID:', error);
        }
    };

    const fetchUniId = async () => {
        try {
            const response = await fetch(`/api/university/id?userId=${id}`);
            const data = await response.json();
            if (data.universityId) {
                setEventData(prev => ({ ...prev, uniId: data.universityId }));
            }
        } catch (error) {
            console.error('Failed to fetch University ID:', error);
        }
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!validateForm()) {
            console.log('Missing fields');
            return;
        }
    
        // Formatting date and times
        let formattedDate = `${eventData.date.getFullYear()}-${(eventData.date.getMonth() + 1).toString().padStart(2, '0')}-${eventData.date.getDate().toString().padStart(2, '0')}`;
        let formattedStartTime = `${eventData.startTime.getHours().toString().padStart(2, '0')}:${eventData.startTime.getMinutes().toString().padStart(2, '0')}:00`;
        let formattedEndTime = `${eventData.endTime.getHours().toString().padStart(2, '0')}:${eventData.endTime.getMinutes().toString().padStart(2, '0')}:00`;


        let rsoId = null;
        let uniId = null;

        switch (eventData.type) {
            case 'Public':
                rsoId = null;
                uniId = null;
                break;
            case 'Private':
                uniId = eventData.uniId; // Assuming uniId is always available for a logged-in user
                break;
            case 'RSO':
                rsoId = eventData.rsoId; // rsoId should be set if the user is part of an RSO
                uniId = eventData.uniId;
                break;
            default:
                console.log('Invalid event type');
                return;
        }
    
        const updatedEventData = {
            ...eventData,
            rsoId,
            uniId, 
            date: formattedDate,
            startTime: formattedStartTime,
            endTime: formattedEndTime
        };
    
        console.log('Formatted event data:', updatedEventData);
        //public event, has no university id or rso id
        //private event, has university id but no rso id
        //rso event, has university id and rso id
        // Send data to the backend
        fetch('/api/events/create', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedEventData)
        }).then(data => {
            if (data.status === 200) {
                window.showToast({
                    title: "Success",
                    message: "Event Created successfully!",
                    type: "success",
                    autoHide: true
                });
            }else{
                data.json().then(data => {
                window.showToast({
                    title: "Error", message: data.error, type: "error", autoHide: true});
                });
            }
            
        });


    };

    const headerStyle = {
        marginBottom: '20px',
        paddingBottom: '10px',
        borderBottom: '2px solid #ccc'
    };

    const inputStyle = {
        padding: '10px',
        borderRadius: '5px',
        border: '1px solid #ccc',
        fontSize: '16px',
        width: '100%',
        boxSizing: 'border-box',
        appearance: 'none'
    };

    const selectStyle = {
        ...inputStyle,
        backgroundImage: `url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="rgba(0,0,0,0.54)" d="M7 10l5 5 5-5z"/></svg>')`,
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'right 10px center',
        backgroundSize: '12px',
        paddingRight: '30px'
    };

    return (
        <>
        <form
            style={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                padding: "1rem",
                minWidth: "300px",
                width: '60vw',
                margin: 'auto'
            }}
            onSubmit={handleSubmit}
        >
            <h1 style={headerStyle}>Create an Event</h1>
            <FormField label="Event Name:">
                <input
                    style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }}
                    type="text"
                    name="name"
                    placeholder="Event Name"
                    value={eventData.name}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Type:">
                <select
                    style={selectStyle}
                    name="type"
                    value={eventData.type}
                    onChange={handleChange}
                >
                    <option value="">Select Type</option>
                    <option value="Private">Private</option>
                    <option value="Public">Public</option>
                    <option value="RSO">RSO</option>
                </select>
            </FormField>
            <FormField label="Category:">
                <input
                    style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }}
                    type="text"
                    name="category"
                    placeholder="Category"
                    value={eventData.category}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Description:">
                <textarea
                    style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%',
                        minHeight: '100px'
                    }}
                    name="description"
                    placeholder="Description"
                    value={eventData.description}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Date:">
                <DatePicker
                    selected={eventData.date}
                    onChange={handleDateChange}
                    customInput={<input style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }} />}
                />
            </FormField>
            <FormField label="Start Time:">
                <DatePicker
                    selected={eventData.startTime}
                    onChange={handleStartTimeChange}
                    showTimeSelect
                    showTimeSelectOnly
                    timeIntervals={15}
                    timeCaption="Time"
                    dateFormat="h:mm aa"
                    customInput={<input style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }} />}
                />
            </FormField>
            <FormField label="End Time:">
                <DatePicker
                    selected={eventData.endTime}
                    onChange={handleEndTimeChange}
                    showTimeSelect
                    showTimeSelectOnly
                    timeIntervals={15}
                    timeCaption="Time"
                    dateFormat="h:mm aa"
                    customInput={<input style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }} />}
                />
            </FormField>
            <FormField label="Location:">
                <input
                    style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }}
                    type="text"
                    name="location"
                    placeholder="Location"
                    value={eventData.location}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Contact Phone:">
                <input
                    style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }}
                    type="text"
                    name="contactPhone"
                    placeholder="Contact Phone"
                    value={eventData.contactPhone}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Contact Email:">
                <input
                    style={{
                        padding: '10px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        fontSize: '16px',
                        width: '100%'
                    }}
                    type="email"
                    name="contactEmail"
                    placeholder="Contact Email"
                    value={eventData.contactEmail}
                    onChange={handleChange}
                />
            </FormField>
            {errors.general && <ErrorMessage error={errors.general} />}
            <Button type="submit">Create Event</Button>
        </form>
        </>
    );
};

export default EventForm;
