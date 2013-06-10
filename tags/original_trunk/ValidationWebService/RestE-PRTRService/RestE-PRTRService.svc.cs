using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.IO;
using QueryLayer;
using QueryLayer.Utilities;
using System.Web;
using System.Net;
using System.Text;
using System.Configuration;




namespace RestEPRTRService
{
     
    public class RestService : IRestEPRTRService
    {

        
        public String AddDato(String datYear, String datNationalID, String datCountryCode)
        {


            String varXquery = "";

            try {

 
                byte[] data = FromHex(datNationalID);
                String varNationalID = Encoding.UTF8.GetString(data).Trim();

    

                if (datYear != "" && varNationalID != "" && datCountryCode != "" && datYear != null && varNationalID != null && datCountryCode != null)
                {
                    int intYear = int.Parse(datYear);
                   
                    //get facilityID
                    IEnumerable<VALIDATION_FACILITY> Facilities = Facility.GetFacilityID(varNationalID, intYear, datCountryCode);
               
                    if (Facilities.Count() == 0)
                    {
                        //ERROR 1 and ERROR 5, the messages are in the xquery
                        varXquery = "1,True";
                        
                    }else{
                       if (Facilities.Count() > 1)
                        {
                           //ERROR 2 
                            varXquery = "2,Multiple facilities has been reported in the past with the previous NationalID in the previous reporting year. The facility cannot be imported.";

                        }else{
                            
                            if (Facilities.Count() == 1)
                            {
                                varXquery = "0,True";
                            }
                        
                        }
                    }
                }
                else
                {
                    varXquery = "0,Not reported one of these elements in the XML: Year, NationalID or CountryCode";
                }


               return varXquery;

            }
            catch (Exception ex)
            {

                return ex.Message;
            }
           

        }

        public static byte[] FromHex(string hex) { hex = hex.Replace("-", ""); byte[] raw = new byte[hex.Length / 2]; for (int i = 0; i < raw.Length; i++) { raw[i] = Convert.ToByte(hex.Substring(i * 2, 2), 16); } return raw; } 
        
       
        public string ConnetcGis(string LonCoor, string LatCoor)
        {

            string datNutCodeEnd = "";
            if ((LonCoor != "" && LatCoor != "") && (LonCoor != null && LatCoor != null))
            {
                String baseUriStart = System.Configuration.ConfigurationManager.AppSettings.Get(0);
  
                baseUriStart = baseUriStart + "&" + System.Configuration.ConfigurationManager.AppSettings.Keys.Get(1);

                baseUriStart = baseUriStart + "=" + LonCoor + "," + LatCoor + "&";

                String baseUriMedium = "";

                String appKey ="";
                String appName = "";

                int ContadorApp = System.Configuration.ConfigurationManager.AppSettings.AllKeys.Count();
                for (int i = 2; i < ContadorApp; i++)
                {
                    appKey = System.Configuration.ConfigurationManager.AppSettings.Get(i);
                    appName = System.Configuration.ConfigurationManager.AppSettings.Keys.Get(i);
                    baseUriMedium = baseUriMedium + "&" + appName + "=" + appKey;

                }

                String baseUri = baseUriStart + baseUriMedium;

                //LonCoor=16.4027431529776&LatCoor=57.0126631873995
                // string valor1 = ConfigurationManager.AppSettings.GetKey(1);
                //String baseUriStart = "http://discomap.eea.europa.eu/ArcGIS/rest/services/Admin/EuroBoundaries_Dyna_WGS84/MapServer/2/query?text=&geometry=";
                //String baseUri = baseUriStart + LonCoor + "," + LatCoor + "&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&where=&returnGeometry=false&outSR=&outFields=NUTS_CODE&f=json";
                HttpWebRequest connection = (HttpWebRequest)HttpWebRequest.Create(baseUri);

                connection.Method = "GET";
                HttpWebResponse response = (HttpWebResponse)connection.GetResponse();

                StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.UTF8);

                String datJSON = sr.ReadLine();

                int intNutcode1 = datJSON.LastIndexOf("attributes");

                if (intNutcode1 != -1)
                {

                    string datNutcodeStart = datJSON.Substring(intNutcode1);

                    int intNutcode2 = datNutcodeStart.LastIndexOf("NUTS_CODE");

                    if (intNutcode2 != -1)
                    {
                        //int longNutCodeStart = 

                        string datNutCodeMedium = datNutcodeStart.Substring(intNutcode2);

                        int longNutCodeStart = 12;

                        int longNutCode = 4;

                        datNutCodeEnd = datNutCodeMedium.Substring(longNutCodeStart, longNutCode);
                        datNutCodeEnd = "1," + datNutCodeEnd;
                    }
                    else
                    {
                        datNutCodeEnd = "0,Error in the JSON string";
                    }

                }
                else
                {
                    datNutCodeEnd = "0,No NUTS code reported";
                }
            }
            else
            {
                datNutCodeEnd = "0,No correct coordinates reported";
            }
           
            return datNutCodeEnd;
        }
        

    }


}

