import arcpy
import sys
import os
import os.path 
import zipfile
#import time
import datetime
import shutil
from progress_bar import ProgressBar

# !!!!!!!!!!!!!!!!!!!!!!!!!
# PARAMETERS
# !!!!!!!!!!!!!!!!!!!!!!!!!

# +++++++++++++++++
# PATH
# +++++++++++++++++
#Solution path
solPth = "D:\Projects\EEA\EPRTR\EPRTR KML solution"

# +++++++++++++++++
# INPUT
# +++++++++++++++++
#Input mxd file
mxdIn = solPth + "\EPRTR_facilities_basis_short.mxd"
#Path to the base lyr file
inpPth = solPth + "\EPRTR_style_basic.lyr"
#Path to the style lyr files folder
symPth = solPth + "\Lyr_files"

# +++++++++++++++++
# OUTPUT
# +++++++++++++++++
#Production output kmz file
kmzOut = solPth + "\EPRTR_facilities.kmz"

#Versioned output mxd file
mxdOut = solPth + "\EPRTR_Filled_" + str(datetime.datetime.now())[:10] + ".mxd"
#print 'mxd: ', mxdOut 
#Temp output kmz file
kmzOut2 = solPth + "\EPRTR_facilities_temp.kmz"
#Versioned output kmz file
kmzOut3 = solPth + "\EPRTR_facilities_" + str(datetime.datetime.now())[:10] + ".kmz"

#Querystring 
qString = " AND \"FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE.IAActivityCode\" = "

# +++++++++++++++++
# REST IS CODE - DON'T MESS
# +++++++++++++++++

print ''
print datetime.datetime.now(), ' - Reading settings .... '

prgb = ProgressBar(45)
prgb.fill_char = '='
prgbc = 0    

mxd = arcpy.mapping.MapDocument(mxdIn)
df = arcpy.mapping.ListDataFrames(mxd)[0]

#Function : AddLayer (inputlayer path, symbollayer path, querystring value, the new layername, group layer in which the layer ia added, dataframe)
def add_layer(inputLayer, symbolLayer, queryStr, layerName, _targetGroupLayer, _df):
	addLayer = arcpy.mapping.Layer(inputLayer)
	if addLayer.supports("DEFINITIONQUERY"):
		addLayer.definitionQuery = addLayer.definitionQuery + qString + queryStr
		addLayer.name = layerName
	symLayer = arcpy.mapping.Layer(symbolLayer)
	arcpy.mapping.UpdateLayer(_df, addLayer, symLayer, True)
	if _targetGroupLayer.isGroupLayer:
		arcpy.mapping.AddLayerToGroup(_df, _targetGroupLayer, addLayer, "BOTTOM")
	del addLayer, symbolLayer

#loop to add all the layers	
#Energy Sector
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "1 Energy sector", df)[0]

print ''
print datetime.datetime.now(), ' - Adding layers'		

#prgbc += 1
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol0.lyr","'1.(a)'","1.(a) Mineral oil and gas refineries",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol1.lyr","'1.(b)'","1.(b) Gasification and liquefaction",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol2.lyr","'1.(c)'","1.(c) Thermal power stations and other combustion installations",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol3.lyr","'1.(d)'","1.(d) Coke ovens",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol4.lyr","'1.(e)'","1.(e) Coal rolling mills",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol5.lyr","'1.(f)'","1.(f) Manufacture of coal products and solid smokeless fuel",targetGroupLayer, df)
   
#Productiona and processing of metals
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "2 Production and processing of metals", df)[0]
prgbc += 6
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol6.lyr","'2.(a)'","2.(a) Metal ore (including sulphide ore) roasting or sintering installations",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol7.lyr","'2.(b)'","2.(b) Production of pig iron or steel including continuous casting",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol8.lyr","'2.(c)'","2.(c) Processing of ferrous metals",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol9.lyr","'2.(d)'","2.(d) Ferrous metal foundries",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol10.lyr","'2.(e)'","2.(e) Production of non-ferrous crude metals from ore, concentrates or secondary raw materials",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol11.lyr","'2.(f)'","2.(f) Surface treatment of metals and plastics using electrolytic or chemical processes",targetGroupLayer, df)

#Mineral industry
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "3 Mineral industry", df)[0]
prgbc += 6
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol12.lyr","'3.(a)'","3.(a) Underground mining and related operations",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol13.lyr","'3.(b)'","3.(b) Opencast mining and quarrying",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol14.lyr","'3.(c)'","3.(c) Production of cement clinker or lime in rotary kilns or other furnaces",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol15.lyr","'3.(d)'","3.(d) Production of asbestos and the manufacture of asbestos based products",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol16.lyr","'3.(e)'","3.(e) Manufacture of glass, including glass fibre",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol17.lyr","'3.(f)'","3.(f) Melting mineral substances, including the production of mineral fibres",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol18.lyr","'3.(g)'","3.(g) Manufacture of ceramic products including tiles, bricks, stoneware or porcelain",targetGroupLayer, df)

