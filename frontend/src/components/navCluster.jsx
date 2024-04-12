import React, { useState } from 'react';
import Modal from './modal';
import EventForm from './eventForm.jsx';

const NavCluster = ({ user }) => {
    const [modalContent, setModalContent] = useState('');
    const [showModal, setShowModal] = useState(false);

    const handleOpenModal = (content) => {
        setModalContent(content);
        setShowModal(true);
    };

    const handleCloseModal = () => {
        setShowModal(false);
    };

    const buttonClusterStyle = {
        position: 'relative',
        top: '20px',
        left: '20px',
        display: 'flex',
        flexDirection: 'row',
        gap: '10px',
    };

    const buttonStyle = {
        padding: '10px 20px',
        border: 'none',
        borderRadius: '5px',
        boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
        cursor: 'pointer',
        backgroundColor: '#f0f0f0',
        color: 'black',
    };

    const createButtonStyle = {
        ...buttonStyle,
        backgroundColor: 'green',
        color: 'white',
    };

    const renderModalContent = () => {
        switch (modalContent) {
            case 'createEvent':
                return <EventForm />
            case 'rso':
                return <h1>RSO Management Form</h1>;
            case 'university':
                return <h1>University Management Form</h1>;
            case 'approveEvents':
                return <h1>Approve Events Form</h1>;
            default:
                return null;
        }
    };

    return (
        <div style={buttonClusterStyle}>
            {['admin', 'superAdmin'].includes(user.role) && (
                <button onClick={() => handleOpenModal('createEvent')} style={createButtonStyle}>Create Event</button>
            )}
            <Modal show={showModal} onClose={handleCloseModal}>
                {renderModalContent()}
            </Modal>

            {user.role === 'admin' && (
                <button onClick={() => handleOpenModal('rso')} style={buttonStyle}>RSO</button>
            )}
            
            {user.role === 'superAdmin' && (
                <>
                    <button onClick={() => handleOpenModal('university')} style={buttonStyle}>University Page</button>
                    <button onClick={() => handleOpenModal('approveEvents')} style={buttonStyle}>Approve Events</button>
                </>
            )}
        </div>
    );
};

export default NavCluster;
