Feature: view cart details

  As a hungry student
  So that I can make a decision about what to eat
  I want to view the relevant information about a food cart

#Background: movies in database

#  Given the following movies exist:
#  | title        | rating | director     | release_date |
#  | Star Wars    | PG     | George Lucas |   1977-05-25 |
#  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
#  | Alien        | R      |              |   1979-05-25 |
#  | THX-1138     | R      | George Lucas |   1971-03-11 |
#  | Deleted Film | R      | no           |   1980-01-01 |

#Scenario: add director to existing movie
#  When I go to the edit page for "Alien"
#  And  I fill in "Director" with "Ridley Scott"
#  And  I press "Update Movie Info"
#  Then the director of "Alien" should be "Ridley Scott"
Background: carts in database

  Given the following carts exist:
  | name        | user_id | location     | opening_time |closing_time|payment_options|top_rated_food|
  |The Chicken Dudes| 1|location1|'9:30:00'|'18:00:00'|'cash, venmo'|'chicken over rice'|

  And the following users exist:
  |email_id|name|
  |"owner_person@gmail.com"|"owner user"|

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

Scenario: see all the carts
  When I go to the home page
  Then I should see "The Chicken Dudes"
