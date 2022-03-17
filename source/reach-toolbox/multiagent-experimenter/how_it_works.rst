############
How it works
############

MAX (for ‘Multi-Agent eXperimenter’) is a framework for agent-based simulation and full agent-based applications building. MAX runs on the Java virtual machine, so it works on all major platforms (MacOS, Windows, Linux, et al). It can run as a desktop application and a command line application. The requirements to use MAX are Java (11+) and an IDE.

Since MAX is modular, two aspects of working with MAX will be detailed here: Executing an existing model and developing a new model.

############
Executing an existing MAX model
############

Since MAX is a java application. Each model is a java application and is executed separately. To do so, the requirements are the .jar file of the model and an .xml configuration file given in parameter.

Command: java –jar model.jar –experimenter experimenter.xml

The figure below shows the execution of one of MAX models, Bitcoin, with some data inspectors enabled. At the center of the simulation, the scheduler which allows to adjust the simulation speed, even pause it if necessary.
It is surrounded by data inspectors chosen to appear in this simulation. Namely, a general data inspector which shows the state of the network with (from left to right) a line chart of the number of agents as a function of time, an illustration of the network topology in real time as well as certain network parameters displayed at the right of the figure.
Two bar chart figures follow. One that tells us about the block creation activity and another about the merits of block creators. And finally, a table that contains information on the blocks added to the blockchain (height, number of transactions…).

.. image:: img/executionExample.png

This simulation has been executed with some given parameters and data inspectors chosen to be displayed. Which is possible using a configuration file that contains some parameters used in the model and their value. The advantage of using MAX under these conditions is the ability to configure the simulation with the desired values and to be able to adjust them according to the data extracted by the data inspectors activated in the .xml file show below.

.. image:: img/xmlFile.png

1-	The .xml file contains the simulation parameters which can easily be modified.

.. list-table:: MAX Parameters
   :widths: 25 75
   :header-rows: 1

   * - Parameter
     - Description
   * - MAX_CORE_EXPERIMENTER_NAME
     - Defines the name of the experimentation class.
   * - MAX_CORE_EXPORT_PNG
     - Activate / Deactivate the export of results in .png
   * - MAX_CORE_SIMULATION_STEP
     - Defines the simulation step.
   * - MAX_CORE_UI_MODE
     - Defines the display mode (GUI / SERVER).
   * - MAX_MODEL_NETWORK_DELAY
     - Defines the delay for receiving a message.
   * - MAX_MODEL_NETWORK_RELIABILITY
     - Defines the reliability of receiving a message (0-100).
   * - MAX_MODEL_NETWORK_NEIGHBOUR_DISCOVERY_FREQUENCY
     - Defines how often neighbors are discovered.
   * - MAX_CORE_MAX_OUTBOUND_CONNECTIONS
     - Defines the number of outgoing connections of an agent.
   * - MAX_CORE_MAX_INBOUND_CONNECTIONS
     - Defines the number of incoming connections from an agent.
   * - MAX_MODEL_LEDGER_FEE
     - Defines the default cost of a transaction.
   * - MAX_MODEL_LEDGER_MAX_NUMBER_TXS
     - Defines the maximum number of transactions in a block.
   * - MAX_MODEL_LEDGER_REWARD
     - Defines the reward for miners by block.
   * - MAX_CORE_TIMEOUT_TICK
     - Defines the simulation time-out as a function of time.

2-	It also contains the available data inspectors (to activate/deactivate with keywords GUI/OFF)

.. list-table:: MAX Data Inspectors
   :widths: 25 75
   :header-rows: 1

   * - Data inspector
     - Description
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_BCBLOCK_CREATING_ACTIVITY
     - Displays the creation of blocks by miner in BarChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_BCCONFIRMATION_TIME_OF_TXS_PER_BLOCK
     - Displays the confirmation time of transactions by block in BarChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_BCMERIT
     - Displays the merit of an agent (e.g. computing power for Bitcoin) in BarChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_BLOCK_WINDOW
     - Displays the blockchain as a table.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_GENVIRONMENT
     - Displays a network graph showing agents and connections.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCBALANCE
     - Displays the accounts of each agent in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCCONFIRMATION_TIME_OF_TXS
     - Displays transaction confirmation time in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCNUMBER_OF_AGENTS
     - Displays the number of agents in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCSYNCHRONIZATION
     - Displays network synchronization in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCTOTAL_FEE_BY_BLOCK
     - Displays total transaction fees per block in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCTXS_BY_BLOCK
     - Displays the number of transactions per block in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_LCUNCONFIRMED_TXS_BY_TIME
     - Displays the number of unconfirmed transactions over time in LineChart format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_RGCONFIRMED_TX_ACTIVITY_OF_USERS
     - Displays transaction confirmation activity in RasterGram format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_RGCONNECTIVITY
     - Displays the connections (in the active sense in the network) of the agents in RasterGram format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_RGNEIGHBOR
     - Displays the connections (in the sense of connection between 2 users) in RasterGram format.
   * - MAX_MODEL_LEDGER_BLOCKCHAIN_RGBLOCK_CREATING_ACTIVITY
     - Displays the creation of blocks by miner in RasterGram format.


############
Developing an existing MAX model
############

A complete documentation about development under MAX can be found `here <https://cea-licia.gitlab.io/max/max.gitlab.io>`_.
