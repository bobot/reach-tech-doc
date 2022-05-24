#############
ProRegister
#############

.. contents:: Contents
        :depth: 2
        :local:
        :backlinks: top

**************
Introduction
**************
ProRegister is a new generation tool (still in development) which allows to a third-party tool to share and store its logs inside a blockchain in order to ensure the incorruptibility of them.
It is a privacy-compliant blockchain permissioned private solution based on the open source `Hyperledger Fabric project <https://www.hyperledger.org/>`_.

By its design, ProRegister can be seen as a secure audit trail. It can be used as a proof in many different use cases. To be able do this, ProRegister stores all sensitive data for each different actor of the network,
in an external databases relied to its blockchain. For each stored data, a hash print is generated and stored to the joined blockchain, ensuring by this way the integrity of the data. This principle provides then a
Proof of Existence.

It proves that a certain data was stored at a specific time, and that this data effectively corresponds to a hash stored in the blockchain. Moreover, it also provides a Proof of Matching, which by the uses of smart contracts, enables to prove when the data has been
used and by whom.
At the same time, the tool is himself GDPR compliant by respecting the right to oblivion. By a smart mechanism, ProRegister allows to delete the stored data at demand.

**************
How it Works?
**************


The tool is deployed in a SaaS and available by a REST API. It can be used as a private blockchain for a standalone organisation or as a shared private blockchain for a consortium.
In ProRegister, we have the notion of stack (see :numref:`ProRegisterStack.png` )  which is the unit of deployment within an organization. A ProRegister stack  is composed of one unit of
each basic component (API, endorser peer, orderer, ledger) of the blockchain network. So to do horizontal scalability, rather than adding individual components, we will add new instances of the stack.
Currently by default each organization is composed of three instances  of the stack.


  .. _ProRegisterStack.png:
  .. figure:: ./images/ProRegisterStack.png

      ProRegister deployment architecture with stack concept

Each ProRegister deployment has a single so-called public channel that is shared among all organizations, and one or more so-called private channels with access restricted to its organization. The private channel corresponds to the external database storing the trace provided by
the client application. The public channel will contain metadata used to store the trace and its generated hash print. In case of consortium, the public channel correspond to a second level of blockchain. By this way, all public information are certified by the other members
of the network.

*******************************************************************
Authentication/authorization: Retrieving a Keycloak access token
*******************************************************************
All requests to the API must include an authentication/authorization token retrieved from an ID Provider to which the API is connected.

Normally the ID Provider is managed by the client who is supposed to know how to use it. However, we will describe in instructions shared in private how to obtain an access token with
the Keycloak used by default in our test environments. For security reasons, we prefer not to expose the url of the Keycloak server in this document.

***************
Trace creation
***************

The sequence of interaction between the main components of ProRegister  in the trace creation process ( :numref:`trace_creation.png` ).

  .. _trace_creation.png:
  .. figure:: ./images/trace_creation.png


     ProRegister interactions during trace creation process.


Definition of structure’s elements
===================================

To store a trace in ProRegister, it is needed to send a structured json message which contains the trace and certains information which will describe/define the trace.

  .. figure:: ./images/trace_structure.drawio.png


     ProRegister trace and trace schema structure


* **creationDatetime:** the date correspond to the creation date of the trace and must respect the following pattern -  « yyyy-MM-ddTHH:mm:ss.SSSZ » .
* **context.name:** is a unique functional ID which correspond to a major functionnality.
* **context.task:** is a unique functional ID which correspond to a step inside the functionnality.
* **context.attributes.key:** is an element used during the step (ex:parameter).
* **context.attributes.value:** is the value of the previous element(ex:parameter value).
* **context.gdprDatetime:** the date correspond to the retention date and must respect the following pattern -  « yyyy-MM-ddTHH:mm:ss.SSSZ » .
* **numberOfElements:** is equals to number of couples « elementField, elementValue » in the listOfElements.
* **listOfElements.elementField:** is a unique functional ID.
* **listOfElements.elementValue:** is the trace to store.
* **listOfElements.elementMetadataList (optional):** some time, it could be useful to subdivide the trace in different sub information. This list allows to store these elements.
* **listOfElements.elementMetadataList.numberOfElementMetadata:** is equals to number of couples « elementMetadataField, elementMetadataValue ».
* **listOfElements.elementMetadataList.elementMetadataField:** is a unique functional ID.
* **listOfElements.elementMetadataList.elementMetadataValue:** is the trace to store.


Endpoint
=========

+---------+--------------------------------+
| method  | url                            |
+=========+================================+
|| POST   || /api/chaincodes/trace         |
+---------+--------------------------------+

Example usage:

.. code-block:: bash

    curl -k -X POST --data $REQUEST_BODY  \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${token}" \
     https://<url_environment>:<port_environment>/api/chaincodes/trace

with a json body which is based on the previous description of the request structure.


Nominal output
================

The nominal output of the query is the key of the created trace.

+------+---------------------------------------------------+
| Code | Example                                           |
+======+===================================================+
|  201 ||                                                  |
|      || {                                                |
|      ||   "transactionKey": {                            |
|      ||   "product": "string",                           |
|      ||   "instance": "string",                          |
|      ||   "organization": "string",                      |
|      ||   "apiInterface": "string",                      |
|      ||   "traceGroupID": "string",                      |
|      ||   "creationDatetime": "2020-03-27T15:56:33.974Z" |
|      ||   }                                              |
|      || }                                                |
+------+---------------------------------------------------+



Possible errors
================
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 401    ||                                                                                                                                                         |Token is not valid             |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "401",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Token not found. Token not found in IDProvider. idProvider response: userInfo:Error: Request failed with status code 401" |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 403    ||                                                                                                                                                         | User has not got enough rights|
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "403",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Forbidden scope Forbidden access for user to write"                                                                       |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 409    ||                                                                                                                                                         | The trace is already existing |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "409",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Conflict error. Conflict error submitting main tx"                                                                        |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+






