import React from 'react';

export const FormField = ({ label, children }) => {
    return (
        <div style={{
            display: 'flex',
            flexDirection: 'row',
            alignItems: 'center',
            marginBottom: '20px',
            justifyContent: 'space-between',
            width: '100%',
        }}>
            <label style={{
                width: '30%',
                margin: '10px',
                textAlign: 'right',
                fontSize: '1rem',
            }}>{label}</label>
            <div style={{
                width: '70%',
                margin: '0 10px',
                '::placeholder': {
                    color: '#aaa',
                    fontSize: '1rem',
                    opacity: 1,

                } 
            }}>
                {children}
            </div>
        </div>
    );
};
