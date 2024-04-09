import React, { useEffect, useState } from 'react';

let lastToastId = 0; // Guarantees toast ID uniqueness

const Toast = ({ id, title, message, type, onClose, autoHide, style }) => {
    const [visible, setVisible] = useState(true); // Track visibility for fading

    useEffect(() => {
        let timer;
        if (autoHide) {
            timer = setTimeout(() => {
                setVisible(false); // Initiate fade out by changing visibility
            }, 5000); // Time before starting the fade-out process
        }
        return () => clearTimeout(timer);
    }, [autoHide]);

    useEffect(() => {
        let fadeOutTimer;
        if (!visible) {
            fadeOutTimer = setTimeout(() => onClose(id), 1000); // Match the transition time
        }
        return () => clearTimeout(fadeOutTimer);
    }, [visible, onClose, id]);

    const toastStyle = {
        transition: 'opacity 1s',
        opacity: visible  ? 1 : 0,
        minWidth: '250px',
        margin: '0.5rem',
        padding: '10px',
        borderRadius: '4px',
        display: 'flex',
        alignItems: 'center',
        boxShadow: '0 0 10px rgba(0,0,0,0.1)',
        zIndex: 1000,
        backgroundColor: type === 'success' ? '#dff0d8' : '#e8817c',
        color: type === 'success' ? '#3c763d' : '#891d18',
        ...style,
    };

    const closeButtonStyle = {
        marginLeft: 'auto',
        cursor: 'pointer',
    };

    return (
        <div style={toastStyle}>
            <div style={{ marginRight: '10px' }}>
                {type === 'success' ? <span>&#10003;</span> : <span>&#10060;</span>}
            </div>
            <div>
                <div style={{ fontWeight: 'bold' }}>{title}</div>
                <div>{message}</div>
            </div>
            <div style={closeButtonStyle} onClick={() => onClose(id)}>
                &#10006;
            </div>
        </div>
    );
};

const ToastContainer = () => {
    const [toasts, setToasts] = useState([]);

    const addToast = (toast) => {
        const id = ++lastToastId; // Increment before use to ensure it starts from 1
        setToasts(currentToasts => [{ ...toast, id }, ...currentToasts]);
    };

    const removeToast = (id) => {
        setToasts(currentToasts => currentToasts.filter(toast => toast.id !== id));
    };

    useEffect(() => {
        window.showToast = ({ title, message, type, autoHide }) => 
            addToast({ title, message, type, autoHide });
    }, []);

    return (
        <div style={{ position: 'fixed', top: '20px', right: '20px' }}>
            {toasts.map((toast, index) => (
                <Toast
                    key={toast.id}
                    id={toast.id}
                    title={toast.title}
                    message={toast.message}
                    type={toast.type}
                    autoHide={toast.autoHide}
                    onClose={removeToast}
                    style={{
                        top: `${index * 70}px`, // Adjust if necessary based on your toast height
                    }}
                />
            ))}
        </div>
    );
};

export default ToastContainer;