.. raw:: pdf

   PageBreak


**************
Traces query
**************


The sequence of interaction between the main components of ProRegister  in the traces query process ( :numref:`trace_request.png` ).

  .. _trace_request.png:
  .. figure:: ./images/trace_request.png


     ProRegister interactions during traces query process.



By keys
========

This endpoint is done to retrieve stored traces by using the linked ID generated and returned during the storage. It is possible to fetch one or many traces with the same query.

Endpoint
----------

+---------+-----------------------------------+
| method  | url                               |
+=========+===================================+
| POST    |/api/chaincodes/trace/queryByKeys  |
+---------+-----------------------------------+


parameter
^^^^^^^^^^

+-------------+-----------------------------------------------------+
| Parameter   | Type of values                                      |
+=============+=====================================================+
| Header      || Authorization: Bearer $TOKEN                       |
+-------------+-----------------------------------------------------+
| Body        || {                                                  |
|             ||    "listOfTransactionKeys": [                      |
|             ||     {                                              |
|             ||       "product": "string",                         |
|             ||       "instance": "string",                        |
|             ||       "organization": "string",                    |
|             ||       "apiInterface": "string",                    |
|             ||       "traceGroupID": "string",                    |
|             ||       "creationDateTime": "date"                   |
|             ||    }                                               |
|             ||   ]                                                |
|             || }                                                  |
+-------------+-----------------------------------------------------+


Example of use
----------------

.. code-block:: bash

    curl -k -X GET --data $REQUEST_BODY  \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Authorization: Bearer ${token}" \
     https://<url_environment>:<port_environment>/api/chaincodes/trace/queryByKeys

with a json body which is based on the previous description of the request structure.


Nominal output
----------------

The nominal output of the query is the list of the traces found and/or the input keys with no corresponding traces found.

When the traces are found for all the input keys:

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||     {                                                                       |
||     ||        "listOfTraces": [                                                    |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "25bfaefb-ed42-42ba-b2c4-2de07c92e885",        |
||     ||              "creationDatetime": "2022-04-20T16:16:32.000Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-20T16:16:32.000Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2023-08-25T16:16:32.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12154",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          },                                                                 |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "b18f9255-e0f1-4ec5-ac44-8e254ad72bc7",        |
||     ||              "creationDatetime": "2022-04-13T16:12:12.427Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-13T16:12:12.427Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2022-08-25T16:13:33.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12150",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          }                                                                  |
||     ||        ]                                                                    |
||     ||     }                                                                       |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+



When there is no trace for some input keys:

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||     {                                                                       |
||     ||        "listOfTraces": [                                                    |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "25bfaefb-ed42-42ba-b2c4-2de07c92e885",        |
||     ||              "creationDatetime": "2022-04-20T16:16:32.000Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-20T16:16:32.000Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2023-08-25T16:16:32.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12154",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          }                                                                  |
||     ||        ],                                                                   |
||     ||       "listOfUnknownTraces": [                                              |
||     ||         {                                                                   |
||     ||           "transactionKey": {                                               |
||     ||             "product": "BEIAM",                                             |
||     ||             "instance": "rcc",                                              |
||     ||             "organization": "ORG0",                                         |
||     ||             "apiInterface": "API0",                                         |
||     ||             "traceGroupID": "b18f9255-e0f1-4ec5-ac44-8e254ad72bc7",         |
||     ||             "creationDatetime": "2022-04-13T16:12:12.427Z"                  |
||     ||           }                                                                 |
||     ||         },                                                                  |
||     ||         {                                                                   |
||     ||           "transactionKey": {                                               |
||     ||             "product": "BEIAM",                                             |
||     ||             "instance": "rcc",                                              |
||     ||             "organization": "ORG0",                                         |
||     ||             "apiInterface": "API0",                                         |
||     ||             "traceGroupID": "6bb00cd9-9cd5-41cd-a817-f2771013c633",         |
||     ||             "creationDatetime": "2022-04-13T16:11:34.663Z"                  |
||     ||           }                                                                 |
||     ||         }                                                                   |
||     ||       ]                                                                     |
||     ||     }                                                                       |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+


Possible errors
-----------------

+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 401    ||                                                                                                                                                         |Token is not valid             |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "401",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Token not found. Token not found in IDProvider. idProvider response: userInfo:Error: Request failed with status code 401" |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 403    ||                                                                                                                                                         | User has not got enough rights|
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "403",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Forbidden scope Forbidden access for user to write"                                                                       |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 409    ||                                                                                                                                                         | The trace is already existing |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "409",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Conflict error. Conflict error submitting main tx"                                                                        |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+


.. raw:: pdf

   PageBreak


By trace elements fields
=========================


This endpoint allows to retrieve stored traces following matching with the traces elements values. The request will return zero, one or many traces as result.

Endpoint
----------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| POST    |/api/chaincodes/trace/queryByFields  |
+---------+-------------------------------------+


parameter
^^^^^^^^^^
It is possible to specify a clause about the owners (creator accounts) of the desired traces. The identifiers of the owners of the traces are known by those who manage the Identity Provider connected to the API.


