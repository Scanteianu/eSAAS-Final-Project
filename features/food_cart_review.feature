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
            | name              | user_id | location  | coordinates                          | opening_time        | closing_time        | payment_options | top_rated_food    |
            | The Chicken Dudes | 1       | location1 | 40.80877070458994,-73.96310377081672 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, venmo     | chicken over rice |
            | The Mexican Cart  | 2       | location2 | 40.80680499795128,-73.96078581662722 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, card      | Carne Asada Tacos |

        And the following reviews exist:
            | food_cart_id | user_id | rating | review                           |
            | 1            | 3       | 3      | the food was alright             |
            | 1            | 3       | 5      | The carne asada was super tender |

    Scenario: Write a review for a food cart
        Given I am on the home page
        When I view more for "The Chicken Dudes"
        And I fill in "cart_review[review]" with "I love the chicken over rice"
        And I select "5" from "cart_review[rating]"
        And I press "Save Changes"
        Then I should be on the view page for "The Chicken Dudes"
        And I should see "Rating: 5/5"
        And I should see "I love the chicken over rice"
