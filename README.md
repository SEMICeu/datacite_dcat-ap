# datacite_dcat-ap

Use Saxon via command line:

java -jar saxon9he.jar -s:datacite-example-full-v4.1.xml -xsl:transform.xslt -o:atacite-example-full-v4.1.rdf

As the example is about Software only the publisher is converted in a foaf:organization

java -jar saxon9he.jar -s:datacite-example-dataset-v4.1.xml -xsl:transform.xslt -o:atacite-example-dataset-v4.1.rdf

In this case the dataset is converted in a dcat:catalog, dataset and distribution.