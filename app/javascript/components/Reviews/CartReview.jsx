import React from 'react';
import Rating from '@mui/material/Rating';
import Avatar from '@mui/material/Avatar';
import '../styles/CartReview.css'

const CartReview = ({reviewInfo}) => {
    const stringToColor = (string) => {
        let hash = 0;
        let i;
        
        /* eslint-disable no-bitwise */
        for (i = 0; i < string.length; i += 1) {
            hash = string.charCodeAt(i) + ((hash << 5) - hash);
        }
        
        let color = '#';
        
        for (i = 0; i < 3; i += 1) {
            const value = (hash >> (i * 8)) & 0xff;
            color += `00${value.toString(16)}`.substr(-2);
        }
        /* eslint-enable no-bitwise */
        
        return color;
    }

    return <div className="cart-review">
        <div className="review-user">
            <Avatar sx={{ bgcolor: stringToColor(reviewInfo.user)}}>{reviewInfo.user[0]}</Avatar>
            <span className="user-name">{reviewInfo.user}</span>               
        </div>
        <Rating name="read-only" precision={0.1} value={reviewInfo.star_rating} readOnly />
        <p className="description">{reviewInfo.text}</p>
    </div>
};

export default CartReview;