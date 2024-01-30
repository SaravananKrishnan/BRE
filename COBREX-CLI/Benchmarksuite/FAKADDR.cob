      *========================== COB-FAKER ===========================*
      * Authors: Brian D Pead
      *
      * License: MIT
      *
      * Date        Version  Description
      * ----        -------  -----------
      * 2020-02-08  1.0      First release
      *================================================================*

       IDENTIFICATION DIVISION.
      *========================

       PROGRAM-ID.             FAKADDR.

       ENVIRONMENT DIVISION.
      *=====================

       CONFIGURATION SECTION.
      *----------------------

       SOURCE-COMPUTER.
           IBM-Z15.
      *    IBM-Z15 DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
      *---------------------

       FILE-CONTROL.
      /
       DATA DIVISION.
      *==============

       FILE SECTION.
      *-------------

       WORKING-STORAGE SECTION.
      *------------------------

       01  W-FOUND-DX              PIC S9(4)  COMP.
       01  W-RANDOM-NO             PIC S9(4)V9(9)
                                              COMP.
       01  W-RANDOM-SUB            PIC S9(4)  COMP.
       01  W-SUB-1                 PIC S9(4)  COMP.
       01  W-SUB-1-SAVE            PIC S9(4)  COMP.
       01  W-SUB-2                 PIC S9(4)  COMP.
       01  W-SUB-D                 PIC S9(4)  COMP.
       01  W-DIGIT-CNT             PIC S9(4)  COMP.
       01  W-RANDOM-DIG            PIC 9.
       01  W-TABLE-1               PIC X(30).
       01  W-TABLE-2               PIC X(30)       VALUE SPACES.
       01  W-FAKER-RESULT          PIC X(80).
       01  W-FAKER-FORMAT          PIC X(80).
       01  W-FORMAT-START          PIC X           VALUE '{'.
       01  W-FORMAT-END            PIC X           VALUE '}'.

       01  FILLER                  PIC X(01)       VALUE 'Y'.
           88  W-FIRST-CALL                        VALUE 'Y'.
           88  W-NOT-FIRST-CALL                    VALUE 'N'.

       01  W-COMPILED-DATE.
           05  W-COMPILED-DATE-YYYY
                                   PIC X(04).
           05  W-COMPILED-DATE-MM  PIC X(02).
           05  W-COMPILED-DATE-DD  PIC X(02).
           05  W-COMPILED-TIME-HH  PIC X(02).
           05  W-COMPILED-TIME-MM  PIC X(02).
           05  W-COMPILED-TIME-SS  PIC X(02).
           05  FILLER              PIC X(07).

       01  W-RECURSED-FORMAT.
           05  W-RECURSED-FORMAT-CHAR
                                   PIC X           OCCURS 80
                                                   INDEXED W-RF-DX.
       01  W-RECURSED-FORMAT-REST  PIC X(80).

       01  W-POINTER               PIC S9(4)  COMP.
       01  W-POSTCODE              PIC 9(05).
       01  W-HASH                  PIC X(01)       VALUE '#'.
       01  W-PERCENT               PIC X(01)       VALUE '%'.
       01  W-FAKPERS-PROG          PIC X(08)       VALUE 'FAKPERS'.
       01  W-FAKRAND-PROG          PIC X(08)       VALUE 'FAKRAND'.

       01  W-FORMAT-ENTRY          PIC X(04).
           88  W-FORMAT-ENTRY-IS-FORMAT            VALUE 'CT'
                                                         'SA'
                                                         'SN'.

       01  W-FAKER-PARAMETER.      
           05  FAKER-PROVIDER-FUNCTION
                                   PIC X(30).
               88  ADDRESS-ADDRESS                 VALUE 
                                   'ADDRESS-ADDRESS'.
               88  ADDRESS-BUILDING-NO             VALUE 
                                   'ADDRESS-BUILDING-NO'.
               88  ADDRESS-CITY                    VALUE 
                                   'ADDRESS-CITY'.
               88  ADDRESS-CITY-PREFIX             VALUE 
                                   'ADDRESS-CITY-PREFIX'.
               88  ADDRESS-CITY-SUFFIX             VALUE 
                                   'ADDRESS-CITY-SUFFIX'.
               88  ADDRESS-MILITARY-APO            VALUE
                                   'ADDRESS-MILITARY-APO'.
               88  ADDRESS-MILITARY-DPO            VALUE
                                   'ADDRESS-MILITARY-DPO'.
               88  ADDRESS-MILITARY-SHIP-PREFIX    VALUE
                                   'ADDRESS-MILITARY-SHIP-PREFIX'.
               88  ADDRESS-MILITARY-STATE-ABBR     VALUE
                                   'ADDRESS-MILITARY-STATE-ABBR'.
               88  ADDRESS-POSTCODE                VALUE 
                                   'ADDRESS-POSTCODE'.
               88  ADDRESS-SECONDARY-ADDRESS       VALUE 
                                   'ADDRESS-SECONDARY-ADDRESS'.
               88  ADDRESS-STATE                   VALUE 
                                   'ADDRESS-STATE'.
               88  ADDRESS-STATE-ABBR              VALUE 
                                   'ADDRESS-STATE-ABBR'.
               88  ADDRESS-STATE-POSTCODE          VALUE 
                                   'ADDRESS-STATE-POSTCODE'.
               88  ADDRESS-STREET-ADDRESS          VALUE 
                                   'ADDRESS-STREET-ADDRESS'.
               88  ADDRESS-STREET-NAME             VALUE 
                                   'ADDRESS-STREET-NAME'.
               88  ADDRESS-STREET-SUFFIX           VALUE 
                                   'ADDRESS-STREET-SUFFIX'.
               88  ADDRESS-TERRITORY-ABBR          VALUE
                                   'ADDRESS-TERRITORY-ABBR'.
               88  BANK-ACCOUNT                    VALUE
                                   'BANK-ACCOUNT'.
               88  BANK-ROUTING                    VALUE
                                   'BANK-ROUTING'.
               88  COMPANY-COMPANY                 VALUE
                                   'COMPANY-COMPANY'.
               88  COMPANY-SUFFIX                  VALUE
                                   'COMPANY-SUFFIX'.
               88  PERSON-FIRST-NAME               VALUE 
                                   'PERSON-FIRST-NAME'.    
               88  PERSON-FIRST-NAME-MALE          VALUE
                                   'PERSON-FIRST-NAME-MALE'.    
               88  PERSON-FIRST-NAME-FEMALE        VALUE 
                                   'PERSON-FIRST-NAME-FEMALE'.    
               88  PERSON-LAST-NAME                VALUE 
                                   'PERSON-LAST-NAME'.    
               88  PERSON-LAST-NAME-MALE           VALUE 
                                   'PERSON-LAST-NAME-MALE'.    
               88  PERSON-LAST-NAME-FEMALE         VALUE 
                                   'PERSON-LAST-NAME-FEMALE'.    
               88  PERSON-NAME                     VALUE 
                                   'PERSON-NAME'.    
               88  PERSON-NAME-MALE                VALUE 
                                   'PERSON-NAME-MALE'.    
               88  PERSON-NAME-FEMALE              VALUE 
                                   'PERSON-NAME-FEMALE'.    
               88  PERSON-PREFIX                   VALUE 
                                   'PERSON-PREFIX'.    
               88  PERSON-PREFIX-MALE              VALUE 
                                   'PERSON-PREFIX-MALE'.    
               88  PERSON-PREFIX-FEMALE            VALUE 
                                   'PERSON-PREFIX-FEMALE'.    
               88  PERSON-SUFFIX                   VALUE 
                                   'PERSON-SUFFIX'.    
               88  PERSON-SUFFIX-MALE              VALUE 
                                   'PERSON-SUFFIX-MALE'.    
               88  PERSON-SUFFIX-FEMALE            VALUE 
                                   'PERSON-SUFFIX-FEMALE'. 
               88  TAXID-EIN                       VALUE 
                                   'TAXID-EIN'. 
               88  TAXID-EIN-HYPHEN                VALUE 
                                   'TAXID-EIN-HYPHEN'. 
               88  TAXID-ITIN                      VALUE 
                                   'TAXID-ITIN'. 
               88  TAXID-ITIN-HYPHEN               VALUE 
                                   'TAXID-ITIN-HYPHEN'. 
               88  TAXID-SSN                       VALUE 
                                   'TAXID-SSN'. 
               88  TAXID-SSN-HYPHEN                VALUE 
                                   'TAXID-SSN-HYPHEN'. 
               88  TELEPHONE                       VALUE 
                                   'TELEPHONE'. 

           05  FAKER-SEED-NO       PIC 9(9)   COMP VALUE 0.

           05  FAKER-SEED-TEXT     PIC X(80)       VALUE SPACES.

      **** Output fields:
      ****     FAKER-RESPONSE-CODE
      ****         Use 88 levels to determine result of calls.
      ****     FAKER-RESPONSE-MSG
      ****         Non-space if bad response.
      ****     FAKER-RESULT
      ****         Returned result of the call.
      ****     FAKER-RESULT-FIELDS
      ****         Populated for certain compound results - redefined
      ****         for address and person fields.
      ****     FAKER-INFO-CNT
      ****         Debugging information count.
      ****     FAKER-INFO-OCCS
      ****         Debugging information.

           05  FAKER-RESPONSE-CODE PIC 9(4). 
               88  FAKER-RESPONSE-GOOD             VALUE 0.
               88  FAKER-UNKNOWN-PROVIDER          VALUE 10.
               88  FAKER-UNKNOWN-FUNCTION          VALUE 20.
               88  FAKER-UNKNOWN-FORMAT            VALUE 30.

           05  FAKER-RESPONSE-MSG  PIC X(80). 

           05  FAKER-RESULT        PIC X(80). 

           05  FAKER-RESULT-FIELDS PIC X(80). 

      **** These fields are populated only for ADDRESS-ADDRESS calls:
           05  FAKER-ADDRESS REDEFINES FAKER-RESULT-FIELDS.
               10  FAKER-ADDRESS-STREET
                                   PIC X(35).
               10  FAKER-ADDRESS-CITY
                                   PIC X(25).
               10  FAKER-ADDRESS-STATE
                                   PIC X(10).
               10  FAKER-ADDRESS-POSTCODE
                                   PIC X(10).

      **** These fields are populated only for PERSON-NAME, 
      **** PERSON-NAME-MALE and PERSON-NAME-FEMALE calls:
           05  FAKER-PERSON REDEFINES FAKER-RESULT-FIELDS.
               10  FAKER-PERSON-PREFIX
                                   PIC X(10).
               10  FAKER-PERSON-FIRST-NAME
                                   PIC X(25).
               10  FAKER-PERSON-LAST-NAME
                                   PIC X(35).
               10  FAKER-PERSON-SUFFIX
                                   PIC X(10).

      **** These fields are populated only for TELEPHONE calls:
           05  FAKER-TELEPHONE REDEFINES FAKER-RESULT-FIELDS.
               10  FAKER-TELEPHONE-AREA-CODE
                                   PIC X(03).
               10  FILLER          PIC X(01).
               10  FAKER-TELEPHONE-PREFIX
                                   PIC X(03).
               10  FILLER          PIC X(01).
               10  FAKER-TELEPHONE-SUFFIX
                                   PIC X(04).
               10  FILLER          PIC X(01).
               10  FAKER-TELEPHONE-EXTENSION
                                   PIC X(04).

           05  FAKER-INFO-CNT      PIC S9(4)  COMP. 

           05  FAKER-INFO-OCCS.
               10  FAKER-INFO                      OCCURS 20
                                                   INDEXED FI-DX
                                                           FI-DX2.
                   15  FAKER-TABLE PIC X(30).
                   15  FAKER-RANDOM-NO-SUB
                                   PIC S9(4)V9(9)
                                              COMP.
                   15  FAKER-TABLE-ENTRY
                                   PIC S9(4)  COMP.
                            *>   REPLACING ==FI-DX== BY ==W-FI-DX==.

       01  W-FAKRAND-PARAMETER.    
           05  FAKRAND-SEED-NO     PIC 9(09)  COMP VALUE 0.

           05  FAKRAND-SEED-TEXT   PIC X(80)       VALUE SPACES.
           
           05  FAKRAND-RANDOM-NO   PIC V9(09) COMP.


       01  FORMATS-CITY.
           05  FORMAT-CITY-CNT     PIC S9(4)  COMP VALUE 4.
           05  FORMAT-CITY-WEIGHT-TOT
                                   PIC S99V9(9)
                                              COMP VALUE 0.
           05  FORMAT-CITY-OCCS.
               10  FILLER          PIC X(32)       VALUE 
                                                        '{CP} {FN}{CS}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.250000000.
               10  FILLER          PIC X(32)       VALUE '{CP} {FN}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.250000000.
               10  FILLER          PIC X(32)       VALUE '{FN}{CS}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.250000000.
               10  FILLER          PIC X(32)       VALUE '{LN}{CS}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.250000000.
           05  FILLER REDEFINES FORMAT-CITY-OCCS.
               10  FILLER                          OCCURS 4
                                                   INDEXED FC-DX.
                   15  FORMAT-CITY PIC X(32).
                   15  FORMAT-CITY-WEIGHT
                                   PIC SV9(9) COMP.

       01  FORMATS-STREET-NAME.
           05  FORMAT-STREET-NAME-CNT
                                   PIC S9(4)  COMP VALUE 2.
           05  FORMAT-STREET-NAME-WEIGHT-TOT
                                   PIC S99V9(9)
                                              COMP VALUE 0.
           05  FORMAT-STREET-NAME-OCCS.
               10  FILLER          PIC X(32)       VALUE '{FN} {SS}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.500000000.
               10  FILLER          PIC X(32)       VALUE '{LN} {SS}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.500000000.
           05  FILLER REDEFINES FORMAT-STREET-NAME-OCCS.
               10  FILLER                          OCCURS 2
                                                   INDEXED FSN-DX.
                   15  FORMAT-STREET-NAME
                                   PIC X(32).
                   15  FORMAT-STREET-NAME-WEIGHT
                                   PIC SV9(9) COMP.

       01  FORMATS-STREET-ADDR.
           05  FORMAT-STREET-ADDR-CNT
                                   PIC S9(4)  COMP VALUE 2.
           05  FORMAT-STREET-ADDR-WEIGHT-TOT
                                   PIC S99V9(9)
                                              COMP VALUE 0.
           05  FORMAT-STREET-ADDR-OCCS.
               10  FILLER          PIC X(32)       VALUE '{BN} {SN}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.900000000.
               10  FILLER          PIC X(32)       VALUE
                                                      '{BN} {SN}, {2A}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.100000000.
           05  FILLER REDEFINES FORMAT-STREET-ADDR-OCCS.
               10  FILLER                          OCCURS 2
                                                   INDEXED FSA-DX.
                   15  FORMAT-STREET-ADDR
                                   PIC X(32).
                   15  FORMAT-STREET-ADDR-WEIGHT
                                   PIC SV9(9) COMP.

       01  FORMATS-ADDRESS.
           05  FORMAT-ADDRESS-CNT
                                   PIC S9(4)  COMP VALUE 4.
           05  FORMAT-ADDRESS-WEIGHT-TOT
                                   PIC S99V9(9)
                                              COMP VALUE 0.
           05  FORMAT-ADDRESS-OCCS.
               10  FILLER          PIC X(32)       VALUE
                                                '{SA}\n{CT}, {SP}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.990000000.
               10  FILLER          PIC X(32)       VALUE
                                                  '{MA}\nAPO {MS} {PC}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.004000000.
               10  FILLER          PIC X(32)       VALUE
                                             '{M$} {LN}\nFPO {MS} {PC}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.003000000.
               10  FILLER          PIC X(32)       VALUE
                                                  '{MD}\nDPO {MS} {PC}'.
               10  FILLER          PIC SV9(9) COMP VALUE  0.003000000.
           05  FILLER REDEFINES FORMAT-ADDRESS-OCCS.
               10  FILLER                          OCCURS 4
                                                   INDEXED FA-DX.
                   15  FORMAT-ADDRESS
                                   PIC X(32).
                   15  FORMAT-ADDRESS-WEIGHT
                                   PIC SV9(9) COMP.

       01  CITY-PREFIXES.
           05  CITY-PREFIX-CNT     PIC S9(4)  COMP VALUE 7.
           05  CITY-PREFIX-OCCS.
               10  FILLER          PIC X(14)       VALUE 'North'.
               10  FILLER          PIC X(14)       VALUE 'East'.
               10  FILLER          PIC X(14)       VALUE 'West'.
               10  FILLER          PIC X(14)       VALUE 'South'.
               10  FILLER          PIC X(14)       VALUE 'New'.
               10  FILLER          PIC X(14)       VALUE 'Lake'.
               10  FILLER          PIC X(14)       VALUE 'Port'.
           05  FILLER REDEFINES CITY-PREFIX-OCCS.
               10  FILLER                          OCCURS 7
                                                   INDEXED CP-DX.
                   15  CITY-PREFIX PIC X(14).

       01  CITY-SUFFIXES.
           05  CITY-SUFFIX-CNT     PIC S9(4)  COMP VALUE 19.
           05  CITY-SUFFIX-OCCS.
               10  FILLER          PIC X(14)       VALUE 'town'.
               10  FILLER          PIC X(14)       VALUE 'ton'.
               10  FILLER          PIC X(14)       VALUE 'land'.
               10  FILLER          PIC X(14)       VALUE 'ville'.
               10  FILLER          PIC X(14)       VALUE 'berg'.
               10  FILLER          PIC X(14)       VALUE 'burgh'.
               10  FILLER          PIC X(14)       VALUE 'borough'.
               10  FILLER          PIC X(14)       VALUE 'bury'.
               10  FILLER          PIC X(14)       VALUE 'view'.
               10  FILLER          PIC X(14)       VALUE 'port'.
               10  FILLER          PIC X(14)       VALUE 'mouth'.
               10  FILLER          PIC X(14)       VALUE 'stad'.
               10  FILLER          PIC X(14)       VALUE 'furt'.
               10  FILLER          PIC X(14)       VALUE 'chester'.
               10  FILLER          PIC X(14)       VALUE 'mouth'.
               10  FILLER          PIC X(14)       VALUE 'fort'.
               10  FILLER          PIC X(14)       VALUE 'haven'.
               10  FILLER          PIC X(14)       VALUE 'side'.
               10  FILLER          PIC X(14)       VALUE 'shire'.
           05  FILLER REDEFINES CITY-SUFFIX-OCCS.
               10  FILLER                          OCCURS 19
                                                   INDEXED CS-DX.
                   15  CITY-SUFFIX PIC X(14).

       01  BUILDING-NUMBER-FORMATS.
           05  BUILDING-NUMBER-FORMAT-CNT
                                   PIC S9(4)  COMP VALUE 3.
           05  BUILDING-NUMBER-FORMAT-OCCS.
               10  FILLER          PIC X(14)       VALUE '%####'.
               10  FILLER          PIC X(14)       VALUE '%###'.
               10  FILLER          PIC X(14)       VALUE '%##'.
           05  FILLER REDEFINES BUILDING-NUMBER-FORMAT-OCCS.
               10  FILLER                          OCCURS 3
                                                   INDEXED BNF-DX.
                   15  BUILDING-NUMBER-FORMAT
                                   PIC X(14).

       01  STREET-SUFFIXES.
           05  STREET-SUFFIX-CNT   PIC S9(4)  COMP VALUE 225.
           05  STREET-SUFFIX-OCCS.
               10  FILLER          PIC X(14)       VALUE 'Alley'.
               10  FILLER          PIC X(14)       VALUE 'Avenue'.
               10  FILLER          PIC X(14)       VALUE 'Branch'.
               10  FILLER          PIC X(14)       VALUE 'Bridge'.
               10  FILLER          PIC X(14)       VALUE 'Brook'.
               10  FILLER          PIC X(14)       VALUE 'Brooks'.
               10  FILLER          PIC X(14)       VALUE 'Burg'.
               10  FILLER          PIC X(14)       VALUE 'Burgs'.
               10  FILLER          PIC X(14)       VALUE 'Bypass'.
               10  FILLER          PIC X(14)       VALUE 'Camp'.
               10  FILLER          PIC X(14)       VALUE 'Canyon'.
               10  FILLER          PIC X(14)       VALUE 'Cape'.
               10  FILLER          PIC X(14)       VALUE 'Causeway'.
               10  FILLER          PIC X(14)       VALUE 'Center'.
               10  FILLER          PIC X(14)       VALUE 'Centers'.
               10  FILLER          PIC X(14)       VALUE 'Circle'.
               10  FILLER          PIC X(14)       VALUE 'Circles'.
               10  FILLER          PIC X(14)       VALUE 'Cliff'.
               10  FILLER          PIC X(14)       VALUE 'Cliffs'.
               10  FILLER          PIC X(14)       VALUE 'Club'.
               10  FILLER          PIC X(14)       VALUE 'Common'.
               10  FILLER          PIC X(14)       VALUE 'Corner'.
               10  FILLER          PIC X(14)       VALUE 'Corners'.
               10  FILLER          PIC X(14)       VALUE 'Course'.
               10  FILLER          PIC X(14)       VALUE 'Court'.
               10  FILLER          PIC X(14)       VALUE 'Courts'.
               10  FILLER          PIC X(14)       VALUE 'Cove'.
               10  FILLER          PIC X(14)       VALUE 'Coves'.
               10  FILLER          PIC X(14)       VALUE 'Creek'.
               10  FILLER          PIC X(14)       VALUE 'Crescent'.
               10  FILLER          PIC X(14)       VALUE 'Crest'.
               10  FILLER          PIC X(14)       VALUE 'Crossing'.
               10  FILLER          PIC X(14)       VALUE 'Crossroad'.
               10  FILLER          PIC X(14)       VALUE 'Curve'.
               10  FILLER          PIC X(14)       VALUE 'Dale'.
               10  FILLER          PIC X(14)       VALUE 'Dam'.
               10  FILLER          PIC X(14)       VALUE 'Divide'.
               10  FILLER          PIC X(14)       VALUE 'Drive'.
               10  FILLER          PIC X(14)       VALUE 'Drive'.
               10  FILLER          PIC X(14)       VALUE 'Drives'.
               10  FILLER          PIC X(14)       VALUE 'Estate'.
               10  FILLER          PIC X(14)       VALUE 'Estates'.
               10  FILLER          PIC X(14)       VALUE 'Expressway'.
               10  FILLER          PIC X(14)       VALUE 'Extension'.
               10  FILLER          PIC X(14)       VALUE 'Extensions'.
               10  FILLER          PIC X(14)       VALUE 'Fall'.
               10  FILLER          PIC X(14)       VALUE 'Falls'.
               10  FILLER          PIC X(14)       VALUE 'Ferry'.
               10  FILLER          PIC X(14)       VALUE 'Field'.
               10  FILLER          PIC X(14)       VALUE 'Fields'.
               10  FILLER          PIC X(14)       VALUE 'Flat'.
               10  FILLER          PIC X(14)       VALUE 'Flats'.
               10  FILLER          PIC X(14)       VALUE 'Ford'.
               10  FILLER          PIC X(14)       VALUE 'Fords'.
               10  FILLER          PIC X(14)       VALUE 'Forest'.
               10  FILLER          PIC X(14)       VALUE 'Forge'.
               10  FILLER          PIC X(14)       VALUE 'Forges'.
               10  FILLER          PIC X(14)       VALUE 'Fork'.
               10  FILLER          PIC X(14)       VALUE 'Forks'.
               10  FILLER          PIC X(14)       VALUE 'Fort'.
               10  FILLER          PIC X(14)       VALUE 'Freeway'.
               10  FILLER          PIC X(14)       VALUE 'Garden'.
               10  FILLER          PIC X(14)       VALUE 'Gardens'.
               10  FILLER          PIC X(14)       VALUE 'Gateway'.
               10  FILLER          PIC X(14)       VALUE 'Glen'.
               10  FILLER          PIC X(14)       VALUE 'Glens'.
               10  FILLER          PIC X(14)       VALUE 'Green'.
               10  FILLER          PIC X(14)       VALUE 'Greens'.
               10  FILLER          PIC X(14)       VALUE 'Grove'.
               10  FILLER          PIC X(14)       VALUE 'Groves'.
               10  FILLER          PIC X(14)       VALUE 'Harbor'.
               10  FILLER          PIC X(14)       VALUE 'Harbors'.
               10  FILLER          PIC X(14)       VALUE 'Haven'.
               10  FILLER          PIC X(14)       VALUE 'Heights'.
               10  FILLER          PIC X(14)       VALUE 'Highway'.
               10  FILLER          PIC X(14)       VALUE 'Hill'.
               10  FILLER          PIC X(14)       VALUE 'Hills'.
               10  FILLER          PIC X(14)       VALUE 'Hollow'.
               10  FILLER          PIC X(14)       VALUE 'Inlet'.
               10  FILLER          PIC X(14)       VALUE 'Inlet'.
               10  FILLER          PIC X(14)       VALUE 'Island'.
               10  FILLER          PIC X(14)       VALUE 'Island'.
               10  FILLER          PIC X(14)       VALUE 'Islands'.
               10  FILLER          PIC X(14)       VALUE 'Islands'.
               10  FILLER          PIC X(14)       VALUE 'Isle'.
               10  FILLER          PIC X(14)       VALUE 'Isle'.
               10  FILLER          PIC X(14)       VALUE 'Junction'.
               10  FILLER          PIC X(14)       VALUE 'Junctions'.
               10  FILLER          PIC X(14)       VALUE 'Key'.
               10  FILLER          PIC X(14)       VALUE 'Keys'.
               10  FILLER          PIC X(14)       VALUE 'Knoll'.
               10  FILLER          PIC X(14)       VALUE 'Knolls'.
               10  FILLER          PIC X(14)       VALUE 'Lake'.
               10  FILLER          PIC X(14)       VALUE 'Lakes'.
               10  FILLER          PIC X(14)       VALUE 'Land'.
               10  FILLER          PIC X(14)       VALUE 'Landing'.
               10  FILLER          PIC X(14)       VALUE 'Lane'.
               10  FILLER          PIC X(14)       VALUE 'Light'.
               10  FILLER          PIC X(14)       VALUE 'Lights'.
               10  FILLER          PIC X(14)       VALUE 'Loaf'.
               10  FILLER          PIC X(14)       VALUE 'Lock'.
               10  FILLER          PIC X(14)       VALUE 'Locks'.
               10  FILLER          PIC X(14)       VALUE 'Locks'.
               10  FILLER          PIC X(14)       VALUE 'Lodge'.
               10  FILLER          PIC X(14)       VALUE 'Lodge'.
               10  FILLER          PIC X(14)       VALUE 'Loop'.
               10  FILLER          PIC X(14)       VALUE 'Mall'.
               10  FILLER          PIC X(14)       VALUE 'Manor'.
               10  FILLER          PIC X(14)       VALUE 'Manors'.
               10  FILLER          PIC X(14)       VALUE 'Meadow'.
               10  FILLER          PIC X(14)       VALUE 'Meadows'.
               10  FILLER          PIC X(14)       VALUE 'Mews'.
               10  FILLER          PIC X(14)       VALUE 'Mill'.
               10  FILLER          PIC X(14)       VALUE 'Mills'.
               10  FILLER          PIC X(14)       VALUE 'Mission'.
               10  FILLER          PIC X(14)       VALUE 'Mission'.
               10  FILLER          PIC X(14)       VALUE 'Motorway'.
               10  FILLER          PIC X(14)       VALUE 'Mount'.
               10  FILLER          PIC X(14)       VALUE 'Mountain'.
               10  FILLER          PIC X(14)       VALUE 'Mountain'.
               10  FILLER          PIC X(14)       VALUE 'Mountains'.
               10  FILLER          PIC X(14)       VALUE 'Mountains'.
               10  FILLER          PIC X(14)       VALUE 'Neck'.
               10  FILLER          PIC X(14)       VALUE 'Orchard'.
               10  FILLER          PIC X(14)       VALUE 'Oval'.
               10  FILLER          PIC X(14)       VALUE 'Overpass'.
               10  FILLER          PIC X(14)       VALUE 'Park'.
               10  FILLER          PIC X(14)       VALUE 'Parks'.
               10  FILLER          PIC X(14)       VALUE 'Parkway'.
               10  FILLER          PIC X(14)       VALUE 'Parkways'.
               10  FILLER          PIC X(14)       VALUE 'Pass'.
               10  FILLER          PIC X(14)       VALUE 'Passage'.
               10  FILLER          PIC X(14)       VALUE 'Path'.
               10  FILLER          PIC X(14)       VALUE 'Pike'.
               10  FILLER          PIC X(14)       VALUE 'Pine'.
               10  FILLER          PIC X(14)       VALUE 'Pines'.
               10  FILLER          PIC X(14)       VALUE 'Place'.
               10  FILLER          PIC X(14)       VALUE 'Plain'.
               10  FILLER          PIC X(14)       VALUE 'Plains'.
               10  FILLER          PIC X(14)       VALUE 'Plains'.
               10  FILLER          PIC X(14)       VALUE 'Plaza'.
               10  FILLER          PIC X(14)       VALUE 'Plaza'.
               10  FILLER          PIC X(14)       VALUE 'Point'.
               10  FILLER          PIC X(14)       VALUE 'Points'.
               10  FILLER          PIC X(14)       VALUE 'Port'.
               10  FILLER          PIC X(14)       VALUE 'Port'.
               10  FILLER          PIC X(14)       VALUE 'Ports'.
               10  FILLER          PIC X(14)       VALUE 'Ports'.
               10  FILLER          PIC X(14)       VALUE 'Prairie'.
               10  FILLER          PIC X(14)       VALUE 'Prairie'.
               10  FILLER          PIC X(14)       VALUE 'Radial'.
               10  FILLER          PIC X(14)       VALUE 'Ramp'.
               10  FILLER          PIC X(14)       VALUE 'Ranch'.
               10  FILLER          PIC X(14)       VALUE 'Rapid'.
               10  FILLER          PIC X(14)       VALUE 'Rapids'.
               10  FILLER          PIC X(14)       VALUE 'Rest'.
               10  FILLER          PIC X(14)       VALUE 'Ridge'.
               10  FILLER          PIC X(14)       VALUE 'Ridges'.
               10  FILLER          PIC X(14)       VALUE 'River'.
               10  FILLER          PIC X(14)       VALUE 'Road'.
               10  FILLER          PIC X(14)       VALUE 'Road'.
               10  FILLER          PIC X(14)       VALUE 'Roads'.
               10  FILLER          PIC X(14)       VALUE 'Roads'.
               10  FILLER          PIC X(14)       VALUE 'Route'.
               10  FILLER          PIC X(14)       VALUE 'Row'.
               10  FILLER          PIC X(14)       VALUE 'Rue'.
               10  FILLER          PIC X(14)       VALUE 'Run'.
               10  FILLER          PIC X(14)       VALUE 'Shoal'.
               10  FILLER          PIC X(14)       VALUE 'Shoals'.
               10  FILLER          PIC X(14)       VALUE 'Shore'.
               10  FILLER          PIC X(14)       VALUE 'Shores'.
               10  FILLER          PIC X(14)       VALUE 'Skyway'.
               10  FILLER          PIC X(14)       VALUE 'Spring'.
               10  FILLER          PIC X(14)       VALUE 'Springs'.
               10  FILLER          PIC X(14)       VALUE 'Springs'.
               10  FILLER          PIC X(14)       VALUE 'Spur'.
               10  FILLER          PIC X(14)       VALUE 'Spurs'.
               10  FILLER          PIC X(14)       VALUE 'Square'.
               10  FILLER          PIC X(14)       VALUE 'Square'.
               10  FILLER          PIC X(14)       VALUE 'Squares'.
               10  FILLER          PIC X(14)       VALUE 'Squares'.
               10  FILLER          PIC X(14)       VALUE 'Station'.
               10  FILLER          PIC X(14)       VALUE 'Station'.
               10  FILLER          PIC X(14)       VALUE 'Stravenue'.
               10  FILLER          PIC X(14)       VALUE 'Stravenue'.
               10  FILLER          PIC X(14)       VALUE 'Stream'.
               10  FILLER          PIC X(14)       VALUE 'Stream'.
               10  FILLER          PIC X(14)       VALUE 'Street'.
               10  FILLER          PIC X(14)       VALUE 'Street'.
               10  FILLER          PIC X(14)       VALUE 'Streets'.
               10  FILLER          PIC X(14)       VALUE 'Summit'.
               10  FILLER          PIC X(14)       VALUE 'Summit'.
               10  FILLER          PIC X(14)       VALUE 'Terrace'.
               10  FILLER          PIC X(14)       VALUE 'Throughway'.
               10  FILLER          PIC X(14)       VALUE 'Trace'.
               10  FILLER          PIC X(14)       VALUE 'Track'.
               10  FILLER          PIC X(14)       VALUE 'Trafficway'.
               10  FILLER          PIC X(14)       VALUE 'Trail'.
               10  FILLER          PIC X(14)       VALUE 'Trail'.
               10  FILLER          PIC X(14)       VALUE 'Tunnel'.
               10  FILLER          PIC X(14)       VALUE 'Tunnel'.
               10  FILLER          PIC X(14)       VALUE 'Turnpike'.
               10  FILLER          PIC X(14)       VALUE 'Turnpike'.
               10  FILLER          PIC X(14)       VALUE 'Underpass'.
               10  FILLER          PIC X(14)       VALUE 'Union'.
               10  FILLER          PIC X(14)       VALUE 'Unions'.
               10  FILLER          PIC X(14)       VALUE 'Valley'.
               10  FILLER          PIC X(14)       VALUE 'Valleys'.
               10  FILLER          PIC X(14)       VALUE 'Via'.
               10  FILLER          PIC X(14)       VALUE 'Viaduct'.
               10  FILLER          PIC X(14)       VALUE 'View'.
               10  FILLER          PIC X(14)       VALUE 'Views'.
               10  FILLER          PIC X(14)       VALUE 'Village'.
               10  FILLER          PIC X(14)       VALUE 'Village'.
               10  FILLER          PIC X(14)       VALUE 'Villages'.
               10  FILLER          PIC X(14)       VALUE 'Ville'.
               10  FILLER          PIC X(14)       VALUE 'Vista'.
               10  FILLER          PIC X(14)       VALUE 'Vista'.
               10  FILLER          PIC X(14)       VALUE 'Walk'.
               10  FILLER          PIC X(14)       VALUE 'Walks'.
               10  FILLER          PIC X(14)       VALUE 'Wall'.
               10  FILLER          PIC X(14)       VALUE 'Way'.
               10  FILLER          PIC X(14)       VALUE 'Ways'.
               10  FILLER          PIC X(14)       VALUE 'Well'.
               10  FILLER          PIC X(14)       VALUE 'Wells'.
           05  FILLER REDEFINES STREET-SUFFIX-OCCS.
               10  FILLER                          OCCURS 225
                                                   INDEXED SS-DX.
                   15  STREET-SUFFIX
                                   PIC X(14).

       01  SECONDARY-ADDRESS-FORMATS.
           05  SECONDARY-ADDRESS-FORMAT-CNT
                                   PIC S9(4)  COMP VALUE 2.
           05  SECONDARY-ADDRESS-FORMAT-OCCS.
               10  FILLER          PIC X(14)       VALUE 'Apt %##'.
               10  FILLER          PIC X(14)       VALUE 'Ste %##'.
           05  FILLER REDEFINES SECONDARY-ADDRESS-FORMAT-OCCS.
               10  FILLER                          OCCURS 2
                                                   INDEXED PF-DX.
                   15  SECONDARY-ADDRESS-FORMAT
                                   PIC X(14).

       01  POSTCODE-FORMATS.
           05  POSTCODE-FORMAT-CNT
                                   PIC S9(4)  COMP VALUE 2.
           05  POSTCODE-FORMAT-OCCS.
               10  FILLER          PIC X(14)       VALUE '#####'.
               10  FILLER          PIC X(14)       VALUE '#####-####'.
           05  FILLER REDEFINES POSTCODE-FORMAT-OCCS.
               10  FILLER                          OCCURS 2
                                                   INDEXED PF-DX.
                   15  POSTCODE-FORMAT
                                   PIC X(14).

       01  STATES.
           05  STATE-CNT           PIC S9(4)  COMP VALUE 50.
           05  STATE-OCCS.
               10  FILLER          PIC X(14)     VALUE 'Alabama'.
               10  FILLER          PIC X(14)     VALUE 'Alaska'.
               10  FILLER          PIC X(14)     VALUE 'Arizona'.
               10  FILLER          PIC X(14)     VALUE 'Arkansas'.
               10  FILLER          PIC X(14)     VALUE 'California'.
               10  FILLER          PIC X(14)     VALUE 'Colorado'.
               10  FILLER          PIC X(14)     VALUE 'Connecticut'.
               10  FILLER          PIC X(14)     VALUE 'Delaware'.
               10  FILLER          PIC X(14)     VALUE 'Florida'.
               10  FILLER          PIC X(14)     VALUE 'Georgia'.
               10  FILLER          PIC X(14)     VALUE 'Hawaii'.
               10  FILLER          PIC X(14)     VALUE 'Idaho'.
               10  FILLER          PIC X(14)     VALUE 'Illinois'.
               10  FILLER          PIC X(14)     VALUE 'Indiana'.
               10  FILLER          PIC X(14)     VALUE 'Iowa'.
               10  FILLER          PIC X(14)     VALUE 'Kansas'.
               10  FILLER          PIC X(14)     VALUE 'Kentucky'.
               10  FILLER          PIC X(14)     VALUE 'Louisiana'.
               10  FILLER          PIC X(14)     VALUE 'Maine'.
               10  FILLER          PIC X(14)     VALUE 'Maryland'.
               10  FILLER          PIC X(14)     VALUE 'Massachusetts'.
               10  FILLER          PIC X(14)     VALUE 'Michigan'.
               10  FILLER          PIC X(14)     VALUE 'Minnesota'.
               10  FILLER          PIC X(14)     VALUE 'Mississippi'.
               10  FILLER          PIC X(14)     VALUE 'Missouri'.
               10  FILLER          PIC X(14)     VALUE 'Montana'.
               10  FILLER          PIC X(14)     VALUE 'Nebraska'.
               10  FILLER          PIC X(14)     VALUE 'Nevada'.
               10  FILLER          PIC X(14)     VALUE 'New Hampshire'.
               10  FILLER          PIC X(14)     VALUE 'New Jersey'.
               10  FILLER          PIC X(14)     VALUE 'New Mexico'.
               10  FILLER          PIC X(14)     VALUE 'New York'.
               10  FILLER          PIC X(14)     VALUE 'North Carolina'.
               10  FILLER          PIC X(14)     VALUE 'North Dakota'.
               10  FILLER          PIC X(14)     VALUE 'Ohio'.
               10  FILLER          PIC X(14)     VALUE 'Oklahoma'.
               10  FILLER          PIC X(14)     VALUE 'Oregon'.
               10  FILLER          PIC X(14)     VALUE 'Pennsylvania'.
               10  FILLER          PIC X(14)     VALUE 'Rhode Island'.
               10  FILLER          PIC X(14)     VALUE 'South Carolina'.
               10  FILLER          PIC X(14)     VALUE 'South Dakota'.
               10  FILLER          PIC X(14)     VALUE 'Tennessee'.
               10  FILLER          PIC X(14)     VALUE 'Texas'.
               10  FILLER          PIC X(14)     VALUE 'Utah'.
               10  FILLER          PIC X(14)     VALUE 'Vermont'.
               10  FILLER          PIC X(14)     VALUE 'Virginia'.
               10  FILLER          PIC X(14)     VALUE 'Washington'.
               10  FILLER          PIC X(14)     VALUE 'West Virginia'.
               10  FILLER          PIC X(14)     VALUE 'Wisconsin'.
               10  FILLER          PIC X(14)     VALUE 'Wyoming'.
           05  FILLER REDEFINES STATE-OCCS.
               10  FILLER                          OCCURS 50
                                                   INDEXED ST-DX.
                   15  STATE       PIC X(14).

       01  STATES-ABBR.
           05  STATE-ABBR-CNT      PIC S9(4)  COMP VALUE 51.
           05  STATE-ABBR-OCCS.
               10  FILLER          PIC X(14)       VALUE 'AL'.
               10  FILLER          PIC X(14)       VALUE 'AK'.
               10  FILLER          PIC X(14)       VALUE 'AZ'.
               10  FILLER          PIC X(14)       VALUE 'AR'.
               10  FILLER          PIC X(14)       VALUE 'CA'.
               10  FILLER          PIC X(14)       VALUE 'CO'.
               10  FILLER          PIC X(14)       VALUE 'CT'.
               10  FILLER          PIC X(14)       VALUE 'DE'.
               10  FILLER          PIC X(14)       VALUE 'DC'.
               10  FILLER          PIC X(14)       VALUE 'FL'.
               10  FILLER          PIC X(14)       VALUE 'GA'.
               10  FILLER          PIC X(14)       VALUE 'HI'.
               10  FILLER          PIC X(14)       VALUE 'ID'.
               10  FILLER          PIC X(14)       VALUE 'IL'.
               10  FILLER          PIC X(14)       VALUE 'IN'.
               10  FILLER          PIC X(14)       VALUE 'IA'.
               10  FILLER          PIC X(14)       VALUE 'KS'.
               10  FILLER          PIC X(14)       VALUE 'KY'.
               10  FILLER          PIC X(14)       VALUE 'LA'.
               10  FILLER          PIC X(14)       VALUE 'ME'.
               10  FILLER          PIC X(14)       VALUE 'MD'.
               10  FILLER          PIC X(14)       VALUE 'MA'.
               10  FILLER          PIC X(14)       VALUE 'MI'.
               10  FILLER          PIC X(14)       VALUE 'MN'.
               10  FILLER          PIC X(14)       VALUE 'MS'.
               10  FILLER          PIC X(14)       VALUE 'MO'.
               10  FILLER          PIC X(14)       VALUE 'MT'.
               10  FILLER          PIC X(14)       VALUE 'NE'.
               10  FILLER          PIC X(14)       VALUE 'NV'.
               10  FILLER          PIC X(14)       VALUE 'NH'.
               10  FILLER          PIC X(14)       VALUE 'NJ'.
               10  FILLER          PIC X(14)       VALUE 'NM'.
               10  FILLER          PIC X(14)       VALUE 'NY'.
               10  FILLER          PIC X(14)       VALUE 'NC'.
               10  FILLER          PIC X(14)       VALUE 'ND'.
               10  FILLER          PIC X(14)       VALUE 'OH'.
               10  FILLER          PIC X(14)       VALUE 'OK'.
               10  FILLER          PIC X(14)       VALUE 'OR'.
               10  FILLER          PIC X(14)       VALUE 'PA'.
               10  FILLER          PIC X(14)       VALUE 'RI'.
               10  FILLER          PIC X(14)       VALUE 'SC'.
               10  FILLER          PIC X(14)       VALUE 'SD'.
               10  FILLER          PIC X(14)       VALUE 'TN'.
               10  FILLER          PIC X(14)       VALUE 'TX'.
               10  FILLER          PIC X(14)       VALUE 'UT'.
               10  FILLER          PIC X(14)       VALUE 'VT'.
               10  FILLER          PIC X(14)       VALUE 'VA'.
               10  FILLER          PIC X(14)       VALUE 'WA'.
               10  FILLER          PIC X(14)       VALUE 'WV'.
               10  FILLER          PIC X(14)       VALUE 'WI'.
               10  FILLER          PIC X(14)       VALUE 'WY'.
           05  FILLER REDEFINES STATE-ABBR-OCCS.
               10  FILLER                          OCCURS 51
                                                   INDEXED SA-DX.
                   15  STATE-ABBR  PIC X(14).


       01  STATES-POSTCODE.
           05  STATE-POSTCODE-CNT  PIC S9(4)  COMP VALUE 51.
           05  STATE-POSTCODE-OCCS.
               10  FILLER          PIC X(14)     VALUE 'AL 35004 36925'.
               10  FILLER          PIC X(14)     VALUE 'AK 99501 99950'.
               10  FILLER          PIC X(14)     VALUE 'AZ 85001 86556'.
               10  FILLER          PIC X(14)     VALUE 'AR 71601 72959'.
               10  FILLER          PIC X(14)     VALUE 'CA 90001 96162'.
               10  FILLER          PIC X(14)     VALUE 'CO 80001 81658'.
               10  FILLER          PIC X(14)     VALUE 'CT 06001 06389'.
               10  FILLER          PIC X(14)     VALUE 'DE 19701 19980'.
               10  FILLER          PIC X(14)     VALUE 'DC 20001 20039'.
               10  FILLER          PIC X(14)     VALUE 'FL 32004 34997'.
               10  FILLER          PIC X(14)     VALUE 'GA 30001 31999'.
               10  FILLER          PIC X(14)     VALUE 'HI 96701 96898'.
               10  FILLER          PIC X(14)     VALUE 'ID 83201 83876'.
               10  FILLER          PIC X(14)     VALUE 'IL 60001 62999'.
               10  FILLER          PIC X(14)     VALUE 'IN 46001 47997'.
               10  FILLER          PIC X(14)     VALUE 'IA 50001 52809'.
               10  FILLER          PIC X(14)     VALUE 'KS 66002 67954'.
               10  FILLER          PIC X(14)     VALUE 'KY 40003 42788'.
               10  FILLER          PIC X(14)     VALUE 'LA 70001 71232'.
               10  FILLER          PIC X(14)     VALUE 'ME 03901 04992'.
               10  FILLER          PIC X(14)     VALUE 'MD 20331 20331'.
               10  FILLER          PIC X(14)     VALUE 'MA 01001 02791'.
               10  FILLER          PIC X(14)     VALUE 'MI 48001 49971'.
               10  FILLER          PIC X(14)     VALUE 'MN 55001 56763'.
               10  FILLER          PIC X(14)     VALUE 'MS 38601 39776'.
               10  FILLER          PIC X(14)     VALUE 'MO 63001 65899'.
               10  FILLER          PIC X(14)     VALUE 'MT 59001 59937'.
               10  FILLER          PIC X(14)     VALUE 'NE 68001 68118'.
               10  FILLER          PIC X(14)     VALUE 'NV 88901 89883'.
               10  FILLER          PIC X(14)     VALUE 'NH 03031 03897'.
               10  FILLER          PIC X(14)     VALUE 'NJ 07001 08989'.
               10  FILLER          PIC X(14)     VALUE 'NM 87001 88441'.
               10  FILLER          PIC X(14)     VALUE 'NY 10001 14905'.
               10  FILLER          PIC X(14)     VALUE 'NC 27006 28909'.
               10  FILLER          PIC X(14)     VALUE 'ND 58001 58856'.
               10  FILLER          PIC X(14)     VALUE 'OH 43001 45999'.
               10  FILLER          PIC X(14)     VALUE 'OK 73001 73199'.
               10  FILLER          PIC X(14)     VALUE 'OR 97001 97920'.
               10  FILLER          PIC X(14)     VALUE 'PA 15001 19640'.
               10  FILLER          PIC X(14)     VALUE 'RI 02801 02940'.
               10  FILLER          PIC X(14)     VALUE 'SC 29001 29948'.
               10  FILLER          PIC X(14)     VALUE 'SD 57001 57799'.
               10  FILLER          PIC X(14)     VALUE 'TN 37010 38589'.
               10  FILLER          PIC X(14)     VALUE 'TX 73301 73301'.
               10  FILLER          PIC X(14)     VALUE 'UT 84001 84784'.
               10  FILLER          PIC X(14)     VALUE 'VT 05001 05495'.
               10  FILLER          PIC X(14)     VALUE 'VA 20040 20041'.
               10  FILLER          PIC X(14)     VALUE 'WA 98001 99403'.
               10  FILLER          PIC X(14)     VALUE 'WV 24701 26886'.
               10  FILLER          PIC X(14)     VALUE 'WI 53001 54990'.
               10  FILLER          PIC X(14)     VALUE 'WY 82001 83128'.
           05  FILLER REDEFINES STATE-POSTCODE-OCCS.
               10  FILLER                          OCCURS 51
                                                   INDEXED SP-DX.
                   15  STATE-ABBR-PC
                                   PIC X(2).
                   15  FILLER      PIC X.
                   15  STATE-POSTCODE-MIN
                                   PIC 9(5).
                   15  FILLER      PIC X.
                   15  STATE-POSTCODE-MAX
                                   PIC 9(5).

       01  TERRITORIES-ABBR.
           05  TERRITORY-ABBR-CNT  PIC S9(4)  COMP VALUE 8.
           05  TERRITORY-ABBR-OCCS.
               10  FILLER          PIC X(14)       VALUE 'AS'.
               10  FILLER          PIC X(14)       VALUE 'FM'.
               10  FILLER          PIC X(14)       VALUE 'GU'.
               10  FILLER          PIC X(14)       VALUE 'MH'.
               10  FILLER          PIC X(14)       VALUE 'MP'.
               10  FILLER          PIC X(14)       VALUE 'PW'.
               10  FILLER          PIC X(14)       VALUE 'PR'.
               10  FILLER          PIC X(14)       VALUE 'VI'.
           05  FILLER REDEFINES TERRITORY-ABBR-OCCS.
               10  FILLER                          OCCURS 8
                                                   INDEXED TA-DX.
                   15  TERRITORY-ABBR
                                   PIC X(14).

       01  MILITARY-STATES-ABBR.
           05  MILITARY-STATE-ABBR-CNT
                                   PIC S9(4)  COMP VALUE 3.
           05  MILITARY-STATE-ABBR-OCCS.
               10  FILLER          PIC X(14)       VALUE 'AA'.
               10  FILLER          PIC X(14)       VALUE 'AE'.
               10  FILLER          PIC X(14)       VALUE 'AP'.
           05  FILLER REDEFINES MILITARY-STATE-ABBR-OCCS.
               10  FILLER                          OCCURS 3
                                                   INDEXED MSA-DX.
                   15  MILITARY-STATE-ABBR
                                   PIC X(14).

       01  MILITARY-SHIP-PREFIXES.
           05  MILITARY-SHIP-PREFIX-CNT
                                   PIC S9(4)  COMP VALUE 4.
           05  MILITARY-SHIP-PREFIX-OCCS.
               10  FILLER          PIC X(14)       VALUE 'USS'.
               10  FILLER          PIC X(14)       VALUE 'USNS'.
               10  FILLER          PIC X(14)       VALUE 'USNV'.
               10  FILLER          PIC X(14)       VALUE 'USCGC'.
           05  FILLER REDEFINES MILITARY-SHIP-PREFIX-OCCS.
               10  FILLER                          OCCURS 4
                                                   INDEXED MSP-DX.
                   15  MILITARY-SHIP-PREFIX
                                   PIC X(14).

       01  MILITARY-APO-FORMATS.
           05  MILITARY-APO-FORMAT-CNT
                                   PIC S9(4)  COMP VALUE 2.
           05  MILITARY-APO-FORMAT-OCCS.
               10  FILLER          PIC X(14)       VALUE 'PSC %###'.
               10  FILLER          PIC X(14)       VALUE 'Box %###'.
           05  FILLER REDEFINES MILITARY-APO-FORMAT-OCCS.
               10  FILLER                          OCCURS 2
                                                   INDEXED MAF-DX.
                   15  MILITARY-APO-FORMAT
                                   PIC X(14).

       01  MILITARY-DPO-FORMATS.
           05  MILITARY-DPO-FORMAT-CNT
                                   PIC S9(4)  COMP VALUE 2.
           05  MILITARY-DPO-FORMAT-OCCS.
               10  FILLER          PIC X(14)       VALUE 'Unit %###'.
               10  FILLER          PIC X(14)       VALUE 'Box %###'.
           05  FILLER REDEFINES MILITARY-DPO-FORMAT-OCCS.
               10  FILLER                          OCCURS 2
                                                   INDEXED MDF-DX.
                   15  MILITARY-DPO-FORMAT
                                   PIC X(14).

       LINKAGE SECTION.
      *----------------

       01  L-PARAMETER.            
       
           05  FAKER-PROVIDER-FUNCTION
                                   PIC X(30).
               88  ADDRESS-ADDRESS                 VALUE 
                                   'ADDRESS-ADDRESS'.
               88  ADDRESS-BUILDING-NO             VALUE 
                                   'ADDRESS-BUILDING-NO'.
               88  ADDRESS-CITY                    VALUE 
                                   'ADDRESS-CITY'.
               88  ADDRESS-CITY-PREFIX             VALUE 
                                   'ADDRESS-CITY-PREFIX'.
               88  ADDRESS-CITY-SUFFIX             VALUE 
                                   'ADDRESS-CITY-SUFFIX'.
               88  ADDRESS-MILITARY-APO            VALUE
                                   'ADDRESS-MILITARY-APO'.
               88  ADDRESS-MILITARY-DPO            VALUE
                                   'ADDRESS-MILITARY-DPO'.
               88  ADDRESS-MILITARY-SHIP-PREFIX    VALUE
                                   'ADDRESS-MILITARY-SHIP-PREFIX'.
               88  ADDRESS-MILITARY-STATE-ABBR     VALUE
                                   'ADDRESS-MILITARY-STATE-ABBR'.
               88  ADDRESS-POSTCODE                VALUE 
                                   'ADDRESS-POSTCODE'.
               88  ADDRESS-SECONDARY-ADDRESS       VALUE 
                                   'ADDRESS-SECONDARY-ADDRESS'.
               88  ADDRESS-STATE                   VALUE 
                                   'ADDRESS-STATE'.
               88  ADDRESS-STATE-ABBR              VALUE 
                                   'ADDRESS-STATE-ABBR'.
               88  ADDRESS-STATE-POSTCODE          VALUE 
                                   'ADDRESS-STATE-POSTCODE'.
               88  ADDRESS-STREET-ADDRESS          VALUE 
                                   'ADDRESS-STREET-ADDRESS'.
               88  ADDRESS-STREET-NAME             VALUE 
                                   'ADDRESS-STREET-NAME'.
               88  ADDRESS-STREET-SUFFIX           VALUE 
                                   'ADDRESS-STREET-SUFFIX'.
               88  ADDRESS-TERRITORY-ABBR          VALUE
                                   'ADDRESS-TERRITORY-ABBR'.
               88  BANK-ACCOUNT                    VALUE
                                   'BANK-ACCOUNT'.
               88  BANK-ROUTING                    VALUE
                                   'BANK-ROUTING'.
               88  COMPANY-COMPANY                 VALUE
                                   'COMPANY-COMPANY'.
               88  COMPANY-SUFFIX                  VALUE
                                   'COMPANY-SUFFIX'.
               88  PERSON-FIRST-NAME               VALUE 
                                   'PERSON-FIRST-NAME'.    
               88  PERSON-FIRST-NAME-MALE          VALUE
                                   'PERSON-FIRST-NAME-MALE'.    
               88  PERSON-FIRST-NAME-FEMALE        VALUE 
                                   'PERSON-FIRST-NAME-FEMALE'.    
               88  PERSON-LAST-NAME                VALUE 
                                   'PERSON-LAST-NAME'.    
               88  PERSON-LAST-NAME-MALE           VALUE 
                                   'PERSON-LAST-NAME-MALE'.    
               88  PERSON-LAST-NAME-FEMALE         VALUE 
                                   'PERSON-LAST-NAME-FEMALE'.    
               88  PERSON-NAME                     VALUE 
                                   'PERSON-NAME'.    
               88  PERSON-NAME-MALE                VALUE 
                                   'PERSON-NAME-MALE'.    
               88  PERSON-NAME-FEMALE              VALUE 
                                   'PERSON-NAME-FEMALE'.    
               88  PERSON-PREFIX                   VALUE 
                                   'PERSON-PREFIX'.    
               88  PERSON-PREFIX-MALE              VALUE 
                                   'PERSON-PREFIX-MALE'.    
               88  PERSON-PREFIX-FEMALE            VALUE 
                                   'PERSON-PREFIX-FEMALE'.    
               88  PERSON-SUFFIX                   VALUE 
                                   'PERSON-SUFFIX'.    
               88  PERSON-SUFFIX-MALE              VALUE 
                                   'PERSON-SUFFIX-MALE'.    
               88  PERSON-SUFFIX-FEMALE            VALUE 
                                   'PERSON-SUFFIX-FEMALE'. 
               88  TAXID-EIN                       VALUE 
                                   'TAXID-EIN'. 
               88  TAXID-EIN-HYPHEN                VALUE 
                                   'TAXID-EIN-HYPHEN'. 
               88  TAXID-ITIN                      VALUE 
                                   'TAXID-ITIN'. 
               88  TAXID-ITIN-HYPHEN               VALUE 
                                   'TAXID-ITIN-HYPHEN'. 
               88  TAXID-SSN                       VALUE 
                                   'TAXID-SSN'. 
               88  TAXID-SSN-HYPHEN                VALUE 
                                   'TAXID-SSN-HYPHEN'. 
               88  TELEPHONE                       VALUE 
                                   'TELEPHONE'. 

           05  FAKER-SEED-NO       PIC 9(9)   COMP VALUE 0.

           05  FAKER-SEED-TEXT     PIC X(80)       VALUE SPACES.

      **** Output fields:
      ****     FAKER-RESPONSE-CODE
      ****         Use 88 levels to determine result of calls.
      ****     FAKER-RESPONSE-MSG
      ****         Non-space if bad response.
      ****     FAKER-RESULT
      ****         Returned result of the call.
      ****     FAKER-RESULT-FIELDS
      ****         Populated for certain compound results - redefined
      ****         for address and person fields.
      ****     FAKER-INFO-CNT
      ****         Debugging information count.
      ****     FAKER-INFO-OCCS
      ****         Debugging information.

           05  FAKER-RESPONSE-CODE PIC 9(4). 
               88  FAKER-RESPONSE-GOOD             VALUE 0.
               88  FAKER-UNKNOWN-PROVIDER          VALUE 10.
               88  FAKER-UNKNOWN-FUNCTION          VALUE 20.
               88  FAKER-UNKNOWN-FORMAT            VALUE 30.

           05  FAKER-RESPONSE-MSG  PIC X(80). 

           05  FAKER-RESULT        PIC X(80). 

           05  FAKER-RESULT-FIELDS PIC X(80). 

      **** These fields are populated only for ADDRESS-ADDRESS calls:
           05  FAKER-ADDRESS REDEFINES FAKER-RESULT-FIELDS.
               10  FAKER-ADDRESS-STREET
                                   PIC X(35).
               10  FAKER-ADDRESS-CITY
                                   PIC X(25).
               10  FAKER-ADDRESS-STATE
                                   PIC X(10).
               10  FAKER-ADDRESS-POSTCODE
                                   PIC X(10).

      **** These fields are populated only for PERSON-NAME, 
      **** PERSON-NAME-MALE and PERSON-NAME-FEMALE calls:
           05  FAKER-PERSON REDEFINES FAKER-RESULT-FIELDS.
               10  FAKER-PERSON-PREFIX
                                   PIC X(10).
               10  FAKER-PERSON-FIRST-NAME
                                   PIC X(25).
               10  FAKER-PERSON-LAST-NAME
                                   PIC X(35).
               10  FAKER-PERSON-SUFFIX
                                   PIC X(10).

      **** These fields are populated only for TELEPHONE calls:
           05  FAKER-TELEPHONE REDEFINES FAKER-RESULT-FIELDS.
               10  FAKER-TELEPHONE-AREA-CODE
                                   PIC X(03).
               10  FILLER          PIC X(01).
               10  FAKER-TELEPHONE-PREFIX
                                   PIC X(03).
               10  FILLER          PIC X(01).
               10  FAKER-TELEPHONE-SUFFIX
                                   PIC X(04).
               10  FILLER          PIC X(01).
               10  FAKER-TELEPHONE-EXTENSION
                                   PIC X(04).

           05  FAKER-INFO-CNT      PIC S9(4)  COMP. 

           05  FAKER-INFO-OCCS.
               10  FAKER-INFO                      OCCURS 20
                                                   INDEXED FI-DX
                                                           FI-DX2.
                   15  FAKER-TABLE PIC X(30).
                   15  FAKER-RANDOM-NO-SUB
                                   PIC S9(4)V9(9)
                                              COMP.
                   15  FAKER-TABLE-ENTRY
                                   PIC S9(4)  COMP.
       
       01  L-FORMAT-TABLE-1.
           05  L-FORMAT-ENTRY-CNT-1
                                   PIC S9(4)  COMP.
           05  L-FORMAT-WEIGHT-TOT-1
                                   PIC S99V9(9)
                                              COMP.
           05  L-FORMAT-OCCS-1.
               10  FILLER                          OCCURS 10
                                                   INDEXED L-F-DX-1.
                   15  L-FORMAT-ENTRY-1
                                   PIC X(32).
                   15  L-FORMAT-WEIGHT-1
                                   PIC SV9(9) COMP.

       01  L-FORMAT-TABLE-2.
           05  L-FORMAT-ENTRY-CNT-2
                                   PIC S9(4)  COMP.
           05  L-FORMAT-WEIGHT-TOT-2
                                   PIC S99V9(9)
                                              COMP.
           05  L-FORMAT-OCCS-2.
               10  FILLER                          OCCURS 10
                                                   INDEXED L-F-DX-2.
                   15  L-FORMAT-ENTRY-2
                                   PIC X(32).
                   15  L-FORMAT-WEIGHT-2
                                   PIC SV9(9) COMP.


       01  L-ADDRESS-TABLE-1.
           05  L-ADDRESS-ENTRY-CNT-1
                                   PIC S9(4)  COMP.
           05  L-ADDRESS-OCCS-1.
               10  FILLER                          OCCURS 1000
                                                   INDEXED L-A-DX-1.
                   15  L-ADDRESS-ENTRY-1
                                   PIC X(14).
      /
       PROCEDURE DIVISION USING L-PARAMETER.
      *==================

       MAIN.
      *-----

           PERFORM SUB-1000-START-UP THRU SUB-1000-EXIT

           PERFORM SUB-2000-PROCESS THRU SUB-2000-EXIT

           PERFORM SUB-3000-SHUT-DOWN THRU SUB-3000-EXIT
           .
       MAIN-EXIT.
           GOBACK.
      /
       SUB-1000-START-UP.
      *------------------

           IF      W-NOT-FIRST-CALL
               GO TO SUB-1000-EXIT
           END-IF

           SET W-NOT-FIRST-CALL    TO TRUE
           MOVE FUNCTION WHEN-COMPILED 
                                   TO W-COMPILED-DATE

           DISPLAY 'FAKADDR  compiled on '
               W-COMPILED-DATE-YYYY '/'
               W-COMPILED-DATE-MM   '/'
               W-COMPILED-DATE-DD   ' at '
               W-COMPILED-TIME-HH   ':'
               W-COMPILED-TIME-MM   ':'
               W-COMPILED-TIME-SS

           PERFORM SUB-1100-SUM-WEIGHTS THRU SUB-1100-EXIT
           .
       SUB-1000-EXIT.
           EXIT.
      /
       SUB-1100-SUM-WEIGHTS.
      *---------------------

           PERFORM VARYING FC-DX FROM 1 BY 1
                     UNTIL FC-DX > FORMAT-CITY-CNT
               ADD  FORMAT-CITY-WEIGHT(FC-DX)
                 TO FORMAT-CITY-WEIGHT-TOT
           END-PERFORM

           PERFORM VARYING FSN-DX FROM 1 BY 1
                     UNTIL FSN-DX > FORMAT-STREET-NAME-CNT
               ADD  FORMAT-STREET-NAME-WEIGHT(FSN-DX)
                 TO FORMAT-STREET-NAME-WEIGHT-TOT
           END-PERFORM

           PERFORM VARYING FSA-DX FROM 1 BY 1
                     UNTIL FSA-DX > FORMAT-STREET-ADDR-CNT
               ADD  FORMAT-STREET-ADDR-WEIGHT(FSA-DX)
                 TO FORMAT-STREET-ADDR-WEIGHT-TOT
           END-PERFORM

           PERFORM VARYING FA-DX FROM 1 BY 1
                     UNTIL FA-DX > FORMAT-ADDRESS-CNT
               ADD  FORMAT-ADDRESS-WEIGHT(FA-DX)
                 TO FORMAT-ADDRESS-WEIGHT-TOT
           END-PERFORM

      D    DISPLAY 'FAKADDR weight totals: '
      D    DISPLAY '    ' FORMAT-CITY-WEIGHT-TOT
      D    DISPLAY '    ' FORMAT-STREET-NAME-WEIGHT-TOT
      D    DISPLAY '    ' FORMAT-STREET-ADDR-WEIGHT-TOT
      D    DISPLAY '    ' FORMAT-ADDRESS-WEIGHT-TOT
           .
       SUB-1100-EXIT.
           EXIT.
      /
       SUB-2000-PROCESS.
      *-----------------

           MOVE 0                  
             TO FAKER-INFO-CNT     IN L-PARAMETER
           MOVE LOW-VALUES         
             TO FAKER-INFO-OCCS    IN L-PARAMETER

           EVALUATE TRUE
             WHEN ADDRESS-ADDRESS  IN L-PARAMETER
               PERFORM SUB-9010-ADDRESS THRU SUB-9010-EXIT

             WHEN ADDRESS-BUILDING-NO
                                   IN L-PARAMETER
               PERFORM SUB-9020-BUILDING-NO THRU SUB-9020-EXIT

             WHEN ADDRESS-CITY     IN L-PARAMETER  
               PERFORM SUB-9030-CITY THRU SUB-9030-EXIT

             WHEN ADDRESS-CITY-PREFIX
                                   IN L-PARAMETER        
               PERFORM SUB-9040-CITY-PREFIX THRU SUB-9040-EXIT

             WHEN ADDRESS-CITY-SUFFIX
                                   IN L-PARAMETER        
               PERFORM SUB-9050-CITY-SUFFIX THRU SUB-9050-EXIT

             WHEN ADDRESS-MILITARY-APO
                                   IN L-PARAMETER        
               PERFORM SUB-9060-MILITARY-APO THRU SUB-9060-EXIT

             WHEN ADDRESS-MILITARY-DPO
                                   IN L-PARAMETER        
               PERFORM SUB-9070-MILITARY-DPO THRU SUB-9070-EXIT

             WHEN ADDRESS-MILITARY-SHIP-PREFIX
                                   IN L-PARAMETER        
               PERFORM SUB-9080-MILITARY-SHIP-PREFIX THRU SUB-9080-EXIT

             WHEN ADDRESS-MILITARY-STATE-ABBR
                                   IN L-PARAMETER        
               PERFORM SUB-9090-MILITARY-STATE-ABBR THRU SUB-9090-EXIT

             WHEN ADDRESS-POSTCODE IN L-PARAMETER       
               PERFORM SUB-9100-POSTCODE THRU SUB-9100-EXIT

             WHEN ADDRESS-SECONDARY-ADDRESS 
                                   IN L-PARAMETER     
               PERFORM SUB-9110-SECONDARY-ADDRESS THRU SUB-9110-EXIT

             WHEN ADDRESS-STATE    IN L-PARAMETER  
               PERFORM SUB-9120-STATE THRU SUB-9120-EXIT

             WHEN ADDRESS-STATE-ABBR  
                                   IN L-PARAMETER    
               PERFORM SUB-9130-STATE-ABBR THRU SUB-9130-EXIT

             WHEN ADDRESS-STATE-POSTCODE
                                   IN L-PARAMETER        
               PERFORM SUB-9140-STATE-POSTCODE THRU SUB-9140-EXIT

             WHEN ADDRESS-STREET-ADDRESS  
                                   IN L-PARAMETER    
               PERFORM SUB-9150-STREET-ADDRESS THRU SUB-9150-EXIT

             WHEN ADDRESS-STREET-NAME
                                   IN L-PARAMETER  
               PERFORM SUB-9160-STREET-NAME THRU SUB-9160-EXIT

             WHEN ADDRESS-STREET-SUFFIX
                                   IN L-PARAMETER
               PERFORM SUB-9170-STREET-SUFFIX THRU SUB-9170-EXIT

             WHEN ADDRESS-TERRITORY-ABBR  
                                   IN L-PARAMETER    
               PERFORM SUB-9180-TERRITORY-ABBR THRU SUB-9180-EXIT

             WHEN OTHER
               SET  FAKER-UNKNOWN-FUNCTION
                                   IN L-PARAMETER
                                   TO TRUE
               STRING 'Unknown FAKADDR function "'
                       FAKER-PROVIDER-FUNCTION
                                   IN L-PARAMETER
                       '"'  DELIMITED SIZE
                                 INTO FAKER-RESPONSE-MSG
                                   IN L-PARAMETER   
               GO TO SUB-2000-EXIT
           END-EVALUATE

           ADD  1                  
             TO FAKER-INFO-CNT     IN L-PARAMETER
           SET  FI-DX              
             TO FAKER-INFO-CNT     IN L-PARAMETER
           MOVE W-TABLE-1          
             TO FAKER-TABLE        IN L-PARAMETER(FI-DX)

           IF      W-TABLE-1(1:8) = 'FORMATS-'
               PERFORM SUB-2100-FORMAT THRU SUB-2100-EXIT

               IF      NOT FAKER-RESPONSE-GOOD
                                   IN L-PARAMETER
                   GO TO SUB-2000-EXIT
               END-IF

               IF      ADDRESS-ADDRESS
                                   IN L-PARAMETER
                   PERFORM SUB-2200-SEPARATE-FIELDS THRU SUB-2200-EXIT
               END-IF
           ELSE
               PERFORM SUB-9800-FIND-RANDOM-ADDRESS THRU SUB-9800-EXIT

               MOVE W-FAKER-RESULT 
                 TO FAKER-RESULT   IN L-PARAMETER
           END-IF
           .
       SUB-2000-EXIT.
           EXIT.

       SUB-2100-FORMAT.
      *----------------

           PERFORM SUB-9700-FIND-RANDOM-FORMAT THRU SUB-9700-EXIT

           MOVE W-FAKER-FORMAT     TO W-RECURSED-FORMAT
           MOVE 1                  TO W-SUB-1

           PERFORM SUB-2110-RECURSE-FORMATS THRU SUB-2110-EXIT
               UNTIL W-SUB-1 > LENGTH OF W-RECURSED-FORMAT
               OR    NOT FAKER-RESPONSE-GOOD
                                    IN L-PARAMETER

           IF      NOT FAKER-RESPONSE-GOOD
                                   IN L-PARAMETER
               GO TO SUB-2100-EXIT
           END-IF

           MOVE SPACES         
             TO FAKER-RESULT       IN L-PARAMETER
           MOVE 1                  TO W-SUB-1
                                      W-SUB-2

           PERFORM SUB-2120-PROCESS-FORMATS THRU SUB-2120-EXIT
               UNTIL W-SUB-1 > LENGTH OF W-RECURSED-FORMAT
               OR    W-SUB-2 > LENGTH OF FAKER-RESULT
                                          IN L-PARAMETER
               OR    W-RECURSED-FORMAT(W-SUB-1 : ) = SPACES
           .
       SUB-2100-EXIT.
           EXIT.
      /
       SUB-2110-RECURSE-FORMATS.
      *-------------------------

           IF      W-RECURSED-FORMAT-CHAR(W-SUB-1) NOT = W-FORMAT-START
               ADD  1              TO W-SUB-1
               GO TO SUB-2110-EXIT
           END-IF

           MOVE W-SUB-1            TO W-SUB-1-SAVE
           ADD  1                  TO W-SUB-1

           UNSTRING W-RECURSED-FORMAT
                            DELIMITED W-FORMAT-END
                                 INTO W-FORMAT-ENTRY
                              POINTER W-SUB-1 

           IF      W-FORMAT-ENTRY-IS-FORMAT
               MOVE W-RECURSED-FORMAT(W-SUB-1 : )
                                   TO W-RECURSED-FORMAT-REST
               MOVE W-SUB-1-SAVE   TO W-SUB-1 

               PERFORM SUB-9000-EXAMINE-FIND-FORMAT THRU SUB-9000-EXIT

               IF      NOT FAKER-RESPONSE-GOOD
                                   IN L-PARAMETER
                   GO TO SUB-2110-EXIT
               END-IF
    
               STRING W-FAKER-FORMAT
                            DELIMITED '  '
                                 INTO W-RECURSED-FORMAT
                              POINTER W-SUB-1-SAVE

               MOVE W-RECURSED-FORMAT-REST
                                   TO W-RECURSED-FORMAT(W-SUB-1-SAVE : )
           END-IF
           .
       SUB-2110-EXIT.
           EXIT.
      
       SUB-2120-PROCESS-FORMATS.
      *-------------------------

           IF      W-RECURSED-FORMAT-CHAR(W-SUB-1) = W-FORMAT-START
               ADD  1              TO W-SUB-1

               UNSTRING W-RECURSED-FORMAT
                            DELIMITED W-FORMAT-END
                                 INTO W-FORMAT-ENTRY
                              POINTER W-SUB-1 

               PERFORM SUB-9000-EXAMINE-FIND-FORMAT THRU SUB-9000-EXIT

               STRING W-FAKER-RESULT
                            DELIMITED '  '
                                 INTO FAKER-RESULT
                                      IN L-PARAMETER
                              POINTER W-SUB-2
           ELSE
               MOVE W-RECURSED-FORMAT-CHAR(W-SUB-1)
                 TO FAKER-RESULT   IN L-PARAMETER(W-SUB-2 : 1)
               ADD  1              TO W-SUB-1
                                      W-SUB-2
           END-IF
           .
       SUB-2120-EXIT.
           EXIT.

       SUB-2200-SEPARATE-FIELDS.
      *------------------------

           MOVE 1                  TO W-POINTER

           UNSTRING FAKER-RESULT   IN L-PARAMETER
                            DELIMITED '\n'
                                 INTO FAKER-ADDRESS-STREET
                                       IN L-PARAMETER
                              POINTER W-POINTER

           UNSTRING FAKER-RESULT   IN L-PARAMETER
                            DELIMITED ', '
                                 INTO FAKER-ADDRESS-CITY
                                       IN L-PARAMETER
                              POINTER W-POINTER

           UNSTRING FAKER-RESULT   IN L-PARAMETER
                            DELIMITED ' '
                                 INTO FAKER-ADDRESS-STATE
                                       IN L-PARAMETER
                                      FAKER-ADDRESS-POSTCODE
                                       IN L-PARAMETER
                              POINTER W-POINTER
           .
       SUB-2200-EXIT.
           EXIT.
      /
       SUB-3000-SHUT-DOWN.
      *-------------------

      D    IF      FAKER-RESPONSE-GOOD
      D                            IN L-PARAMETER
      D        DISPLAY 'FAKADDR completed successfully'
      D    ELSE
      D        DISPLAY 'FAKADDR ended with error '
      D                FAKER-RESPONSE-CODE
      D                            IN L-PARAMETER
      D                ': '
      D                FAKER-RESPONSE-MSG
      D                             IN L-PARAMETER
      D    END-IF
           .
       SUB-3000-EXIT.
           EXIT.
      /
       SUB-9000-EXAMINE-FIND-FORMAT.
      *-----------------------------

           EVALUATE W-FORMAT-ENTRY
             WHEN 'BN'
               PERFORM SUB-9020-BUILDING-NO THRU SUB-9020-EXIT

             WHEN 'CT'
               PERFORM SUB-9030-CITY THRU SUB-9030-EXIT

             WHEN 'CP'
               PERFORM SUB-9040-CITY-PREFIX THRU SUB-9040-EXIT

             WHEN 'CS'
               PERFORM SUB-9050-CITY-SUFFIX THRU SUB-9050-EXIT

             WHEN 'MA'
               PERFORM SUB-9060-MILITARY-APO THRU SUB-9060-EXIT

             WHEN 'MD'
               PERFORM SUB-9070-MILITARY-DPO THRU SUB-9070-EXIT

             WHEN 'M$'
               PERFORM SUB-9080-MILITARY-SHIP-PREFIX THRU SUB-9080-EXIT

             WHEN 'MS'
               PERFORM SUB-9090-MILITARY-STATE-ABBR THRU SUB-9090-EXIT

             WHEN 'PC'
               PERFORM SUB-9100-POSTCODE THRU SUB-9100-EXIT

             WHEN '2A'
               PERFORM SUB-9110-SECONDARY-ADDRESS THRU SUB-9110-EXIT

             WHEN 'ST'
               PERFORM SUB-9130-STATE-ABBR THRU SUB-9130-EXIT

             WHEN 'SP'
               PERFORM SUB-9140-STATE-POSTCODE THRU SUB-9140-EXIT

             WHEN 'SA'
               PERFORM SUB-9150-STREET-ADDRESS THRU SUB-9150-EXIT

             WHEN 'SN'
               PERFORM SUB-9160-STREET-NAME THRU SUB-9160-EXIT

             WHEN 'SS'
               PERFORM SUB-9170-STREET-SUFFIX THRU SUB-9170-EXIT

             WHEN 'FN'
               PERFORM SUB-9190-FIRST-NAME THRU SUB-9190-EXIT

             WHEN 'LN'
               PERFORM SUB-9200-LAST-NAME THRU SUB-9200-EXIT

             WHEN OTHER
               MOVE SPACES         TO W-TABLE-1
               SET  FAKER-UNKNOWN-FORMAT
                                   IN L-PARAMETER
                                   TO TRUE
               STRING 'Unknown FAKADDR format "'
                       W-FORMAT-ENTRY
                       '"'  DELIMITED SIZE
                                 INTO FAKER-RESPONSE-MSG
                                   IN L-PARAMETER
               GO TO SUB-9000-EXIT
           END-EVALUATE

           ADD  1                  
             TO FAKER-INFO-CNT     IN L-PARAMETER
           SET  FI-DX              
             TO FAKER-INFO-CNT     IN L-PARAMETER
           MOVE W-TABLE-1          
             TO FAKER-TABLE        IN L-PARAMETER(FI-DX)

           EVALUATE TRUE
             WHEN W-TABLE-1(1:8) = 'FORMATS-'
               PERFORM SUB-9700-FIND-RANDOM-FORMAT THRU SUB-9700-EXIT

             WHEN W-TABLE-1 = 'FIRST-NAME'
             OR               'LAST-NAME'
               MOVE FAKER-RESULT   IN W-FAKER-PARAMETER
                 TO W-FAKER-RESULT             

             WHEN OTHER     
               PERFORM SUB-9800-FIND-RANDOM-ADDRESS THRU SUB-9800-EXIT
           END-EVALUATE
           .
       SUB-9000-EXIT.
           EXIT.
      /
       SUB-9010-ADDRESS.
      *-----------------

           MOVE 'FORMATS-ADDRESS'  TO W-TABLE-1            

           SET  ADDRESS OF L-FORMAT-TABLE-1
             TO ADDRESS OF FORMATS-ADDRESS
           .
       SUB-9010-EXIT.
           EXIT.
      /
       SUB-9020-BUILDING-NO.
      *---------------------

           MOVE 'BUILDING-NUMBER-FORMATS' 
                                   TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF BUILDING-NUMBER-FORMATS
           .
       SUB-9020-EXIT.
           EXIT.
      /
       SUB-9030-CITY.
      *--------------

           MOVE 'FORMATS-CITY'     TO W-TABLE-1            

           SET  ADDRESS OF L-FORMAT-TABLE-1
             TO ADDRESS OF FORMATS-CITY
           .
       SUB-9030-EXIT.
           EXIT.
      /
       SUB-9040-CITY-PREFIX.
      *---------------------

           MOVE 'CITY-PREFIXES'    TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF CITY-PREFIXES
           .
       SUB-9040-EXIT.
           EXIT.
      /
       SUB-9050-CITY-SUFFIX.
      *---------------------

           MOVE 'CITY-SUFFIXES'    TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF CITY-SUFFIXES
           .
       SUB-9050-EXIT.
           EXIT.
      /
       SUB-9060-MILITARY-APO.
      *----------------------

           MOVE 'MILITARY-APO-FORMATS'
                                   TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF MILITARY-APO-FORMATS
           .
       SUB-9060-EXIT.
           EXIT.
      /
       SUB-9070-MILITARY-DPO.
      *----------------------

           MOVE 'MILITARY-DPO-FORMATS'
                                   TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF MILITARY-DPO-FORMATS
           .
       SUB-9070-EXIT.
           EXIT.
      /
       SUB-9080-MILITARY-SHIP-PREFIX.
      *------------------------------

           MOVE 'MILITARY-SHIP-PREFIXES'
                                   TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF MILITARY-SHIP-PREFIXES
           .
       SUB-9080-EXIT.
           EXIT.
      /
       SUB-9090-MILITARY-STATE-ABBR.
      *-----------------------------

           MOVE 'MILITARY-STATES-ABBR'
                                   TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF MILITARY-STATES-ABBR
           .
       SUB-9090-EXIT.
           EXIT.
      /
       SUB-9100-POSTCODE.
      *------------------
        
           MOVE 'POSTCODE-FORMATS' TO W-TABLE-1  

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF POSTCODE-FORMATS
           .
       SUB-9100-EXIT.
           EXIT.
      /
       SUB-9110-SECONDARY-ADDRESS.
      *---------------------------

           MOVE 'SECONDARY-ADDRESS-FORMATS'
                                   TO W-TABLE-1  

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF SECONDARY-ADDRESS-FORMATS
           .
       SUB-9110-EXIT.
           EXIT.
      /
       SUB-9120-STATE.
      *---------------

           MOVE 'STATES'           TO W-TABLE-1  

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF STATES
           .
       SUB-9120-EXIT.
           EXIT.
      /
       SUB-9130-STATE-ABBR.
      *--------------------

           MOVE 'STATES-ABBR'      TO W-TABLE-1  

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF STATES-ABBR
           .
       SUB-9130-EXIT.
           EXIT.
      /
       SUB-9140-STATE-POSTCODE.
      *------------------------

           MOVE 'STATES-POSTCODE'  TO W-TABLE-1            

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF STATES-POSTCODE
           .
       SUB-9140-EXIT.
           EXIT.
      /
       SUB-9150-STREET-ADDRESS.
      *------------------------

           MOVE 'FORMATS-STREET-ADDR'
                                   TO W-TABLE-1  

           SET  ADDRESS OF L-FORMAT-TABLE-1
             TO ADDRESS OF FORMATS-STREET-ADDR
           .
       SUB-9150-EXIT.
           EXIT.
      /
       SUB-9160-STREET-NAME.
      *---------------------

           MOVE 'FORMATS-STREET-NAME'
                                   TO W-TABLE-1  

           SET  ADDRESS OF L-FORMAT-TABLE-1
             TO ADDRESS OF FORMATS-STREET-NAME
           .
       SUB-9160-EXIT.
           EXIT.
      /
       SUB-9170-STREET-SUFFIX.
      *-----------------------
        
           MOVE 'STREET-SUFFIXES'  TO W-TABLE-1  

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF STREET-SUFFIXES
           .
       SUB-9170-EXIT.
           EXIT.
      /
       SUB-9180-TERRITORY-ABBR.
      *------------------------
        
           MOVE 'TERRITORIES-ABBR' TO W-TABLE-1  

           SET  ADDRESS OF L-ADDRESS-TABLE-1
             TO ADDRESS OF TERRITORIES-ABBR
           .
       SUB-9180-EXIT.
           EXIT.
      /
       SUB-9190-FIRST-NAME.
      *--------------------
        
           MOVE 'FIRST-NAME'       TO W-TABLE-1  
           SET  PERSON-FIRST-NAME  IN W-FAKER-PARAMETER
             TO TRUE

           CALL W-FAKPERS-PROG  USING W-FAKER-PARAMETER
           .
       SUB-9190-EXIT.
           EXIT.
      /
       SUB-9200-LAST-NAME.
      *-------------------
        
           MOVE 'LAST-NAME'        TO W-TABLE-1 
           SET  PERSON-LAST-NAME   IN W-FAKER-PARAMETER
             TO TRUE

           CALL W-FAKPERS-PROG  USING W-FAKER-PARAMETER
           .
       SUB-9200-EXIT.
           EXIT.
      
       SUB-9700-FIND-RANDOM-FORMAT.
      *----------------------------

           PERFORM SUB-9901-CALL-FAKRAND

           IF      W-TABLE-2 = SPACES
               COMPUTE W-RANDOM-NO =  FAKRAND-RANDOM-NO
                                      * L-FORMAT-WEIGHT-TOT-1
           ELSE
               COMPUTE W-RANDOM-NO =  FAKRAND-RANDOM-NO
                                      * (L-FORMAT-WEIGHT-TOT-1 +
                                         L-FORMAT-WEIGHT-TOT-2)
           END-IF

           MOVE W-RANDOM-NO        TO FAKER-RANDOM-NO-SUB
                                        IN L-PARAMETER(FI-DX)
           MOVE 0                  TO W-FOUND-DX

           PERFORM SUB-9710-FIND-FORMAT THRU SUB-9710-EXIT
               VARYING L-F-DX-1 FROM 1 BY 1
                 UNTIL W-FOUND-DX > 0
                 OR    L-F-DX-1 > L-FORMAT-ENTRY-CNT-1

           EVALUATE TRUE
             WHEN W-FOUND-DX > 0
               MOVE L-FORMAT-ENTRY-1(W-FOUND-DX)
                                   TO W-FAKER-FORMAT

             WHEN W-TABLE-2 NOT = SPACES
               ADD  1              
                 TO FAKER-INFO-CNT IN L-PARAMETER
               SET  FI-DX          
                 TO FAKER-INFO-CNT IN L-PARAMETER
               MOVE W-TABLE-2      
                 TO FAKER-TABLE    IN L-PARAMETER(FI-DX)
               MOVE W-RANDOM-NO    
                 TO FAKER-RANDOM-NO-SUB
                                   IN L-PARAMETER(FI-DX)

               MOVE 0              TO W-FOUND-DX

               PERFORM SUB-9720-FIND-FORMAT THRU SUB-9720-EXIT
                   VARYING L-F-DX-2 FROM 1 BY 1
                     UNTIL W-FOUND-DX > 0
                     OR    L-F-DX-2 > L-FORMAT-ENTRY-CNT-2

               IF      W-FOUND-DX > 0
                   MOVE L-FORMAT-ENTRY-2(W-FOUND-DX)
                                   TO W-FAKER-FORMAT
               ELSE
                   MOVE 'Random format not found'
                                   TO W-FAKER-FORMAT
               END-IF

             WHEN OTHER
               MOVE 'Random format not found'
                                   TO W-FAKER-FORMAT
           END-EVALUATE
           .
       SUB-9700-EXIT.
           EXIT.
      /
       SUB-9710-FIND-FORMAT.
      *---------------------
      
           IF      W-RANDOM-NO <= L-FORMAT-WEIGHT-1(L-F-DX-1)
               SET  W-FOUND-DX     TO L-F-DX-1
               MOVE W-FOUND-DX     TO FAKER-TABLE-ENTRY
                                        IN L-PARAMETER(FI-DX)
           ELSE
               SUBTRACT L-FORMAT-WEIGHT-1(L-F-DX-1)
                                 FROM W-RANDOM-NO
           END-IF
           .
       SUB-9710-EXIT.
           EXIT.
      /
       SUB-9720-FIND-FORMAT.
      *---------------------
      
           IF      W-RANDOM-NO <= L-FORMAT-WEIGHT-2(L-F-DX-2)
               SET  W-FOUND-DX     TO L-F-DX-2
               MOVE W-FOUND-DX     TO FAKER-TABLE-ENTRY
                                        IN L-PARAMETER(FI-DX)
           ELSE
               SUBTRACT L-FORMAT-WEIGHT-2(L-F-DX-2)
                                 FROM W-RANDOM-NO
           END-IF
           .
       SUB-9720-EXIT.
           EXIT.

       SUB-9800-FIND-RANDOM-ADDRESS.
      *-----------------------------

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-RANDOM-SUB    =  FAKRAND-RANDOM-NO
                                      * L-ADDRESS-ENTRY-CNT-1
                                      + 1

           MOVE W-RANDOM-SUB       TO FAKER-RANDOM-NO-SUB
                                        IN L-PARAMETER(FI-DX)
                                      W-FOUND-DX
                                      FAKER-TABLE-ENTRY
                                        IN L-PARAMETER(FI-DX)

           IF      W-TABLE-1 = 'STATES-POSTCODE'
               SET  SP-DX          TO W-FOUND-DX

               PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

               COMPUTE W-POSTCODE  =  (FAKRAND-RANDOM-NO
                                       * (STATE-POSTCODE-MAX(SP-DX)
                                       -  STATE-POSTCODE-MIN(SP-DX)))
                                      + STATE-POSTCODE-MIN(SP-DX)
                                      + 1
               COMPUTE W-RANDOM-SUB
                                   =  FAKRAND-RANDOM-NO  
                                      * POSTCODE-FORMAT-CNT
                                      + 1

               MOVE L-ADDRESS-ENTRY-1(W-FOUND-DX)(1 : 3)
                                   TO W-FAKER-RESULT(1 : 3)
               MOVE POSTCODE-FORMAT(W-RANDOM-SUB)
                                   TO W-FAKER-RESULT(4 : )
               MOVE W-POSTCODE     TO W-FAKER-RESULT(4 : 5)
           ELSE
               MOVE L-ADDRESS-ENTRY-1(W-FOUND-DX)
                                   TO W-FAKER-RESULT
           END-IF

           MOVE 0                  TO W-DIGIT-CNT

           INSPECT W-FAKER-RESULT
                             TALLYING W-DIGIT-CNT
                              FOR ALL W-HASH
                                      W-PERCENT

           IF      W-DIGIT-CNT > 0
               PERFORM SUB-9810-REPLACE-DIGIT THRU SUB-9810-EXIT
                   VARYING W-SUB-D FROM 1 BY 1
                     UNTIL W-SUB-D > LENGTH OF W-FAKER-RESULT
           END-IF              
           .
       SUB-9800-EXIT.
           EXIT.
      /
       SUB-9810-REPLACE-DIGIT.
      *-----------------------

           IF      W-FAKER-RESULT(W-SUB-D : 1) NOT = W-HASH
           AND                                       W-PERCENT
               GO TO SUB-9810-EXIT
           END-IF

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           IF      W-FAKER-RESULT(W-SUB-D : 1) = W-PERCENT
               COMPUTE W-RANDOM-DIG
                                   =  FAKRAND-RANDOM-NO
                                      * 9
                                      + 1
           ELSE       
               COMPUTE W-RANDOM-DIG
                                   =  FAKRAND-RANDOM-NO
                                      * 10
           END-IF

           MOVE W-RANDOM-DIG       TO W-FAKER-RESULT(W-SUB-D : 1)
           .
       SUB-9810-EXIT.
           EXIT.
      /
       SUB-9901-CALL-FAKRAND.
      *----------------------

           CALL W-FAKRAND-PROG  USING W-FAKRAND-PARAMETER 
           .
       SUB-9901-EXIT.
           EXIT.