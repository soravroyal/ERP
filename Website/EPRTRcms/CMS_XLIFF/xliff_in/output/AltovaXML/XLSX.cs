// XLSX.cs
// This file contains generated code and will be overwritten when you rerun code generation.

using System;
using System.Xml;
using System.Collections;
using System.Text.RegularExpressions;
using System.IO.Packaging;

namespace Altova.Xml 
{
    public class XLSX
    {
        public static string Index2ColumnName(int index)
        {
            System.Text.StringBuilder str = new System.Text.StringBuilder();

            do
            {
                str = str.Insert(0, (char)('A' + (char)(--index) % 26));
                index /= 26;
            }
            while (index > 0);
            return str.ToString();
        }

        public static int ColumnName2Index(string colName)
        {
            int index = 0;

            for (int i = 0; i < colName.Length; i++)
                index = (index * 26) + (int)colName[i] - ((int)'A' - 1);

            return index;
        }

        public static XmlElement GetChildElement(XmlNode parent, string localName)
        {
            XmlElement e = FindChildElement(parent, localName);
            if (e == null)
                throw new Exception("Child element " + localName + "not found in parent node " + parent.LocalName);
            return e;
        }

        public static XmlElement FindChildElement (XmlNode parent, string localName)
        {
            foreach (XmlNode n in parent.ChildNodes)
            {
                if (n.NodeType == XmlNodeType.Element && n.LocalName == localName)
                    return (XmlElement) n;
            }
            return null;
        }

        public static ElementIterator GetChildElements(XmlNode parent, string localName)
        {
            return new ElementIterator(parent, localName);
        }

        public static ElementIterator GetChildElements(XmlNode parent)
        {
            return new ElementIterator(parent, null);
        }

        public class ElementIterator : System.Collections.IEnumerable, System.IDisposable
        {
            private XmlNode parent;
            private string localName;

            public ElementIterator(XmlNode parent, string localName)
            {
                this.parent = parent;
                this.localName = localName;
            }

            public System.Collections.IEnumerator GetEnumerator()
            {
                return new Enumerator(parent.ChildNodes, localName);
            }
            
            public void Dispose()
            {
            } 

            class Enumerator : System.Collections.IEnumerator
            {
                private System.Collections.IEnumerator iterator;
                private string localName;

                public Enumerator(XmlNodeList list, string localName)
                {
                    this.iterator = list.GetEnumerator();
                    this.localName = localName;
                }

                public void Reset()
                {
                    iterator.Reset();
                }

                public object Current
                {
                    get
                    {
                        return iterator.Current;
                    }
                }

                public bool MoveNext()
                {
                    while (iterator.MoveNext())
                    {
                        XmlNode node = (XmlNode) iterator.Current;
                        if (node.NodeType == XmlNodeType.Element)
                            if (localName == null || localName == node.LocalName)
                                return true;
                    }
                    return false;
                }
            }
        }

        public static XmlElement AppendElement(XmlNode parent, string localName)
        {
            return AppendElement(parent, null, localName);
        }

        public static XmlElement AppendElement(XmlNode parent, string localName, string nsUri)
        {
            XmlDocument document = null;
            if (parent.NodeType == XmlNodeType.Document)
                document = (XmlDocument)parent;
            else
                document = parent.OwnerDocument;

            if (nsUri == null)
                return (XmlElement)parent.AppendChild(document.CreateElement(localName));
            return (XmlElement)parent.AppendChild(document.CreateElement(localName, nsUri));
        }
    }

	public class XLSXReader
	{
        private XmlDocument relsBaseDoc = null;
        private XmlDocument workBookDoc = null;
        private string workBookFileName = null;
        private XmlDocument workBookRels = null;

        private ArrayList sharedStrings = null;

        private XmlDocument resultDoc = null;
        private XmlElement resultWorkBook = null;

        private ArrayList workSheetNames = null;

        private Package xlsxZip = null;
        
        private System.IO.Stream inStream = null;

        private int minColumn = 0;
        private int maxColumn = 0;

        private enum InternalFormatNumber { String = 0, Number = 1 };

