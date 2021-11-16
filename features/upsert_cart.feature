Feature: upsert cart

  As a user of the app
  So that I can help share accurate information about carts
  I want to update an existing cart or add a new cart

  Background: carts in database

    Given the following users exist:
      | email_id               | name       |
      | owner_person@gmail.com | owner user |
      | test1@columbia.edu     | test1      |

    And the following carts exist:
      | name              | user_id | location  | coordinates                          | opening_time        | closing_time        | payment_options | top_rated_food      |
      | The Chicken Dudes | 1       | location1 | 40.80877070458994,-73.96310377081672 | 2021-11-02 13:30:00 | 2021-11-02 24:00:00 | 'cash, venmo'   | 'chicken over rice' |

    And the following reviews exist:
      | food_cart_id | user_id | rating | review               |
      | 1            | 2       | 3      | the food was alright |

  Scenario: Update cart's address
    Given I am on the home page
    And I am logged in
    When I view more for "The Chicken Dudes"
    And I follow "Edit Cart Details"
    And I fill in "cart[location]" with "new location"
    And I press "Save Changes"
    Then I should be on the view page for "The Chicken Dudes"
    And I should see "new location"

  Scenario: create a new cart
    Given I am on the home page
    And I am logged in
    And I follow "Add new food cart"
    And  I fill in "Name" with "the new cart"
    And  I fill in "Address" with "120th broadway"
    And I fill in "cart[opening_time]" with "09:30:00.000"
    And I fill in "cart[closing_time]" with "18:00:00.000"
    And I press "Add Cart"
    Then I should be on the home page
    And I should see "the new cart"
    When I view more for "the new cart"
    Then I should see "120th broadway"
    Then I should see "04:30AM"
    Then I should see "01:00PM"