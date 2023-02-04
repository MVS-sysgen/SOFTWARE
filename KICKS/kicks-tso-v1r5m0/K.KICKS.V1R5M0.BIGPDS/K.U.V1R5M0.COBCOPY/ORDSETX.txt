       01  ORDMAP1.
      *
           05  FILLLER                 PIC X(12).
      *
           05  ORD-L-TRANID            PIC S9(04)  COMP.
           05  ORD-A-TRANID            PIC X(01).
           05  ORD-C-TRANID            PIC X(01).
           05  ORD-H-TRANID            PIC X(01).
           05  ORD-D-TRANID            PIC X(04).
      *
           05  ORD-L-INSTR             PIC S9(04)  COMP.
           05  ORD-A-INSTR             PIC X(01).
           05  ORD-C-INSTR             PIC X(01).
           05  ORD-H-INSTR             PIC X(01).
           05  ORD-D-INSTR             PIC X(79).
      *
           05  ORD-L-CUSTNO            PIC S9(04)  COMP.
           05  ORD-A-CUSTNO            PIC X(01).
           05  ORD-C-CUSTNO            PIC X(01).
           05  ORD-H-CUSTNO            PIC X(01).
           05  ORD-D-CUSTNO            PIC X(06).
      *
           05  ORD-L-LNAME             PIC S9(04)  COMP.
           05  ORD-A-LNAME             PIC X(01).
           05  ORD-C-LNAME             PIC X(01).
           05  ORD-H-LNAME             PIC X(01).
           05  ORD-D-LNAME             PIC X(30).
      *
           05  ORD-L-PO                PIC S9(04)  COMP.
           05  ORD-A-PO                PIC X(01).
           05  ORD-C-PO                PIC X(01).
           05  ORD-H-PO                PIC X(01).
           05  ORD-D-PO                PIC X(10).
      *
           05  ORD-L-FNAME             PIC S9(04)  COMP.
           05  ORD-A-FNAME             PIC X(01).
           05  ORD-C-FNAME             PIC X(01).
           05  ORD-H-FNAME             PIC X(01).
           05  ORD-D-FNAME             PIC X(20).
      *
           05  ORD-L-ADDR              PIC S9(04)  COMP.
           05  ORD-A-ADDR              PIC X(01).
           05  ORD-C-ADDR              PIC X(01).
           05  ORD-H-ADDR              PIC X(01).
           05  ORD-D-ADDR              PIC X(30).
      *
           05  ORD-L-CITY              PIC S9(04)  COMP.
           05  ORD-A-CITY              PIC X(01).
           05  ORD-C-CITY              PIC X(01).
           05  ORD-H-CITY              PIC X(01).
           05  ORD-D-CITY              PIC X(20).
      *
           05  ORD-L-STATE             PIC S9(04)  COMP.
           05  ORD-A-STATE             PIC X(01).
           05  ORD-C-STATE             PIC X(01).
           05  ORD-H-STATE             PIC X(01).
           05  ORD-D-STATE             PIC X(02).
      *
           05  ORD-L-ZIPCODE           PIC S9(04)  COMP.
           05  ORD-A-ZIPCODE           PIC X(01).
           05  ORD-C-ZIPCODE           PIC X(01).
           05  ORD-H-ZIPCODE           PIC X(01).
           05  ORD-D-ZIPCODE           PIC X(10).
      *
           05  ORD-LINE-ITEM           OCCURS 10 TIMES.
      *
               10  ORD-L-PCODE         PIC S9(04)  COMP.
               10  ORD-A-PCODE         PIC X(01).
               10  ORD-C-PCODE         PIC X(01).
               10  ORD-H-PCODE         PIC X(01).
               10  ORD-D-PCODE         PIC X(10).
      *
               10  ORD-L-QTY           PIC S9(04)  COMP.
               10  ORD-A-QTY           PIC X(01).
               10  ORD-C-QTY           PIC X(01).
               10  ORD-H-QTY           PIC X(01).
               10  ORD-D-QTY           PIC ZZZZ9
                                       BLANK WHEN ZERO.
               10  ORD-D-QTY-ALPHA     REDEFINES ORD-D-QTY
                                       PIC X(05).
      *
               10  ORD-L-DESC          PIC S9(04)  COMP.
               10  ORD-A-DESC          PIC X(01).
               10  ORD-C-DESC          PIC X(01).
               10  ORD-H-DESC          PIC X(01).
               10  ORD-D-DESC          PIC X(20).
      *
               10  ORD-L-LIST          PIC S9(04)  COMP.
               10  ORD-A-LIST          PIC X(01).
               10  ORD-C-LIST          PIC X(01).
               10  ORD-H-LIST          PIC X(01).
               10  ORD-D-LIST          PIC Z,ZZZ,ZZ9.99
                                       BLANK WHEN ZERO.
      *
               10  ORD-L-NET           PIC S9(04)  COMP.
               10  ORD-A-NET           PIC X(01).
               10  ORD-C-NET           PIC X(01).
               10  ORD-H-NET           PIC X(01).
               10  ORD-D-NET           PIC ZZZZZZ9.99
                                       BLANK WHEN ZERO.
               10  ORD-D-NET-ALPHA     REDEFINES ORD-D-NET
                                       PIC X(10).
      *
               10  ORD-L-AMOUNT        PIC S9(04)  COMP.
               10  ORD-A-AMOUNT        PIC X(01).
               10  ORD-C-AMOUNT        PIC X(01).
               10  ORD-H-AMOUNT        PIC X(01).
               10  ORD-D-AMOUNT        PIC Z,ZZZ,ZZ9.99
                                       BLANK WHEN ZERO.
      *
           05  ORD-L-TOTAL             PIC S9(04)  COMP.
           05  ORD-A-TOTAL             PIC X(01).
           05  ORD-C-TOTAL             PIC X(01).
           05  ORD-H-TOTAL             PIC X(01).
           05  ORD-D-TOTAL             PIC Z,ZZZ,ZZ9.99
                                       BLANK WHEN ZERO.
      *
           05  ORD-L-MESSAGE           PIC S9(04)  COMP.
           05  ORD-A-MESSAGE           PIC X(01).
           05  ORD-C-MESSAGE           PIC X(01).
           05  ORD-H-MESSAGE           PIC X(01).
           05  ORD-D-MESSAGE           PIC X(79).
      *
           05  ORD-L-FKEY              PIC S9(04)  COMP.
           05  ORD-A-FKEY              PIC X(01).
           05  ORD-C-FKEY              PIC X(01).
           05  ORD-H-FKEY              PIC X(01).
           05  ORD-D-FKEY              PIC X(40).
      *
           05  ORD-L-DUMMY             PIC S9(04)  COMP.
           05  ORD-A-DUMMY             PIC X(01).
           05  ORD-C-DUMMY             PIC X(01).
           05  ORD-H-DUMMY             PIC X(01).
           05  ORD-D-DUMMY             PIC X(01).
      *
