import React from 'react';
import {AppBar as MuiAppBar, Toolbar, Typography} from '@mui/material';
import './styles/AppBar.css';

const AppBar = ({appName}) => {
    return <MuiAppBar position="static">
        <Toolbar variant="dense">
            <Typography variant="h6" color="inherit" component="div">{appName}</Typography>
        </Toolbar>
    </MuiAppBar>
};

export default AppBar;