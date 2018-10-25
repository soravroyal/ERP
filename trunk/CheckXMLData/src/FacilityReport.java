import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Properties;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;

import net.sf.saxon.Configuration;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.query.DynamicQueryContext;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.StringValue;


public class FacilityReport 
{
	int id;
	String country;
	int year;
	String url;
	
	public FacilityReport(int id, String country, int year, String url) 
	{
		this.url = url;
		this.country = country;
		this.year = year;
		this.id = id;
		
		checkURL();
	}
	
	public String toString() 
	{
		return id+";"+year+";"+country+";"+url;
	}
	
	private void checkURL()
	{
		String line;
		
		//url = "http://cdr.eionet.europa.eu/cy/eu/eprtrdat/envvvjs4a";
		//url = "http://cdr.eionet.europa.eu/at/eu/eprtrdat/envwnubhw";
		
		//Is an envelope
		if(!url.endsWith(".xml"))
		{
			try 
			{
		        URL envelopeURL = new URL(url+"/xml");
		        InputStream is = envelopeURL.openStream();  // throws an IOException
		        BufferedReader br = new BufferedReader(new InputStreamReader(is));

		        while ((line = br.readLine()) != null) 
		        {
	        		if(line.contains("<file name=\""))
		        	{
			        	String[] fileArray = line.split("<file name=\"");
			        	for(int i=1;i<fileArray.length;i++)
			        	{
			        		String name = fileArray[i].split("\"")[0];
				            if(name.contains(".xml"))
				            {
				            	url = url + "/" + name;
				            }
			        	}
		        	}
		        }
		        
		        br.close();
		        is.close();
		    } 
			catch (MalformedURLException mue) 
			{
		         mue.printStackTrace();
		    } 
			catch (IOException ioe) 
			{
		         ioe.printStackTrace();
		    } 
		}
	}

	public String executeXQuery()
	{
		if(!url.endsWith(".xml"))
			return null;
		
		InputStream queryStream = null;
		XQueryExpression exp = null;
		OutputStream destStream = null;
		StreamResult destResult = null;
		String output = "";
		
		//XQuery configuration object and contexts
		Configuration config = new Configuration();
		StaticQueryContext sqc = config.newStaticQueryContext();
		DynamicQueryContext dqc = new DynamicQueryContext(config);
		
		//Prepare output stream
		destStream = new ByteArrayOutputStream();
		destResult = new StreamResult(destStream);

		//Read the xquery file
		try
		{
			queryStream = new FileInputStream("./src/ReadData.xquery");
		}
		catch(FileNotFoundException ex)
		{
			System.out.println("File not found: "+ex.getMessage());
			return null;
		}
		
		//Compile the xquery
		try
		{
			exp = sqc.compileQuery(queryStream, null);
		}
		catch(IOException ex)
		{
			System.out.println("Can't open XQUERY expression: "+ex.getMessage());
			return null;
		}
		catch(XPathException ex)
		{
			System.out.println("Can't compile XQUERY expression: "+ex.getMessage());
			return null;
		}
		
		//Prepare input file
		Properties props = new Properties();
		props.setProperty(OutputKeys.METHOD, "html");
		props.setProperty(OutputKeys.INDENT, "yes");
		
		dqc.setParameter(new StructuredQName("", "", "source_url"), new StringValue(url));
		dqc.setParameter(new StructuredQName("", "", "id"), new StringValue(id+""));
		dqc.setParameter(new StructuredQName("", "", "country"), new StringValue(country));
		dqc.setParameter(new StructuredQName("", "", "year"), new StringValue(year+""));
		
		//Run xquery
		try 
		{
			exp.run(dqc, destResult, props);
			output = new String( ((ByteArrayOutputStream)destStream).toByteArray());
		} 
		catch (XPathException ex) 
		{
			System.out.println("Failed to run XQuery: "+ex.getMessage());
			return null;
		}
		
		return output;
	}
}
