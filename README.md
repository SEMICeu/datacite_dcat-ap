# datacite_dcat-ap

Use Saxon via command line:

java -jar saxon9he.jar -s:datacite-example-full-v4.1.xml -xsl:transform.xslt -o:datacite-example-full-v4.1.rdf

As the example is about Software only the publisher is converted in a foaf:organization

java -jar saxon9he.jar -s:datacite-example-dataset-v4.1.xml -xsl:transform.xslt -o:datacite-example-dataset-v4.1.rdf

In this case the dataset is converted in a dcat:catalog, dataset and distribution.


The datacite schema and the 2 examples have been downloaded from: https://schema.datacite.org/meta/kernel-4.1/

