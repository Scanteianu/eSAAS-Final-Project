import React, { useEffect, useState } from 'react';
import { Container, Heading, List, ListItem, ListIcon } from "@chakra-ui/react"
import { MdPayment } from 'react-icons/md'
import { GoLocation } from 'react-icons/go' 
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
        <Heading as="h1">{localCartData.name}</Heading>
        <List>
            <ListItem>
                <ListIcon as={GoLocation} />
                {localCartData.location}
            </ListItem>
            {localCartData.paymentOptions && <ListItem>
                <ListIcon as={MdPayment} />
                {localCartData.paymentOptions.join(', ')}
            </ListItem>}
        </List>
        <Heading as="h3" size="md" marginTop="1rem">Reviews</Heading>
        {
            localCartData.reviews 
                ? localCartData.reviews.map(review => <CartReview key={review.name} reviewInfo={review} />)
                : 'None'
        }
    </Container>
};

export default Cart;