+----------------------------------------------+-------------------------------------------------------------------------+
| Parameter                                    | Type of values                                                          |
+==============================================+=========================================================================+
| Header                                       |   Authorization: Bearer $TOKEN                                          |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body (without  traces owners criteria)       ||      {                                                                 |
|                                              ||         "TraceFiltered": {                                             |
|                                              ||           "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",    |
|                                              ||           "creationDatetimeHigherBound": "2022-04-25T14:12:43.232Z"    |
|                                              ||           "lowerBoundExcluded": true,                                  |
|                                              ||           "higherBoundExcluded": false,                                |
|                                              ||           "numberOfElements": 1,                                       |
|                                              ||           "listOfElements": [                                          |
|                                              ||             {                                                          |
|                                              ||               "elementField": "expectedElementField",                  |
|                                              ||               "elementValue": "expectedElementElementValue"            |
|                                              ||             }                                                          |
|                                              ||           ]                                                            |
|                                              ||       }                                                                |
|                                              ||     }                                                                  |
|                                              ||                                                                        |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body (with traces owners criteria)           || {                                                                      |
|                                              ||    "TraceFiltered": {                                                  |
|                                              ||       "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",        |
|                                              ||       "creationDatetimeHigherBound": "2022-04-25T14:12:43.232Z",       |
|                                              ||       "lowerBoundExcluded": true,                                      |
|                                              ||       "higherBoundExcluded": false,                                    |
|                                              ||       "numberOfElements": 1,                                           |
|                                              ||       "listOfElements": [                                              |
|                                              ||         {                                                              |
|                                              ||          "elementField": "expectedElementField",                       |
|                                              ||          "elementValue": "expectedElementElementValue"                 |
|                                              ||         }                                                              |
|                                              ||       ]                                                                |
|                                              ||    },                                                                  |
|                                              ||    "TracesOwners": ["f215ef93-bc79-959-88754-6f43e42fc53a"]            |
|                                              || }                                                                      |
+----------------------------------------------+-------------------------------------------------------------------------+

Example of use
---------------

.. code-block:: bash

    curl -k -X POST --data $REQUEST_BODY  \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Authorization: Bearer ${token}"  \
      https://<url_environment>:<port_environment>/api/chaincodes/trace/queryByFilters

with a json body which is based on the previous description of the request structure.



Nominal output
----------------

The nominal output of the query is the list of the traces found. But an anomaly whose correction is planned makes it possible to have
"keys of traces not found" in the results.  In reality, these keys correspond to the traces that the author of the request does not have the right to access.

When the traces are found for all the input keys:

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||     {                                                                       |
||     ||        "listOfTraces": [                                                    |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "25bfaefb-ed42-42ba-b2c4-2de07c92e885",        |
||     ||              "creationDatetime": "2022-04-20T16:16:32.000Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-20T16:16:32.000Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2023-08-25T16:16:32.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12154",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          },                                                                 |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "b18f9255-e0f1-4ec5-ac44-8e254ad72bc7",        |
||     ||              "creationDatetime": "2022-04-13T16:12:12.427Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-13T16:12:12.427Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2022-08-25T16:13:33.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12150",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          }                                                                  |
||     ||        ]                                                                    |
||     ||     }                                                                       |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+



When there is no trace for some input keys:

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||     {                                                                       |
||     ||        "listOfTraces": [                                                    |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "25bfaefb-ed42-42ba-b2c4-2de07c92e885",        |
||     ||              "creationDatetime": "2022-04-20T16:16:32.000Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-20T16:16:32.000Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2023-08-25T16:16:32.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12154",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          }                                                                  |
||     ||        ],                                                                   |
||     ||       "listOfUnknownTraces": [                                              |
||     ||         {                                                                   |
||     ||           "transactionKey": {                                               |
||     ||             "product": "BEIAM",                                             |
||     ||             "instance": "rcc",                                              |
||     ||             "organization": "ORG0",                                         |
||     ||             "apiInterface": "API0",                                         |
||     ||             "traceGroupID": "b18f9255-e0f1-4ec5-ac44-8e254ad72bc7",         |
||     ||             "creationDatetime": "2022-04-13T16:12:12.427Z"                  |
||     ||           }                                                                 |
||     ||         },                                                                  |
||     ||         {                                                                   |
||     ||           "transactionKey": {                                               |
||     ||             "product": "BEIAM",                                             |
||     ||             "instance": "rcc",                                              |
||     ||             "organization": "ORG0",                                         |
||     ||             "apiInterface": "API0",                                         |
||     ||             "traceGroupID": "6bb00cd9-9cd5-41cd-a817-f2771013c633",         |
||     ||             "creationDatetime": "2022-04-13T16:11:34.663Z"                  |
||     ||           }                                                                 |
||     ||         }                                                                   |
||     ||       ]                                                                     |
||     ||     }                                                                       |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+


Possible errors
-----------------

+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 401    ||                                                                                                                                                         |Token is not valid             |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "401",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Token not found. Token not found in IDProvider. idProvider response: userInfo:Error: Request failed with status code 401" |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 403    ||                                                                                                                                                         | User has not got enough rights|
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "403",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Forbidden scope Forbidden access for user to write"                                                                       |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 409    ||                                                                                                                                                         | The trace is already existing |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "409",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Conflict error. Conflict error submitting main tx"                                                                        |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+




.. raw:: pdf

   PageBreak


By context
===========

This endpoint allows to retrieve stored traces following matching with the traces context object. The request will return zero, one or many traces as result.

Endpoint
----------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| POST    |/api/chaincodes/trace/queryByContext |
+---------+-------------------------------------+


parameter
^^^^^^^^^^
It is possible to specify a clause about the owners (creator accounts) of the desired traces. The identifiers of the owners of the traces are known by those who
manage the Identity Provider connected to the API.

