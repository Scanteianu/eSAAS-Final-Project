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

Scenario: view a cart
  When I go to the view page for "The Chicken Dudes"
  Then I should see "Cash"
  And I should see "Venmo"
  But I should not see "Credit"
