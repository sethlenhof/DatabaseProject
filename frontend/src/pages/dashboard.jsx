import React from 'react';
import MyCalendar from '../components/calendar';
import NavCluster from '../components/navCluster';
import EventViewScrollable from '../components/eventViewScollable';

export default class Dashboard extends React.Component {
    constructor(props) {
        super(props);
        console.log("constructor called")
        this.state = {
            // Define your state here
            userType: '',
            isLoading: true,
            userId: localStorage.getItem("user"),
            events: [],
            // Define your events array
            // events: [
            //     // ways to format the data
            //     {title: 'Goon', start: '2024-04-10T10:00:00', end: '2024-04-10T12:00:00', color: '#ff9f89'},
            //     {title: 'test day', date: '2024-04-13', color: '#ff9f89'},
            // ]
        };
    }

    componentDidMount() {
        console.log("component did mount")
        this.fetchUserType();
        this.getEvents();
    }
  
    //fetch userType
    fetchUserType = () => {
        const url = `/api/users/type?userId=${this.state.userId}`;
        fetch(url, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
            },
        }).then((data) => {
            if (data.status === 200) {
                data.json().then((data) => {
                    this.setState({ userType: data.userType, isLoading: false});
                });
            } else {
                this.setState({ isLoading: false });
                console.log("Error fetching user type");
            }
        });
    }

    getEvents = () => {
        fetch(`/api/users/events?userId=${this.state.userId}`)
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    console.error('Error getting events', data.error);
                } else {
                    this.setState({ events: data.events, isLoading: false});
                }
            }).catch(error => console.error('Error getting events', error));
    };

    render() {
        if (this.state.isLoading) {
            return <div>Loading...</div>;
        }
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
                        <h1>Welcome, USERNAME</h1>  {/* Consider adding username handling if needed */}
                </div>
                <div style={{
                    display: 'flex',
                    flex: 1,
                    justifyContent: 'space-around',
                    padding: '20px 0',
                }}>
                    <div style={{ width: '45%' }}>
                        <h1 style={{ textAlign: 'center' }}>Calendar</h1>
                        <MyCalendar events={this.state.events}/>
                    </div>
                    <div style={{ width: '45%' }}>
                        <h1 style={{ textAlign: 'center' }}>Upcoming Events</h1>
                        <EventViewScrollable events={this.state.events} />
                    </div>
                </div>
            </div>
        );
    }
    
}