+----------------------------------------------+-------------------------------------------------------------------------+
| Parameter                                    | Type of values                                                          |
+==============================================+=========================================================================+
| Header                                       | Authorization: Bearer $TOKEN                                            |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body (without  traces owners criteria)       ||   {                                                                    |
|                                              ||     "ContextFilter": [                                                 |
|                                              ||       {                                                                |
|                                              ||         "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",      |
|                                              ||         "creationDatetimeHigherBound": "2023-04-25T14:12:43.232Z",     |
|                                              ||         "creationLowerBoundTimestampExcluded": true,                   |
|                                              ||         "creationUpperBoundTimestampExcluded": true,                   |
|                                              ||         "name": "contextName",                                         |
|                                              ||         "task": "taskName",                                            |
|                                              ||         "attributes": [                                                |
|                                              ||           {                                                            |
|                                              ||             "key": "attKey",                                           |
|                                              ||             "value": "attValue"                                        |
|                                              ||           }                                                            |
|                                              ||         ],                                                             |
|                                              ||         "gdprDatetimeLowerBoundTimestamp": "2022-05-03T16:41:47.236Z", |
|                                              ||         "gdprDatetimeUpperBoundTimestamp": "2024-08-23T07:40:27.531Z", |
|                                              ||         "gdprDatetimeLowerBoundTimestampExcluded": true,               |
|                                              ||         "gdprDatetimeUpperBoundTimestampExcluded": true                |
|                                              ||       }                                                                |
|                                              ||     ]                                                                  |
|                                              ||   }                                                                    |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body (with traces owners criteria)           ||    {                                                                   |
|                                              ||      "ContextFilter": [                                                |
|                                              ||        {                                                               |
|                                              ||          "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",     |
|                                              ||          "creationDatetimeHigherBound": "2023-04-25T14:12:43.232Z",    |
|                                              ||          "creationLowerBoundTimestampExcluded": true,                  |
|                                              ||          "creationUpperBoundTimestampExcluded": true,                  |
|                                              ||          "name": "contextName",                                        |
|                                              ||          "task": "taskName",                                           |
|                                              ||          "attributes": [                                               |
|                                              ||            {                                                           |
|                                              ||              "key": "attKey",                                          |
|                                              ||              "value": "attValue"                                       |
|                                              ||            }                                                           |
|                                              ||          ],                                                            |
|                                              ||          "gdprDatetimeLowerBoundTimestamp": "2022-05-03T16:41:47.236Z",|
|                                              ||          "gdprDatetimeUpperBoundTimestamp": "2024-08-23T07:40:27.531Z",|
|                                              ||           "gdprDatetimeLowerBoundTimestampExcluded": true,             |
|                                              ||           "gdprDatetimeUpperBoundTimestampExcluded": true              |
|                                              ||         }                                                              |
|                                              ||       ],                                                               |
|                                              ||       "TracesOwners": ["f885ef93-baa9-4b59-85f4-6f43e42fc53a"]         |
|                                              ||     }                                                                  |
+----------------------------------------------+-------------------------------------------------------------------------+


Example of use
--------------

.. code-block:: bash

    curl -k -X POST --data $REQUEST_BODY  \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    https://<url_environment>:<port_environment>/api/chaincodes/trace/queryByContext

with a json body which is based on the previous description of the request structure.


Nominal output
----------------

The nominal output of the query is the list of the traces found. But an anomaly whose correction is planned makes it possible to have
"keys of traces not found" in the results.  In reality, these keys correspond to the traces that the author of the request does not have the right to access.

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||     {                                                                       |
||     ||        "listOfTraces": [                                                    |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "25bfaefb-ed42-42ba-b2c4-2de07c92e885",        |
||     ||              "creationDatetime": "2022-04-20T16:16:32.000Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-20T16:16:32.000Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2023-08-25T16:16:32.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12154",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          },                                                                 |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "b18f9255-e0f1-4ec5-ac44-8e254ad72bc7",        |
||     ||              "creationDatetime": "2022-04-13T16:12:12.427Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-13T16:12:12.427Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2022-08-25T16:13:33.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12150",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          }                                                                  |
||     ||        ]                                                                    |
||     ||     }                                                                       |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+



When there is no trace for some input keys:

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||     {                                                                       |
||     ||        "listOfTraces": [                                                    |
||     ||          {                                                                  |
||     ||            "transactionKey": {                                              |
||     ||              "product": "BEIAM",                                            |
||     ||              "instance": "rcc",                                             |
||     ||              "organization": "ORG0",                                        |
||     ||              "apiInterface": "API0",                                        |
||     ||              "traceGroupID": "25bfaefb-ed42-42ba-b2c4-2de07c92e885",        |
||     ||              "creationDatetime": "2022-04-20T16:16:32.000Z"                 |
||     ||            },                                                               |
||     ||            "creationDatetime": "2022-04-20T16:16:32.000Z",                  |
||     ||            "context": {                                                     |
||     ||              "name": "Mail",                                                |
||     ||              "task": "ouverture",                                           |
||     ||              "attributes": [                                                |
||     ||                {                                                            |
||     ||                  "key": "reference",                                        |
||     ||                  "value": "be_ys_Contrat.pdf"                               |
||     ||                }                                                            |
||     ||              ],                                                             |
||     ||              "gdprDatetime": "2023-08-25T16:16:32.000Z"                     |
||     ||            },                                                               |
||     ||            "numberOfElements": 1,                                           |
||     ||            "listOfElements": [                                              |
||     ||              {                                                              |
||     ||                "elementField": "12154",                                     |
||     ||                "elementValue": "ouverture"                                  |
||     ||              }                                                              |
||     ||            ]                                                                |
||     ||          }                                                                  |
||     ||        ],                                                                   |
||     ||       "listOfUnknownTraces": [                                              |
||     ||         {                                                                   |
||     ||           "transactionKey": {                                               |
||     ||             "product": "BEIAM",                                             |
||     ||             "instance": "rcc",                                              |
||     ||             "organization": "ORG0",                                         |
||     ||             "apiInterface": "API0",                                         |
||     ||             "traceGroupID": "b18f9255-e0f1-4ec5-ac44-8e254ad72bc7",         |
||     ||             "creationDatetime": "2022-04-13T16:12:12.427Z"                  |
||     ||           }                                                                 |
||     ||         },                                                                  |
||     ||         {                                                                   |
||     ||           "transactionKey": {                                               |
||     ||             "product": "BEIAM",                                             |
||     ||             "instance": "rcc",                                              |
||     ||             "organization": "ORG0",                                         |
||     ||             "apiInterface": "API0",                                         |
||     ||             "traceGroupID": "6bb00cd9-9cd5-41cd-a817-f2771013c633",         |
||     ||             "creationDatetime": "2022-04-13T16:11:34.663Z"                  |
||     ||           }                                                                 |
||     ||         }                                                                   |
||     ||       ]                                                                     |
||     ||     }                                                                       |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+





