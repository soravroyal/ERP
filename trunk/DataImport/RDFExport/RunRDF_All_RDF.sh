
echo Starting RDF files generation
rm -rf RDFfiles
mkdir RDFfiles

CMD="java -jar rdf-exporter-1.3-SNAPSHOT-jar-with-dependencies.jar"
OPTS="-d database.properties -f rdfexport.properties -z"
SUFFIX="rdf.gz"
CFLAG=""
#SUFFIX="rdf"
LOOKUPS="annexIActivity areaGroup confidentiality coordinateSystem country
medium method methodType methodBasis
nACEActivity nUTSRegion
pollutant pollutantthreshold
riverBasinDistrict status unit
wasteTreatment wastethreshold wasteType"
#LOOKUPS="contry medium pollutant pollutantthreshold wastethreshold wastetype unit method methodtype rbd"

echo generating lookuptables.$SUFFIX ...
$CMD $LOOKUPS $OPTS -o ./RDFfiles/lookuptables.$SUFFIX
echo generating facility.$SUFFIX ...
$CMD facility $OPTS -o ./RDFfiles/Facility.$SUFFIX
echo generating facilityreport.$SUFFIX ...
$CMD facilityReport $OPTS -o ./RDFfiles/FacilityReport.$SUFFIX
#echo generating nationalreport.$SUFFIX ...
#$CMD nationalreport $OPTS -o ./RDFfiles/NationalReport.$SUFFIX
echo generating pollutantRelease.$SUFFIX ...
$CMD pollutantRelease $OPTS -o ./RDFfiles/PollutantRelease.$SUFFIX
echo generating pollutantTransfer.$SUFFIX ...
$CMD pollutantTransfer $OPTS -o ./RDFfiles/PollutantTransfer.$SUFFIX
echo generating wasteTransfer.$SUFFIX ...
$CMD wasteTransfer $OPTS -o ./RDFfiles/WasteTransfer.$SUFFIX
echo generating Activity.$SUFFIX ...
$CMD activity $OPTS -o ./RDFfiles/Activity.$SUFFIX
echo generating competentAuthority.$SUFFIX ...
$CMD competentAuthority  $OPTS -o ./RDFfiles/CompetentAuthority.$SUFFIX
echo generating FacilityID_Changes.$SUFFIX ...
$CMD facilityID_Changes $OPTS -o ./RDFfiles/FacilityID_Changes.$SUFFIX
echo generating PollutantReleaseMethodUsed.$SUFFIX ...
$CMD pollutantReleaseMethodUsed $OPTS -o ./RDFfiles/PollutantReleaseMethodUsed.$SUFFIX
echo generating PollutantTransferMethodUsed.$SUFFIX ...
$CMD pollutantTransferMethodUsed $OPTS -o ./RDFfiles/PollutantTransferMethodUsed.$SUFFIX
echo generating UploadedReports.$SUFFIX ...
$CMD uploadedReports $OPTS -o ./RDFfiles/UploadedReports.$SUFFIX
echo generating WasteTransferMethodUsed.$SUFFIX ...
$CMD wasteTransferMethodUsed $OPTS -o ./RDFfiles/WasteTransferMethodUsed.$SUFFIX

