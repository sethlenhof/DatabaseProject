import React from 'react';
import Modal from '../components/modal.jsx';
import UniversityProfileForm from '../components/universityForm.jsx';
export default class Test extends React.Component {

    render() {
        return (
            <Modal show={true}><UniversityProfileForm /></Modal>

        );
    }
}
