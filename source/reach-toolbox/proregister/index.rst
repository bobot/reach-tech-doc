ProRegister
===========
.. contents:: Contents
        :depth: 2
        :local:
        :backlinks: top
        
Introduction
########
ProRegister is a new generation tool (still in production) which allows to a third-party tool to share and store its logs inside a blockchain in order to ensure the incorruptibility of them. It is a privacy-compliant blockchain permissioned private solution based on the open source Hyperledger Fabric project.

By its design, ProRegister can be seen as a secure audit trail. It can be used as a proof in many different use cases… To be able do this, ProRegister stores all sensitive data for each different actor of the network,  in an external databases relied to a blockchain. For each stored data, a hash print is generated and stored to the joined blockchain, ensuring by this way the integrity of the data. This principle provides then a Proof of Existence. 

It proves that a certain data was stored at a specific time, and that this data effectively corresponds to a hash stored in the blockchain. Moreover, it also provides a Proof of Matching, which by the uses of smart contracts, enables to prove when the data has been used and by whom. 
At the same time, the tool is himself GDPR compliant by respecting the right to oblivion. By a smart mechanism, ProRegister allows to delete the stored data at demand. 

How it Works?
########

The tool is deployed in a SaaS and available by a REST API. It can be used as a private blockchain for a standalone organisation or as a shared private blockchain for a consortium. Each ProRegister peer is composed by 3 instances which  simulate an internal network with 3 members. By this way, the tool provides to the third-party a private blockchain. As already said, this chain is not shared with the other possible entities of the consortium. Thus, all sensitive data can be saved without risk.


In the same time, each organisation provide 2 channels, a private one and a public one. The first channel is the principal (private) and it corresponds to the trace provided by the third-party tool and stored in the system. The second channel is called public channel because it corresponds to the part which is shared with other entities. It contains metadata used to store the trace and the generated hash print.In case of consortium, the public channel correspond to a second level of blockchain. By this way, all public information are certified by the other members of the network.

Currently, ProRegister does not provide any GUI (which should be available in the next few months) so it is needed to use the REST API to store and query in the blockchain. 
 
Requirement
########
To communicate with the software, a keycloak is needed. Currently, the tool will allow a transaction by checking an access token, provided with the trace, with the keycloak used for the authentication.
In the same time, the token will be used to identify the owner of the provided trace to manage the availability of them during the querying step.

Authentication
########
This endpoint is done to fetch the token from the ID provider with user's credentials

+---------+----------------------------+
| method  | url                        |
+=========+============================+
| POST    |/api/users/authentication   |
+---------+----------------------------+


Example usage:

:: 

    curl -k -X POST --header "Content-Type: application/json" https://<url_environment>:<port_environment>/api/users/authentication --data '{ "credentials" : {"userName" : "fooName", "userPassword" : "fooPwd" }}'


