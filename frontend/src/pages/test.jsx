import React from 'react';
import NavCluster from '../components/navCluster';


export default class Test extends React.Component {

    render() {
        return (
            <>
                <NavCluster user={{role: 'admin'}} />
            <div>
                
            </div>
            </>
        );
    }
}
