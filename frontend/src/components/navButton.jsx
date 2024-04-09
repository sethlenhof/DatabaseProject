import React from 'react';
import { useNavigate } from 'react-router-dom';
import Button from './button.jsx';

const NavButton = ({ to, ...props }) => {
  const navigate = useNavigate();
  
  const handleNavigation = () => {
    navigate(to);
  };

  return <Button {...props} onClick={handleNavigation} />;
};

export default NavButton;