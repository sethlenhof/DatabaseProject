import React from 'react';
import MyCalendar from '../components/calendar.jsx';
import ListView from '../components/listView.jsx';
import Modal from '../components/modal.jsx';
import CreateRso from '../components/createRso.jsx';
import Button from '../components/button.jsx';

export default class Test extends React.Component {

    render() {
        return (
            <Modal show={true}><CreateRso /></Modal>

        );
    }
}
