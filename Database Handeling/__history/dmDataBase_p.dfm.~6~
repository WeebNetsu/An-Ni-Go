object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 279
  Width = 608
  object con: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Delphi Project\D' +
      'atabase Handeling\dbCards.mdb;Mode=ReadWrite;Persist Security In' +
      'fo=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 8
  end
  object tbl: TADOTable
    Active = True
    Connection = con
    CursorType = ctStatic
    TableName = 'tblCards'
    Left = 48
    Top = 8
    object tbldetail: TWideMemoField
      FieldName = 'detail'
      BlobType = ftWideMemo
    end
    object tblcardID: TAutoIncField
      FieldName = 'cardID'
      ReadOnly = True
    end
    object tblcardName: TWideStringField
      FieldName = 'cardName'
      Size = 30
    end
    object tbltrapCard: TBooleanField
      FieldName = 'trapCard'
    end
    object tbleffectCard: TBooleanField
      FieldName = 'effectCard'
    end
    object tblatk: TIntegerField
      FieldName = 'atk'
    end
    object tbldef: TIntegerField
      FieldName = 'def'
    end
    object tblstars: TIntegerField
      FieldName = 'stars'
    end
    object tblimageSRC: TWideStringField
      FieldName = 'imageSRC'
      Size = 50
    end
  end
  object dsc: TDataSource
    DataSet = tbl
    Left = 88
    Top = 8
  end
end