Possible errors
----------------
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 401    ||                                                                                                                                                         |Token is not valid             |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "401",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Token not found. Token not found in IDProvider. idProvider response: userInfo:Error: Request failed with status code 401" |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 403    ||                                                                                                                                                         | User has not got enough rights|
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "403",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Forbidden scope Forbidden access for user to write"                                                                       |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 409    ||                                                                                                                                                         | The trace is already existing |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "409",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Conflict error. Conflict error submitting main tx"                                                                        |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+



***************************
Context schema management
***************************
  .. important:: The use of the endpoints described in this section is optional for the creation and retrieval of traces. But the endpoints obviously have a purpose which is described just below.



  .. _trace_structure.drawio.2:
  .. figure:: ./images/trace_structure.drawio.png

     ProRegister trace and trace schema structure



The context in the structure of a trace is subject to peripheral processing during the creation of each trace for efficient exploitation of these contexts. This context information is intended to facilitate trace queries based on functional criteria.
For this purpose, the context information will be stored in a criteria database during the creation of the traces and will be made available as filters when querying the traces, from a graphical interface for example.

But to make this process optimal, we decided to introduce the concept of context schema. The context schema, as its name indicates, describes a context structure. Each application whose traces are to be inserted and queried in ProRegister is assumed to
have a certain set of context schemas. Therefore, only those context values (present in the traces) that conform to these patterns will be proposed by the GUI as filter criteria for querying the traces. This also implies that the context schemas must be
initialized before starting to insert the traces related to them.

The difference between the structure of a context schema and that of a context value (or context) lies in the content of the attribute. While the content of this attribute is an array of keys in a context schema, its value becomes an array of the same keys
associated with values. See :numref:`trace_structure.drawio.2`


The following points describe the use of context schema management endpoints.


Create a context schema
========================
This endpoint allows to create. The request will return identifier of the created context scheme.

Endpoint
----------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| POST    | /api/v1/context                     |
+---------+-------------------------------------+


parameter
^^^^^^^^^^
+----------------------------------------------+-------------------------------------------------------------------------+
| Parameter                                    | Type of values                                                          |
+==============================================+=========================================================================+
| Header                                       |Authorization: Bearer $TOKEN                                             |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body                                         ||   {                                                                    |
|                                              ||     "context": {                                                       |
|                                              ||       "name": "Package Collection",                                    |
|                                              ||       "task": "Issuer Signature",                                      |
|                                              ||       "attributes": [                                                  |
|                                              ||         "tracking_number",                                             |
|                                              ||         "package_reference",                                           |
|                                              ||         "package_issuer",                                              |
|                                              ||         "signature_time"                                               |
|                                              ||       ],                                                               |
|                                              ||       "gdprDatetime": "2023-08-25T16:16:14.000Z"                       |
|                                              ||     }                                                                  |
|                                              ||   }                                                                    |
|                                              ||                                                                        |
+----------------------------------------------+-------------------------------------------------------------------------+


Example use
------------

.. code-block:: bash

     curl -v -k -X POST  --data $REQUEST_BODY  \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $bearerToken" \
    https://<url_environment>:<port_environment>/api/v1/context

with a json body which is based on the previous description of the request structure.


Nominal output
---------------
Identifier of the created context scheme.

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||    {                                                                        |
||     ||      "_id": "6ea2934ca7b5c0c75a63b5a63c008215",                             |
||     ||      "_rev": "1-28382413c74f0bd8b3bbcdb4674b8a1b"                           |
||     ||    }                                                                        |
+------+------------------------------------------------------------------------------+



Possible errors
----------------
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+



.. raw:: pdf

   PageBreak


Update a context schema
=========================
This endpoint allows to update an existing context schema. The request will return the identifier of the new version of the context scheme.

Endpoint
-------------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| PUT     | /api/v1/context                     |
+---------+-------------------------------------+


parameter
^^^^^^^^^^
+----------------------------------------------+-------------------------------------------------------------------------+
| Parameter                                    | Type of values                                                          |
+==============================================+=========================================================================+
| Header                                       |Authorization: Bearer $TOKEN                                             |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body                                         ||                                                                        |
|                                              ||      {                                                                 |
|                                              ||        "context": {                                                    |
|                                              ||          "_id": "c3ee9cffed2ff959d5b0785436026264",                    |
|                                              ||          "_rev": "2-3608cf1d5e7c50098ad98416b7af4601",                 |
|                                              ||          "name": "Signature",                                          |
|                                              ||          "task": "send_code",                                          |
|                                              ||          "attributes": [                                               |
|                                              ||            "reference",                                                |
|                                              ||            "destinataire",                                             |
|                                              ||            "recipient",                                                |
|                                              ||            "address"                                                   |
|                                              ||          ],                                                            |
|                                              ||          "gdprDatetime": "2022-08-25T16:16:14.000Z"                    |
|                                              ||        }                                                               |
|                                              ||      }                                                                 |
+----------------------------------------------+-------------------------------------------------------------------------+


Example of use
----------------

.. code-block:: bash

   curl -v -k -X PUT  --data $REQUEST_BODY  \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $bearerToken" \
  https://<url_environment>:<port_environment>/api/v1/context

with a json body which is based on the previous description of the request structure.





Nominal output
---------------
Identifier of the updated context schema.

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||   {                                                                         |
||     ||     "_id": "c3ee9cffed2ff959d5b0785436026264",                              |
||     ||     "_rev": "3-64d89d519eece86d4449c475a9a85e3d"                            |
||     ||   }                                                                         |
+------+------------------------------------------------------------------------------+



Possible errors
----------------
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+


.. raw:: pdf

   PageBreak


Request a context schema by id
================================
Retrieve a context schema from its identifier. This query is not very practical, since it implies the prior knowledge of the identifier of the schema to query.
Other queries described below allow to retrieve all or a subset of context schemas from more flexible criteria.


Endpoint
----------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| GET   | /api/v1/context                       |
+---------+-------------------------------------+


parameter:

