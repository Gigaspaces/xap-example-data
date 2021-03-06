===============================
=== OpenSpaces Data Example ===
===============================

 Tutorial
------------
This example is described in details in the following wiki tutorial page:
http://docs.gigaspaces.com/sbp/the-openspaces-data-example.html

1. MOTIVATION

The data example is an abstract example showing off most of OpenSpaces features, namely:

- The definition of two processing units, a processor and a feeder, sharing the same domain model.
- Definition of a Space within the processing unit, with different schemas and SLA.
- Show cases for OpenSpaces Events module, including the polling container and notify container.
- Usage of OpenSpaces Remoting.
- Usage of GigaSpaces local view within a the processing unit.
- Usage of GigaSpaces JMS in OpenSpaces
- Usage of the MessageConverter JMS feature that allows writing POJOs to the space by using the JMS API.

2. STRUCTURE

The example has three modules:

	a. The Common module includes the domain model and a data processor interface that are shared between
	    the feeder and the processor modules.
	b. The Processor module is a processing unit with the main task of processing unprocessed data objects.
	    The processing of data objects is done both using event container and remoting.
	c. The Feeder module is a processing unit that contains two feeders, a standard space feeder and a
	    JMS feeder, that feeds unprocessed data objects which are in turn processed by the processor module.
	    The standard space feeder feeds unprocessed data objects both by directly writing them to the space
	    and by using OpenSpaces Remoting. The JMS feeder uses JMS API to feed unprocessed data objects. It
	    does so by using a MessageConverter that converts JMS ObjectMessages to the data objects.
	    
3. BUILD AND DEPLOYMENT

The example uses maven as its build tool. It comes with
a build script that runs maven automatically. Running the build script with no parameters within
the current directory will list all the relevant tasks that can be run with this example.

Running 'build.(sh/bat) compile' will compile all the different modules. In case of the Processor
and Feeder modules, it will compile the classes directly into their respective PU structure.

Running 'build.(sh/bat) package' will finalize the processing unit structure of both the Processor
and the Feeder by copying the Common module jar file into the 'lib' directory within the 
processing unit structure. In case of the processor module, it will copy the jar file to
'processor/target/org.openspaces.example.data-processor/lib', and will make 'processor/target/data-processor' a ready
to use processing unit.

Running 'build.(sh/bat) intellij' will create run configuration for IntelliJ IDE, allowing you to run the
Processor and the Feeder using IntelliJ run (or degub) targets.

In order to deploy the data example onto the Service Grid, simply run gigaspaces agent (gs-agent.sh/bat) which will start
 a GSM and *two* GSCs will need to be started (note, we need two GSCs because of the SLA defined 
within the processor module). Next, 'build.(sh/bat) deploy' will need to be executed. The task
will deploy the processor.jar and the feeder.jar into the running GSM, 
This will cause the feeder to be deployed into one of the GSC and start feeding unprocessed data into
the two processing units.
Run the GS-UI in order to see the 4 PU instances deployed (two partitions, each with one backup).

Running 'build.(sh/bat) undeploy' will remove all of the processing units of this example from the service grid.

Another option to deploy the example can be using the GS CLI using the deploy option. An interesting
example of externally providing the SLA that applies to the deployed processing unit can be running
'gs.(sh/bat) deploy -sla ../examples/data/partitioned-sla.xml ../examples/data/processor/target/data-processor.jar'.
This allows to deploy the processor example using a partitioned space (and not a partitioned-sync2backup)
which is defined in the pu.xml.
In order to run the feeder using the GS CLI please execute 'gs.(sh/bat) deploy ../examples/data/feeder/target/data-feeder.jar'.

Some ways to play with the examples can be:

1. Start another GSC and relocate (click and drag on GS-UI) the feeder to the other GSC. This will
simplify the output since on the GSC that used to run both a processor and a feeder, you will only
have the processor now. And on the new GSC, you will see the feeder.
2. Kill one of the GSC that runs the Processor processing unit. Thanks to the SLA, each partition (primary and backup)
of an instance will run on a different GSC. This means that the feeder should keep on running,
and the active GSC should have its backup partition space turn into
a primary one. While this is happening, the two other instances of the processor PU will get relocated
to the GSC that is running the Feeder PU.


