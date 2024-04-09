import React, { useEffect, useState } from 'react';

const Toast = ({ title, message, type, onClose, autoHide, style }) => {
    const [visible, setVisible] = useState(true);

    useEffect(() => {
        if (autoHide) {
            const timer = setTimeout(() => {
                setVisible(false); // Trigger the fade out
            }, 5000); // Time before starting the fade-out process
            return () => clearTimeout(timer);
        }
    }, [autoHide]);

    useEffect(() => {
        if (!visible) {
            const fadeOutTimer = setTimeout(onClose, 1000); // Adjust to 1s to match the fade-out transition time
            return () => clearTimeout(fadeOutTimer);
        }
    }, [visible, onClose]);

    const handleCloseInstantly = () => {
        onClose();
    };

    const baseToastStyle = {
        transition: 'opacity 1s', // Match with fadeOutTimer
        opacity: visible ? 1 : 0,
        minWidth: '250px',
        margin: '0.5rem',
        padding: '10px',
        borderRadius: '4px',
        display: 'flex',
        alignItems: 'center',
        boxShadow: '0 0 10px rgba(0,0,0,0.1)',
        zIndex: 1000,
    };

    const toastStyle = {
        ...baseToastStyle,
        backgroundColor: type === 'success' ? '#dff0d8' : '#e8817c',
        color: type === 'success' ? '#3c763d' : '#891d18',
        ...style,
    };

    const iconStyle = {
        marginRight: '20px',
    };

    const closeButtonStyle = {
        marginLeft: 'auto',
        cursor: 'pointer',
    };

    return (
        <div style={toastStyle}>
            <div style={iconStyle}>
            {type === 'success' ? <span>&#10003;</span> : <span>&#10060;</span>}
            </div>
            <div>
                <div style={{ fontWeight: 'bold' }}>{title}</div>
                <div>{message}</div>
            </div>
            <div style={closeButtonStyle} onClick={() => handleCloseInstantly()}>
                    &#10006;
            </div>
        </div>
    );
};

const ToastContainer = () => {
    const [toasts, setToasts] = useState([]);

    const addToast = (toast) => setToasts(currentToasts => [{ ...toast, id: Date.now() }, ...currentToasts]);
    const removeToast = (id) => setToasts(currentToasts => currentToasts.filter(toast => toast.id !== id));

    useEffect(() => {
        window.showToast = addToast;
    }, []);

    // Container style for proper positioning
    const containerStyle = {
        position: 'fixed',
        top: '20px',
        right: '20px',
    };

    return (
        <div style={containerStyle}>
            {toasts.map((toast, index) => (
                <Toast
                    key={toast.id}
                    title={toast.title}
                    message={toast.message}
                    type={toast.type}
                    autoHide={toast.autoHide}
                    onClose={() => removeToast(toast.id)}
                    style={{
                        top: `${index * 70}px`, // Calculate vertical position
                    }}
                />
            ))}
        </div>
    );
};

export default ToastContainer;