+----------------------------------------------+-------------------------------------------------------------------------+
| Parameter                                    | Type of values                                                          |
+==============================================+=========================================================================+
| Header                                       |Authorization: Bearer $TOKEN                                             |
+----------------------------------------------+-------------------------------------------------------------------------+
| Body                                         ||   {                                                                    |
|                                              ||     "_id": "c3ee9cffed2ff959d5b0785436026264",                         |
|                                              ||     "_rev": "3-64d89d519eece86d4449c475a9a85e3d"                       |
|                                              ||   }                                                                    |
|                                              ||                                                                        |
+----------------------------------------------+-------------------------------------------------------------------------+



Example of use
----------------

.. code-block:: bash

  curl -v -k -X GET  --data $REQUEST_BODY  \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $bearerToken" \
  https://<url_environment>:<port_environment>/api/v1/context

with a json body which is based on the previous description of the request structure.

Nominal output
----------------
The requested context schema (an error if the request ID does not match any context schema).


+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||    {                                                                        |
||     ||      "_id": "c3ee9cffed2ff959d5b0785436026264",                             |
||     ||      "_rev": "3-64d89d519eece86d4449c475a9a85e3d",                          |
||     ||      "name": "Signature",                                                   |
||     ||      "task": "envoi code",                                                  |
||     ||      "attributes": [                                                        |
||     ||        "reference",                                                         |
||     ||        "destinataire"                                                       |
||     ||      ],                                                                     |
||     ||      "gdprDatetime": "2022-08-25T16:16:14.000Z"                             |
||     ||    }                                                                        |
+------+------------------------------------------------------------------------------+



Possible errors
-----------------
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+


.. raw:: pdf

   PageBreak



Query of all the context schemas
=================================
This operation allows to query all the context schemas.


Endpoint
----------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
|| Header || Authorization: Bearer $TOKEN       |
+---------+-------------------------------------+
| GET   | /api/v1/context/list                  |
+---------+-------------------------------------+


parameter
^^^^^^^^^^
+----------------------------------------------+-------------------------------------------------------------------------+
| Parameter                                    | Type of values                                                          |
+==============================================+=========================================================================+
| Header                                       |Authorization: Bearer $TOKEN                                             |
+----------------------------------------------+-------------------------------------------------------------------------+


Example of use
---------------

.. code-block:: bash

  curl -v -k -X GET    \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $bearerToken" \
  https://<url_environment>:<port_environment>/api/v1/context/list



Nominal output
----------------
The list of all context schemas.

+------+-------------------------------------------------------------------------------+
| Code | Example                                                                       |
+======+===============================================================================+
|| 200 ||   {                                                                          |
||     ||     "total_rows": 76,                                                        |
||     ||     "offset": 0,                                                             |
||     ||     "rows": [                                                                |
||     ||       {                                                                      |
||     ||         "id": "9cf011a07640fb6236ec960827000ad2",                            |
||     ||         "key": "9cf011a07640fb6236ec960827000ad2",                           |
||     ||         "value": {                                                           |
||     ||           "rev": "1-28382413c74f0bd8b3bbcdb4674b8a1b"                        |
||     ||         },                                                                   |
||     ||         "doc": {                                                             |
||     ||         "_id": "9cf011a07640fb6236ec960827000ad2",                           |
||     ||           "_rev": "1-28382413c74f0bd8b3bbcdb4674b8a1b",                      |
||     ||           "name": "Signature",                                               |
||     ||           "task": "envoi code",                                              |
||     ||           "attributes": [                                                    |
||     ||             "reference",                                                     |
||     ||             "destinataire"                                                   |
||     ||           ],                                                                 |
||     ||           "gdprDatetime": "2022-08-25T16:16:14.000Z"                         |
||     ||         }                                                                    |
||     ||       },                                                                     |
||     ||       {                                                                      |
||     ||         "id": "9cf011a07640fb6236ec960827000c24",                            |
||     ||         "key": "9cf011a07640fb6236ec960827000c24",                           |
||     ||         "value": {                                                           |
||     ||           "rev": "1-59e435d7715cd34a6163733ae9dd71ae"                        |
||     ||         },                                                                   |
||     ||         "doc": {                                                             |
||     ||           "_id": "9cf011a07640fb6236ec960827000c24",                         |
||     ||           "_rev": "1-59e435d7715cd34a6163733ae9dd71ae",                      |
||     ||           "name": "Signature",                                               |
||     ||           "task": "generation certificat",                                   |
||     ||           "attributes": [                                                    |
||     ||             "reference",                                                     |
||     ||             "utilisateur"                                                    |
||     ||           ],                                                                 |
||     ||           "gdprDatetime": "2022-08-25T16:16:14.000Z"                         |
||     ||         }                                                                    |
||     ||       },                                                                     |
||     ||       {                                                                      |
||     ||         "id": "_design/contextInfo",                                         |
||     ||         "key": "_design/contextInfo",                                        |
||     ||         "value": {                                                           |
||     ||           "rev": "1-9cc7bce2705e7e49b7a056930a35e2b1"                        |
||     ||         },                                                                   |
||     ||         "doc": {                                                             |
||     ||           "_id": "_design/contextInfo",                                      |
||     ||           "_rev": "1-9cc7bce2705e7e49b7a056930a35e2b1",                      |
||     ||           "views": {                                                         |
||     ||             "show": {                                                        |
||     ||               "reduce": "function (keys, values, rereduce) { ... }",         |
||     ||               "map": "function (doc) { ... }"                                |
||     ||             },                                                               |
||     ||             "show_v2": {                                                     |
||     ||               "reduce": "function (keys, values, rereduce) {   ... }",       |
||     ||               "map": "function (doc) { ... }"                                |
||     ||             }                                                                |
||     ||           },                                                                 |
||     ||           "language": "javascript"                                           |
||     ||         }                                                                    |
||     ||       }                                                                      |
||     ||     ]                                                                        |
||     ||   }                                                                          |
||     ||                                                                              |
+------+-------------------------------------------------------------------------------+


