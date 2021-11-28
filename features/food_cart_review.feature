Feature: Give a review to a Food Cart

    As a hungry student
    I want to see what food truck options there are

    Background: carts in database

        Given the following users exist:
            | email_id                         | name                |
            | owner_person@gmail.com           | owner user          |
            | owner2_person@gmail.com          | owner user 2        |
            | test1@columbia.edu               | test1               |
            | logged_in_test_user@columbia.edu | logged_in_test_name |

        And the following carts exist:
            | name              | user_id | location  | coordinates                          | opening_time        | closing_time        | payment_options | top_rated_food    |
            | The Chicken Dudes | 1       | location1 | 40.80877070458994,-73.96310377081672 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, venmo     | chicken over rice |
            | The Mexican Cart  | 2       | location2 | 40.80680499795128,-73.96078581662722 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | cash, card      | Carne Asada Tacos |

        And the following reviews exist:
            | food_cart_id | user_id | rating | review                           |
            | 1            | 3       | 3      | the food was alright             |
            | 2            | 3       | 5      | The carne asada was super tender |

    @javascript
    Scenario: Write a review for a food cart
        Given I am on the home page
        And I am logged in
        When I view more for "The Chicken Dudes"
        And I fill in "initial_cart_review[review]" with "I love the chicken over rice"
        And I select "5" from "initial_cart_review[rating]"
        And I post review
        Then I should be on the view page for "The Chicken Dudes"
        And I should see "Rating: 5/5"
        And I should see "I love the chicken over rice"
        And I should see "logged_in_test_name"
        And I should see "test1"
        And I should only see "2" review(s)

    @javascript
    Scenario: Write single review for a food cart
        Given I am on the home page
        And I am logged in
        When I view more for "The Chicken Dudes"
        And I fill in "initial_cart_review[review]" with "the pita is meh"
        And I select "3" from "initial_cart_review[rating]"
        And I post review
        And I go to the home page
        And I view more for "The Chicken Dudes"
        Then I should be on the view page for "The Chicken Dudes"
        And I should see "Rating: 3/5"
        And I should see "the pita is meh"
        And I should see "logged_in_test_name"
        And I should see "test1"
        And I should not see the post review section
        And I should only see "2" review(s)

    @javascript
    Scenario: Edit a review for a food cart
        Given I am on the home page
        And I am logged in
        When I view more for "The Chicken Dudes"
        And I fill in "initial_cart_review[review]" with "the pita is meh"
        And I select "3" from "initial_cart_review[rating]"
        And I post review
        And I edit review
        And I fill in "edit_cart_review[review]" with "the pita is meh..."
        And I select "2" from "edit_cart_review[rating]"
        And I update review
        Then I should be on the view page for "The Chicken Dudes"
        And I should see "Rating: 2/5"
        And I should see "the pita is meh..."
        And I should see "logged_in_test_name"
        And I should see "test1"
        And I should only see "2" review(s)

    @javascript
    Scenario: Delete authored review for food cart
        Given I am on the home page
        And I am logged in
        When I view more for "The Chicken Dudes"
        And I fill in "initial_cart_review[review]" with "the pita is meh"
        And I select "3" from "initial_cart_review[rating]"
        And I post review
        And I delete review
        Then I should be on the view page for "The Chicken Dudes"
        And I should not see "the pita is meh"
        And I should not see "logged_in_test_name"
        And I should only see "1" review(s)
        And I should see the post review section

    Scenario: Try writing a review, without signing in, for a food cart
        Given I am on the home page
        And I am logged out
        When I view more for "The Chicken Dudes"
        And I should not see the post review section