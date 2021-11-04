Feature: view cart list

    As a hungry student
    I want to see what food truck options there are

    Background: carts in database

        Given the following users exist:
            | email_id                | name         |
            | owner_person@gmail.com  | owner user   |
            | owner2_person@gmail.com | owner user 2 |
            | test1@columbia.edu      | test1        |

        And the following carts exist:
            | name              | user_id | location  | opening_time        | closing_time        | payment_options | top_rated_food    |
            | The Chicken Dudes | 1       | location1 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, venmo     | chicken over rice |
            | The Mexican Cart  | 2       | location2 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, card      | Carne Asada Tacos |

        And the following reviews exist:
            | food_cart_id | user_id | rating | review                           |
            | 1            | 3       | 3      | the food was alright             |
            | 1            | 3       | 5      | The carne asada was super tender |

    Scenario: view all carts
        When I go to the home page
        Then I should see "The Chicken Dudes"
        And I should see "location1"
        And I should see "Payment Options: cash, venmo"
        And I should see "Top Rated Food: chicken over rice"
        And I should see "The Mexican Cart"
        And I should see "location2"
        And I should see "Payment Options: cash, card"
        And I should see "Carne Asada Tacos"