import React from 'react';
import { Avatar, Flex } from '@chakra-ui/react';
import '../styles/CartReview.css'

const CartReview = ({reviewInfo}) => {
    return <div className="cart-review">
        <Flex align="center" direction="row">           
            <Avatar name={reviewInfo.user} size="sm" src='' />                      
            <span className="user-name">{reviewInfo.user}</span>           
        </Flex>
        <div>Rating: {`${reviewInfo.star_rating}/5`}</div>
        <p className="description">{reviewInfo.text}</p>
    </div>
};

export default CartReview;