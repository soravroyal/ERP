package test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;

import net.sf.saxon.Configuration;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.query.DynamicQueryContext;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.value.StringValue;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Test {

    private static final String outputPath = "XQuery/output/out.htm";

    public static void main(String[] args) {

        try {

            long startTime = System.currentTimeMillis();

            // Resources folder
            File resFolder = new File("XQuery/resources/xml");

            InputStream queryStream = null;
            XQueryExpression exp = null;

            // indentation
            Properties props = new Properties();
            props.setProperty(OutputKeys.METHOD, "xml");
            props.setProperty(OutputKeys.INDENT, "yes");

            // create a Configuration object
            Configuration config = new Configuration();

            OutputStream destStream;
            StreamResult destResult;

            // static and dynamic context
            StaticQueryContext sqc = config.newStaticQueryContext();
            DynamicQueryContext dqc = new DynamicQueryContext(config);

            StringBuilder strB = new StringBuilder();
            StringBuilder output = new StringBuilder();

            int total = 0;
            int totalFailed = 0;

            for (File schemaFolder : resFolder.listFiles()) {

                System.out.println("===============");
                System.out.println(schemaFolder.getName());
                System.out.println("===============");

                // Schema directory
                if (schemaFolder.isDirectory()) {

                    if ("LCP".equals(schemaFolder.getName())){
                    // Files
                    for (File file : schemaFolder.listFiles()) {

                        output.setLength(0);
                        output.append(file.getName());

                        // XQUERY
                        strB.setLength(0);
                        strB.append("XQuery/")
                                .append(schemaFolder.getName())
                                .append(".xquery");
                        queryStream = new FileInputStream(strB.toString());
                        exp = sqc.compileQuery(queryStream, null);

                        dqc.setParameter(new StructuredQName("", "",
                                "source_url"), new StringValue(file
                                .getAbsolutePath().replace("\\", "/")));

                        // print the result to a file
                        destStream = new FileOutputStream(outputPath);
                        destResult = new StreamResult(destStream);

                        /**
                         * RUN Xquery
                         */
                        exp.run(dqc, destResult, props);
                        destStream.close();

                        /**
                         * Check Errors
                         */
                        String excelId = "";
                        String ruleId = "";
                        if (!file.getName().contains("COMPLETE")) {
                            Pattern pattern = Pattern.compile("'(.*?)'");
                            Matcher matcher = pattern.matcher(file.getName());
                            while (matcher.find()) {
                                if ("".equals(excelId)) {
                                    excelId = matcher.group(1);
                                } else {
                                    ruleId = matcher.group(1);
                                }
                            }
                        }

                        boolean checked = checkErrors(excelId, ruleId);

                        // counters
                        total++;
                        if (!checked) {
                            totalFailed++;
                        }

                        output.append(" > ").append(checked);

                        System.out.println(output.toString());

                    }
                     } // Schema Folder

                }

            }

            System.out.println("");
            System.out.println("===============");
            System.out.println("SUMMARY");
            System.out.println("===============");
            System.out.println("Total Tests: " + total);
            System.out.println("Failed Tests: " + totalFailed);

            long endTime = System.currentTimeMillis();
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(endTime - startTime);
            System.out.println("");
            System.out.println("Elapsed time: " + cal.get(Calendar.MINUTE)
                    + "m " + cal.get(Calendar.SECOND) + "s");

            ;

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private static boolean checkErrors(String excelId, String ruleId) {

        boolean checked = false;

        if ("".equals(excelId)) {
            excelId = "0";
        }
        if ("".equals(ruleId)) {
            ruleId = "0";
        }

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(false);
        factory.setIgnoringElementContentWhitespace(true);
        try {
            DocumentBuilder builder = factory.newDocumentBuilder();
            File file = new File(outputPath);
            Document doc = builder.parse(file);

            doc.getDocumentElement().normalize();

            NodeList nList = doc.getElementsByTagName("Error");

            // IF no errors IDs are specified, 0 total errors must be found
            if (nList.getLength() == 0 && "0".equals(excelId)
                    && "0".equals(ruleId)) {
                checked = true;
            } else {
                // Loop through <Error> elements.
                int temp = 0;
                while (!checked && temp < nList.getLength()) {

                    Node nNode = nList.item(temp);
                    NamedNodeMap attrs = nNode.getAttributes();

                    // There is an error that matches the IDs provided
                    if (excelId.equals(attrs.getNamedItem("ExcelId")
                            .getNodeValue())
                            && ruleId.equals(attrs.getNamedItem("RuleId")
                                    .getNodeValue())) {
                        checked = true;
                    }

                    temp++;

                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return checked;
    }
}