        public XLSXReader(Altova.IO.Input xlsxInput)
        {
            if (xlsxInput.Type != Altova.IO.Input.InputType.Stream)
                throw new System.Exception("XLSX output can be read only from the stream");

            inStream = xlsxInput.Stream;
            xlsxZip = Package.Open(inStream);
        }
        
        public XLSXReader(System.IO.Stream stream)
		{
            inStream = stream;
            xlsxZip = Package.Open(inStream);
		}

        public XmlDocument run()
        {
            relsBaseDoc = OpenRelsBase();
            workBookDoc = OpenWorkBook();
            workBookRels = OpenWorkBookRels();
            sharedStrings = MakeSharedStrings();

            resultDoc = new XmlDocument();

            resultWorkBook = resultDoc.CreateElement("Workbook");
            resultDoc.AppendChild(resultWorkBook);
            resultWorkBook.SetAttribute("uri", workBookFileName);

            MakeWorkBook();

            return resultDoc;
        }

        private XmlDocument OpenRelsBase()
        {
            return LoadDocumentFromZip("_rels/.rels");
        }

        private XmlDocument OpenWorkBook()
        {
            workBookFileName = FindRelationTargetForKey(relsBaseDoc, "Type", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument");
            return LoadDocumentFromZip(workBookFileName);
        }


        private XmlDocument OpenWorkBookRels()
        {
            string workBookRelsName = GetRelationsFileNameForFileName(workBookFileName);
            return LoadDocumentFromZip(workBookRelsName);
        }

        private ArrayList MakeSharedStrings()
        {
            string stringTableFileName = FindRelationTargetForKey(workBookRels, "Type", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings");
            if (stringTableFileName == null)
                return null;

            stringTableFileName = ReplaceFilename(workBookFileName, stringTableFileName);

            XmlDocument sharedStringsDoc = LoadDocumentFromZip(stringTableFileName);

            XmlElement sst = sharedStringsDoc.DocumentElement;
            if (sst.LocalName != "sst")
                throw new Exception("MakeSharedStrings: document element is not sst!");

            int count = Int32.Parse(sst.GetAttribute("count"));

            sharedStrings = new ArrayList(count);

            foreach (XmlNode si in sst.ChildNodes)
                if (si.NodeType == XmlNodeType.Element)
                    sharedStrings.Add(si.InnerText);

            return sharedStrings;
        }

        private void MakeWorkBook()
        {
            XmlElement workBookNode = XLSX.GetChildElement(workBookDoc, "workbook");
            XmlElement sheets = XLSX.GetChildElement(workBookNode, "sheets");

            workSheetNames = new ArrayList();

            foreach (XmlElement sheet in sheets)
                if (sheet.NodeType == XmlNodeType.Element)
                {
                    string sheetRelId = sheet.GetAttribute("id", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");
                    string sheetName = sheet.GetAttribute("name");

                    workSheetNames.Add(sheetName);

                    string typeURI = FindRelationInfoForKey(workBookRels, "Id", sheetRelId, "Type");
                    if (typeURI == null || typeURI != "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet")
                        continue;
                    
                    string sheetFileName = FindRelationTargetForKey(workBookRels, "Id", sheetRelId);
                    if (sheetFileName == null)
                        continue;

                    sheetFileName = ReplaceFilename(workBookFileName, sheetFileName);

                    XmlElement resultWorkSheet = (XmlElement) resultWorkBook.AppendChild(resultDoc.CreateElement("Worksheet"));
                    resultWorkSheet.SetAttribute("Name", sheetName);

                    MakeWorkSheet(LoadDocumentFromZip(sheetFileName), resultWorkSheet);
                }
        }

        private void MakeWorkSheet(XmlDocument sheetDoc, XmlElement resultWorkSheet)
        {
            if (sheetDoc == null)
                throw new Exception("Worksheet document is null");

            int lastRowSeen = 0;

            XmlElement workSheetElement = XLSX.GetChildElement(sheetDoc, "worksheet");

            XmlElement dimension = null;
            bool mustCreateDimension = false;

            dimension = (XmlElement)resultWorkSheet.AppendChild(resultDoc.CreateElement("Dimension"));
            XmlElement dimensionElement = XLSX.FindChildElement(workSheetElement, "dimension");
            if (dimensionElement == null)
                mustCreateDimension = true;
            else
            {
                string firstCell = dimensionElement.GetAttribute("ref");
                if (firstCell.Length > 0)
                {
                    Regex regex = new Regex("([A-Z]+)(\\d+)(:([A-Z]+)(\\d+))?");
                    Match matcher = regex.Match(firstCell);

                    if (!matcher.Success)
                        throw new Exception("makeWorkSheet: dimension " + firstCell + " doesn't match");

                    int firstColumnIndex = matcher.Groups[1].Value != null && matcher.Groups[1].Value.Length >0 ? XLSX.ColumnName2Index(matcher.Groups[1].Value) : 1;
                    int firstRowIndex = matcher.Groups[2].Value != null && matcher.Groups[2].Value.Length >0 ? Int32.Parse(matcher.Groups[2].Value) : 1;
                    int secondColumnIndex = matcher.Groups[4].Value != null && matcher.Groups[4].Value.Length >0 ? XLSX.ColumnName2Index(matcher.Groups[4].Value) : firstColumnIndex;
                    int secondRowIndex = matcher.Groups[5].Value != null && matcher.Groups[5].Value.Length >0 ? Int32.Parse(matcher.Groups[5].Value) : firstRowIndex;

                    WriteDimension(dimension, firstRowIndex, secondRowIndex, firstColumnIndex, secondColumnIndex);
                }
                else
                    mustCreateDimension = true;
            }

            XmlNode sheetDataElement = XLSX.GetChildElement(workSheetElement, "sheetData");

            minColumn = Int32.MaxValue;
            maxColumn = 0;

            foreach (XmlNode rowNode in sheetDataElement)
                if (rowNode.NodeType == XmlNodeType.Element && rowNode.LocalName == "row")
                {
                    XmlElement rowElement = (XmlElement) rowNode;
                    XmlElement resultRow = (XmlElement)resultWorkSheet.AppendChild(resultDoc.CreateElement("Row"));
                    string rowNumber = rowElement.GetAttribute("r");
                    if (rowNumber.Length > 0)
                        lastRowSeen = Int32.Parse(rowNumber);
                    else
                    {
                        ++lastRowSeen;
                        rowNumber = Convert.ToString(lastRowSeen);
                    }
                    resultRow.SetAttribute("r", rowNumber);
                    MakeRow(rowElement, resultRow);
                }

            if (mustCreateDimension)
            {
                int firstRowIndex = 1;

                XmlElement firstRow = XLSX.GetChildElement(resultWorkSheet, "Row");
                if (firstRow != null)
                    firstRowIndex = Int32.Parse(firstRow.GetAttribute("r"));
                WriteDimension(dimension, firstRowIndex, lastRowSeen, minColumn, maxColumn);
            }
        }

        private void MakeRow(XmlNode xlsxRow, XmlElement resultRow)
        {
            int lastColSeen = 0;
            
            foreach (XmlNode cn in xlsxRow)
                if (cn.NodeType == XmlNodeType.Element && cn.LocalName == "c")
                {
                    XmlElement c = (XmlElement)cn;
                    XmlElement resultCol = (XmlElement)resultRow.AppendChild(resultDoc.CreateElement("Cell"));
                    string columnIdentifier = c.GetAttribute("r");

                    if (columnIdentifier.Length > 0)
                    {
                        int i = 0;
                        while (Char.IsLetter(columnIdentifier[i])) ++i;
                        string colId = columnIdentifier.Substring(0, i);
                        lastColSeen = XLSX.ColumnName2Index(colId);
                        resultCol.SetAttribute("c", colId);
                    }
                    else
                    {
                        lastColSeen++;
                        resultCol.SetAttribute("c", XLSX.Index2ColumnName(lastColSeen));
                    }

                    resultCol.SetAttribute("n", Convert.ToString(lastColSeen));

                    minColumn = (lastColSeen < minColumn) ? lastColSeen : minColumn;
                    maxColumn = (lastColSeen > maxColumn) ? lastColSeen : maxColumn;

                    string cf1 = c.GetAttribute("t");
                    if (cf1.Length == 0) cf1 = "n";
                    // InternalFormatNumber cf2 = InternalFormatNumber.Number;
                    if (cf1 == "inlineStr")
                    {
                        // cf2 = InternalFormatNumber.String;                        
                        resultCol.SetAttribute("t", "s");
                        XmlElement iss = XLSX.GetChildElement(c, "is");
                        if (iss != null)
                            resultCol.InnerText = iss.InnerText;                            
                    }
                    else
                    {
                        XmlElement v = XLSX.FindChildElement(c, "v");
                        if (v != null)
                        {
                            string textValue = v.InnerText;
                            if (cf1 == "s")
                            {
                                // cf2 = InternalFormatNumber.String;                                
                                resultCol.SetAttribute("t", "s");
                                int stringIndex = Int32.Parse(textValue);
                                if (stringIndex < sharedStrings.Count)
                                    resultCol.InnerText = (string) sharedStrings[stringIndex];                                    
                            }
                            else
                            {
                                if (cf1 == "str" || cf1 == "e")
                                    resultCol.SetAttribute("t", "s");
                                else
                                    resultCol.SetAttribute("t", cf1);
                                
                                resultCol.InnerText = textValue;
                            }
                        }
                    }
            }
        }

        private void WriteDimension(XmlElement dimension, int firstRowIndex, int secondRowIndex, int firstColumnIndex, int secondColumnIndex)
        {        
            dimension.SetAttribute("FirstRow", Convert.ToString(firstRowIndex));
            dimension.SetAttribute("FirstColumn", Convert.ToString(firstColumnIndex));
            dimension.SetAttribute("LastRow", Convert.ToString(secondRowIndex));
            dimension.SetAttribute("LastColumn", Convert.ToString(secondColumnIndex));
        }

        private string FindRelationInfoForKey(XmlNode node, string keyName, string key, string type)
        {
            foreach (XmlNode n in node.ChildNodes)
                if (n.NodeType == XmlNodeType.Element && n.LocalName == "Relationships")
                    foreach (XmlNode m in n.ChildNodes)
                        if (m.NodeType == XmlNodeType.Element && m.LocalName == "Relationship")
                            if (((XmlElement)m).GetAttribute(keyName) == key)
                                return ((XmlElement)m).GetAttribute(type);

            return null;
        }
        
        private string FindRelationTargetForKey(XmlNode node, string keyName, string key)
        {
            return FindRelationInfoForKey(node, keyName, key, "Target");
        }

        private XmlDocument LoadDocumentFromZip(string entryName)
        {
            XmlDocument doc = new XmlDocument();
            Uri uri = new Uri(entryName.StartsWith("/") ? entryName : "/" + entryName, UriKind.Relative);
            PackagePart entry = xlsxZip.GetPart(uri);
            doc.Load(entry.GetStream());
            return doc;
        }

        private string GetRelationsFileNameForFileName(string filename)
        {
            int i = filename.LastIndexOf('/');
            string path = filename.Substring(0, i + 1);
            string file = filename.Substring(i + 1);
            return path + "_rels/" + file + ".rels";
        }

        private string ReplaceFilename(string o, string n)
        {
            int i = o.LastIndexOf('/');
            if (n.StartsWith(o.Substring(0, i + 1)))
                return n;
            return o.Substring(0, i + 1) + n;
        }
	}
	
	public class XLSXWriter
	{
        private XmlDocument document = null;
        private XmlDocument resultWorkbookDefinition = null;
        private XmlDocument styles = null;
        private System.IO.Stream targetStream = null;
        private Package xlsxZip = null;

        private class GoodDateTimeFormat
        {
            public GoodDateTimeFormat(String n, String i, int k) { name = n; id = i; number = k; }
            public String name;
            public String id;
            public int number;
        }

        private GoodDateTimeFormat[] goodDateTimeFormats = 
	    { 
		    new GoodDateTimeFormat("", "0", 0), 
		    new GoodDateTimeFormat("dt", "22", 1),
		    new GoodDateTimeFormat("d", "14", 2),
		    new GoodDateTimeFormat("t", "18", 3)
	    };

        private class ResultWorksheet
        {
            public ResultWorksheet(string sheetName, ArrayList matrix) { this.SheetName = sheetName; this.Filename = null; this.Matrix = matrix; }
            public string SheetName = null;
            public string Filename = null;
            public ArrayList Matrix = null;
            public XmlDocument Contents = null;
            public string SheetId = null;
        }

        public XLSXWriter(Altova.IO.Output xlsxOutput, XmlDocument doc)
        {
            if (xlsxOutput.Type != Altova.IO.Output.OutputType.Stream)
                throw new System.Exception("XLSX output can be written only into stream");

            targetStream = xlsxOutput.Stream;
            document = doc;
        }
        
        public XLSXWriter(System.IO.Stream xlsxStream, XmlDocument doc)
		{
            targetStream = xlsxStream;
            document = doc;
		}
		
		public void run()
		{
            const string relationSchema = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships";
            const string workbookContentType = @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml";
            const string worksheetContentType = @"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml";
            const string stylesheetContentType = @"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml";
            
            xlsxZip = Package.Open(targetStream, System.IO.FileMode.Create);

            Hashtable resultWorksheets = new Hashtable();
            MakeWorksheets(ref resultWorksheets);
            
            if (resultWorksheets.Count == 0)
                throw new System.Exception("Cannot create workbook without worksheets"); 
          
            CreateResultSheetContentsAndClearMatrices(ref resultWorksheets);

            Uri uriDefaultContentType = new Uri("/default.xml", UriKind.Relative);
            PackagePart partTemp = xlsxZip.CreatePart(uriDefaultContentType, "application/xml");

            MakeWorkbookDefinition(resultWorksheets);
            PackagePart partWorkbookXML = Save(resultWorkbookDefinition, "/xl/workbook.xml", workbookContentType);
        
            foreach (ResultWorksheet resultWorksheet in resultWorksheets.Values)
                Save(resultWorksheet.Contents, "/xl/" + resultWorksheet.Filename, worksheetContentType);

		    MakeStyles();
            Save(styles, "/xl/styles.xml", stylesheetContentType);

            // create the relationship parts
            Uri uriStartPart = new Uri("/xl/workbook.xml", UriKind.Relative);
            xlsxZip.CreateRelationship(uriStartPart, TargetMode.Internal, relationSchema + "/officeDocument", "rId");
            foreach (ResultWorksheet resultWorksheet in resultWorksheets.Values)
            {
                Uri uriWorksheet = new Uri("/xl/" + resultWorksheet.Filename, UriKind.Relative);
                partWorkbookXML.CreateRelationship(uriWorksheet, TargetMode.Internal, relationSchema + "/worksheet", resultWorksheet.SheetId);
            }
            Uri uriStylesheet = new Uri("/xl/styles.xml", UriKind.Relative);
            partWorkbookXML.CreateRelationship(uriStylesheet, TargetMode.Internal, relationSchema + "/styles", "rId");

            xlsxZip.DeletePart(uriDefaultContentType);
            xlsxZip.Flush();
		}

        private void MakeWorksheets(ref Hashtable resultWorksheets)
        {
            XmlElement workbook = XLSX.GetChildElement(document, "Workbook");

            int sheetNo = 0;
            foreach (XmlElement worksheet in XLSX.GetChildElements(workbook, "Worksheet"))
            {
                string sheetName = worksheet.GetAttribute("Name");
                if (sheetName.Length == 0)
                    throw new System.Exception("Cannot create a worksheet without a name");

                int lastRowSeen = 0;

                ResultWorksheet resultWorksheet = null;
                if (resultWorksheets.Contains(sheetName))
                    resultWorksheet = (ResultWorksheet)resultWorksheets[sheetName];
                else
                    resultWorksheet = new ResultWorksheet(sheetName, new ArrayList());

                foreach (XmlElement row in XLSX.GetChildElements(worksheet, "Row"))
                {
                    string rowIndex = row.GetAttribute("r");
                    int n = 0;

                    if (rowIndex.Length > 0 && ((n = Int32.Parse(rowIndex)) > 0))
						lastRowSeen = n;
					else
                        rowIndex = Convert.ToString(++lastRowSeen);
					
					while (resultWorksheet.Matrix.Count <= lastRowSeen)
						resultWorksheet.Matrix.Add(null);

                    ArrayList lastRow = (ArrayList)resultWorksheet.Matrix[lastRowSeen];
                    if (lastRow == null)
                        lastRow = new ArrayList();

                    MakeCells(row, ref lastRow, lastRowSeen);
                    resultWorksheet.Matrix[lastRowSeen] = lastRow;
                }
                resultWorksheet.Filename = "worksheets/Sheet" + Convert.ToString(sheetNo) + ".xml";
                resultWorksheet.SheetId = "rId" + Convert.ToString(sheetNo++);
                resultWorksheets[sheetName] = resultWorksheet;
            }
        }

        private void MakeCells(XmlElement row, ref ArrayList resultRow, int lastRowIndex)
        {
            int lastColSeen = 0;

            foreach (XmlElement cell in XLSX.GetChildElements(row, "Cell"))
            {
                string colIndex  = cell.GetAttribute("n");
                int n = 0;

                if (colIndex.Length > 0 && ((n = Int32.Parse(colIndex)) > 0))
					lastColSeen = n;
				else
					lastColSeen++;

                if (lastColSeen > 16384)
                    throw new System.Exception("Cannot make more than 16384 columns; This is an Excel limitation");
                
                while (resultRow.Count <= lastColSeen )
                    resultRow.Add(null);
                if (resultRow[lastColSeen] == null)
                   resultRow[lastColSeen] = cell;
            }
        }
        
        private void CreateResultSheetContentsAndClearMatrices(ref Hashtable resultWorksheets)
        {
            foreach (ResultWorksheet resultWorksheet in resultWorksheets.Values)
            {
                XmlDocument resultSheetDocument = new XmlDocument();
                string ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";

                XmlElement worksheet = XLSX.AppendElement(resultSheetDocument, "worksheet", ns);
                XmlElement sheetData = XLSX.AppendElement(worksheet, "sheetData", ns);

                int i = 0;
                foreach (ArrayList cells in resultWorksheet.Matrix)
                {
                    if (cells == null || cells.Count == 0)
                    {
                        i++;
                        continue;
                    }

                    XmlElement row = XLSX.AppendElement(sheetData, "row", ns);
                    row.SetAttribute("r", Convert.ToString(i));
                    int j = 0; 
                    foreach(XmlElement cell in cells)
                    {
                        if (cell == null)
                        {
                            j++;
                            continue;
                        }

                        string val = cell.InnerText;
                        XmlElement c = XLSX.AppendElement(row, "c", ns);
                        string colName = XLSX.Index2ColumnName(j);
                        c.SetAttribute("r", colName + Convert.ToString(i));
                        string t = cell.GetAttribute("t");
                        if (t == "s")
                        {
                            if (val.IndexOf('r') != -1 || val.IndexOf('n') != -1)
							    c.SetAttribute("s", "4");
                            c.SetAttribute("t", "inlineStr");
					        XmlElement iis = XLSX.AppendElement(c, "is", ns);
					        XmlElement tToo = XLSX.AppendElement(iis, "t", ns);
					        tToo.InnerText = val;
                        }
                        else
                        {
                            string attrName = "n";
                            bool checkForDateTimeStyle = false;
                            if (t == "b")
                                attrName = "b";
                            else if (t == "e")
                                attrName = "e";
                            else
                                checkForDateTimeStyle = true;

                            c.SetAttribute("t", attrName);
                            if (checkForDateTimeStyle)
                            {
                                string formatHint = cell.GetAttribute("f");
                                if (formatHint.Length > 0)
                                    foreach (GoodDateTimeFormat gdf in goodDateTimeFormats)
                                        if (formatHint == gdf.name)
                                            c.SetAttribute("s", Convert.ToString(gdf.number));
                            }
                            XmlElement v = XLSX.AppendElement(c, "v", ns);
                            v.InnerText = val;
                        }
                        j++;
                    }
                    i++;
                }
                resultWorksheet.Matrix.Clear();
                resultWorksheet.Contents = resultSheetDocument;
            }
        }

        private void MakeWorkbookDefinition(Hashtable resultWorksheets)
        {
            resultWorkbookDefinition = new XmlDocument();
            string ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
            XmlElement workbook = XLSX.AppendElement(resultWorkbookDefinition, "workbook", ns);

            workbook.SetAttribute("xmlns:r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");
            XmlElement fileVersion = XLSX.AppendElement(workbook, "fileVersion", ns);
            fileVersion.SetAttribute("appName", "xl");
            fileVersion.SetAttribute("lastEdited", "4");
            fileVersion.SetAttribute("lowestEdited", "4");
            XmlElement sheets = XLSX.AppendElement(workbook, "sheets", ns);

            int iSheet = 1;
            foreach(ResultWorksheet resultWorksheet in resultWorksheets.Values)
            {
                XmlElement sheet = XLSX.AppendElement(sheets, "sheet", ns);
                sheet.SetAttribute("name", resultWorksheet.SheetName);
                sheet.SetAttribute("sheetId", Convert.ToString(iSheet));
                sheet.SetAttribute("id", "http://schemas.openxmlformats.org/officeDocument/2006/relationships", resultWorksheet.SheetId);
                iSheet++;
            }
        }

        private void MakeStyles()
        {
            styles = new XmlDocument();
		    string ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
		    XmlElement stylesheet = XLSX.AppendElement(styles, "styleSheet", ns);
		    stylesheet.SetAttribute("xmlns", "http://schemas.openxmlformats.org/spreadsheetml/2006/main");
    		
		    AddEverythingToStylesWhichExcelWantsToHaveToOpenTheCreatedFile(ref stylesheet);
    		
		    XmlElement cellXfs = XLSX.AppendElement(stylesheet, "cellXfs", ns);
		    cellXfs.SetAttribute("count", "5");
            bool anf = false;
            foreach (GoodDateTimeFormat bestDateFormatEver in goodDateTimeFormats)
		    {
			    XmlElement xf = XLSX.AppendElement(cellXfs, "xf", ns);
			    xf.SetAttribute("numFmtId", bestDateFormatEver.id);
                if (anf)
                    xf.SetAttribute("applyNumberFormat", "1");
                anf = true;
		    }
            XmlElement xf2 = XLSX.AppendElement(cellXfs, "xf", ns);
                xf2.SetAttribute("applyAlignment", "1");
            XmlElement alignment = XLSX.AppendElement(xf2, "alignment", ns);
            alignment.SetAttribute("wrapText", "1");
        }

        private void AddEverythingToStylesWhichExcelWantsToHaveToOpenTheCreatedFile(ref XmlElement stylesheet)
        {
            string ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
            XmlElement fonts = XLSX.AppendElement(stylesheet, "fonts", ns);
            fonts.SetAttribute("count", "1");
            XmlElement font = XLSX.AppendElement(fonts, "font", ns);
            XLSX.AppendElement(font, "sz", ns).SetAttribute("val", "10");
            XLSX.AppendElement(font, "name", ns).SetAttribute("val", "Arial");

            XmlElement fills = XLSX.AppendElement(stylesheet, "fills", ns);
            fills.SetAttribute("count", "1");
            XmlElement fill = XLSX.AppendElement(fills, "fill", ns);
            XLSX.AppendElement(fill, "patternFill", ns).SetAttribute("patternType", "none");

            XmlElement borders = XLSX.AppendElement(stylesheet, "borders", ns);
            borders.SetAttribute("count", "1");
            XmlElement border = XLSX.AppendElement(borders, "border", ns);
            XLSX.AppendElement(border, "left", ns);
            XLSX.AppendElement(border, "right", ns);
            XLSX.AppendElement(border, "top", ns);
            XLSX.AppendElement(border, "bottom", ns);
            XLSX.AppendElement(border, "diagonal", ns);

            XmlElement cellStyleXfs = XLSX.AppendElement(stylesheet, "cellStyleXfs", ns);
            cellStyleXfs.SetAttribute("count", "1");
            XmlElement xf = XLSX.AppendElement(cellStyleXfs, "xf", ns);
            xf.SetAttribute("numFmtId", "0");
            xf.SetAttribute("fontId", "0");
            xf.SetAttribute("fillId", "0");
            xf.SetAttribute("borderId", "0");
        }

        private PackagePart Save(XmlDocument document, string entryName, string contentType)
        {
            Uri uri = PackUriHelper.CreatePartUri(new Uri(entryName, UriKind.Relative));
            PackagePart entry = xlsxZip.CreatePart(uri, contentType);
            XmlTreeOperations.SaveDocument(document, entry.GetStream(), true);
            return entry;
        }
	}
}
