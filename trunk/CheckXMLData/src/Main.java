import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;


public class Main 
{

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		String line;
		int n=0;
		
		
		if(args.length < 6)
		{
			System.out.println("Please, set the input and output csv file paths (input, facilityCount, PollutantRelease, PollutantTransfer, WasteTransfer, Errors)");
			return;
		}

		try
		{
			BufferedReader csv = new BufferedReader(new FileReader(args[0]));
			PrintStream facilityCounts = new PrintStream(new FileOutputStream(args[1]));
			PrintStream polRelease = new PrintStream(new FileOutputStream(args[2]));
			PrintStream polTransfer = new PrintStream(new FileOutputStream(args[3]));
			PrintStream wasteTransfer = new PrintStream(new FileOutputStream(args[4]));
			PrintStream errors = new PrintStream(new FileOutputStream(args[5]));
			
			facilityCounts.print("ID,Country,Year,Num\n");	
			polRelease.print("ID,Country,Year,MediumcCode,PollutantCode,Sum\n");	
			polTransfer.print("ID,Country,Year,PollutantCode,Sum\n");	
			wasteTransfer.print("ID,Country,Year,WasteTypeCode,Sum\n");
			errors.print("ID;Year;Country;url\n");
			
			//Headers
			line = csv.readLine();
			
			while((line = csv.readLine()) != null)
			{
				String[] parts = line.split(";");
				FacilityReport facilityReport = new FacilityReport(Integer.parseInt(parts[0]),parts[2],Integer.parseInt(parts[1]),parts[3]);
				
				//System.out.println(facilityReport.countFacilityReports());
				String results = facilityReport.executeXQuery();
				if(results == null)
				{
					errors.print(facilityReport+"\n");
					System.out.println("Error in row "+ n + " -> " + facilityReport);
				}
				else
				{
				
					String[] resultParts = results.split("######");
					
					if(resultParts.length < 4)
					{
						System.out.println("XML not correctly parsed in row "+ n + " -> " + facilityReport);
						errors.print(facilityReport+"\n");
					}
					else
					{
					
						facilityCounts.print(resultParts[0].replaceAll("\\s+","")+"\n");	
						polRelease.print(resultParts[1].trim().replaceAll("\n ","\n")+"\n");	
						polTransfer.print(resultParts[2].trim().replaceAll("\n ","\n")+"\n");	
						wasteTransfer.print(resultParts[3].trim().replaceAll("\n ","\n")+"\n");	
					}
				}
				n++;
				System.out.println("Processed "+n+" files ");
			}
			
			facilityCounts.close();
			polRelease.close();
			polTransfer.close();
			wasteTransfer.close();
			
			csv.close();
		}
		catch(IOException e)
		{
			System.out.println("Impossible to read "+args[0]+" "+e.getMessage()+"\n");
			e.printStackTrace();
		}

	}

}
