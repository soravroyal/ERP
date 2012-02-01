using System;
using System.ServiceModel;
using System.ServiceModel.Web;



namespace RestEPRTRService
{
    [ServiceContract]
    public interface IRestEPRTRService
    {
         
        [OperationContract]
        [WebGet(UriTemplate = "Facility?Year={Year}&NationalID={NationalID}&countryCode={countryCode}", RequestFormat = WebMessageFormat.Xml, BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        String AddDato(String Year, String NationalID, String countryCode);

        [OperationContract]
        [WebGet(UriTemplate = "Coordinates?LonCoor={LonCoor}&LatCoor={LatCoor}", RequestFormat = WebMessageFormat.Xml)]
        String ConnetcGis(string LonCoor, string LatCoor);


    }

    
}
