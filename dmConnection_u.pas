unit dmConnection_u;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TdmCards = class(TDataModule)
    con: TADOConnection;
    tblWinLose: TADOTable;
    tblCards: TADOTable;
    dscWinLose: TDataSource;
    dscCards: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmCards: TdmCards;

implementation

{$R *.dfm}

end.
