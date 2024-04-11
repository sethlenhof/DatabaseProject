import React from 'react';
import { Link } from 'react-router-dom'; // Assuming you're using react-router for navigation

const NavCluster = ({ user }) => {
    const buttonClusterStyle = {
        position: 'relative',
        top: '20px',
        left: '20px',
        display: 'flex',
        flexDirection: 'row', // Align buttons in a row
        gap: '10px', // Space between buttons
    };

    const buttonStyle = {
        padding: '10px 20px', // Padding around the text
        border: 'none',
        borderRadius: '5px', // Rounded borders
        boxShadow: '0 4px 6px rgba(0,0,0,0.1)', // Shadow effect
        cursor: 'pointer',
        backgroundColor: '#f0f0f0', // Default background color for buttons except "Create Event"
        color: 'black', // Default text color
    };

    const createButtonStyle = {
        ...buttonStyle,
        backgroundColor: 'green', // Specific color for the Create button
        color: 'white', // Text color for the Create button
    };

    return (
        <div style={buttonClusterStyle}>
            {['admin', 'superAdmin'].includes(user.role) && (
                <Link to="/create-event" style={{ textDecoration: 'none' }}>
                    <button style={createButtonStyle}>Create Event</button>
                </Link>
            )}
            
            {user.role === 'admin' && (
                <Link to="/rso" style={{ textDecoration: 'none' }}>
                    <button style={buttonStyle}>RSO</button>
                </Link>
            )}
            
            {user.role === 'superAdmin' && (
                <>
                    <Link to="/university" style={{ textDecoration: 'none' }}>
                        <button style={buttonStyle}>University Page</button>
                    </Link>
                    <Link to="/approve-events" style={{ textDecoration: 'none' }}>
                        <button style={buttonStyle}>Approve Events</button>
                    </Link>
                </>
            )}
        </div>
    );
};

export default NavCluster;
