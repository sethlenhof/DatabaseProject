import React from 'react';
import TextBox from '../components/textBox.jsx'; // Import your custom TextBox

// CustomTimeInput receives props from DatePicker, including a ref
const CustomTimeInput = React.forwardRef(({ value, onClick, onChange }, ref) => (
    <TextBox
        type="text"
        placeholder="Select Time"
        value={value}
        onClick={onClick}  // For opening the DatePicker
        onChange={e => onChange(e.target.value)}  // To ensure it updates
        ref={ref}  // Forwarding ref to DOM input
    />
));

export default CustomTimeInput;
