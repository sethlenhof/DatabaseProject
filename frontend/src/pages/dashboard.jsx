import React from 'react';
import MyCalendar from '../components/calendar';
import NavCluster from '../components/navCluster';
import ListView from '../components/listView';

export default class Dashboard extends React.Component {
    state = {
        // Define your state here
        userType: '',
        isLoading: true,
        userId: localStorage.getItem("user"),

        // Define your events array
        events: [
            // ways to format the data
            {title: 'Goon', start: '2024-04-10T10:00:00', end: '2024-04-10T12:00:00', color: '#ff9f89'},
            {title: 'test day', date: '2024-04-13', color: '#ff9f89'},
        ]
    };

    componentDidMount() {
        
    }

    //fetch userType
    async fetchUserType() {
        fetch("/api/users/type", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                userId: this.state.userId,
            }),
        }).then((data) => {
            if (data.status === 200) {
                data.json().then((data) => {
                    this.setState({ userType: data.userType, isLoading: false});
                });
            } else {
                console.log("Error fetching user type");
            }
        });
    }

    render() {
        return (
            <div style={{
                display: 'flex',
                flexDirection: 'column',
                height: '100vh',
                overflow: 'hidden',
            }}>
                <NavCluster user={{ role: this.state.userType }} />
                <div style={{
                        textAlign: 'center',
                    }}>
                        <h1>Welcome, USERNAME</h1>
                </div>
                <div style={{
                    display: 'flex',
                    flex: 1,
                    justifyContent: 'space-around',
                    padding: '20px 0',
                }}>
                    <div style={{ width: '45%' }}>
                        <h1 style={{ textAlign: 'center' }}>Calendar</h1>
                        <MyCalendar events={this.events}/>
                    </div>
                    <div style={{ width: '45%' }}>
                        <h1 style={{ textAlign: 'center' }}>Upcoming Events</h1>
                        <ListView events={this.events} />
                    </div>
                </div>
            </div>
        );
    }
}