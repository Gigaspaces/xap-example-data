#!/bin/bash

DIR_NAME=$(dirname ${BASH_SOURCE[0]})
. $DIR_NAME/../../bin/setenv.sh

if [ "${M2_HOME}" = "" ] ; then
    M2_HOME="${XAP_HOME}/tools/maven/apache-maven-3.0.2"; export M2_HOME #needed to upgraded to 3.2.5
fi

if [ $1 = "clean" ]; then
  (cd $DIR_NAME;
  ${M2_HOME}/bin/mvn clean;
  rm -rf $DIR_NAME/dist; )

elif [ $1 = "compile" ]; then
  (cd $DIR_NAME;
  ${M2_HOME}/bin/mvn compile; )

elif [ $1 = "package" ]; then
  (cd $DIR_NAME;
  ${M2_HOME}/bin/mvn package; )

elif [ $1 = "deploy" ]; then
  ${XAP_HOME}/bin/gs.sh deploy ${DIR_NAME}/processor/target/data-processor.jar
  ${XAP_HOME}/bin/gs.sh deploy ${DIR_NAME}/feeder/target/data-feeder.jar

elif [ $1 = "undeploy" ]; then
  ${XAP_HOME}/bin/gs.sh undeploy data-feeder
  ${XAP_HOME}/bin/gs.sh undeploy data-processor

elif [ $1 = "intellij" ]; then
  cp -r $DIR_NAME/runConfigurations $DIR_NAME/.idea
  echo "Run configurations for IntelliJ IDE created successfully"

else
  echo ""
  echo "Error: Invalid input command: $1 "
  echo ""
  echo "The available commands are:"
  echo ""
  echo "clean                    --> Cleans all output dirs"
  echo "compile                  --> Builds all; don't create JARs"
  echo "package                  --> Builds the distribution"
  echo "deploy                   --> Deploys the processor and the feeder onto the service grid"
  echo "undeploy                 --> Undeploys running processing units"
  echo "intellij                 --> Creates run configuration for IntelliJ IDE"
  echo ""
fi