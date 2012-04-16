Feature: Find via AJAX Search
  Rapid feedback is an important component in the learning process.  In order to help users quickly see how each change of their search terms alters their search results, results are updated as soon as any search field is changed.  This update happens without the need to explicitly select the 'Search' action.

@javascript
Scenario: Update Results Immediately on Change
  Given the user visits the formula search page
  When the user types 'fever' into the 'symptoms' field and moves to another field
  Then the results should immediately update 
  And the first formula listed should be 'qīng hào biē jiǎ tāng'.
