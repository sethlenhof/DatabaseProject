import React from "react";
import Button from "./button";

const CreateRso = () => {
    const id = localStorage.getItem('id');

    const [name, setName] = React.useState("");
    const [type, setType] = React.useState("");
    const [description, setDescription] = React.useState("");

    const inputStyle = {
        padding: '10px',
        margin: '0 10px',
        flex: 1,
        borderRadius: '5px',
        border: '1px solid #ccc',
        fontSize: '16px',
        outline: 'none',
        boxShadow: 'none', // default state without shadow
    };

    const focusedInputStyle = {
        boxShadow: '0 0 8px rgba(0, 0, 0, 0.7)', // blue glow effect
    };

    const labelStyle = {
        width: '150px', // Set a fixed width for better alignment
        margin: '10px',
        textAlign: 'right',
        fontSize: '16px',
    };

    const divStyle = {
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        width: '100%',
        justifyContent: 'space-between',
        marginBottom: '20px',
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
            <h1 style={headerStyle}>Create RSO</h1>
            <div style={divStyle}>
                <label style={labelStyle}>Name:</label>
                <input
                    style={inputStyle}
                    type="text"
                    name="name"
                    placeholder="Enter RSO Name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    onFocus={(e) => e.target.style.boxShadow = focusedInputStyle.boxShadow}
                    onBlur={(e) => e.target.style.boxShadow = 'none'}
                />
            </div>
            <div style={divStyle}>
                <label style={labelStyle}>Type:</label>
                <select
                    style={inputStyle}
                    name="type"
                    value={type}
                    onChange={(e) => setType(e.target.value)}
                    onFocus={(e) => e.target.style.boxShadow = focusedInputStyle.boxShadow}
                    onBlur={(e) => e.target.style.boxShadow = 'none'}
                >
                    <option value="">Select Type</option>
                    <option value="Fraternity">Fraternity</option>
                    <option value="Club">Club</option>
                    <option value="Honor Society">Honor Society</option>
                </select>
            </div>
            <div style={divStyle}>
                <label style={labelStyle}>Description:</label>
                <textarea
                    style={{...inputStyle, minHeight: '100px', resize: 'vertical'}}
                    name="description"
                    placeholder="RSO Description"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    onFocus={(e) => e.target.style.boxShadow = focusedInputStyle.boxShadow}
                    onBlur={(e) => e.target.style.boxShadow = 'none'}
                />
            </div>
            <Button onClick={() => console.log('Form submitted')}>Submit</Button>
        </form>
    );
};

export default CreateRso;