Possible errors
-----------------
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+


.. raw:: pdf

   PageBreak


Query context schemas by filter
================================
Ability to query a set of context schemas using a CouchDB Selector clause.


Endpoint
----------
+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| POST   | /api/v1/context/filter               |
+---------+-------------------------------------+


parameter
^^^^^^^^^^
+---------+------------------------------------------------------------------------------+
| Code    | Example                                                                      |
+=========+==============================================================================+
|| Header || Authorization: Bearer $TOKEN                                                |
+---------+------------------------------------------------------------------------------+
|| 200    ||                                                                             |
||        ||  {                                                                          |
||        ||    "selector": {                                                            |
||        ||      "$or": [                                                               |
||        ||        {                                                                    |
||        ||          "name": {                                                          |
||        ||            "$eq": "contexteN"                                               |
||        ||          }                                                                  |
||        ||        },                                                                   |
||        ||        {                                                                    |
||        ||          "attributes": {                                                    |
||        ||          "$or": [                                                           |
||        ||              {                                                              |
||        ||                "$elemMatch": {                                              |
||        ||                  "$eq": "attr0"                                             |
||        ||                }                                                            |
||        ||              },                                                             |
||        ||              {                                                              |
||        ||                "$elemMatch": {                                              |
||        ||                  "$eq": "attrN"                                             |
||        ||                }                                                            |
||        ||              }                                                              |
||        ||            ]                                                                |
||        ||          }                                                                  |
||        ||        }                                                                    |
||        ||      ]                                                                      |
||        ||    }                                                                        |
||        ||  }                                                                          |
||        ||                                                                             |
+---------+------------------------------------------------------------------------------+


Example of use
----------------

.. code-block:: bash

  curl -v -k -X POST  --data $REQUEST_BODY  \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $bearerToken" \
  https://<url_environment>:<port_environment>/api/v1/context/filter

with a json body which is based on the previous description of the request structure.


Nominal output
---------------
List of context schemas matching the criteria of the query.

+------+------------------------------------------------------------------------------+
| Code | Example                                                                      |
+======+==============================================================================+
|| 200 ||    [                                                                        |
||     ||      {                                                                      |
||     ||        "_id": "c3ee9cffed2ff959d5b0785436000be8",                           |
||     ||        "_rev": "1-28382413c74f0bd8b3bbcdb4674b8a1b",                        |
||     ||        "name": "Signature",                                                 |
||     ||        "task": "envoi code",                                                |
||     ||        "attributes": [                                                      |
||     ||          "reference",                                                       |
||     ||          "destinataire"                                                     |
||     ||        ],                                                                   |
||     ||        "gdprDatetime": "2022-08-25T16:16:14.000Z"                           |
||     ||      },                                                                     |
||     ||      {                                                                      |
||     ||        "_id": "c3ee9cffed2ff959d5b07854360038a5",                           |
||     ||        "_rev": "1-8e1510e8dc3c6a7ff430afc21a8320d5",                        |
||     ||        "name": "Signature",                                                 |
||     ||        "task": "reconnaissance",                                            |
||     ||        "attributes": [                                                      |
||     ||          "reference"                                                        |
||     ||        ],                                                                   |
||     ||        "gdprDatetime": "2022-08-25T16:24:19.000Z"                           |
||     ||      },                                                                     |
||     ||      {                                                                      |
||     ||        "_id": "c3ee9cffed2ff959d5b0785436026264",                           |
||     ||        "_rev": "3-64d89d519eece86d4449c475a9a85e3d",                        |
||     ||        "name": "Signature",                                                 |
||     ||        "task": "send_code",                                                 |
||     ||        "attributes": [                                                      |
||     ||          "reference",                                                       |
||     ||              "destinataire",                                                |
||     ||              "recipient",                                                   |
||     ||              "address"                                                      |
||     ||            ],                                                               |
||     ||            "gdprDatetime": "2022-08-25T16:16:14.000Z"                       |
||     ||          }                                                                  |
||     ||        ]                                                                    |
||     ||                                                                             |
+------+------------------------------------------------------------------------------+



