import React from 'react';

const MuiSVGText = ({SvgComponent, text}) => {
    return <div>
        {SvgComponent}
        <span style={{ 'paddingLeft': '5px' }}>{text}</span>
    </div>
};

export default MuiSVGText;