#Chemical industry
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "4 Chemical industry", df)[0]
prgbc += 7
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol19.lyr","'4.(a)'","4.(a) Industrial scale production of basic organic chemicals",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol20.lyr","'4.(b)'","4.(b) Industrial scale production of basic inorganic chemicals",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol21.lyr","'4.(c)'","4.(c) Industrial scale production of phosphorous, nitrogen or potassium based fertilizers",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol22.lyr","'4.(d)'","4.(d) Industrial scale production of basic plant health products and of biocides",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol23.lyr","'4.(e)'","4.(e) Industrial scale production of basic pharmaceutical products",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol24.lyr","'4.(f)'","4.(f) Industrial scale production of explosives and pyrotechnic products",targetGroupLayer, df)

   #Waste and waste water management
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "5 Waste and waste water management", df)[0]
prgbc += 6
prgb.update_time(prgbc)
print prgb
add_layer(inpPth,symPth + "\EPER_symbol25.lyr","'5.(a)'","5.(a) Disposal or recovery of hazardous waste",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol26.lyr","'5.(b)'","5.(b) Incineration of non-hazardous waste included in Directive 2000/76/EC - waste incineration",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol27.lyr","'5.(c)'","5.(c) Disposal of non-hazardous waste",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol28.lyr","'5.(d)'","5.(d) Landfills (excluding landfills closed before the 16.7.2001)",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol29.lyr","'5.(e)'","5.(e) Disposal or recycling of animal carcasses and animal waste",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol30.lyr","'5.(f)'","5.(f) Urban waste-water treatment plants",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol31.lyr","'5.(g)'","5.(g) Independently operated industrial waste-water treatment plants serving a listed activity",targetGroupLayer, df)
 
   #Paper and wood production processing
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "6 Paper and wood production processing", df)[0]
prgbc += 7
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol32.lyr","'6.(a)'","6.(a) Production of pulp from timber or similar fibrous materials",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol33.lyr","'6.(b)'","6.(b) Production of paper and board and other primary wood products",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol34.lyr","'6.(c)'","6.(c) Preservation of wood and wood products with chemicals",targetGroupLayer, df)
 
#Intensive livestock production and aquaculture
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "7 Intensive livestock production and aquaculture", df)[0]
prgbc += 3
prgb.update_time(prgbc)
print prgb
add_layer(inpPth,symPth + "\EPER_symbol35.lyr","'7.(a)'","7.(a) Intensive rearing of poultry or pigs",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol36.lyr","'7.(b)'","7.(b) Intensive aquaculture",targetGroupLayer, df)
   
#Animal and vegetable products from the food and beverage sector
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "8 Animal and vegetable products from the food and beverage sector", df)[0]
prgbc += 2
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol37.lyr","'8.(a)'","8.(a) Slaughterhouses",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol38.lyr","'8.(b)'","8.(b) Treatment and processing of animal and vegetable materials in food and drink production",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol39.lyr","'8.(c)'","8.(c) Treatment and processing of milk",targetGroupLayer, df)
   
 #Other activities
targetGroupLayer = arcpy.mapping.ListLayers(mxd, "9 Other activities", df)[0]
prgbc += 3
prgb.update_time(prgbc)
print prgb

