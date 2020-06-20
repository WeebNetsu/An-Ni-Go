object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 77
  Width = 178
  object con: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=dbCar' +
      'ds.mdb;Mode=ReadWrite;Persist Security Info=False;Jet OLEDB:Syst' +
      'em database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Pas' +
      'sword="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode' +
      '=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Tra' +
      'nsactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create ' +
      'System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB' +
      ':Don'#39't Copy Locale on Compact=False;Jet OLEDB:Compact Without Re' +
      'plica Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 16
    Top = 16
  end
  object tblCards: TADOTable
    Active = True
    Connection = con
    CursorType = ctStatic
    TableName = 'tblCards'
    Left = 64
    Top = 16
  end
  object dscCards: TDataSource
    DataSet = tblCards
    Left = 120
    Top = 16
  end
end
