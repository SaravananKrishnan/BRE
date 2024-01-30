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

       PROGRAM-ID.             FAKERTST.

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
           SELECT TESTINPT             ASSIGN 'Data\FAKERTST Input.txt'
                                       ORGANIZATION LINE SEQUENTIAL. 

           SELECT TESTOUTP             ASSIGN 'Data\FAKERTST Output.txt'
                                       ORGANIZATION LINE SEQUENTIAL. 
      /
       DATA DIVISION.
      *==============

       FILE SECTION.
      *-------------

       FD  TESTINPT.

       01  TESTINPT-REC.
           05  TI-PROVIDER-FUNCTION
                                   PIC X(30).
           05  TI-COUNT            PIC 9(06). 

       FD  TESTOUTP.

       01  TESTOUTP-REC.
           05  TO-PROVIDER-FUNCTION
                                   PIC X(30).
           05  TO-COLON            PIC X(02). 
           05  TO-FAKER-RESULT     PIC X(80). 

       WORKING-STORAGE SECTION.
      *------------------------

       01  W-TESTINPT-RECS         PIC 9(09)  COMP VALUE 0.
       01  W-TESTOUTP-RECS         PIC 9(09)  COMP VALUE 0.
       01  W-TEST-CNT              PIC 9(09)  COMP.
       01  W-DISP-NUM              PIC ZZ,ZZ9.
       01  W-FAKER-PROG            PIC X(08)       VALUE 'FAKER'.

       01  W-ERROR-MSG             PIC X(21)       VALUE
           '**** FAKERTST error: '.

       01  FILLER                  PIC X(01)       VALUE 'N'.
           88  W-EOF                               VALUE 'Y'.

       01  W-COMPILED-DATE.
           05  W-COMPILED-DATE-YYYY
                                   PIC X(04).
           05  W-COMPILED-DATE-MM  PIC X(02).
           05  W-COMPILED-DATE-DD  PIC X(02).
           05  W-COMPILED-TIME-HH  PIC X(02).
           05  W-COMPILED-TIME-MM  PIC X(02).
           05  W-COMPILED-TIME-SS  PIC X(02).
           05  FILLER              PIC X(07).

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
      /
       PROCEDURE DIVISION.
      *===================

       MAIN.
      *-----

           PERFORM SUB-1000-START-UP THRU SUB-1000-EXIT

           PERFORM SUB-9100-READ-TESTINPT THRU SUB-9100-EXIT

           PERFORM SUB-2000-PROCESS THRU SUB-2000-EXIT
               UNTIL W-EOF

           PERFORM SUB-3000-SHUT-DOWN THRU SUB-3000-EXIT
           .
       MAIN-EXIT.
           STOP RUN.
      /
       SUB-1000-START-UP.
      *------------------

           MOVE FUNCTION WHEN-COMPILED 
                                   TO W-COMPILED-DATE

           DISPLAY 'FAKERTST compiled on '
               W-COMPILED-DATE-YYYY '/'
               W-COMPILED-DATE-MM   '/'
               W-COMPILED-DATE-DD   ' at '
               W-COMPILED-TIME-HH   ':'
               W-COMPILED-TIME-MM   ':'
               W-COMPILED-TIME-SS

           OPEN INPUT  TESTINPT
                OUTPUT TESTOUTP
           .
       SUB-1000-EXIT.
           EXIT.
      /
       SUB-2000-PROCESS.
      *-----------------

           MOVE TI-PROVIDER-FUNCTION
                                   TO FAKER-PROVIDER-FUNCTION

           IF      TI-COUNT NUMERIC
               MOVE TI-COUNT       TO W-TEST-CNT
           ELSE
               MOVE 1              TO W-TEST-CNT
           END-IF
           
           PERFORM SUB-2100-CALL-FAKER THRU SUB-2100-EXIT
               W-TEST-CNT TIMES
           .
       SUB-2000-READ.

           PERFORM SUB-9100-READ-TESTINPT THRU SUB-9100-EXIT
           .
       SUB-2000-EXIT.
           EXIT.
      /
       SUB-2100-CALL-FAKER.
      *--------------------

           CALL W-FAKER-PROG    USING W-FAKER-PARAMETER 

           IF      FAKER-RESPONSE-GOOD
               MOVE TI-PROVIDER-FUNCTION
                                   TO TO-PROVIDER-FUNCTION
               MOVE ': '           TO TO-COLON
               MOVE FAKER-RESULT   TO TO-FAKER-RESULT

               PERFORM SUB-9200-WRITE-TESTOUTP THRU SUB-9200-EXIT

               IF      ADDRESS-ADDRESS
               OR      PERSON-NAME
               OR      PERSON-NAME-MALE
               OR      PERSON-NAME-FEMALE
                   MOVE SPACES     TO TO-PROVIDER-FUNCTION
                   MOVE ': '       TO TO-COLON
                   MOVE FAKER-RESULT-FIELDS
                                   TO TO-FAKER-RESULT

                   PERFORM SUB-9200-WRITE-TESTOUTP THRU SUB-9200-EXIT
               END-IF
           ELSE
               DISPLAY W-ERROR-MSG
                       FAKER-RESPONSE-CODE
                       ' - '
                       FAKER-RESPONSE-MSG
           END-IF

      D    PERFORM VARYING FI-DX FROM 1 BY 1
      D              UNTIL FI-DX > FAKER-INFO-CNT
      D        DISPLAY '    INFO: '
      D                FAKER-TABLE(FI-DX)
      D                ': '
      D                FAKER-RANDOM-NO-SUB(FI-DX)
      D                ', '
      D                FAKER-TABLE-ENTRY(FI-DX)
      D    END-PERFORM
           .
       SUB-2100-EXIT.
           EXIT.
      /
       SUB-3000-SHUT-DOWN.
      *-------------------
      
           CLOSE TESTINPT
                 TESTOUTP

           MOVE W-TESTINPT-RECS    TO W-DISP-NUM
           DISPLAY 'TESTINPT records read:    '
                   W-DISP-NUM

           MOVE W-TESTOUTP-RECS    TO W-DISP-NUM
           DISPLAY 'TESTOUTP records written: '
                   W-DISP-NUM

           DISPLAY 'FAKERTST completed'
           .
       SUB-3000-EXIT.
           EXIT.
      /
       SUB-9100-READ-TESTINPT.
      *-----------------------
      
           READ TESTINPT
               AT END
                   SET  W-EOF      TO TRUE
               NOT AT END
                   ADD  1          TO W-TESTINPT-RECS
           END-READ
           .
       SUB-9100-EXIT.
           EXIT.
      /
       SUB-9200-WRITE-TESTOUTP.
      *------------------------
      
           WRITE TESTOUTP-REC

           ADD  1                  TO W-TESTOUTP-RECS
           .
       SUB-9200-EXIT.
           EXIT.