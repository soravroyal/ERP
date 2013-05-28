
The RDF export uses a Java product that was developed for other projects.

There will occasionally be updates to the Java product. When this happens,
then the rdf-exporter-1.0-SNAPSHOT.jar will have to be recompiled.

The RDFExport directory links to an external SVN repository as a symbolic link.
To recompile the rdf-exported do:

    cd RDFExport
    mvn -Dmaven.test.skip=true install
    target/rdf-exporter-1.0-SNAPSHOT.jar ..
    cd ..
    svn ci rdf-exporter-1.0-SNAPSHOT.jar

RDFExport is a Maven project, and the website is here: http://maven.apache.org/

