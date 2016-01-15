package test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;

import net.sf.saxon.Configuration;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.query.DynamicQueryContext;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.value.StringValue;

public class RunXquery {

	private static final String outputPath = "XQuery/output/out.htm";

	public static void main(String[] args) {

		try {

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

			queryStream = new FileInputStream(
					"XQuery/mandatory.xquery");
			exp = sqc.compileQuery(queryStream, null);

			File file = new File("XQuery/resources/test.xml");

			dqc.setParameter(new StructuredQName("", "", "source_url"),
					new StringValue(file.getAbsolutePath().replace("\\", "/")));

			// print the result to a file
			destStream = new FileOutputStream(outputPath);
			destResult = new StreamResult(destStream);

			/**
			 * RUN Xquery
			 */
			exp.run(dqc, destResult, props);
			destStream.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
