import React, { useEffect, useState } from 'react';

const Modal = ({ show, onClose, children }) => {
    const [shouldDisplay, setShouldDisplay] = useState(false);
    const [isVisible, setIsVisible] = useState(false);

    useEffect(() => {
        if (show) {
            setShouldDisplay(true);  // First, make sure the modal is being displayed
            setTimeout(() => setIsVisible(true), 10); // Then trigger the opacity transition
        } else {
            setIsVisible(false);  // Start by hiding the modal
        }
    }, [show]);

    useEffect(() => {
        if (!isVisible && shouldDisplay) {
            // Only after the fade-out transition completes, remove the modal from the DOM
            const timer = setTimeout(() => {
                setShouldDisplay(false);
            }, 300); // This delay must match the transition duration
            return () => clearTimeout(timer);
        }
    }, [isVisible, shouldDisplay]);

    if (!shouldDisplay) return null;

    const handleBackgroundClick = (event) => {
        if (event.target === event.currentTarget) {
            onClose();
        }
    };

    const modalStyle = {
        transition: 'opacity 300ms ease-in-out',
        opacity: isVisible ? 1 : 0,
    };

    const backgroundStyle = {
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        backgroundColor: 'rgba(0,0,0,0.7)',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 2,
        backdropFilter: 'blur(5px)',
        ...modalStyle
    };

    const closeButtonStyle = {
        position: 'absolute',
        top: '10px',
        right: '10px',
        marginLeft: 'auto',
        cursor: 'pointer',
        color: 'red',
        fontSize: '24px',
        fontWeight: 'bold',
    };

    return (
        <div onClick={handleBackgroundClick} style={backgroundStyle}>
            <div style={{
                ...modalStyle, 
                backgroundColor: 'white',
                padding: '20px',
                borderRadius: '10px',
                maxWidth: '500px',
                width: '80%',
                maxHeight: '90%',
                overflowY: 'auto',
                position: 'relative',
            }}>
                <div style={closeButtonStyle} onClick={onClose}>
                    &#10006;
                </div>
                
                {children}
            </div>
        </div>
    );
};

export default Modal;
