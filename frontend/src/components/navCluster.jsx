import React, { useState } from 'react';
import Modal from './modal';
import EventForm from './eventForm.jsx';
import CreateRso from './createRsoForm.jsx';
import UniversityProfileForm from './universityForm.jsx';
import JoinRSO from './joinRSO.jsx';
import ApproveEvents from './approveEvents.jsx';

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
            case 'create-rso':
                return <CreateRso />;
            case 'university':
                return <UniversityProfileForm />;
            case 'approveEvents':
                return <ApproveEvents />;
            case 'join-rso':
                return <h1><JoinRSO /></h1>;
            default:
                return null;
        }
    };

    return (
        <div style={buttonClusterStyle}>
            {['rsoAdmin', 'superAdmin'].includes(user.role) && (
                <button onClick={() => handleOpenModal('createEvent')} style={createButtonStyle}>Create University Event</button>
            )}
            <Modal show={showModal} onClose={handleCloseModal}>
                {renderModalContent()}
            </Modal>
            {user.role === 'superAdmin' && (
                <>
                    <button onClick={() => handleOpenModal('university')} style={buttonStyle}>Update University Page</button>
                    <button onClick={() => handleOpenModal('approveEvents')} style={buttonStyle}>Approve Events</button>
                </>
            )}
            {/* make sure to remove super admin later */}
            {['student', 'rsoAdmin', 'superAdmin'].includes(user.role) && (
            <>
                <button onClick={() => handleOpenModal('create-rso')} style={createButtonStyle}>Create RSO</button>
                <button onClick={() => handleOpenModal('join-rso')} style={buttonStyle}>Join RSO</button>
            </>
            )}
            {user.role === 'unknown' && (
                <button onClick={() => window.location.href="/"} style={buttonStyle}>Login</button>
            )}
        </div>
    );
};

export default NavCluster;
