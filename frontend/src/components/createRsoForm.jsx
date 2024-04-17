import React, { useState } from "react";
import Button from "./button.jsx";
import { FormField } from './formField.jsx';

const CreateRso = () => {
    const id = localStorage.getItem('user');

    const [rsoData, setRsoData] = useState({
        name: '',
        type: '',
        description: '',
        color: 'white',
    });

    const handleChange = (e) => {
        setRsoData({
            ...rsoData,
            [e.target.name]: e.target.value
        });
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
    

    const formStyle = {
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        padding: '20px',
        width: '60vw',
        margin: 'auto',
    };

    const headerStyle = {
        marginBottom: '20px',
        paddingBottom: '10px',
        borderBottom: '2px solid #ccc'
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        
        fetch("/api/rsos/create", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    userId: id,
                    name: rsoData.name,
                    type: rsoData.type,
                    description: rsoData.description,
                    color: rsoData.color,
                }),
            }).then(data => {
                if (data.status === 200) {
                    window.showToast({
                        title: "Success",
                        message: "RSO Created successfully!",
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

    return (
        <form style={formStyle} onSubmit={handleSubmit}>
            <h1 style={headerStyle}>Create Registered Student Organization</h1>
            <FormField label="Name:">
                <input
                    style={inputStyle}
                    type="text"
                    name="name"
                    placeholder="Enter RSO Name"
                    value={rsoData.name}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Type:">
                <select
                    style={selectStyle}
                    name="type"
                    value={rsoData.type}
                    onChange={handleChange}
                >
                    <option value="">Select Type</option>
                    <option value="Fraternity">Fraternity</option>
                    <option value="Club">Club</option>
                    <option value="Honor Society">Honor Society</option>
                </select>
            </FormField>
            <FormField label="Description:">
                <textarea
                    style={{...inputStyle, minHeight: '100px', resize: 'vertical'}}
                    name="description"
                    placeholder="RSO Description"
                    value={rsoData.description}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Members:">
                <textarea
                    style={{...inputStyle, minHeight: '100px', resize: 'vertical'}}
                    name="members"
                    placeholder="Enter Member Emails (comma separated)"
                    value={rsoData.members}
                    onChange={handleChange}
                />
            </FormField>
            <FormField label="Color:">
                    <input
                        type="color"
                        name="color"
                        value={rsoData.color}
                        onChange={handleChange}
                        style={inputStyle}
                    />
            </FormField>
            <Button type="submit">Create RSO</Button>
        </form>
    );
};

export default CreateRso;
