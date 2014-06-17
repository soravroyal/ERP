﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     Este código fue generado por una herramienta.
//     Versión de runtime:4.0.30319.18052
//
//     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
//     se vuelve a generar el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QueryLayer.WebAppCode.EPRTR.ResourceProviders
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
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="EPRTRcms")]
	public partial class DBResourceDataClassesDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Definiciones de métodos de extensibilidad
    partial void OnCreated();
    partial void InsertReviseResourceKey(ReviseResourceKey instance);
    partial void UpdateReviseResourceKey(ReviseResourceKey instance);
    partial void DeleteReviseResourceKey(ReviseResourceKey instance);
    partial void InsertReviseResourceValue(ReviseResourceValue instance);
    partial void UpdateReviseResourceValue(ReviseResourceValue instance);
    partial void DeleteReviseResourceValue(ReviseResourceValue instance);
    #endregion
		
		public DBResourceDataClassesDataContext() : 
				base(global::EPRTR.ResourceProviders.Properties.Settings.Default.EPRTRcmsConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public DBResourceDataClassesDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DBResourceDataClassesDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DBResourceDataClassesDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DBResourceDataClassesDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<StringResource> StringResources
		{
			get
			{
				return this.GetTable<StringResource>();
			}
		}
		
		public System.Data.Linq.Table<ReviseResourceKey> ReviseResourceKeys
		{
			get
			{
				return this.GetTable<ReviseResourceKey>();
			}
		}
		
		public System.Data.Linq.Table<ReviseResourceValue> ReviseResourceValues
		{
			get
			{
				return this.GetTable<ReviseResourceValue>();
			}
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.StringResource")]
	public partial class StringResource
	{
		
		private string _ResourceType;
		
		private string _ResourceKey;
		
		private string _CultureCode;
		
		private string _ResourceValue;
		
		public StringResource()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceType", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
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
					this._ResourceType = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceKey", DbType="NVarChar(255) NOT NULL", CanBeNull=false)]
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
					this._ResourceKey = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_CultureCode", DbType="NVarChar(10)")]
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
					this._CultureCode = value;
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceValue", DbType="NVarChar(MAX) NOT NULL", CanBeNull=false)]
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
					this._ResourceValue = value;
				}
			}
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.ReviseResourceKey")]
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
		
    #region Definiciones de métodos de extensibilidad
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
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceKeyID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceKey", DbType="NVarChar(200)")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceType", DbType="NVarChar(250)")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_AllowHTML", DbType="Bit NOT NULL")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_KeyDescription", DbType="NVarChar(255)")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_KeyTitle", DbType="NVarChar(255)")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ContentsGroupID", DbType="Int")]
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
					this.OnContentsGroupIDChanging(value);
					this.SendPropertyChanging();
					this._ContentsGroupID = value;
					this.SendPropertyChanged("ContentsGroupID");
					this.OnContentsGroupIDChanged();
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
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.ReviseResourceValue")]
	public partial class ReviseResourceValue : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _ResourceValueID;
		
		private int _ResourceKeyID;
		
		private string _CultureCode;
		
		private string _ResourceValue;
		
    #region Definiciones de métodos de extensibilidad
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
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceValueID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceKeyID", DbType="Int NOT NULL")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_CultureCode", DbType="NVarChar(10)")]
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
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_ResourceValue", DbType="NVarChar(MAX)")]
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
}
#pragma warning restore 1591
