Feature: view cart by name

    As a foodie looking for food trucks
    I want to be able to view more information
    about named food truck

    Background: food trucks in database

        Given the following food carts exist:
            | name            | location  | opening_time | closing_time | payment_options     | top_rated_food    |
            | mexican cart    | location1 | 9:30:00      | 18:00:00     | 'Cash, Card'        | taco al pastor    |
            | The Halal Guys  | location2 | 9:30:00      | 18:00:00     | 'Cash, Card, Venmo' | chicken over rice |
            | Dumpling Corner | location3 | 9:30:00      | 18:00:00     | 'Cash, Venmo'       | Soup  dumplings   |

    @javascript
    Scenario: view information for The Halal Guys
        When I go to the view page for "The Halal Guys"
        Then I should see "Cash"
        Then I should see "Card"
        Then I should see "Venmo"
