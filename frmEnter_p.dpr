program frmEnter_p;

uses
  Forms,
  frmEnter_u in 'frmEnter_u.pas' {frmEnter},
  frmGame_u in 'frmGame_u.pas' {frmGame},
  dmConnection_u in 'dmConnection_u.pas' {dmCards: TDataModule},
  frmWinLose_u in 'frmWinLose_u.pas' {frmWinLose};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'An-Ni-Go!';
  Application.HelpFile := 'C:\Users\Stephen\Documents\Coding\Delphi Project\An-Ni-Go!\README.htm';
  Application.CreateForm(TfrmEnter, frmEnter);
  Application.CreateForm(TfrmGame, frmGame);
  Application.CreateForm(TdmCards, dmCards);
  Application.CreateForm(TfrmWinLose, frmWinLose);
  Application.Run;
end.
