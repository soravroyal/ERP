﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.3082
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QueryLayer
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[System.Data.Linq.Mapping.DatabaseAttribute(Name="EPRTRweb")]
	public partial class DataClassesPollutantTransferDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    #endregion
		
		public DataClassesPollutantTransferDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesPollutantTransferDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesPollutantTransferDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesPollutantTransferDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<POLLUTANTTRANSFER> POLLUTANTTRANSFERs
		{
			get
			{
				return this.GetTable<POLLUTANTTRANSFER>();
			}
		}
	}
	
	[Table(Name="dbo.POLLUTANTTRANSFER")]
	public partial class POLLUTANTTRANSFER
	{
		
		private int _FacilityReportID;
		
		private string _FacilityName;
		
		private int _FacilityID;
		
		private bool _ConfidentialIndicatorFacility;
		
		private int _ReportingYear;
		
		private string _MethodCode;
		
		private double _Quantity;
		
		private string _UnitCode;
		
		private string _PollutantGroupCode;
		
		private string _PollutantCode;
		
		private string _CAS;
		
		private int _LOV_PollutantGroupID;
		
		private int _LOV_PollutantID;
		
		private bool _ConfidentialIndicator;
		
		private string _ConfidentialCode;
		
		private System.Nullable<int> _LOV_ConfidentialityID;
		
		private string _CountryCode;
		
		private int _LOV_CountryID;
		
		private string _RiverBasinDistrictCode;
		
		private int _LOV_RiverBasinDistrictID;
		
		private string _NUTSLevel2RegionCode;
		
		private System.Nullable<int> _LOV_NUTSRLevel1ID;
		
		private System.Nullable<int> _LOV_NUTSRLevel2ID;
		
		private System.Nullable<int> _LOV_NUTSRLevel3ID;
		
		private string _IASectorCode;
		
		private string _IAActivityCode;
		
		private string _IASubActivityCode;
		
		private string _IPPCSectorCode;
		
		private string _IPPCActivityCode;
		
		private string _IPPCSubActivityCode;
		
		private System.Nullable<int> _LOV_IASectorID;
		
		private System.Nullable<int> _LOV_IAActivityID;
		
		private System.Nullable<int> _LOV_IASubActivityID;
		
		private string _NACESectorCode;
		
		private string _NACEActivityCode;
		
		private string _NACESubActivityCode;
		
		private System.Nullable<int> _LOV_NACESectorID;
		
		private System.Nullable<int> _LOV_NACEActivityID;
		
		private System.Nullable<int> _LOV_NACESubActivityID;
		
		public POLLUTANTTRANSFER()
		{
		}
		
		[Column(Storage="_FacilityReportID", DbType="Int NOT NULL")]
		public int FacilityReportID
		{
			get
			{
				return this._FacilityReportID;
			}
			set
			{
				if ((this._FacilityReportID != value))
				{
					this._FacilityReportID = value;
				}
			}
		}
		
		[Column(Storage="_FacilityName", DbType="NVarChar(255)")]
		public string FacilityName
		{
			get
			{
				return this._FacilityName;
			}
			set
			{
				if ((this._FacilityName != value))
				{
					this._FacilityName = value;
				}
			}
		}
		
		[Column(Storage="_FacilityID", DbType="Int NOT NULL")]
		public int FacilityID
		{
			get
			{
				return this._FacilityID;
			}
			set
			{
				if ((this._FacilityID != value))
				{
					this._FacilityID = value;
				}
			}
		}
		
		[Column(Storage="_ConfidentialIndicatorFacility", DbType="Bit NOT NULL")]
		public bool ConfidentialIndicatorFacility
		{
			get
			{
				return this._ConfidentialIndicatorFacility;
			}
			set
			{
				if ((this._ConfidentialIndicatorFacility != value))
				{
					this._ConfidentialIndicatorFacility = value;
				}
			}
		}
		
		[Column(Storage="_ReportingYear", DbType="Int NOT NULL")]
		public int ReportingYear
		{
			get
			{
				return this._ReportingYear;
			}
			set
			{
				if ((this._ReportingYear != value))
				{
					this._ReportingYear = value;
				}
			}
		}
		
		[Column(Storage="_MethodCode", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string MethodCode
		{
			get
			{
				return this._MethodCode;
			}
			set
			{
				if ((this._MethodCode != value))
				{
					this._MethodCode = value;
				}
			}
		}
		
		[Column(Storage="_Quantity", DbType="Float NOT NULL")]
		public double Quantity
		{
			get
			{
				return this._Quantity;
			}
			set
			{
				if ((this._Quantity != value))
				{
					this._Quantity = value;
				}
			}
		}
		
		[Column(Storage="_UnitCode", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string UnitCode
		{
			get
			{
				return this._UnitCode;
			}
			set
			{
				if ((this._UnitCode != value))
				{
					this._UnitCode = value;
				}
			}
		}
		
		[Column(Storage="_PollutantGroupCode", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string PollutantGroupCode
		{
			get
			{
				return this._PollutantGroupCode;
			}
			set
			{
				if ((this._PollutantGroupCode != value))
				{
					this._PollutantGroupCode = value;
				}
			}
		}
		
		[Column(Storage="_PollutantCode", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string PollutantCode
		{
			get
			{
				return this._PollutantCode;
			}
			set
			{
				if ((this._PollutantCode != value))
				{
					this._PollutantCode = value;
				}
			}
		}
		
		[Column(Storage="_CAS", DbType="NVarChar(20)")]
		public string CAS
		{
			get
			{
				return this._CAS;
			}
			set
			{
				if ((this._CAS != value))
				{
					this._CAS = value;
				}
			}
		}
		
		[Column(Storage="_LOV_PollutantGroupID", DbType="Int NOT NULL")]
		public int LOV_PollutantGroupID
		{
			get
			{
				return this._LOV_PollutantGroupID;
			}
			set
			{
				if ((this._LOV_PollutantGroupID != value))
				{
					this._LOV_PollutantGroupID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_PollutantID", DbType="Int NOT NULL")]
		public int LOV_PollutantID
		{
			get
			{
				return this._LOV_PollutantID;
			}
			set
			{
				if ((this._LOV_PollutantID != value))
				{
					this._LOV_PollutantID = value;
				}
			}
		}
		
		[Column(Storage="_ConfidentialIndicator", DbType="Bit NOT NULL")]
		public bool ConfidentialIndicator
		{
			get
			{
				return this._ConfidentialIndicator;
			}
			set
			{
				if ((this._ConfidentialIndicator != value))
				{
					this._ConfidentialIndicator = value;
				}
			}
		}
		
		[Column(Storage="_ConfidentialCode", DbType="NVarChar(255)")]
		public string ConfidentialCode
		{
			get
			{
				return this._ConfidentialCode;
			}
			set
			{
				if ((this._ConfidentialCode != value))
				{
					this._ConfidentialCode = value;
				}
			}
		}
		
		[Column(Storage="_LOV_ConfidentialityID", DbType="Int")]
		public System.Nullable<int> LOV_ConfidentialityID
		{
			get
			{
				return this._LOV_ConfidentialityID;
			}
			set
			{
				if ((this._LOV_ConfidentialityID != value))
				{
					this._LOV_ConfidentialityID = value;
				}
			}
		}
		
		[Column(Storage="_CountryCode", DbType="NVarChar(255)")]
		public string CountryCode
		{
			get
			{
				return this._CountryCode;
			}
			set
			{
				if ((this._CountryCode != value))
				{
					this._CountryCode = value;
				}
			}
		}
		
		[Column(Storage="_LOV_CountryID", DbType="Int NOT NULL")]
		public int LOV_CountryID
		{
			get
			{
				return this._LOV_CountryID;
			}
			set
			{
				if ((this._LOV_CountryID != value))
				{
					this._LOV_CountryID = value;
				}
			}
		}
		
		[Column(Storage="_RiverBasinDistrictCode", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string RiverBasinDistrictCode
		{
			get
			{
				return this._RiverBasinDistrictCode;
			}
			set
			{
				if ((this._RiverBasinDistrictCode != value))
				{
					this._RiverBasinDistrictCode = value;
				}
			}
		}
		
		[Column(Storage="_LOV_RiverBasinDistrictID", DbType="Int NOT NULL")]
		public int LOV_RiverBasinDistrictID
		{
			get
			{
				return this._LOV_RiverBasinDistrictID;
			}
			set
			{
				if ((this._LOV_RiverBasinDistrictID != value))
				{
					this._LOV_RiverBasinDistrictID = value;
				}
			}
		}
		
		[Column(Storage="_NUTSLevel2RegionCode", DbType="NVarChar(255)")]
		public string NUTSLevel2RegionCode
		{
			get
			{
				return this._NUTSLevel2RegionCode;
			}
			set
			{
				if ((this._NUTSLevel2RegionCode != value))
				{
					this._NUTSLevel2RegionCode = value;
				}
			}
		}
		
		[Column(Storage="_LOV_NUTSRLevel1ID", DbType="Int")]
		public System.Nullable<int> LOV_NUTSRLevel1ID
		{
			get
			{
				return this._LOV_NUTSRLevel1ID;
			}
			set
			{
				if ((this._LOV_NUTSRLevel1ID != value))
				{
					this._LOV_NUTSRLevel1ID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_NUTSRLevel2ID", DbType="Int")]
		public System.Nullable<int> LOV_NUTSRLevel2ID
		{
			get
			{
				return this._LOV_NUTSRLevel2ID;
			}
			set
			{
				if ((this._LOV_NUTSRLevel2ID != value))
				{
					this._LOV_NUTSRLevel2ID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_NUTSRLevel3ID", DbType="Int")]
		public System.Nullable<int> LOV_NUTSRLevel3ID
		{
			get
			{
				return this._LOV_NUTSRLevel3ID;
			}
			set
			{
				if ((this._LOV_NUTSRLevel3ID != value))
				{
					this._LOV_NUTSRLevel3ID = value;
				}
			}
		}
		
		[Column(Storage="_IASectorCode", DbType="NVarChar(255)")]
		public string IASectorCode
		{
			get
			{
				return this._IASectorCode;
			}
			set
			{
				if ((this._IASectorCode != value))
				{
					this._IASectorCode = value;
				}
			}
		}
		
		[Column(Storage="_IAActivityCode", DbType="NVarChar(255)")]
		public string IAActivityCode
		{
			get
			{
				return this._IAActivityCode;
			}
			set
			{
				if ((this._IAActivityCode != value))
				{
					this._IAActivityCode = value;
				}
			}
		}
		
		[Column(Storage="_IASubActivityCode", DbType="NVarChar(255)")]
		public string IASubActivityCode
		{
			get
			{
				return this._IASubActivityCode;
			}
			set
			{
				if ((this._IASubActivityCode != value))
				{
					this._IASubActivityCode = value;
				}
			}
		}
		
		[Column(Storage="_IPPCSectorCode", DbType="NVarChar(255)")]
		public string IPPCSectorCode
		{
			get
			{
				return this._IPPCSectorCode;
			}
			set
			{
				if ((this._IPPCSectorCode != value))
				{
					this._IPPCSectorCode = value;
				}
			}
		}
		
		[Column(Storage="_IPPCActivityCode", DbType="NVarChar(255)")]
		public string IPPCActivityCode
		{
			get
			{
				return this._IPPCActivityCode;
			}
			set
			{
				if ((this._IPPCActivityCode != value))
				{
					this._IPPCActivityCode = value;
				}
			}
		}
		
		[Column(Storage="_IPPCSubActivityCode", DbType="NVarChar(255)")]
		public string IPPCSubActivityCode
		{
			get
			{
				return this._IPPCSubActivityCode;
			}
			set
			{
				if ((this._IPPCSubActivityCode != value))
				{
					this._IPPCSubActivityCode = value;
				}
			}
		}
		
		[Column(Storage="_LOV_IASectorID", DbType="Int")]
		public System.Nullable<int> LOV_IASectorID
		{
			get
			{
				return this._LOV_IASectorID;
			}
			set
			{
				if ((this._LOV_IASectorID != value))
				{
					this._LOV_IASectorID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_IAActivityID", DbType="Int")]
		public System.Nullable<int> LOV_IAActivityID
		{
			get
			{
				return this._LOV_IAActivityID;
			}
			set
			{
				if ((this._LOV_IAActivityID != value))
				{
					this._LOV_IAActivityID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_IASubActivityID", DbType="Int")]
		public System.Nullable<int> LOV_IASubActivityID
		{
			get
			{
				return this._LOV_IASubActivityID;
			}
			set
			{
				if ((this._LOV_IASubActivityID != value))
				{
					this._LOV_IASubActivityID = value;
				}
			}
		}
		
		[Column(Storage="_NACESectorCode", DbType="NVarChar(255)")]
		public string NACESectorCode
		{
			get
			{
				return this._NACESectorCode;
			}
			set
			{
				if ((this._NACESectorCode != value))
				{
					this._NACESectorCode = value;
				}
			}
		}
		
		[Column(Storage="_NACEActivityCode", DbType="NVarChar(255)")]
		public string NACEActivityCode
		{
			get
			{
				return this._NACEActivityCode;
			}
			set
			{
				if ((this._NACEActivityCode != value))
				{
					this._NACEActivityCode = value;
				}
			}
		}
		
		[Column(Storage="_NACESubActivityCode", DbType="NVarChar(255)")]
		public string NACESubActivityCode
		{
			get
			{
				return this._NACESubActivityCode;
			}
			set
			{
				if ((this._NACESubActivityCode != value))
				{
					this._NACESubActivityCode = value;
				}
			}
		}
		
		[Column(Storage="_LOV_NACESectorID", DbType="Int")]
		public System.Nullable<int> LOV_NACESectorID
		{
			get
			{
				return this._LOV_NACESectorID;
			}
			set
			{
				if ((this._LOV_NACESectorID != value))
				{
					this._LOV_NACESectorID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_NACEActivityID", DbType="Int")]
		public System.Nullable<int> LOV_NACEActivityID
		{
			get
			{
				return this._LOV_NACEActivityID;
			}
			set
			{
				if ((this._LOV_NACEActivityID != value))
				{
					this._LOV_NACEActivityID = value;
				}
			}
		}
		
		[Column(Storage="_LOV_NACESubActivityID", DbType="Int")]
		public System.Nullable<int> LOV_NACESubActivityID
		{
			get
			{
				return this._LOV_NACESubActivityID;
			}
			set
			{
				if ((this._LOV_NACESubActivityID != value))
				{
					this._LOV_NACESubActivityID = value;
				}
			}
		}
	}
}
#pragma warning restore 1591
