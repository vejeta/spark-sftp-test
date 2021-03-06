#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export SPARK_DIST_CLASSPATH=$(/home/mendezr/development/hadoop-2.9.2/bin/hadoop classpath)
export HADOOP_HOME=$HOME/development/hadoop-2.9.2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native

#This configuration is for a cluster with 1 master and 2 workers with 4 cores each.
# spark.master=yarn #This option is not needed, is the default mode of operation for submitted jobs in data proc
# spark.submit.deployMode=client # Another mode of operation.
# spark.scheduler.mode=FAIR # Mode not currently sopported, policy not configured in the cluster
# spark.dynamicAllocation.minExecutors=4 #This option did not work with spark.dynamicAllocation.enabled=true

DYNAMIC_ALLOCATION=''

if [ "$1" = "disableDynamicAllocation" ]
then
  DYNAMIC_ALLOCATION='spark.executor.instances=4,spark.deploy.mode=cluster,spark.dynamicAllocation.enabled=false'
fi

gcloud dataproc jobs submit spark --cluster superclusterhive --region europe-west1 --class org.fortysevendeg.sparksftp.ReadingSFTPHadoopApp --properties 'spark.executor.extraJavaOptions=-verbose:class,spark.executorEnv.SFTP_USER=webdev01,spark.executorEnv.SFTP_PASS=sftptest1,spark.executorEnv.SFTP_HOST=104.199.85.170,spark.executorEnv.SFTP_USERS_PATH=/home/webdev01/sample.psv,spark.executorEnv.SFTP_SALARIES_PATH=/home/webdev01/salaries.psv,'$DYNAMIC_ALLOCATION --jars gs://dataproc-419763b0-894e-4402-8a6d-ed84cf766202-europe-west1/sparksftpTest-assembly-0.0.1.jar,gs://dataproc-419763b0-894e-4402-8a6d-ed84cf766202-europe-west1/sparksftpTest-assembly-0.0.1-deps.jar