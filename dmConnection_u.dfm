object dmCards: TdmCards
  OldCreateOrder = False
  Height = 201
  Width = 168
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
    Left = 32
    Top = 24
  end
  object tblWinLose: TADOTable
    Active = True
    Connection = con
    CursorType = ctStatic
    TableName = 'tblWinOrLose'
    Left = 32
    Top = 72
  end
  object tblCards: TADOTable
    Active = True
    Connection = con
    CursorType = ctStatic
    TableName = 'tblCards'
    Left = 32
    Top = 128
  end
  object dscWinLose: TDataSource
    DataSet = tblWinLose
    Left = 96
    Top = 72
  end
  object dscCards: TDataSource
    DataSet = tblCards
    Left = 96
    Top = 128
  end
end
