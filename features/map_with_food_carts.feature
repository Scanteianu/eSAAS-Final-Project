Feature: view Google Maps with Food Carts

    As a hungry student
    I want to see what food truck are nearby on the map

    Background: carts in database

        Given the following users exist:
            | email_id                | name         |
            | owner_person@gmail.com  | owner user   |
            | owner2_person@gmail.com | owner user 2 |
            | test1@columbia.edu      | test1        |

        And the following carts exist:
            | name              | user_id | location  | coordinates                          | opening_time        | closing_time        | payment_options | top_rated_food    |
            | The Chicken Dudes | 1       | location1 | 40.80877070458994,-73.96310377081672 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, venmo     | chicken over rice |
            | The Mexican Cart  | 2       | location2 | 40.80680499795128,-73.96078581662722 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, card      | Carne Asada Tacos |

        And the following reviews exist:
            | food_cart_id | user_id | rating | review                           |
            | 1            | 3       | 3      | the food was alright             |
            | 1            | 3       | 5      | The carne asada was super tender |

    @javascript
    Scenario: view all of the food cart markers on the map
        When I go to the home page
        Then I should see Google Maps
        And I should see 2 markers on the map
        And I should see a map marker for "The Chicken Dudes"
        And I should see a map marker for "The Mexican Cart"