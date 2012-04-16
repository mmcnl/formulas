Feature: Display Details Popover
  After performing a successful search a user will likely want to learn more detailed information about the formulas listed.  In order to facilitate this, when a user hovers over a formula's row in the results table, a popover is shown.  This popover includes a full description of the formula's properties as well as highlighting to indicate which aspects of the properties matched the user's search terms.

Background:
  Given the user visits the formula search page
  When the symptoms are 'fever'
  And the search is initiated
  And a results table is shown

@javascript
Scenario: Show Popover When Hovering Over a Formula
  Given there is no popover displayed for the first formula
  When the user hovers over that formula's row
  Then that row's popover is displayed
