Infrastructure provided by Deusto
=================================

Deusto provides the following computation environment:

    * 144 vCPU.
    * 375GB RAM.
    * Storage:

        * SSD: 7.04 TB
        * HDD: 19.8 TB
    * Powered by `Kubernetes <https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/>`_.


Deusto offers three ways to take advantage of its cluster:

    1. Web access to JupyterLab.
    2. Usage of applications deployed by Deusto.
    3. DIY and deploy your own Kubernetes deployments.

Next, those different access methods are explained.

JupyterLab
----------

Deusto offers a JupyterHub instance in which each participant could have its own isolated `JupyterLab <https://jupyter.org/>`_ 
experimentation environment. JupyterLab is a web-based environment in which different Python libraries for Data Analytics
and Machine Learning are pre-installed. In Deusto's instance, the user can choose among the following distributions:

    * **jupyter/datascience-notebook**: Python 3 and everything in *jupyter/r-notebook* + dask, pandas, numexpr, 
      matplotlib, scipy, seaborn, 
      scikit-learn, scikit-image, sympy, cython, patsy, statsmodel, cloudpickle, dill, numba, bokeh, sqlalchemy, hdf5, 
      vincent, beautifulsoup, protobuf, xlrd, bottleneck, and pytables packages.
    * **jupyter/tensorflow-notebook**: Python libraries from *jupyter/datascience-notebook* + tensorflow and keras machine learning libraries.
    * **jupyter/all-spark-notebook**: Python, R, and Scala support for Apache Spark.

All distributions include git, allowing users checking out their own repositories and commiting their work. In addition, 
conda and pip package managers are available. More information about those distributions can be found at 
`https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html <https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html>`_.

Accessing to JupyterLab
+++++++++++++++++++++++

For accesing to JupyterLab, the user should request her credentials opening a ticket at `https://support.reach-incubator.eu <https://support.reach-incubator.eu>`_.

Next the user can access to JupyterLab at `https://jupyter.reach.apps.deustotech.eu <https://jupyter.reach.apps.deustotech.eu>`_. First, user 
must click on *"Sign in with keycloack"* in order to access to the platform.

.. image:: img/jupyter_login.png

Next, the user is redirected to the authentication interface. Here, she must introduce her credentials.

.. image:: img/keycloack.png

Once authenticated, user could select the desired distribution.

.. image:: img/jupyter_distro.png

The following image depicts the main screen of the JupyterLab environment. From here, diferent notebooks can be created, even a web-based CLI for interacting
with the environment. At the right part, the file browser is displayed. Files created at the JupyterLab environment persist over different runs of the environment,
however, we recommend to use git to save changes on your developments.

.. image:: img/jupyter_notebook.png

If you want to launch a different JupyterLab distribution you should recreate your instance. To do that, you must click on "File" and next on 
"Hub Control Panel".

.. image:: img/jupyter_hub_management.png

From here, you can manage your JupyterLab instance. Click on "Stop My Server" to stop your instance. When the instance is stopped (the stop button disappears),
click on "My Server" to recreate your instance with the selected ditribution.

.. image:: img/jupyter_stop_server.png

Applications deployed by Deusto
-------------------------------

The cluster offered by Deusto can host a wide variety of applications. There are two main sources in where you can check for applications and frameworks
which can be deployed at the cluster:

* `ArtifactHub.io <https://artifacthub.io/>`_.
* `Docker Hub <https://hub.docker.com/>`_.

Next, different applications related to Data Analytics and Machine Learning are listed:

* `Spark <https://artifacthub.io/packages/helm/bitnami/spark>`_
* `Kafka <https://artifacthub.io/packages/helm/bitnami/kafka>`_
* `Airflow <https://artifacthub.io/packages/helm/bitnami/airflow>`_
* `NiFi <https://artifacthub.io/packages/helm/cetic/nifi>`_
* `PyTorch <https://artifacthub.io/packages/helm/bitnami/pytorch>`_
* `Tensorflow <https://hub.docker.com/r/tensorflow/tensorflow>`_
* `Dagster <https://artifacthub.io/packages/helm/dagster/dagster>`_
* `Dask <https://artifacthub.io/packages/helm/dask/dask>`_
* `PostgreSQL <https://artifacthub.io/packages/helm/bitnami/postgresql>`_
* `MySQL <https://artifacthub.io/packages/helm/bitnami/mysql>`_
* `MongoDB <https://artifacthub.io/packages/helm/bitnami/mongodb>`_
* `Cassandra <https://artifacthub.io/packages/helm/bitnami/cassandra>`_
* `Neo4J <https://artifacthub.io/packages/helm/psu-swe/neo4j>`_
* `InfluxDB <https://artifacthub.io/packages/helm/bitnami/influxdb>`_
* `CouchDB <https://artifacthub.io/packages/helm/couchdb/couchdb>`_
* `Elasticsearch <https://artifacthub.io/packages/helm/bitnami/elasticsearch>`_
* `Solr <https://artifacthub.io/packages/helm/bitnami/solr>`_
* `Grafana <https://artifacthub.io/packages/helm/bitnami/grafana>`_
* `Kibana <https://artifacthub.io/packages/helm/bitnami/kibana>`_

If you want to use one of those applications or others hosted at ArtifactHub.io <https://artifacthub.io/>`_ or `Docker Hub <https://hub.docker.com/>`_,
you must open a ticket at `https://support.reach-incubator.eu <https://support.reach-incubator.eu>`_. If you want to deploy an application or
framework not included at these sources, you could open a ticket requesting our support as well.