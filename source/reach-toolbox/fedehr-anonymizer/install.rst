############
Introduction
############

********
Preamble
********

===================
Intended readership
===================

This document covers the use for the following users of the *FedEHR
Anonymizer* software:

1.  System administrators
2.  Project administrators

=============
Applicability
=============

This Software User Manual (SUM) applies to the *FedEHR Anonymizers*
software.

=================
Problem reporting
=================

In any case of problem, do not hesitate to email us: support@gnubila.fr

********
Overview
********

=================
FedEHR Anonymizer
=================

The FedEHR Anonymizer module of the `FedEHR <https://www.fedehr.com>`_  suite
used in several cross-enterprise and transactional data federations,
offers a wide range of data cleaning, privacy filtering and information
encryption routines to ano/pseudo-nymize medical sensitive information,
and conforming to national laws and international regulations.

It is generic by design and therefore configurable to respond to the
latest and evolving data privacy regulations. The proposed version of
FedEHR Anonymizer will be widely customizable through the privacy
profiles.

The FedEHR Anonymizer is able to process different file types like
Digital imaging and communications in medicine files (or
`DICOM <http://dicom.nema.org/>`_), CSV files (Comma-Separated Values), etc.

*Note: The privacy profile will be defined during the customization
period.*

==========================
Data privacy and standards
==========================

Thanks to its Anonymizer component, FedEHR can
handle different sorts of anonymization / pseudonymization techniques.
Following the International Organization for Standardization
(`ISO <http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=63411>`_): 
Pseudonymization (from pseudonym) allows for the removal of an
association with a data subject. It differs from anonymization
(anonymous) in that it allows for data to be linked to the same person
across multiple data records or information systems without revealing
the identity of the person. The technique is recognized as an important
method for privacy protection of personal health information. It can be
performed with or without the possibility of re-identifying the subject
of the data (reversible or irreversible pseudonymization).

Supporting the Health Insurance Portability and Accountability Act
(`HIPAA <http://privacyruleandresearch.nih.gov/pr_08.asp>`_) , as described
in the Privacy Rule, as well as the EC Data Protection Directive
95/46/EC and E-Privacy Directive 2002/58/EC
(`Directive <http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32002L0058:en:HTML>`_)
, FedEHR Anonymizer can de-identify all concerned health information.
More particularly, the Anonymizer comes with a default configurable
filter removing all elements potentially identifying an individual or
individual's relatives, employers, or household members. FedEHR
Anonymizer offers different ano/pseudo-nymization strategies which can
be fine-tuned according to the project / initiative / partner / client
specific requirements.

The FedEHR Anonymizer extensible architecture has also been designed to
support the General Data Protection Regulation
(`GDPR <http://www.europarl.europa.eu/sides/getDoc.do?type=TA&reference=P7-TA-2014-0212&language=EN>`_)
, which the European Community (EC) has adopted.

************
Master Index
************

The Master Index (MI) is an electronic database use for the reversible
pseudonymization process. The MI stores and maintains a correspondence
between the original data and the one which has been produced to replace
it. For the moment, only the following functions use this database: *
@integer(...), * @uuid(...), * @resolveId(...), * @resolveUuid(...)


***********************
Curl Api Calls Examples
***********************


* Retrieving a client application Token for Keycloak or IAM curl

This example use our rcc server.

Replace my_client_name and my_client_secret by those provided.

In Response your will recieve the authentification Token.
This Token will have a very short lifespan.

::

	curl --insecure -d 'client_id='my_client_name -d 'client_secret='my_client_secret -d 'grant_type=client_credentials' https://rec.client.almerys.com/auth/realms/fedehr_ano/protocol/openid-connect/token | jq -r '.access_token'


Example of calling the anonymization process api on an csv file. This example use our rcc server.

Add your authentification token after Bearer in -H "Authorization: Bearer ".

Replace the paths /home/user/Documents/my_csv_file.csv and > my_csv_file_processed.csv by yours.

Don't forget to set the csv file parameters and the profile id / version properly.

::

	curl -k -v -X POST "https://fedehran1-rcc.almerys.local/anonymizer/v1/process" -H "accept: */*" -H "Content-Type: multipart/form-data" -H "Authorization: Bearer " -F "data=@/home/user/Documents/my_csv_file.csv;type=text/csv" -F "charset=UTF-8" -F "contentType=CSV" -F "profileId=0" -F "profileVersion=0" -F "CSVDelimiter=," -F "CSVQuote=\"" -F "ignoreWhiteSpaces=true" -F "CSVNoHeader=false" > my_csv_file_processed.csv


* Using mhonarc api to decode multipart responses for Debian/Ubuntu

start by installing mhonarc

::

	sudo apt install mhonarc

Curl example of parsing a multipart response.

Add your authentification token after Bearer in -H "Authorization: Bearer ".

Replace the paths /home/user/Documents/my_csv_file.csv and > my_csv_file_processed.csv by yours.

Don't forget to set the csv file parameters and the profile id / version properly.

::

	curl -k -v -X POST "https://fedehran1-rcc.almerys.local/anonymizer/v1/process-multipart" -H "accept: */*" -H "Content-Type: multipart/form-data" -H "Authorization: Bearer " -F "data=@/home/user/Documents/my_csv_file.csv;type=text/csv" -F "charset=UTF-8" -F "contentType=CSV" -F "profileId=0" -F "profileVersion=0" -F "CSVDelimiter=," -F "CSVQuote=\"" -F "ignoreWhiteSpaces=true" -F "CSVNoHeader=false" | mha-decode -single


********
Profiles
********

=============================
Configuration Files' language
=============================

