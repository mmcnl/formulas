## 中医方剂搜索演示 TCM Formula Search 

**To see the app live, please visit [formulas.heroku.com](http://formulas.heroku.com)**

This little app demonstrates the use of a few current technologies and approaches:

  * Sinatra microframework
  * PostgreSQL full-text, relevance ranked search
    * migrations to import and convert a legacy sqlite database
    * compatible with free Heroku accounts (unlike Solr)
  * Cucumber/Capybara for high-level Executable Specification
  * RSpec for lower level specification
  * jQuery for AJAX updates and other dynamic behavior
  * Twitter Bootstrap for layout, design, and popovers

###Features

  **Feature: Find Relevant Formulas**

  If the user enters a few details about a medical presentation, the demo searches through a database of a few hundred Traditional Chinese Medicine herbal prescriptions and attempts to suggest relevant formulas.
  
  The returned formulas are selected based on how closely they match the given keywords.  Up to 7 matching formulas are listed in the order of most to least relevant.  They are shown in rows with their name and a graphic indication of their relevance rank.

    Background: 
      Given the user visits the formula search page

    Scenario: Find Formulas Relevant to a Wind-Heat Presentation
      When the symptoms are 'high fever, sore throat, sweating'
      And the pulse is 'rapid, floating'
      And the tongue is 'red body with yellow coat'
      And the search is initiated
      Then a results table is shown
      And these formulas and ranking graphs are displayed
        | 100 | yín qiáo sǎn           |
        | 82  | huáng lián jiě dú tāng |
        | 70  | qīng hào biē jiǎ tāng  |
        | 68  | lìu wèi dì huáng wán   |
        | 68  | bèi mǔ guā lǒu sǎn     |
        | 66  | rén shēn bài dú sǎn    |
        | 64  | qīng gǔ sǎn            |

    Scenario Outline: Search by Various Signs, Symptoms, and Diagnoses
      When the user searches for '<SYMPTOMS>', '<PULSE>', '<TONGUE>', and '<DIAGNOSIS>'
      Then the first formula listed should be '<TOP FORMULA>'.

      Examples: 
        | SYMPTOMS | PULSE | TONGUE | DIAGNOSIS         | TOP FORMULA          |
        | nausea   | wiry  |        |                   | bàn xìa hòu pò tāng  |
        | nausea   | weak  | red    |                   | mài mén dōng tāng    |
        | tinnitus |       |        | Kidney deficiency | lìu wèi dì huáng wán |
        | tinnitus |       |        | Liver yang rising | tiān má gōu téng yǐn |

    Scenario: No Matching Formulas
      When the user searches for 'xyz', 'xyz', 'xyz', and 'xyz'
      Then no results table or formulas are displayed

  **Feature: Find via AJAX Search**

  Rapid feedback is an important component in the learning process.  In order to help users quickly see how each change of their search terms alters their search results, results are updated as soon as any search field is changed.  This update happens without the need to explicitly select the 'Search' action.

      @javascript
      Scenario: Update Results Immediately on Change
        Given the user visits the formula search page
        When the user types 'fever' into the 'symptoms' field and moves to another field
        Then the results should immediately update
        And the first formula listed should be 'qīng hào biē jiǎ tāng'.

  **Feature: Fuzzy Search**

  In order to make it easier to find relevant formulas, a fuzzy search algorithm is used so that common words (stop words) are ignored, word-endings are disregarded (stemming), and a small list of Chinese medicine-related synonyms are treated equivalently.

      Scenario Outline: Receiving Same Results with Semantically Equivalent Searches
        Given the user visits the formula search page
        When the user searches for '<SYMPTOMS>', '<PULSE>', '<TONGUE>', and '<DIAGNOSIS>'
        Then the first formula listed should be '<TOP FORMULA>'.

        Examples: Stop Words Ignored
          | SYMPTOMS      | PULSE | TONGUE | DIAGNOSIS | TOP FORMULA         |
          | cold          |       |        |           | dà huáng fù zǐ tāng |
          | he has a cold |       |        |           | dà huáng fù zǐ tāng |

        Examples: Stemming
          | SYMPTOMS | PULSE    | TONGUE | DIAGNOSIS | TOP FORMULA |
          | cough    | floats   |        |           | sāng jú yǐn |
          | coughing | floating |        |           | sāng jú yǐn |

        Examples: TCM Synomym Expansion
          | SYMPTOMS | PULSE            | TONGUE   | DIAGNOSIS        | TOP FORMULA       |
          |          | weak, fast       |          |                  | mài mén dōng tāng |
          |          | deficient, rapid |          |                  | mài mén dōng tāng |
          |          |                  | enlarged | SP qi deficiency | guī pí tāng       |
          |          |                  | swollen  | Spleen qi xu     | guī pí tāng       |

  **Feature: Display Details Popover**

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

      16 scenarios (16 passed)
      57 steps (57 passed)
      0m7.288s

###RSpec

    FormulaSearch
      #prepare_sql
        returns an array for use by Formula.find_by_sql
        the return array
          contains 5 elements: the SQL template plus 4 variable bind strings
          the SQL template
            is a SELECT statement
            contains four question mark placeholders
          the 4 bind variable strings
            pass through unchanged simple invididual search terms
            pass through unchanged blank search terms
            separate multiple terms with the | character
            remove non-alpha characters
            remove extra whitespace
            synonym processing:
              expand known synonyms, ignoring case differences
              expand known synonyms, ignoring partial matches
              expand any number of synonyms
              expand synonyms without creating duplicate terms

    Finished in 0.14033 seconds
    13 examples, 0 failures

