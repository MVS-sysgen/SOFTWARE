       01  CUSTOMER-INQUIRY-MAP.
      *
           05  FILLER                  PIC X(12).
      *
           05  CIM-L-TRANID            PIC S9(04)  COMP.
           05  CIM-A-TRANID            PIC X(01).
           05  CIM-D-TRANID            PIC X(04).
      *
           05  CIM-L-CUSTNO            PIC S9(04)  COMP.
           05  CIM-A-CUSTNO            PIC X(01).
           05  CIM-D-CUSTNO            PIC X(06).
      *
           05  CIM-L-LNAME             PIC S9(04)  COMP.
           05  CIM-A-LNAME             PIC X(01).
           05  CIM-D-LNAME             PIC X(30).
      *
           05  CIM-L-FNAME             PIC S9(04)  COMP.
           05  CIM-A-FNAME             PIC X(01).
           05  CIM-D-FNAME             PIC X(20).
      *
           05  CIM-L-ADDR              PIC S9(04)  COMP.
           05  CIM-A-ADDR              PIC X(01).
           05  CIM-D-ADDR              PIC X(30).
      *
           05  CIM-L-CITY              PIC S9(04)  COMP.
           05  CIM-A-CITY              PIC X(01).
           05  CIM-D-CITY              PIC X(20).
      *
           05  CIM-L-STATE             PIC S9(04)  COMP.
           05  CIM-A-STATE             PIC X(01).
           05  CIM-D-STATE             PIC X(02).
      *
           05  CIM-L-ZIPCODE           PIC S9(04)  COMP.
           05  CIM-A-ZIPCODE           PIC X(01).
           05  CIM-D-ZIPCODE           PIC X(10).
      *
           05  CIM-INVOICE-LINE        OCCURS 10 TIMES.
      *
               10  CIM-L-INVOICE-LINE  PIC S9(04)  COMP.
               10  CIM-A-INVOICE-LINE  PIC X(01).
               10  CIM-D-INVOICE-LINE  PIC X(44).
      *
           05  CIM-L-MESSAGE           PIC S9(04)  COMP.
           05  CIM-A-MESSAGE           PIC X(01).
           05  CIM-D-MESSAGE           PIC X(79).
      *
           05  CIM-L-DUMMY             PIC S9(04)  COMP.
           05  CIM-A-DUMMY             PIC X(01).
           05  CIM-D-DUMMY             PIC X(01).
      *