Possible errors
~~~~~~~~~~~
+--------+-----------------------------------------------------+-------------------------------+
| Code   | Example                                             | Reason                        |
+========+=====================================================+===============================+
| 400    |{                                                    | Incorrect body format         |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "400",                             |                               |
|        |     "errorMessage": "Error: Incorrect request. Wrong|                               |
|        |parameter instance in params.  No enum match         |                               | 
|        |for: rcie"                                           |                               |
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 401    |{                                                    |Credentials are not valid      |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "401",                             |                               |
|        |     "errorMessage": "Error: Authentication failure  |                               |
|        |idProvider response: Error: Request failed with      |                               | 
|        |userInfo:Error: Request failed with status code 401" |                               |
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+

.. raw:: pdf

   PageBreak



Storage
########
To store a trace in ProRegister, it is needed to send a structured json message which contains the trace, the token and certains information which will describe/define the trace. The following example shows the structure of this message. 

::

    {
      "token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia",    
       "Trace":
      {
        "creationDatetime":"2021-05-12T15:03:03.622Z",
        "context":
        {
          "name":"TestName",
          "task":"TestTask", 
          "attributes":
          [
            {
              "key":"attrKeyOne",
              "value":"attrValueOne"
            },
            {
              "key":"attrKeyTwo",    
              "value":"attrValueTwo"
            }
          ],
          "gdprDatetime":"2021-05-12T15:03:03.622Z"
          "numberOfElements":1,     
          "listOfElements":
          [
            {
              "elementField":"aFunctionalID",            
              "elementValue":"xyz",            
              "elementMetadataList":
              {
                "numberOfElementMetadata":2,
                "listOfElementMetadata":
                [
                  {
                    "elementMetadataField":"A",
                    "elementMetadataValue":"a"
                  },
                  {
                    "elementMetadataField":"B",
                    "elementMetadataValue":"b"
                  }
                ]
              }
            }
          ]
        }
      }
    }


.. raw:: pdf

   PageBreak


Definition of structure’s elements :
~~~~~~~~~~~

* **creationDatetime:** the date correspond to the creation date of the trace and must respect the following pattern -  « yyyy-MM-ddTHH:mm:ss.SSSZ » .
* **name:** is a unique functional ID which correspond to a major functionnality.
* **task:** is a unique functional ID which correspond to a step inside the functionnality.
* **key:** is an element used during the step (ex:parameter).
* **value:** is the value of the previous element(ex:parameter value).
* **gdprDatetime:** the date correspond to the retention date and must respect the following pattern -  « yyyy-MM-ddTHH:mm:ss.SSSZ » .
* **numberOfElements:** is equals to number of couples « elementField, elementValue » in the listOfElements.
* **elementField:** is a unique functional ID.
* **elementValue:** is the trace to store.
* **elementMetadataList (optional):** some time, it could be useful to subdivide the trace in different sub information. This list allows to store these elements.
* **numberOfElementMetadata:** is equals to number of couples « elementMetadataField, elementMetadataValue ».
* **elementMetadataField:** is a unique functional ID.
* **elementMetadataValue:** is the trace to store.

|
|

+---------+----------------------------+
| method  | url                        |
+=========+============================+
| POST    |/api/chaincodes/trace       |
+---------+----------------------------+

Example usage:

:: 

    curl -k -X POST --data @./json_example.json  -H "Content-Type: application/json" https://<url_environment>:<port_environment>/api/chaincodes/trace
with a json file which is based on the previous structure and contain the information.

.. raw:: pdf

   PageBreak


Possible errors
~~~~~~~~~~~
+--------+-----------------------------------------------------+-------------------------------+
| Code   | Example                                             | Reason                        |
+========+=====================================================+===============================+
| 400    |{                                                    | Incorrect body format         |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "400",                             |                               |
|        |     "errorMessage": "Error: Incorrect request. Wrong|                               |
|        |data in the body of the request.  Missing required   |                               | 
|        |property:token"                                      |                               |
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 401    |{                                                    |Token is not valid             |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "401",                             |                               |
|        |     "errorMessage": "Error: Token not found. Token  |                               |
|        |not found in IDProvider. idProvider response:        |                               | 
|        |userInfo:Error: Request failed with status code 401" |                               |
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 403    |{                                                    | User has not got enough rights|
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "403",                             |                               |
|        |     "errorMessage": "Error: Forbidden scope         |                               |
|        |Forbidden access for user to write"                  |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 409    |{                                                    | The trace is already existing |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "409",                             |                               |
|        |     "errorMessage": "Error: Conflict error. Conflict|                               |
|        |error submitting main tx"                            |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+

.. raw:: pdf

   PageBreak

Query
########
By keys
~~~~~~~~~~~

This endpoint is done to retrieve stored traces by using the linked ID generated and returned during the storage. It is possible to fetch one or many traces with the same query.

+---------+-----------------------------------+
| method  | url                               |
+=========+===================================+
| POST    |/api/chaincodes/trace/queryByKeys  |
+---------+-----------------------------------+


parameter:

+-------------+-----------------------------------------------------+
| Parameter   | Type of values                                      |
+=============+=====================================================+
| Header      |N/A                                                  | 
+-------------+-----------------------------------------------------+
| Body        | {                                                   |
|             |   "token":"string"                                  |
|             |    "listOfTransactionKeys": [                       |
|             |     {                                               |
|             |       "product": "string"                           |
|             |       "instance": "string"                          |
|             |       "organization": "string"                      |
|             |       "apiInterface": "string"                      |
|             |       "traceGroupID": "string"                      |
|             |       "creationDateTime": "date"                    |
|             |    }                                                |
|             |   ]                                                 |
|             |}                                                    |
+-------------+-----------------------------------------------------+

Example usage:

:: 

    curl -k -X GET --data $REQUEST_BODY  -H "Content-Type: application/json" "Accept: application/json" https://<url_environment>:<port_environment>/api/chaincodes/trace/queryByKeys
with a json file which is based on the previous structure and contain the information.


.. raw:: pdf

   PageBreak

Possible errors
~~~~~~~~~~~
+--------+-----------------------------------------------------+-------------------------------+
| Code   | Example                                             | Reason                        |
+========+=====================================================+===============================+
| 400    |{                                                    | Incorrect body format         |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "400",                             |                               |
|        |     "errorMessage": "Error: Incorrect request. Wrong|                               |
|        |data in the body of the request. Missing required    |                               | 
|        |property: token"                                     |                               |
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 401    |{                                                    |token is not valid             |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "401",                             |                               |
|        |     "errorMessage": "Error: token not found. token  |                               |
|        |not found in IDProvider"                             |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 403    |{                                                    | user is not allow             |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "403",                             |                               |
|        |     "errorMessage": "Error: Forbidden scope.        |                               |
|        |Forbidden access for user to read"                   |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 406    |{                                                    |the trace was corrupted        |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "406",                             |                               |
|        |     "errorMessage": "Error: functional error. Error |                               |
|        |in private data haash integrity"                     |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+

.. raw:: pdf

   PageBreak

By fields
~~~~~~~~~~~

This endpoint is done to retrieve stored traces by using elements which were used to store the trace. It is possible to fetch one or many traces with the same query.

+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| POST    |/api/chaincodes/trace/queryByFields  |
+---------+-------------------------------------+


parameter:

+-------------+-----------------------------------------------------+
| Parameter   | Type of values                                      |
+=============+=====================================================+
| Header      |N/A                                                  | 
+-------------+-----------------------------------------------------+
| Body        | {                                                   |
|             |   "token":"string"                                  |
|             |    "TraceFiltered": {                               |
|             |     {                                               |
|             |       "creationDatetimeLowerBound": "date"          |
|             |       "creationDatetimeHigherBound": "date"         |
|             |       "lowerBoundExcluded": "boolean"               |
|             |       "higherBoundExcluded": "boolean"              |
|             |       "numberOfElements": "int"                     |
|             |       "listOfElements": [                           |
|             |         {                                           |
|             |          "elementField": "string"                   |
|             |          "elementValue": "string"                   |
|             |         }                                           |
|             |       ]                                             |
|             |    }                                                |
|             |   }                                                 |
|             |}                                                    |
+-------------+-----------------------------------------------------+

Example usage:

:: 

    curl -k -X POST --data $REQUEST_BODY  -H "Content-Type: application/json" "Accept: application/json" https://<url_environment>:<port_environment>/api/chaincodes/trace/queryByFilters
with a json file which is based on the previous structure and contain the information.


Possible errors
~~~~~~~~~~~
+--------+-----------------------------------------------------+-------------------------------+
| Code   | Example                                             | Reason                        |
+========+=====================================================+===============================+
| 400    |{                                                    | Incorrect body format         |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "400",                             |                               |
|        |     "errorMessage": "Error: Incorrect request. Wrong|                               |
|        |data in the body of the request. Missing required    |                               | 
|        |property: token"                                     |                               |
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 401    |{                                                    |token is not valid             |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "401",                             |                               |
|        |     "errorMessage": "Error: token not found. token  |                               |
|        |not found in IDProvider"                             |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 403    |{                                                    | user is not allow             |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "403",                             |                               |
|        |     "errorMessage": "Error: Forbidden scope.        |                               |
|        |Forbidden access for user to read"                   |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+
| 406    |{                                                    |the trace was corrupted        |
|        | "listOfErrors": [                                   |                               |
|        |    {                                                |                               |
|        |     "errorCode": "406",                             |                               |
|        |     "errorMessage": "Error: functional error. Error |                               |
|        |in private data haash integrity"                     |                               | 
|        |    }                                                |                               |
|        |   ]                                                 |                               |
|        |}                                                    |                               |
+--------+-----------------------------------------------------+-------------------------------+

.. raw:: pdf

   PageBreak


By context
~~~~~~~~~~~
This endpoint is done to retrieve stored traces by using the context elements key used during the storage.

+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| POST    |/api/chaincodes/trace/queryByContext |
+---------+-------------------------------------+


parameter:

+-------------+--------------------------------------------------------------+
| Parameter   | Type of values                                               |
+=============+==============================================================+
| Header      |N/A                                                           | 
+-------------+--------------------------------------------------------------+
| Body        | {                                                            |
|             |   "token":"string"                                           |
|             |    "ContextFilter": {                                        |
|             |     [                                                        |
|             |       {                                                      |
|             |         "creationLowerBoundTimestamp": "date"                |
|             |         "creationUpperBoundTimestamp": "date"                |
|             |         "creationLowerBoundTimestampExcluded": "boolean"     |
|             |         "creationUpperBoundTimestampExcluded": "boolean"     |
|             |         "context": "string"                                  |
|             |         "task": "string"                                     |
|             |         "attributes": [                                      |
|             |           {                                                  |
|             |            "key": "string"                                   |
|             |            "value": "string"                                 |
|             |           }                                                  |
|             |         ]                                                    |
|             |         "gdprDatetimeLowerBoundTimestamp": "date"            |
|             |         "gdprDatetimeUpperBoundTimestamp": "date"            |
|             |         "gdprDatetimeLowerBoundTimestampExcluded": "boolean" |
|             |         "gdprDatetimeUpperBoundTimestampExcluded": "boolean" |
|             |       }                                                      |
|             |     ]                                                        |
|             |   }                                                          |
|             | }                                                            |
+-------------+--------------------------------------------------------------+

Example usage:

:: 

    curl -k -X POST --data $REQUEST_BODY  -H "Content-Type: application/json" "Accept: application/json" https://<url_environment>:<port_environment>/api/chaincodes/trace/queryByContext
with a json file which is based on the previous structure and contain the information.


List context values
~~~~~~~~~~~
This endpoint is done to retrieve all possible elements key.

+---------+-------------------------------------+
| method  | url                                 |
+=========+=====================================+
| GET     |/api/chaincodes/trace/context/view   |
+---------+-------------------------------------+


Example usage:

:: 

    curl -k -X GET --data $REQUEST_BODY  -H "Content-Type: application/json" "Accept: application/json" https://<url_environment>:<port_environment>/api/chaincodes/trace/context/view



