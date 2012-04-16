Feature: Find Relevant Formulas
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