add_layer(inpPth,symPth + "\EPER_symbol40.lyr","'9.(a)'","9.(a) Pretreatment or dyeing of fibres or textiles",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol41.lyr","'9.(b)'","9.(b) Tanning of hides and skins",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol42.lyr","'9.(c)'","9.(c) Surface treatment of substances, objects or products using organic solvents",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol43.lyr","'9.(d)'","9.(d) Production of carbon or electro-graphite through incineration or graphitization",targetGroupLayer, df)
add_layer(inpPth,symPth + "\EPER_symbol44.lyr","'9.(e)'","9.(e) Building of, painting or removal of paint from ships",targetGroupLayer, df)
prgbc += 5
prgb.update_time(prgbc)
print prgb

print 'Updating layers'
for lyr in arcpy.mapping.ListLayers(mxd):
    if lyr.isGroupLayer:
        lyr.visible = True
		
arcpy.RefreshActiveView()
arcpy.RefreshTOC()

if os.path.exists(mxdOut): 
	os.remove(mxdOut)

if os.path.exists(kmzOut2): 
	os.remove(kmzOut2)

print 'Saving new mxd'

#mxd.saveACopy(r"C:\Project\Project2.mxd")
mxd.saveACopy(mxdOut)
print '  '
print datetime.datetime.now(),' ---- CREATING KMZ FILE ---- '
print '  '
print 'Parameters: ',mxdOut, " ", df.name, " ", kmzOut2, " 1"
print 'Wait ....!'
#Export to kml
arcpy.MapToKML_conversion(mxdOut, df.name, kmzOut2, "1")

print datetime.datetime.now(), ' - Kml done!'
#>>n = datetime.datetime.now()
#time.sleep(30)
#print 'Done'
del mxd, df, targetGroupLayer

# zip_susser_v2.py
print '  '
print datetime.datetime.now(),' ---- VALIDATING KMZ FILE ---- '
print '  '

grimoire = [
	("FileHeader","PK\003\004"),
	("DataDescriptor","PK\x07\x08"),
	("CentralDir","PK\001\002"),
	("EndArchive","PK\005\006"),
	("EndArchive64","PK\x06\x06"),
	("EndArchive64Locator","PK\x06\x07"),
	("ArchiveExtraData","PK\x06\x08"),
	("DigitalSignature","PK\x05\x05"),]

f = open(kmzOut2, 'rb')
buff = f.read()
f.close()
blen = len(buff)
print "archive size is", blen
for magic_name, magic in grimoire:
    pos = 0
    while pos < blen:
        pos = buff.find(magic, pos)
        if pos < 0:
            break
        print "%s at %d" % (magic_name, pos)
        pos += 4
#
# find what is in the EndArchive struct
#
structEndArchive = "<4s4H2LH"     # 9 [sic] items, end of archive, 22
bytes
import struct
posEndArchive = buff.find("PK\005\006")
print "using posEndArchive =", posEndArchive
assert 0 < posEndArchive < blen
endArchive = struct.unpack(structEndArchive, buff
[posEndArchive:posEndArchive+22])
print "endArchive:", repr(endArchive)
endArchiveFieldNames = """
    signature
    this_disk_num
    central_dir_disk_num
    central_dir_this_disk_num_entries
    central_dir_overall_num_entries
    central_dir_size
    central_dir_offset
    comment_size
    """.split()
for name, value in zip(endArchiveFieldNames, endArchive):
    print "%33s : %r" % (name, value)
#
# inspect the comment
#
actual_comment_size = blen - 22 - posEndArchive
expected_comment_size = endArchive[7]
comment = buff[posEndArchive + 22:]
print
print "expected_comment_size:", expected_comment_size
print "actual_comment_size:", actual_comment_size
print "comment is all spaces:", comment == ' ' * actual_comment_size
print "comment is all '\\0':", comment == '\0' * actual_comment_size
print "comment (first 100 bytes):", repr(comment[:100])

print '  '
print datetime.datetime.now(),' ---- COPY KMZ FILE TO REPLACE AND ADD NEW IMAGES ---- '
print '  '

def add2zip(_file, _zip):
#	_file = _file.encode('ascii') #convert path to ascii for ZipFile Method
	if os.path.isfile(_file):
		(filepath, filename) = os.path.split(_file)
		_zip.write(_file, filename, zipfile.ZIP_DEFLATED )

def getzip(filename, ignoreable=100): 
	try: 
		return zipfile.ZipFile(filename) 
	except zipfile.BadZipfile: 
		original = open(filename, 'rb') 
		try: 
			data = original.read() 
		finally: 
			original.close() 
		position = data.rindex(zipfile.stringEndArchive, -(22 + ignoreable), -20) 
		coredata = cStringIO.StringIO(data[: 22 + position]) 
		return zipfile.ZipFile(coredata) 

print ' -- Reads file -- '
zin = getzip(kmzOut2)
zout = zipfile.ZipFile (kmzOut3, 'w')

print ' - kmz includes following files'
	
for item in zin.infolist():
	buffer = zin.read(item.filename)
	print item.filename
	if (item.filename != 'legend0.png'):
		zout.writestr(item, buffer)
	else:
		add2zip(solPth + '\legend0.png', zout)
		add2zip(solPth + '\eprtr_foot.png', zout)
		add2zip(solPth + '\eprtr_head.png', zout)

zout.close()
zin.close()
print datetime.datetime.now(),'Writing new kmz succeded!'

# clean up
if os.path.exists(kmzOut2): 
	os.remove(kmzOut2)

print '  '
print datetime.datetime.now(),' ---- CREATE PRODUCTION COPY OF KMZ FILE ---- '
print '  '

# clean up
if os.path.exists(kmzOut): 
	os.remove(kmzOut)

shutil.copy2(kmzOut3, kmzOut)

if os.path.isfile (kmzOut): print "Copy Success"
f = open (kmzOut2, "w").close ()

print '  '
print datetime.datetime.now(),' ---- DONE! ---- '
print '  '




