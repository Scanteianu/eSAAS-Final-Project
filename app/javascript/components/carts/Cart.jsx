import React, { useEffect, useState } from 'react';
import PaymentIcon from '@mui/icons-material/Payment';
import LocationOn from '@mui/icons-material/LocationOn';
import { Container } from '@mui/material';
import MuiSVGText from '../MuiSVGText';
import CartReview from '../Reviews/CartReview';

const Cart = () => {
    useEffect(() => {
        fetch('/api/carts/1')
            .then(response => response.json())
            .then(data => {
                if (data) {
                    console.log(data);
                    setLocalCartData(data);
                }
            })
    }, []);

    const [localCartData, setLocalCartData] = useState({});

    return <Container>
        <h1>{localCartData.name}</h1>
        <MuiSVGText SvgComponent={<LocationOn />} text={localCartData.location} />
        {localCartData.paymentOptions && <MuiSVGText SvgComponent={<PaymentIcon />} text={localCartData.paymentOptions.join(', ')} />}
        <h3 style={{'marginTop': '1rem'}}>Reviews</h3>
        {
            localCartData.reviews 
                ? localCartData.reviews.map(review => <CartReview key={review.name} reviewInfo={review} />)
                : 'None'
        }
    </Container>
};

export default Cart;