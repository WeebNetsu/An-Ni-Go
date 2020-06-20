unit frmEnter_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, dmConnection_u, Grids, DBGrids, DBCtrls,
  Buttons;

type
  TfrmEnter = class(TForm)
    imgBanner: TImage;
    lblCaption: TLabel;
    pnlWinLose: TPanel;
    pnlEnterGame: TPanel;
    lblWon: TLabel;
    lblLost: TLabel;
    lblWonNum: TLabel;
    lblLostNum: TLabel;
    btnStart: TButton;
    Label1: TLabel;
    memHowToPlay: TMemo;
    pnlHowToPlay: TPanel;
    lblHowToPlay: TLabel;
    DBGrid1: TDBGrid;
    bitbtnReset: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure bitbtnResetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnter: TfrmEnter;

implementation

uses
  frmGame_u, frmWinLose_u;
{$R *.dfm}

procedure TfrmEnter.bitbtnResetClick(Sender: TObject);
var
  iButtonSelected: integer;
begin
  // Confirm that the user wants to do delete their stats
  iButtonSelected := messagedlg(
    'Are you sure you want to reset your stats? (THIS CAN NOT BE UNDONE)',
    mtWarning, mbOKCancel, 0);

  if iButtonSelected = 1 then
  begin
    with dmCards do
    begin
      tblWinLose.Open;
      tblWinLose.Edit;
      tblWinLose['won'] := 0;
      tblWinLose['lost'] := 0;
      tblWinLose.Post;
    end; // end of with

    ShowMessage('Your stats were deleted');
    lblWonNum.Caption := dmCards.tblWinLose['won'];
    lblLostNum.Caption := dmCards.tblWinLose['lost'];
  end // end of if
  else
  begin
    ShowMessage('Your stats was NOT deleted');
  end;
end;

procedure TfrmEnter.btnStartClick(Sender: TObject);
begin
//goes to the next form
  Self.Hide;
  frmGame.Show;
end;

procedure TfrmEnter.FormActivate(Sender: TObject);
var
  iPageCenter: integer;
  tFile: textfile;
  sLine: string;
begin
//gets the center of the page
  iPageCenter := frmEnter.Width div 3;

  // Use this to make the GUI so you can easily manipulate components
  imgBanner.Width := Screen.Width;
  lblCaption.Left := iPageCenter;
  pnlEnterGame.Left := iPageCenter;
  pnlHowToPlay.Width := 250;
  memHowToPlay.Width := 243;
  memHowToPlay.Height := 170;

  // We don't want the player to edit this...
  memHowToPlay.ReadOnly := true;
  memHowToPlay.Clear;
  AssignFile(tFile, 'how-to-play.txt');
  Reset(tFile);

  while not eof(tFile) do
  begin
    Readln(tFile, sLine);
    memHowToPlay.Lines.Add(sLine);
  end;

  lblWonNum.Caption := dmCards.tblWinLose['won'];
  lblLostNum.Caption := dmCards.tblWinLose['lost'];
end;

end.
