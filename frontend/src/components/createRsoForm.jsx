import React from "react";
import Button from "./button.jsx";
import { FormField } from './formField.jsx';

const CreateRso = () => {
    const id = localStorage.getItem('id');

    const [name, setName] = React.useState("");
    const [type, setType] = React.useState("");
    const [description, setDescription] = React.useState("");
    const [members, setMembers] = React.useState("");

    const inputStyle = {
        padding: '10px',
        borderRadius: '5px',
        border: '1px solid #ccc',
        fontSize: '16px',
        width: '100%', // Ensures that the width matches other inputs
        boxSizing: 'border-box', // Ensures padding and borders are included in the width calculation
        appearance: 'none' // Removes default system styling on dropdowns
    };
    
    const selectStyle = {
        ...inputStyle,
        backgroundImage: `url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="rgba(0,0,0,0.54)" d="M7 10l5 5 5-5z"/></svg>')`,
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'right 10px center', // Positions the arrow icon correctly
        backgroundSize: '12px', // Ensures the arrow icon is not too big
        // Additional padding to the right to ensure text does not overlap the arrow icon
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

    return (
        <form style={formStyle}>
            <h1 style={headerStyle}>Create Registered Student Organization</h1>
            <FormField label="Name:">
                <input
                    style={inputStyle}
                    type="text"
                    name="name"
                    placeholder="Enter RSO Name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                />
            </FormField>
            <FormField label="Type:">
                <select
                    style={selectStyle}
                    name="type"
                    value={type}
                    onChange={(e) => setType(e.target.value)}
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
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                />
            </FormField>
            <FormField label="Members:">
                <textarea
                    style={{...inputStyle, minHeight: '100px', resize: 'vertical'}}
                    name="members"
                    placeholder="Enter Member Emails (comma separated)"
                    value={members}
                    onChange={(e) => setMembers(e.target.value)}
                />
            </FormField>
            <Button onClick={() => console.log('Form submitted')}>Submit</Button>
        </form>
    );
};

export default CreateRso;
