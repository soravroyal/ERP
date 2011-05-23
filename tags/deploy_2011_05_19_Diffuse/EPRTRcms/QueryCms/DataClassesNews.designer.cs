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
	public partial class DataClassesNewsDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    partial void InsertNewsKey(NewsKey instance);
    partial void UpdateNewsKey(NewsKey instance);
    partial void DeleteNewsKey(NewsKey instance);
    partial void InsertNewsValue(NewsValue instance);
    partial void UpdateNewsValue(NewsValue instance);
    partial void DeleteNewsValue(NewsValue instance);
    #endregion
		
		public DataClassesNewsDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesNewsDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesNewsDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public DataClassesNewsDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<NewsKey> NewsKeys
		{
			get
			{
				return this.GetTable<NewsKey>();
			}
		}
		
		public System.Data.Linq.Table<NewsValue> NewsValues
		{
			get
			{
				return this.GetTable<NewsValue>();
			}
		}
	}
	
	[Table(Name="dbo.NewsKey")]
	public partial class NewsKey : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _NewsKeyID;
		
		private bool _TopNewsIndicator;
		
		private System.DateTime _NewsDate;
		
		private bool _Visible;
		
		private EntitySet<NewsValue> _NewsValues;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnNewsKeyIDChanging(int value);
    partial void OnNewsKeyIDChanged();
    partial void OnTopNewsIndicatorChanging(bool value);
    partial void OnTopNewsIndicatorChanged();
    partial void OnNewsDateChanging(System.DateTime value);
    partial void OnNewsDateChanged();
    partial void OnVisibleChanging(bool value);
    partial void OnVisibleChanged();
    #endregion
		
		public NewsKey()
		{
			this._NewsValues = new EntitySet<NewsValue>(new Action<NewsValue>(this.attach_NewsValues), new Action<NewsValue>(this.detach_NewsValues));
			OnCreated();
		}
		
		[Column(Storage="_NewsKeyID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int NewsKeyID
		{
			get
			{
				return this._NewsKeyID;
			}
			set
			{
				if ((this._NewsKeyID != value))
				{
					this.OnNewsKeyIDChanging(value);
					this.SendPropertyChanging();
					this._NewsKeyID = value;
					this.SendPropertyChanged("NewsKeyID");
					this.OnNewsKeyIDChanged();
				}
			}
		}
		
		[Column(Storage="_TopNewsIndicator", DbType="Bit NOT NULL")]
		public bool TopNewsIndicator
		{
			get
			{
				return this._TopNewsIndicator;
			}
			set
			{
				if ((this._TopNewsIndicator != value))
				{
					this.OnTopNewsIndicatorChanging(value);
					this.SendPropertyChanging();
					this._TopNewsIndicator = value;
					this.SendPropertyChanged("TopNewsIndicator");
					this.OnTopNewsIndicatorChanged();
				}
			}
		}
		
		[Column(Storage="_NewsDate", DbType="DateTime NOT NULL")]
		public System.DateTime NewsDate
		{
			get
			{
				return this._NewsDate;
			}
			set
			{
				if ((this._NewsDate != value))
				{
					this.OnNewsDateChanging(value);
					this.SendPropertyChanging();
					this._NewsDate = value;
					this.SendPropertyChanged("NewsDate");
					this.OnNewsDateChanged();
				}
			}
		}
		
		[Column(Storage="_Visible", DbType="Bit NOT NULL")]
		public bool Visible
		{
			get
			{
				return this._Visible;
			}
			set
			{
				if ((this._Visible != value))
				{
					this.OnVisibleChanging(value);
					this.SendPropertyChanging();
					this._Visible = value;
					this.SendPropertyChanged("Visible");
					this.OnVisibleChanged();
				}
			}
		}
		
		[Association(Name="NewsKey_NewsValue", Storage="_NewsValues", ThisKey="NewsKeyID", OtherKey="NewsKeyID")]
		public EntitySet<NewsValue> NewsValues
		{
			get
			{
				return this._NewsValues;
			}
			set
			{
				this._NewsValues.Assign(value);
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
		
		private void attach_NewsValues(NewsValue entity)
		{
			this.SendPropertyChanging();
			entity.NewsKey = this;
		}
		
		private void detach_NewsValues(NewsValue entity)
		{
			this.SendPropertyChanging();
			entity.NewsKey = null;
		}
	}
	
	[Table(Name="dbo.NewsValue")]
	public partial class NewsValue : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _NewsValueID;
		
		private int _NewsKeyID;
		
		private string _CultureCode;
		
		private string _HeaderText;
		
		private string _BodyText;
		
		private string _AuthorName;
		
		private System.Nullable<System.DateTime> _CreateDate;
		
		private EntityRef<NewsKey> _NewsKey;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnNewsValueIDChanging(int value);
    partial void OnNewsValueIDChanged();
    partial void OnNewsKeyIDChanging(int value);
    partial void OnNewsKeyIDChanged();
    partial void OnCultureCodeChanging(string value);
    partial void OnCultureCodeChanged();
    partial void OnHeaderTextChanging(string value);
    partial void OnHeaderTextChanged();
    partial void OnBodyTextChanging(string value);
    partial void OnBodyTextChanged();
    partial void OnAuthorNameChanging(string value);
    partial void OnAuthorNameChanged();
    partial void OnCreateDateChanging(System.Nullable<System.DateTime> value);
    partial void OnCreateDateChanged();
    #endregion
		
		public NewsValue()
		{
			this._NewsKey = default(EntityRef<NewsKey>);
			OnCreated();
		}
		
		[Column(Storage="_NewsValueID", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int NewsValueID
		{
			get
			{
				return this._NewsValueID;
			}
			set
			{
				if ((this._NewsValueID != value))
				{
					this.OnNewsValueIDChanging(value);
					this.SendPropertyChanging();
					this._NewsValueID = value;
					this.SendPropertyChanged("NewsValueID");
					this.OnNewsValueIDChanged();
				}
			}
		}
		
		[Column(Storage="_NewsKeyID", DbType="Int NOT NULL")]
		public int NewsKeyID
		{
			get
			{
				return this._NewsKeyID;
			}
			set
			{
				if ((this._NewsKeyID != value))
				{
					if (this._NewsKey.HasLoadedOrAssignedValue)
					{
						throw new System.Data.Linq.ForeignKeyReferenceAlreadyHasValueException();
					}
					this.OnNewsKeyIDChanging(value);
					this.SendPropertyChanging();
					this._NewsKeyID = value;
					this.SendPropertyChanged("NewsKeyID");
					this.OnNewsKeyIDChanged();
				}
			}
		}
		
		[Column(Storage="_CultureCode", DbType="NVarChar(10) NOT NULL", CanBeNull=false)]
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
		
		[Column(Storage="_HeaderText", DbType="NVarChar(MAX) NOT NULL", CanBeNull=false)]
		public string HeaderText
		{
			get
			{
				return this._HeaderText;
			}
			set
			{
				if ((this._HeaderText != value))
				{
					this.OnHeaderTextChanging(value);
					this.SendPropertyChanging();
					this._HeaderText = value;
					this.SendPropertyChanged("HeaderText");
					this.OnHeaderTextChanged();
				}
			}
		}
		
		[Column(Storage="_BodyText", DbType="NVarChar(MAX) NOT NULL", CanBeNull=false)]
		public string BodyText
		{
			get
			{
				return this._BodyText;
			}
			set
			{
				if ((this._BodyText != value))
				{
					this.OnBodyTextChanging(value);
					this.SendPropertyChanging();
					this._BodyText = value;
					this.SendPropertyChanged("BodyText");
					this.OnBodyTextChanged();
				}
			}
		}
		
		[Column(Storage="_AuthorName", DbType="NVarChar(MAX)")]
		public string AuthorName
		{
			get
			{
				return this._AuthorName;
			}
			set
			{
				if ((this._AuthorName != value))
				{
					this.OnAuthorNameChanging(value);
					this.SendPropertyChanging();
					this._AuthorName = value;
					this.SendPropertyChanged("AuthorName");
					this.OnAuthorNameChanged();
				}
			}
		}
		
		[Column(Storage="_CreateDate", DbType="DateTime")]
		public System.Nullable<System.DateTime> CreateDate
		{
			get
			{
				return this._CreateDate;
			}
			set
			{
				if ((this._CreateDate != value))
				{
					this.OnCreateDateChanging(value);
					this.SendPropertyChanging();
					this._CreateDate = value;
					this.SendPropertyChanged("CreateDate");
					this.OnCreateDateChanged();
				}
			}
		}
		
		[Association(Name="NewsKey_NewsValue", Storage="_NewsKey", ThisKey="NewsKeyID", OtherKey="NewsKeyID", IsForeignKey=true)]
		public NewsKey NewsKey
		{
			get
			{
				return this._NewsKey.Entity;
			}
			set
			{
				NewsKey previousValue = this._NewsKey.Entity;
				if (((previousValue != value) 
							|| (this._NewsKey.HasLoadedOrAssignedValue == false)))
				{
					this.SendPropertyChanging();
					if ((previousValue != null))
					{
						this._NewsKey.Entity = null;
						previousValue.NewsValues.Remove(this);
					}
					this._NewsKey.Entity = value;
					if ((value != null))
					{
						value.NewsValues.Add(this);
						this._NewsKeyID = value.NewsKeyID;
					}
					else
					{
						this._NewsKeyID = default(int);
					}
					this.SendPropertyChanged("NewsKey");
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
