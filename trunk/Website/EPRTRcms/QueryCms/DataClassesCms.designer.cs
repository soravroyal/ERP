﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.3053
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QueryCms
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
	
	
	[System.Data.Linq.Mapping.DatabaseAttribute(Name="EPRTRcms")]
	public partial class DataClassesCmsDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    partial void InsertReviseResourceValue(ReviseResourceValue instance);
    partial void UpdateReviseResourceValue(ReviseResourceValue instance);
    partial void DeleteReviseResourceValue(ReviseResourceValue instance);
    partial void InsertReviseResourceKey(ReviseResourceKey instance);
    partial void UpdateReviseResourceKey(ReviseResourceKey instance);
    partial void DeleteReviseResourceKey(ReviseResourceKey instance);
    partial void InsertLOV_ContentsGroup(LOV_ContentsGroup instance);
    partial void UpdateLOV_ContentsGroup(LOV_ContentsGroup instance);
    partial void DeleteLOV_ContentsGroup(LOV_ContentsGroup instance);
    #endregion
		
		public DataClassesCmsDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesCmsDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesCmsDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesCmsDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<ReviseResourceValue> ReviseResourceValues
		{
			get
			{
				return this.GetTable<ReviseResourceValue>();
			}
		}
		
		public System.Data.Linq.Table<ReviseResourceKey> ReviseResourceKeys
		{
			get
			{
				return this.GetTable<ReviseResourceKey>();
			}
		}
		
		public System.Data.Linq.Table<LOV_ContentsGroup> LOV_ContentsGroups
		{
			get
			{
				return this.GetTable<LOV_ContentsGroup>();
			}
		}
	}
	
	[Table(Name="dbo.ReviseResourceValue")]
	public partial class ReviseResourceValue : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _ResourceValueID;
		
		private int _ResourceKeyID;
		
		private string _CultureCode;
		
		private string _ResourceValue;
		
		private EntityRef<ReviseResourceKey> _ReviseResourceKey;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnResourceValueIDChanging(int value);
    partial void OnResourceValueIDChanged();
    partial void OnResourceKeyIDChanging(int value);
    partial void OnResourceKeyIDChanged();
    partial void OnCultureCodeChanging(string value);
    partial void OnCultureCodeChanged();
    partial void OnResourceValueChanging(string value);
    partial void OnResourceValueChanged();
    #endregion
		
		public ReviseResourceValue()
		{
			this._ReviseResourceKey = default(EntityRef<ReviseResourceKey>);
			OnCreated();
		}
		
		[Column(Storage="_ResourceValueID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int ResourceValueID
		{
			get
			{
				return this._ResourceValueID;
			}
			set
			{
				if ((this._ResourceValueID != value))
				{
					this.OnResourceValueIDChanging(value);
					this.SendPropertyChanging();
					this._ResourceValueID = value;
					this.SendPropertyChanged("ResourceValueID");
					this.OnResourceValueIDChanged();
				}
			}
		}
		
		[Column(Storage="_ResourceKeyID", DbType="Int NOT NULL")]
		public int ResourceKeyID
		{
			get
			{
				return this._ResourceKeyID;
			}
			set
			{
				if ((this._ResourceKeyID != value))
				{
					if (this._ReviseResourceKey.HasLoadedOrAssignedValue)
					{
						throw new System.Data.Linq.ForeignKeyReferenceAlreadyHasValueException();
					}
					this.OnResourceKeyIDChanging(value);
					this.SendPropertyChanging();
					this._ResourceKeyID = value;
					this.SendPropertyChanged("ResourceKeyID");
					this.OnResourceKeyIDChanged();
				}
			}
		}
		
		[Column(Storage="_CultureCode", DbType="NVarChar(10)")]
		public string CultureCode
		{
			get
			{
				return this._CultureCode;
			}
			set
			{
				if ((this._CultureCode != value))
				{
					this.OnCultureCodeChanging(value);
					this.SendPropertyChanging();
					this._CultureCode = value;
					this.SendPropertyChanged("CultureCode");
					this.OnCultureCodeChanged();
				}
			}
		}
		
		[Column(Storage="_ResourceValue", DbType="NVarChar(MAX)")]
		public string ResourceValue
		{
			get
			{
				return this._ResourceValue;
			}
			set
			{
				if ((this._ResourceValue != value))
				{
					this.OnResourceValueChanging(value);
					this.SendPropertyChanging();
					this._ResourceValue = value;
					this.SendPropertyChanged("ResourceValue");
					this.OnResourceValueChanged();
				}
			}
		}
		
		[Association(Name="ReviseResourceKey_ReviseResourceValue", Storage="_ReviseResourceKey", ThisKey="ResourceKeyID", OtherKey="ResourceKeyID", IsForeignKey=true)]
		public ReviseResourceKey ReviseResourceKey
		{
			get
			{
				return this._ReviseResourceKey.Entity;
			}
			set
			{
				ReviseResourceKey previousValue = this._ReviseResourceKey.Entity;
				if (((previousValue != value) 
							|| (this._ReviseResourceKey.HasLoadedOrAssignedValue == false)))
				{
					this.SendPropertyChanging();
					if ((previousValue != null))
					{
						this._ReviseResourceKey.Entity = null;
						previousValue.ReviseResourceValues.Remove(this);
					}
					this._ReviseResourceKey.Entity = value;
					if ((value != null))
					{
						value.ReviseResourceValues.Add(this);
						this._ResourceKeyID = value.ResourceKeyID;
					}
					else
					{
						this._ResourceKeyID = default(int);
					}
					this.SendPropertyChanged("ReviseResourceKey");
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
	}
	
	[Table(Name="dbo.ReviseResourceKey")]
	public partial class ReviseResourceKey : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _ResourceKeyID;
		
		private string _ResourceKey;
		
		private string _ResourceType;
		
		private bool _AllowHTML;
		
		private string _KeyDescription;
		
		private string _KeyTitle;
		
		private System.Nullable<int> _ContentsGroupID;
		
		private EntitySet<ReviseResourceValue> _ReviseResourceValues;
		
		private EntityRef<LOV_ContentsGroup> _LOV_ContentsGroup;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnResourceKeyIDChanging(int value);
    partial void OnResourceKeyIDChanged();
    partial void OnResourceKeyChanging(string value);
    partial void OnResourceKeyChanged();
    partial void OnResourceTypeChanging(string value);
    partial void OnResourceTypeChanged();
    partial void OnAllowHTMLChanging(bool value);
    partial void OnAllowHTMLChanged();
    partial void OnKeyDescriptionChanging(string value);
    partial void OnKeyDescriptionChanged();
    partial void OnKeyTitleChanging(string value);
    partial void OnKeyTitleChanged();
    partial void OnContentsGroupIDChanging(System.Nullable<int> value);
    partial void OnContentsGroupIDChanged();
    #endregion
		
		public ReviseResourceKey()
		{
			this._ReviseResourceValues = new EntitySet<ReviseResourceValue>(new Action<ReviseResourceValue>(this.attach_ReviseResourceValues), new Action<ReviseResourceValue>(this.detach_ReviseResourceValues));
			this._LOV_ContentsGroup = default(EntityRef<LOV_ContentsGroup>);
			OnCreated();
		}
		
		[Column(Storage="_ResourceKeyID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int ResourceKeyID
		{
			get
			{
				return this._ResourceKeyID;
			}
			set
			{
				if ((this._ResourceKeyID != value))
				{
					this.OnResourceKeyIDChanging(value);
					this.SendPropertyChanging();
					this._ResourceKeyID = value;
					this.SendPropertyChanged("ResourceKeyID");
					this.OnResourceKeyIDChanged();
				}
			}
		}
		
		[Column(Storage="_ResourceKey", DbType="NVarChar(200)")]
		public string ResourceKey
		{
			get
			{
				return this._ResourceKey;
			}
			set
			{
				if ((this._ResourceKey != value))
				{
					this.OnResourceKeyChanging(value);
					this.SendPropertyChanging();
					this._ResourceKey = value;
					this.SendPropertyChanged("ResourceKey");
					this.OnResourceKeyChanged();
				}
			}
		}
		
		[Column(Storage="_ResourceType", DbType="NVarChar(250)")]
		public string ResourceType
		{
			get
			{
				return this._ResourceType;
			}
			set
			{
				if ((this._ResourceType != value))
				{
					this.OnResourceTypeChanging(value);
					this.SendPropertyChanging();
					this._ResourceType = value;
					this.SendPropertyChanged("ResourceType");
					this.OnResourceTypeChanged();
				}
			}
		}
		
		[Column(Storage="_AllowHTML", DbType="Bit NOT NULL")]
		public bool AllowHTML
		{
			get
			{
				return this._AllowHTML;
			}
			set
			{
				if ((this._AllowHTML != value))
				{
					this.OnAllowHTMLChanging(value);
					this.SendPropertyChanging();
					this._AllowHTML = value;
					this.SendPropertyChanged("AllowHTML");
					this.OnAllowHTMLChanged();
				}
			}
		}
		
		[Column(Storage="_KeyDescription", DbType="NVarChar(255)")]
		public string KeyDescription
		{
			get
			{
				return this._KeyDescription;
			}
			set
			{
				if ((this._KeyDescription != value))
				{
					this.OnKeyDescriptionChanging(value);
					this.SendPropertyChanging();
					this._KeyDescription = value;
					this.SendPropertyChanged("KeyDescription");
					this.OnKeyDescriptionChanged();
				}
			}
		}
		
		[Column(Storage="_KeyTitle", DbType="NVarChar(255)")]
		public string KeyTitle
		{
			get
			{
				return this._KeyTitle;
			}
			set
			{
				if ((this._KeyTitle != value))
				{
					this.OnKeyTitleChanging(value);
					this.SendPropertyChanging();
					this._KeyTitle = value;
					this.SendPropertyChanged("KeyTitle");
					this.OnKeyTitleChanged();
				}
			}
		}
		
		[Column(Storage="_ContentsGroupID", DbType="Int")]
		public System.Nullable<int> ContentsGroupID
		{
			get
			{
				return this._ContentsGroupID;
			}
			set
			{
				if ((this._ContentsGroupID != value))
				{
					if (this._LOV_ContentsGroup.HasLoadedOrAssignedValue)
					{
						throw new System.Data.Linq.ForeignKeyReferenceAlreadyHasValueException();
					}
					this.OnContentsGroupIDChanging(value);
					this.SendPropertyChanging();
					this._ContentsGroupID = value;
					this.SendPropertyChanged("ContentsGroupID");
					this.OnContentsGroupIDChanged();
				}
			}
		}
		
		[Association(Name="ReviseResourceKey_ReviseResourceValue", Storage="_ReviseResourceValues", ThisKey="ResourceKeyID", OtherKey="ResourceKeyID")]
		public EntitySet<ReviseResourceValue> ReviseResourceValues
		{
			get
			{
				return this._ReviseResourceValues;
			}
			set
			{
				this._ReviseResourceValues.Assign(value);
			}
		}
		
		[Association(Name="LOV_ContentsGroup_ReviseResourceKey", Storage="_LOV_ContentsGroup", ThisKey="ContentsGroupID", OtherKey="LOV_ContentsGroupID", IsForeignKey=true)]
		public LOV_ContentsGroup LOV_ContentsGroup
		{
			get
			{
				return this._LOV_ContentsGroup.Entity;
			}
			set
			{
				LOV_ContentsGroup previousValue = this._LOV_ContentsGroup.Entity;
				if (((previousValue != value) 
							|| (this._LOV_ContentsGroup.HasLoadedOrAssignedValue == false)))
				{
					this.SendPropertyChanging();
					if ((previousValue != null))
					{
						this._LOV_ContentsGroup.Entity = null;
						previousValue.ReviseResourceKeys.Remove(this);
					}
					this._LOV_ContentsGroup.Entity = value;
					if ((value != null))
					{
						value.ReviseResourceKeys.Add(this);
						this._ContentsGroupID = value.LOV_ContentsGroupID;
					}
					else
					{
						this._ContentsGroupID = default(Nullable<int>);
					}
					this.SendPropertyChanged("LOV_ContentsGroup");
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
		
		private void attach_ReviseResourceValues(ReviseResourceValue entity)
		{
			this.SendPropertyChanging();
			entity.ReviseResourceKey = this;
		}
		
		private void detach_ReviseResourceValues(ReviseResourceValue entity)
		{
			this.SendPropertyChanging();
			entity.ReviseResourceKey = null;
		}
	}
	
	[Table(Name="dbo.LOV_ContentsGroup")]
	public partial class LOV_ContentsGroup : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _LOV_ContentsGroupID;
		
		private string _Code;
		
		private string _Name;
		
		private System.Nullable<int> _StartYear;
		
		private System.Nullable<int> _EndYear;
		
		private EntitySet<ReviseResourceKey> _ReviseResourceKeys;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnLOV_ContentsGroupIDChanging(int value);
    partial void OnLOV_ContentsGroupIDChanged();
    partial void OnCodeChanging(string value);
    partial void OnCodeChanged();
    partial void OnNameChanging(string value);
    partial void OnNameChanged();
    partial void OnStartYearChanging(System.Nullable<int> value);
    partial void OnStartYearChanged();
    partial void OnEndYearChanging(System.Nullable<int> value);
    partial void OnEndYearChanged();
    #endregion
		
		public LOV_ContentsGroup()
		{
			this._ReviseResourceKeys = new EntitySet<ReviseResourceKey>(new Action<ReviseResourceKey>(this.attach_ReviseResourceKeys), new Action<ReviseResourceKey>(this.detach_ReviseResourceKeys));
			OnCreated();
		}
		
		[Column(Storage="_LOV_ContentsGroupID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int LOV_ContentsGroupID
		{
			get
			{
				return this._LOV_ContentsGroupID;
			}
			set
			{
				if ((this._LOV_ContentsGroupID != value))
				{
					this.OnLOV_ContentsGroupIDChanging(value);
					this.SendPropertyChanging();
					this._LOV_ContentsGroupID = value;
					this.SendPropertyChanged("LOV_ContentsGroupID");
					this.OnLOV_ContentsGroupIDChanged();
				}
			}
		}
		
		[Column(Storage="_Code", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string Code
		{
			get
			{
				return this._Code;
			}
			set
			{
				if ((this._Code != value))
				{
					this.OnCodeChanging(value);
					this.SendPropertyChanging();
					this._Code = value;
					this.SendPropertyChanged("Code");
					this.OnCodeChanged();
				}
			}
		}
		
		[Column(Storage="_Name", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
		public string Name
		{
			get
			{
				return this._Name;
			}
			set
			{
				if ((this._Name != value))
				{
					this.OnNameChanging(value);
					this.SendPropertyChanging();
					this._Name = value;
					this.SendPropertyChanged("Name");
					this.OnNameChanged();
				}
			}
		}
		
		[Column(Storage="_StartYear", DbType="Int")]
		public System.Nullable<int> StartYear
		{
			get
			{
				return this._StartYear;
			}
			set
			{
				if ((this._StartYear != value))
				{
					this.OnStartYearChanging(value);
					this.SendPropertyChanging();
					this._StartYear = value;
					this.SendPropertyChanged("StartYear");
					this.OnStartYearChanged();
				}
			}
		}
		
		[Column(Storage="_EndYear", DbType="Int")]
		public System.Nullable<int> EndYear
		{
			get
			{
				return this._EndYear;
			}
			set
			{
				if ((this._EndYear != value))
				{
					this.OnEndYearChanging(value);
					this.SendPropertyChanging();
					this._EndYear = value;
					this.SendPropertyChanged("EndYear");
					this.OnEndYearChanged();
				}
			}
		}
		
		[Association(Name="LOV_ContentsGroup_ReviseResourceKey", Storage="_ReviseResourceKeys", ThisKey="LOV_ContentsGroupID", OtherKey="ContentsGroupID")]
		public EntitySet<ReviseResourceKey> ReviseResourceKeys
		{
			get
			{
				return this._ReviseResourceKeys;
			}
			set
			{
				this._ReviseResourceKeys.Assign(value);
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
		
		private void attach_ReviseResourceKeys(ReviseResourceKey entity)
		{
			this.SendPropertyChanging();
			entity.LOV_ContentsGroup = this;
		}
		
		private void detach_ReviseResourceKeys(ReviseResourceKey entity)
		{
			this.SendPropertyChanging();
			entity.LOV_ContentsGroup = null;
		}
	}
}
#pragma warning restore 1591
