import React, { useEffect, useState } from 'react';
import Button from './button';

const JoinRSO = () => {
    const [rsos, setRsos] = useState([]);
    const userId = localStorage.getItem('user');

    if(!userId) {
        //show toast
        window.showToast({title: "Error", message: "Must sign in to join RSO", type: "error", autoHide: false});
    }

    useEffect(() => {
        if (userId) {
            fetch(`/api/rsos?userId=${userId}`)
                .then(response => response.json())
                .then(data => setRsos(data.rsos))
                .catch(error => console.error('Error fetching RSO data:', error));
        }
     }, [userId]);
    //this needs to be made lmao
    const handleJoinRSO = (rsoId, rsoName) => {
        fetch('/api/rso/join', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ userId, rsoId }) // Sending both userId and rsoId
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                window.showToast({title: "Error", message: data.error, type: "error", autoHide: true});

            } else {
                window.showToast({title: "Success", message: `Joined RSO ${rsoName}`, type: "success", autoHide: true});
            }
        })
        .catch(error => console.error('Error joining RSO:', error));
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
            <h1 style={headerStyle}>Join Registered Student Organizations</h1>
            {rsos.map(rso => (
                <div key={rso.RSO_ID} style={{
                    padding: '10px',
                    margin: '10px',
                    borderRadius: '5px',
                    border: '1px solid',
                    borderColor: rso.COLOR,
                    fontSize: '16px',
                    width: '100%'
                }}>
                    <h4>{rso.RSO_NAME}</h4>
                    <p>{rso.RSO_DESCRIPTION}</p>
                    <Button onClick={() => handleJoinRSO(rso.RSO_ID, rso.RSO_NAME)}>
                        Join
                    </Button>
                </div>
            ))}
        </div>
    );
};

export default JoinRSO;
