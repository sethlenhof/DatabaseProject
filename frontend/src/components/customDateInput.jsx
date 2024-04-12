import React from 'react';
import TextBox from './textBox.jsx'; // Import your custom TextBox

// CustomInputComponent receives props from DatePicker, including a ref
const CustomDateInput = React.forwardRef(({ value, onClick, onChange }, ref) => (
    <TextBox
        type="text"
        placeholder="Select Date"
        value={value}
        onClick={onClick}  // For opening the DatePicker
        onChange={e => onChange(e.target.value)}  // To ensure it updates
        ref={ref}  // Forwarding ref to DOM input
    />
));

export default CustomDateInput;