Possible errors
----------------
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| Code   | Example                                                                                                                                                  | Reason                        |
+========+==========================================================================================================================================================+===============================+
| 400    ||                                                                                                                                                         | Incorrect body format         |
|        || {                                                                                                                                                       |                               |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "400",                                                                                                                               |                               |
|        ||       "errorMessage": "Error: Incorrect request. Wrong data in the body of the request. Missing required property:token"                                |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
| 500    || {                                                                                                                                                       |Internal HTTP server error     |
|        ||   "listOfErrors": [                                                                                                                                     |                               |
|        ||     {                                                                                                                                                   |                               |
|        ||       "errorCode": "500",                                                                                                                               |                               |
|        ||       "errorMessage": "Server internal error"                                                                                                           |                               |
|        ||     }                                                                                                                                                   |                               |
|        ||   ]                                                                                                                                                     |                               |
|        || }                                                                                                                                                       |                               |
|        ||                                                                                                                                                         |                               |
+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+


****************
User interface
****************
In addition to the REST API that allows direct interaction with the ProRegister's API, ProRegister is accompanied by a graphical user interface (under development)
whose functionality is currently limited to querying and exporting the traces stored in ProRegister to form an evidence file, a concept also under development.

  .. _proregister_gui_home.png:
  .. figure:: ./images/proregister_gui_home.png


     ProRegister GUI homepage


The interface has 4 tabs of which only the first two are functional for the moment. We describe them below.


Traces by elements filter
===========================
This is the tab that is displayed by default. It is a view that allows to query the traces from a criterion based on the values of the "elements" of the traces
(section `By trace elements fields`_). The tab could be renamed "Traces by elements filter" for more clarity (in a future version).

The tab has a single field to receive the JSON argument of the query. If you have read `By trace elements fields`_, you know the format of this argument.
But a peculiarity of the GUI (to be reviewed?) is that the ``TracesOwners`` field must be present in the argument, even if the array is empty.

Figure :numref:`proregister_gui_elements_filter.png` shows the result of a query execution. The "Download PDF" button at the bottom right of the result list allows you to make an export in PDF format
that will be used as an evidence file.

  .. _proregister_gui_elements_filter.png:
  .. figure:: ./images/proregister_gui_elements_filter.png

     Result of a query of traces by "element filter"




Examples of arguments (valid and invalid)
-------------------------------------------

+---------------------------------------------------------------------+-------------------------------------------------------------------------+
| Desccription                                                        | Value                                                                   |
+=====================================================================+=========================================================================+
| Invalid : TracesOwners field absent                                 ||      {                                                                 |
|                                                                     ||         "TraceFiltered": {                                             |
|                                                                     ||           "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",    |
|                                                                     ||           "creationDatetimeHigherBound": "2022-04-25T14:12:43.232Z"    |
|                                                                     ||           "lowerBoundExcluded": true,                                  |
|                                                                     ||           "higherBoundExcluded": false,                                |
|                                                                     ||           "numberOfElements": 1,                                       |
|                                                                     ||           "listOfElements": [                                          |
|                                                                     ||             {                                                          |
|                                                                     ||               "elementField": "expectedElementField",                  |
|                                                                     ||               "elementValue": "expectedElementElementValue"            |
|                                                                     ||             }                                                          |
|                                                                     ||           ]                                                            |
|                                                                     ||       }                                                                |
|                                                                     ||     }                                                                  |
|                                                                     ||                                                                        |
+---------------------------------------------------------------------+-------------------------------------------------------------------------+
| Valid: TracesOwners field present with a value                      || {                                                                      |
|                                                                     ||    "TraceFiltered": {                                                  |
|                                                                     ||       "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",        |
|                                                                     ||       "creationDatetimeHigherBound": "2022-04-25T14:12:43.232Z",       |
|                                                                     ||       "lowerBoundExcluded": true,                                      |
|                                                                     ||       "higherBoundExcluded": false,                                    |
|                                                                     ||       "numberOfElements": 1,                                           |
|                                                                     ||       "listOfElements": [                                              |
|                                                                     ||         {                                                              |
|                                                                     ||          "elementField": "expectedElementField",                       |
|                                                                     ||          "elementValue": "expectedElementElementValue"                 |
|                                                                     ||         }                                                              |
|                                                                     ||       ]                                                                |
|                                                                     ||    },                                                                  |
|                                                                     ||    "TracesOwners": ["f215ef93-bc79-959-88754-6f43e42fc53a"]            |
|                                                                     || }                                                                      |
+---------------------------------------------------------------------+-------------------------------------------------------------------------+
| Valid: TracesOwners field present with several  values              || {                                                                      |
|                                                                     ||    "TraceFiltered": {                                                  |
|                                                                     ||       "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",        |
|                                                                     ||       "creationDatetimeHigherBound": "2022-04-25T14:12:43.232Z",       |
|                                                                     ||       "lowerBoundExcluded": true,                                      |
|                                                                     ||       "higherBoundExcluded": false,                                    |
|                                                                     ||       "numberOfElements": 1,                                           |
|                                                                     ||       "listOfElements": [                                              |
|                                                                     ||         {                                                              |
|                                                                     ||          "elementField": "expectedElementField",                       |
|                                                                     ||          "elementValue": "expectedElementElementValue"                 |
|                                                                     ||         }                                                              |
|                                                                     ||       ]                                                                |
|                                                                     ||    },                                                                  |
|                                                                     ||    "TracesOwners": ["f215ef93-bc79-959-88754-6f43e42fc53a",            |
|                                                                     ||                       "36255032-3d34-4d34-b57d-a81c35ed49e2"           |
|                                                                     ||      ]                                                                 |
|                                                                     || }                                                                      |
|                                                                     ||                                                                        |
+---------------------------------------------------------------------+-------------------------------------------------------------------------+
| Valid: TracesOwners field present but empty                         || {                                                                      |
|                                                                     ||    "TraceFiltered": {                                                  |
|                                                                     ||       "creationDatetimeLowerBound": "2022-03-03T16:41:47.236Z",        |
|                                                                     ||       "creationDatetimeHigherBound": "2022-04-25T14:12:43.232Z",       |
|                                                                     ||       "lowerBoundExcluded": true,                                      |
|                                                                     ||       "higherBoundExcluded": false,                                    |
|                                                                     ||       "numberOfElements": 1,                                           |
|                                                                     ||       "listOfElements": [                                              |
|                                                                     ||         {                                                              |
|                                                                     ||          "elementField": "expectedElementField",                       |
|                                                                     ||          "elementValue": "expectedElementElementValue"                 |
|                                                                     ||         }                                                              |
|                                                                     ||       ]                                                                |
|                                                                     ||    },                                                                  |
|                                                                     ||    "TracesOwners": []                                                  |
|                                                                     || }                                                                      |
+---------------------------------------------------------------------+-------------------------------------------------------------------------+


Traces by context filter
=========================
You can access the query view for traces by context by clicking on the “Traces by Context” tab.

  .. _proregister_gui_empty_context.png:
  .. figure:: ./images/proregister_gui_empty_context.png

     Query view of traces by context


It is important to know that this view is intended to be the main query interface because it proposes as query criteria the context information of the traces, which allows to better
understand the origin of the traces we want to query from a functional point of view.

And very importantly, this context information is proposed by the view and can just be selected in different fields. But all this is not automatic, this information is only available for traces
whose contexts correspond to existing context schemas at the time of the creation of the traces, see `Context schema management`_ which discusses in more detail the relationship between traces and
context schemas.

The following figure illustrates the result of an example of a trace query based on context information selected in the view form.


  .. _proregister_gui_context_filter.png:
  .. figure:: ./images/proregister_gui_context_filter.png

     Result of a query by context filter


As in the previous view, the results obtained in this way can be exported as a PDF file for use as an "evidence file".
