Overview of CERTH Data Sharing Tool
===================================

CERTH/ITI has designed a Tool for enabling the data sharing and data permission management using a proposed smart contract hierarchy. The tool tackles also with the problem of data integrity verification which lies under the data quality issue that should be addressed by the REACH toolkit. The combination of the data integrity verification and the fact that only pointers/references to the data are stored in the Blockchain, render the tool compliant with GDPR by design.

Getting access to the Infrastructure
------------------------------------

The Data Sharing Tool is integrated into the BaaS Platform, so any access to it is made through the Platform.

.. note:: To obtain access, contact us by mail (<krinidis@iti.gr>, <ggogos@iti.gr>) to the consortium address.
  
Use case
--------
Through the Home Page of BaaS, the user will be able to see the available datasets provided to the Platform and make a request to the provider. The dataset page will provide information about the type of the data, the field of science (e.g. Medical & Health, Energy) and comments about their content. Data providers (CERTH) sharing their data with data consumers in a secure way, use a blockchain network with deployed Solidity smart contracts to store the fingerprints of the data assets for integrity verification, as well as reference to the data so that authenticated users can access them. Data consumers searching for relevant data and wishing to check its integrity, use a blockchain network with deployed Solidity smart contracts to search for the data based on a set of criteria and also to verify their integrity.
The sequence flow of the users' actions, after the registration to the BaaS, will be the following:

1. Search for datasets of interest through the dataset menu. The information of the datasets provided in the menu, will help the users to choose the most suitable dataset for their purpose.
2. Make a request through the Platform for the dataset of interest. A notification will be sent to the data provider to accept or reject the request.
3. The response will be sent back to the user and it will be stored in the Blockchain and it can be shown in the transaction tracing menu for history traceability.
4. If the data provider accepts the request, the user will be able to download the dataset and use it.
5. On a request rejection, the actions of step (2) will be followed and the user can make a new request for another dataset.


