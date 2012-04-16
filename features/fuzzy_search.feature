Feature: Fuzzy Search
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
