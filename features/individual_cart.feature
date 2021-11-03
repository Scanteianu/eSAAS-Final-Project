Feature: view cart details

  As a hungry student
  So that I can make a decision about what to eat
  I want to view the relevant information about a food cart

  Background: carts in database

    Given the following carts exist:
      | name              | user_id | location  | opening_time        | closing_time        | payment_options | top_rated_food      |
      | The Chicken Dudes | 1       | location1 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | 'cash, venmo'   | 'chicken over rice' |

    And the following users exist:
      | email_id               | name       |
      | owner_person@gmail.com | owner user |
      | test1@columbia.edu     | test1      |

    And the following reviews exist:
      | food_cart_id | user_id | rating | review               |
      | 1            | 2       | 3      | the food was alright |

  Scenario: view a cart's location
    When I go to the view page for "The Chicken Dudes"
    Then I should see "location1"

  Scenario: view a cart's open and close hours
    When I go to the view page for "The Chicken Dudes"
    Then I should see "09:30AM"
    And I should see "08:00PM"

  Scenario: view a cart's payment options
    When I go to the view page for "The Chicken Dudes"
    Then I should see "cash"
    And I should see "venmo"
    But I should not see "card"

  Scenario: view a cart's top rated food
    When I go to the view page for "The Chicken Dudes"
    Then I should see "chicken over rice"

  Scenario: view a cart's owner
    When I go to the view page for "The Chicken Dudes"
    Then I should see "owner user"

  Scenario: view a cart's reviews
    When I go to the view page for "The Chicken Dudes"
    Then I should see "Reviews"
    And I should see the user review for "test1"

  Scenario: see all the carts
    When I go to the home page
    Then I should see "The Chicken Dudes"

  Scenario: navigate to a cart's page
    When I go to the home page
    And I follow "The Chicken Dudes"
    Then I should be on the view page for "The Chicken Dudes"
