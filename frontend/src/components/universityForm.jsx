import React, { useState } from 'react';
import Button from '../components/button.jsx';
import { FormField } from './formField.jsx';
import ErrorMessage from './errorMessage.jsx';

const UniversityProfileForm = () => {
    // const { userId, name, location, description, numStudents, color } = req.body;
    const [universityData, setUniversityData] = useState({
        name: '',
        location: '',
        description: '',
        numberOfStudents: '',
        color: 'white',
    });

    const [errors, setErrors] = useState({});

    const handleChange = (e) => {
        setUniversityData({
            ...universityData,
            [e.target.name]: e.target.value
        });
    };

    const validateForm = () => {
        let formErrors = {};
        if (!universityData.name) {
            formErrors.name = "University name is required.";
        }
        if (!universityData.location) {
            formErrors.location = "Location is required.";
        }
        if (!universityData.description) {
            formErrors.description = "Description is required.";
        }
        if (!universityData.numberOfStudents || isNaN(universityData.numberOfStudents)) {
            formErrors.numberOfStudents = "Must be a valid number.";
        }
    
        setErrors(formErrors); // Update state with the errors found
    
        if (Object.keys(formErrors).length > 0) {
            // Only show the toast if there are errors
            window.showToast({
                title: "Error",
                message: "Please correct the highlighted errors.",
                type: "error",
                autoHide: true
            });
            return false;
        }
    
        return true; // If no errors, return true indicating form is valid
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (validateForm()) {
            console.log('Submitting university profile:', universityData);
            // Here you might send data to a server or another handler function
            const url = '/api/updateUniversityInfo';
            fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    userId: localStorage.getItem("user"),
                    name: universityData.name,
                    location: universityData.location,
                    description: universityData.description,
                    numStudents: universityData.numberOfStudents,
                    color: universityData.color
                }),
            }).then(data => {
                if (data.status === 200) {
                    window.showToast({
                        title: "Success",
                        message: "University profile updated successfully!",
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
        }
    };

    const headerStyle = {
        marginBottom: '20px',
        paddingBottom: '10px',
        borderBottom: '2px solid #ccc'
    };

    const formStyle = {
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        padding: '20px',
        width: '60vw',
        margin: 'auto',
        fontFamily: 'Arial, sans-serif'
    };

    const inputStyle = {
        padding: '10px',
        width: '100%',
        borderRadius: '5px',
        border: '1px solid #ccc',
        fontSize: '1rem',
        '::placeholder': {
            color: '#aaa',
            fontSize: '1rem',
            opacity: 1,
        }
    };

    return (
        <div style={{ padding: '20px', maxWidth: '50vw', margin: 'auto', display:'flex', justifyContent:'start' }}>
            <form onSubmit={handleSubmit} style={formStyle}>
            <h1 style={headerStyle}>Create University Profile</h1>
                <FormField label="Name:">
                    <input
                        type="text"
                        name="name"
                        value={universityData.name}
                        onChange={handleChange}
                        placeholder="Enter university name"
                        style={inputStyle}
                    />
                    {errors.name && <ErrorMessage error={errors.name} />}
                </FormField>
                <FormField label="Location:">
                    <input
                        type="text"
                        name="location"
                        value={universityData.location}
                        onChange={handleChange}
                        placeholder="Enter location"
                        style={inputStyle}
                    />
                    {errors.location && <ErrorMessage error={errors.location} />}
                </FormField>
                <FormField label="Description:">
                    <textarea
                        name="description"
                        value={universityData.description}
                        onChange={handleChange}
                        placeholder="Enter description"
                        style={{...inputStyle, height: '100px'}}
                    />
                    {errors.description && <ErrorMessage error={errors.description} />}
                </FormField>
                <FormField label="Number of Students:">
                    <input
                        type="number"
                        name="numberOfStudents"
                        value={universityData.numberOfStudents}
                        onChange={handleChange}
                        placeholder="Enter number of students"
                        style={inputStyle}
                    />
                    {errors.numberOfStudents && <ErrorMessage error={errors.numberOfStudents} />}
                </FormField>
                <FormField label="Color:">
                    <input
                        type="color"
                        name="color"
                        value={universityData.color}
                        onChange={handleChange}
                        style={inputStyle}
                    />
                </FormField>
                <Button type="submit">Submit Profile</Button>
            </form>
        </div>
    );
};

export default UniversityProfileForm;