The language for the configuration files is YAML ("YAML Ain't Markup
Language). YAML is a human readable data serialization language. You
will find more information about YAML
`here <https://en.wikipedia.org/wiki/YAML>`_.

Due to the YAML Parser used, some syntax constraints have to be
respected:

* Indent using the space character (always use the same number of space characters)
* Do not indent using the tabulation character

=================================================
Configuration files for the Dicom/CSV Anonymizers
=================================================

-----------------------------------
Structure of the configuration file
-----------------------------------

The structure of the configuration file is as follows: ::

    parameters:              # Optional
      - tag: PARAM1
        value: "VALUE1"
    elements:                # Mandatory
      - tag: TAG1
        action: ACTION1
    keepActions:             # Optional (available only with DICOMS)
      - tag: GROUP1
    removeActions:           # Optional (available only with DICOMS)
      - tag: GROUP2
  
--------------------------------
Basic configuration file example
--------------------------------

You will find below an example of the configuration file used by the
Anonymizer: ::

    parameters:
      - tag: DATEINC
        value: "-500"
      - tag: SUBJECT
        value: Subject
      - tag: DATEPATTERN
        value: "yyyyMMdd HH:mm:ss"
      - tag: FT_CONSTANT
        value: "XXX"
    elements:
      - tag: 00100010 #PatientName
        action: "@fulltextindex(this,$FT_CONSTANT,\"DAMERAU_LEVENSHTEIN\",@append($SUBJECT,\"-\",@integer(this,4)))"
      - tag: 00100030 #PatientBirthDate
        action: "@empty()"
      - tag: 00080020 #StudyDate
        action: "@incrementdate(this,$DATEINC,$$ATEPATTERN)"
      - tag: 00080023 #ContentDate
        action: "@fulltextsearch(this)"
    keepActions:
      - tag: 0018 #Keep group 0018
    removeActions:
      - tag: curves #Remove curves

----------
Parameters
----------

You can define constants that will be used as parameters in the
functions (c.f. below) of the Anonymizer. To do so, just declare the
*parameters* section and add your constants and the corresponding values
as follows: ::


    parameters:
      - tag: PARAM1
        value: "VALUE1"
      - tag: PARAM2
        value: "VALUE2"

=================================================
Configuration file for the Dicom Pixel Anonymizer
=================================================

This configuration file allows to specify the regions of pixel to blank
on the Dicom image.

The YAML script is organized into one or more sections, with each
section being comprised of a unique signature and one or more regions.

A signature defines one image type based on constraints (more or less
complex, depending on the hardware) specified in the signature's script.

-----------------------------------
Structure of the configuration file
-----------------------------------

The structure of the configuration file is as follows: ::

    section:                              # Mandatory
      -
        signature:                        # Mandatory
          script:                         # Mandatory
            identifier: "IDENTIFIER1"     # Mandatory
            test: "TEST1"                 # Mandatory
            target: "TARGET1"             # Mandatory
        region:                           # Mandatory
          - value: "VALUE1       "        # Mandatory

--------------------------------
Basic configuration file example
--------------------------------

You will find below an example of the configuration file used by the
Anonymizer: ::

    $ cat pixel-anonymizer-script.yaml
    # manufacturer: GE
    section:
      - # name: "CT Dose Series"
        signature:
          script:
            identifier: "[0008,0104]"
            test: "containsIgnoreCase"
            target: "IEC Body Dosimetry Phantom"
        region:
          - value: "(0,0,512,200)"
      -
        signature:
          script:
            identifier: "[0008,103e]"
            test: "containsIgnoreCase"
            target: "Dose Report"
        region:
          - value: "(0,0,512,110)"
      -
        signature:
          conditions:
            andOperator:
              -
                script:
                  -
                    identifier: "[0008,0070]"
                    test: "containsIgnoreCase"
                    target: "GE MEDICAL"
                  -
                    identifier: "[0040,0310]"
                    test: "containsIgnoreCase"
                    target: "DLP"
        region:
          - value: "(0,0,512,110)"

----------------
Simple signature
----------------

::

    signature:
      script:
        identifier: "[0008,0104]"
        test: "containsIgnoreCase"
        target: "IEC Body Dosimetry Phantom"


This signature will blank the region(s) of the Dicom where the Dicom tag
"0008,0104" contains (not case sensitive) the string "IEC Body Dosimetry
Phantom".

-----------------
Complex signature
-----------------

::

    signature:
      conditions:
        andOperator:
          -
            script:
              -
                identifier: "[0008,0070]"
                test: "containsIgnoreCase"
                target: "VITAL Images"
              -
                identifier: "[0028,0010]"
                test: "containsIgnoreCase"
                target: "1041"
            orOperator:
              -
                script:
                  -
                    identifier: "[0008,103e]"
                    test: "containsIgnoreCase"
                    target: "AAA"
                  -
                    identifier: "[0008,103e]"
                    test: "containsIgnoreCase"
                    target: "Report"

This signature is more complex due to the and/or conditions.

It will blank the region(s) of the Dicom where:

* The tag "0008,0070" contains (not case sensitive) "VITAL Images" and the tag "0028,0010" contains (not case sensitive) "1041"
* and the tag "0008,103e" contains (not case sensitive) "AAA" OR "Report".

--------------------------
Available script functions
--------------------------

* contains
* containsIgnoreCase
* equals

------
Region
------

A region is a rectangular area of an image, specified by four integers,
separated by commas. +
You can have one or more regions per section. +
The four integers represent: (left position, top position, width,
height)

Syntax: ::

    region:
      - value: "(0,0,795,150)"

*NB: Setting the four integers to 0 will skip the pixel anonymization
process for the specified hardware.*::

    region:
      - value: "(0,0,0,0)"
