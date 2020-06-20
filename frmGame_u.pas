﻿unit frmGame_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, dmConnection_u, ComCtrls, math, Buttons;

type
  TfrmGame = class(TForm)
    pnlBoard: TPanel;
    pnlEnimyCardHolder: TPanel;
    imgPDeck: TImage;
    imgEDeck: TImage;
    lblPlayerHP: TLabel;
    lblPP: TLabel;
    lblCP: TLabel;
    lblComHP: TLabel;
    imgE1: TImage;
    imgE2: TImage;
    imgE5: TImage;
    imgE4: TImage;
    imgE3: TImage;
    imgE6: TImage;
    pnlPlayerCardHolder: TPanel;
    imgP1: TImage;
    imgP2: TImage;
    imgP5: TImage;
    imgP4: TImage;
    imgP3: TImage;
    imgP6: TImage;
    imgFE1: TImage;
    imgFE2: TImage;
    imgFE3: TImage;
    imgFP3: TImage;
    imgFP2: TImage;
    imgFP1: TImage;
    btnHelp: TButton;
    btnBattlePhase: TButton;
    btnEndTurn: TButton;
    lblWait: TLabel;
    pnlCardVal1: TPanel;
    pnlCardVal4: TPanel;
    pnlCardVal5: TPanel;
    pnlCardVal2: TPanel;
    pnlCardVal3: TPanel;
    pnlCardVal6: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure imgP1Click(Sender: TObject);
    procedure imgP2Click(Sender: TObject);
    procedure imgP3Click(Sender: TObject);
    procedure imgP4Click(Sender: TObject);
    procedure imgP5Click(Sender: TObject);
    procedure imgP6Click(Sender: TObject);
    procedure imgPDeckClick(Sender: TObject);
    procedure btnEndTurnClick(Sender: TObject);
    procedure btnBattlePhaseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    iDeckCard, iComDeckCard, iTurn, iMove, iGameTurn, iComHP,
      iPlayerHP: integer;
    bDraw, bCard1Atk, bCard2Atk, bCard3Atk, bCalledWinner: boolean;
    // did they already attack?

    arrPlayerCards: array [1 .. 60] of String; // Player deck
    arrPlayerHand: array [1 .. 6] of string;
    arrPlayerHandAtk: array [1 .. 6] of integer;
    arrPlayerCardOnFieldAtk: array [1 .. 3] of integer;
    arrComCards: array [1 .. 60] of String; // computer deck
    arrComHand: array [1 .. 1] of String; // Cards in computers hand
    arrComHandAtk: array [1 .. 1] of integer;
    arrComCardOnFieldAtk: array [1 .. 3] of integer;

    procedure removeCard;
    procedure addCardsToArray;
    procedure draw;
    procedure battlePhase;
    procedure addCardToField(iCard: integer);
    procedure newGame;
    procedure COM;
    procedure comDraw;
    procedure comAddCardToField;
    procedure comComparePower;
    procedure comAttack(iCom: integer; iPlayer: integer);
    procedure HP;
    procedure setWinStats;

    function getWinner: boolean;
    function isCardOnField: boolean;
  public
    { Public declarations }
    bGameEndWinner: boolean;
  end;

var
  frmGame: TfrmGame;

implementation

uses
  frmEnter_u, frmWinLose_u;
{$R *.dfm}

procedure TfrmGame.addCardsToArray();
var
  I: integer;
begin
  with dmCards do
  begin
    tblCards.Open;
    tblCards.First;
    for I := 1 to 159 do
    begin
      tblCards.Edit;
      // makes sure all the cards are NOT in use
      tblCards['used'] := False;
      tblCards.Next;
    end;

    // Adds cards to player deck
    I := 1;
    while I <= 60 do // deck can only hold 60 cards
    Begin
      // Gets random cards
      if tblCards.locate('cardID', RandomRange(9, 160), []) then
      begin
        // if the card is not already in use, then add it to the players hand
        if tblCards['used'] = False then
        begin
          // make it used
          tblCards.Edit;
          // makes card used
          tblCards['used'] := True;
          tblCards.Post;
          arrPlayerCards[I] := tblCards['imageSRC'] + ';' + inttostr
            (tblCards['atk']);
          Inc(I);
        end;
      end;
    End; // end of while loop

    // Adds cards to COM deck
    I := 1;
    while I <= 60 do // deck can only hold 60 cards
    Begin
      // Gets random cards
      if tblCards.locate('cardID', RandomRange(9, 160), []) then
      begin
        // if the card is not already in use, then add it to the COM hand
        if tblCards['used'] = False then
        begin
          // make it used
          tblCards.Edit;
          tblCards['used'] := True;
          tblCards.Post;
          arrComCards[I] := tblCards['imageSRC'] + ';' + inttostr
            (tblCards['atk']);
          Inc(I);
        end;
      end;
    End; // end of while loop
  end;
end;

procedure TfrmGame.draw;
begin
  // finds the invisible image which represents an open space
  if imgP1.Visible = False then
  begin
    arrPlayerHand[1] := copy(arrPlayerCards[iDeckCard], 1,
      Pos(';', arrPlayerCards[iDeckCard]) - 1);
    arrPlayerHandAtk[1] := strToint(copy(arrPlayerCards[iDeckCard], Pos(';',
          arrPlayerCards[iDeckCard]) + 1, 5));

    pnlCardVal1.Caption := inttostr(arrPlayerHandAtk[1]);
    imgP1.Picture.LoadFromFile(arrPlayerHand[1]);

    Inc(iDeckCard);
    imgP1.Visible := True;
  end
  else if imgP2.Visible = False then
  begin
    arrPlayerHand[2] := copy(arrPlayerCards[iDeckCard], 1,
      Pos(';', arrPlayerCards[iDeckCard]) - 1);
    arrPlayerHandAtk[2] := strToint(copy(arrPlayerCards[iDeckCard], Pos(';',
          arrPlayerCards[iDeckCard]) + 1, 5));

    pnlCardVal2.Caption := inttostr(arrPlayerHandAtk[2]);
    imgP2.Picture.LoadFromFile(arrPlayerHand[2]);

    Inc(iDeckCard);
    imgP2.Visible := True;
  end
  else if imgP3.Visible = False then
  begin
    arrPlayerHand[3] := copy(arrPlayerCards[iDeckCard], 1,
      Pos(';', arrPlayerCards[iDeckCard]) - 1);
    arrPlayerHandAtk[3] := strToint(copy(arrPlayerCards[iDeckCard], Pos(';',
          arrPlayerCards[iDeckCard]) + 1, 5));

    pnlCardVal3.Caption := inttostr(arrPlayerHandAtk[3]);
    imgP3.Picture.LoadFromFile(arrPlayerHand[3]);

    Inc(iDeckCard);
    imgP3.Visible := True;
  end
  else if imgP4.Visible = False then
  begin
    arrPlayerHand[4] := copy(arrPlayerCards[iDeckCard], 1,
      Pos(';', arrPlayerCards[iDeckCard]) - 1);
    arrPlayerHandAtk[4] := strToint(copy(arrPlayerCards[iDeckCard], Pos(';',
          arrPlayerCards[iDeckCard]) + 1, 5));

    pnlCardVal4.Caption := inttostr(arrPlayerHandAtk[4]);
    imgP4.Picture.LoadFromFile(arrPlayerHand[4]);

    Inc(iDeckCard);
    imgP4.Visible := True;
  end
  else if imgP5.Visible = False then
  begin
    arrPlayerHand[5] := copy(arrPlayerCards[iDeckCard], 1,
      Pos(';', arrPlayerCards[iDeckCard]) - 1);
    arrPlayerHandAtk[5] := strToint(copy(arrPlayerCards[iDeckCard], Pos(';',
          arrPlayerCards[iDeckCard]) + 1, 5));

    pnlCardVal5.Caption := inttostr(arrPlayerHandAtk[5]);
    imgP5.Picture.LoadFromFile(arrPlayerHand[5]);

    Inc(iDeckCard);
    imgP5.Visible := True;
  end
  else if imgP6.Visible = False then
  begin
    arrPlayerHand[6] := copy(arrPlayerCards[iDeckCard], 1,
      Pos(';', arrPlayerCards[iDeckCard]) - 1);
    arrPlayerHandAtk[6] := strToint(copy(arrPlayerCards[iDeckCard], Pos(';',
          arrPlayerCards[iDeckCard]) + 1, 5));

    pnlCardVal6.Caption := inttostr(arrPlayerHandAtk[6]);
    imgP6.Picture.LoadFromFile(arrPlayerHand[6]);

    Inc(iDeckCard);
    imgP6.Visible := True;
  end
  else
  begin
    // gets the player to remove a card from his/her hand if they already have 6
    ShowMessage('Please discard 1 card from your hand.');
    removeCard;
  end;

  // makes sure none of the cards on the field has attacked yet
  bCard1Atk := False;
  bCard2Atk := False;
  bCard3Atk := False;
  bDraw := True;
end;

procedure TfrmGame.btnBattlePhaseClick(Sender: TObject);
begin
  // the computer has nothing to defend itself with, so the player cannot attack yet
  if iGameTurn = 1 then
  begin
    ShowMessage('You cannot play first');
    Exit;
  end;

  // player can only battle after they have drawn
  if bDraw = True then
  begin
    battlePhase;
  end
  else
  begin
    ShowMessage('You have to draw first');
  end;

  // lblPlayerPoints (shows player amount of HP they have)
  lblPP.Caption := inttostr(iPlayerHP);
  lblCP.Caption := inttostr(iComHP);
  HP;
end;

procedure TfrmGame.btnEndTurnClick(Sender: TObject);
begin
  // ends the players turn and allows the computer to continue
  if iTurn = 1 then
  begin
    if bDraw then
    begin
      if isCardOnField then
      begin
        Inc(iGameTurn); // if iGameturn mod 2 = 0 : COM turn
        btnBattlePhase.Enabled := True;
        lblWait.Visible := True;
        bDraw := False;
        iMove := 0;

        COM;
      end;
    end
    else
    begin
      ShowMessage('You have to draw first');
    end;
  end;
end;

procedure TfrmGame.btnHelpClick(Sender: TObject);
var
  tHelpFile: textfile;
  sLine: string;
begin
  AssignFile(tHelpFile, 'how-to-play.txt');
  Reset(tHelpFile);

  while not eof(tHelpFile) do
  begin
    Readln(tHelpFile, sLine);
    ShowMessage(sLine);
  end;
end;

procedure TfrmGame.COM;
begin
  comDraw; // draws card
  comAddCardToField;
  comComparePower; // makes sure AI can attack before actually attacking
  Inc(iGameTurn);

  lblPP.Caption := inttostr(iPlayerHP);
  lblCP.Caption := inttostr(iComHP);

  HP;
end;

procedure TfrmGame.comAddCardToField;
begin
  // makes sure there is an open space, then adds a card to the field
  if not(imgFE1.Visible) then
  begin
    imgFE1.Picture.LoadFromFile(copy(arrComHand[1], 1,
        Pos(';', arrComHand[1]) - 1));
    imgFE1.Visible := True;
    arrComCardOnFieldAtk[1] := arrComHandAtk[1];
  end
  else if not(imgFE2.Visible) then
  begin
    imgFE2.Picture.LoadFromFile(copy(arrComHand[1], 1,
        Pos(';', arrComHand[1]) - 1));
    imgFE2.Visible := True;
    arrComCardOnFieldAtk[2] := arrComHandAtk[1];
  end
  else if not(imgFE3.Visible) then
  begin
    imgFE3.Picture.LoadFromFile(copy(arrComHand[1], 1,
        Pos(';', arrComHand[1]) - 1));
    imgFE3.Visible := True;
    arrComCardOnFieldAtk[3] := arrComHandAtk[1];
  end;
end;

procedure TfrmGame.comAttack(iCom, iPlayer: integer);
var
  iDamage: integer;
begin
  // allows COM to attack the player and destroy their card(s)
  if (iCom = 1) and (iPlayer = 1) then
  begin
    iCom := arrComCardOnFieldAtk[1];
    iPlayer := arrPlayerCardOnFieldAtk[1];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP1.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 1) and (iPlayer = 2) then
  begin
    iCom := arrComCardOnFieldAtk[1];
    iPlayer := arrPlayerCardOnFieldAtk[2];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP2.Visible := False;
    ShowMessage('COM destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 1) and (iPlayer = 3) then
  begin
    iCom := arrComCardOnFieldAtk[1];
    iPlayer := arrPlayerCardOnFieldAtk[3];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP3.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 2) and (iPlayer = 1) then
  begin
    iCom := arrComCardOnFieldAtk[2];
    iPlayer := arrPlayerCardOnFieldAtk[1];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP1.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 2) and (iPlayer = 2) then
  begin
    iCom := arrComCardOnFieldAtk[2];
    iPlayer := arrPlayerCardOnFieldAtk[2];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP2.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 2) and (iPlayer = 3) then
  begin
    iCom := arrComCardOnFieldAtk[2];
    iPlayer := arrPlayerCardOnFieldAtk[3];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP3.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 3) and (iPlayer = 1) then
  begin
    iCom := arrComCardOnFieldAtk[3];
    iPlayer := arrPlayerCardOnFieldAtk[1];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP1.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 3) and (iPlayer = 2) then
  begin
    iCom := arrComCardOnFieldAtk[3];
    iPlayer := arrPlayerCardOnFieldAtk[2];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP2.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end
  else if (iCom = 3) and (iPlayer = 3) then
  begin
    iCom := arrComCardOnFieldAtk[3];
    iPlayer := arrPlayerCardOnFieldAtk[3];
    iDamage := iCom - iPlayer;

    iPlayerHP := iPlayerHP - iDamage;
    imgFP3.Visible := False;
    ShowMessage('Com destroyed one of your cards. ' + inttostr(iDamage)
        + ' damage was done.');
  end;
end;

procedure TfrmGame.addCardToField(iCard: integer);
begin
  // make sure its the players turn
  if iGameTurn mod 2 <> 0 then
  begin
    // Make sure the player does not play on FormActivate
    if iTurn >= 1 then
    begin
      // Make sure the player has drawn a card
      if bDraw then
      begin
        // Player cannot add more than 1 card to the field/turn
        if iMove = 0 then
        begin
          // find out which card was clicked
          if iCard = 1 then
          begin
            // Make sure that there is space open for adding another card
            if imgFP1.Visible = False then
            begin
              imgFP1.Picture := imgP1.Picture;
              imgFP1.Visible := True;
              imgP1.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[1] := strToint(pnlCardVal1.Caption);
            end
            else if imgFP2.Visible = False then
            begin
              imgFP2.Picture := imgP1.Picture;
              imgFP2.Visible := True;
              imgP1.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[2] := strToint(pnlCardVal1.Caption);
            end
            else if imgFP3.Visible = False then
            begin
              imgFP3.Picture := imgP1.Picture;
              imgFP3.Visible := True;
              imgP1.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[3] := strToint(pnlCardVal1.Caption);
            end
            else
            begin
              ShowMessage('No open spaces are avalible');
            end;
            // end of if iCard = 1
          end
          else if iCard = 2 then
          begin
            if imgFP1.Visible = False then
            begin
              imgFP1.Picture := imgP2.Picture;
              imgFP1.Visible := True;
              imgP2.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[1] := strToint(pnlCardVal2.Caption);
            end
            else if imgFP2.Visible = False then
            begin
              imgFP2.Picture := imgP2.Picture;
              imgFP2.Visible := True;
              imgP2.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[2] := strToint(pnlCardVal2.Caption);
            end
            else if imgFP3.Visible = False then
            begin
              imgFP3.Picture := imgP2.Picture;
              imgFP3.Visible := True;
              imgP2.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[3] := strToint(pnlCardVal2.Caption);
            end
            else
            begin
              ShowMessage('No open spaces are avalible');
            end;
            // end of if iCard = 2
          end
          else if iCard = 3 then
          begin
            if imgFP1.Visible = False then
            begin
              imgFP1.Picture := imgP3.Picture;
              imgFP1.Visible := True;
              imgP3.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[1] := strToint(pnlCardVal3.Caption);
            end
            else if imgFP2.Visible = False then
            begin
              imgFP2.Picture := imgP3.Picture;
              imgFP2.Visible := True;
              imgP3.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[2] := strToint(pnlCardVal3.Caption);
            end
            else if imgFP3.Visible = False then
            begin
              imgFP3.Picture := imgP3.Picture;
              imgFP3.Visible := True;
              imgP3.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[3] := strToint(pnlCardVal3.Caption);
            end // end of if iMove = 0
            else
            begin
              ShowMessage('No open spaces are avalible');
            end;
            // end of if iCard = 3
          end
          else if iCard = 4 then
          begin
            if imgFP1.Visible = False then
            begin
              imgFP1.Picture := imgP4.Picture;
              imgFP1.Visible := True;
              imgP4.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[1] := strToint(pnlCardVal4.Caption);
            end
            else if imgFP2.Visible = False then
            begin
              imgFP2.Picture := imgP4.Picture;
              imgFP2.Visible := True;
              imgP4.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[2] := strToint(pnlCardVal4.Caption);
            end
            else if imgFP3.Visible = False then
            begin
              imgFP3.Picture := imgP4.Picture;
              imgFP3.Visible := True;
              imgP4.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[3] := strToint(pnlCardVal4.Caption);
            end
            else
            begin
              ShowMessage('No open spaces are avalible');
            end;
            // end of if iCard = 4
          end
          else if iCard = 5 then
          begin
            if imgFP1.Visible = False then
            begin
              imgFP1.Picture := imgP5.Picture;
              imgFP1.Visible := True;
              imgP5.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[1] := strToint(pnlCardVal5.Caption);
            end
            else if imgFP2.Visible = False then
            begin
              imgFP2.Picture := imgP5.Picture;
              imgFP2.Visible := True;
              imgP5.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[2] := strToint(pnlCardVal5.Caption);
            end
            else if imgFP3.Visible = False then
            begin
              imgFP3.Picture := imgP5.Picture;
              imgFP3.Visible := True;
              imgP5.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[3] := strToint(pnlCardVal5.Caption);
            end
            else
            begin
              ShowMessage('No open spaces are avalible');
            end;
            // end of if iCard = 5
          end
          else
          begin
            if imgFP1.Visible = False then
            begin
              imgFP1.Picture := imgP6.Picture;
              imgFP1.Visible := True;
              imgP6.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[1] := strToint(pnlCardVal6.Caption);
            end
            else if imgFP2.Visible = False then
            begin
              imgFP2.Picture := imgP6.Picture;
              imgFP2.Visible := True;
              imgP6.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[2] := strToint(pnlCardVal6.Caption);
            end
            else if imgFP3.Visible = False then
            begin
              imgFP3.Picture := imgP6.Picture;
              imgFP3.Visible := True;
              imgP6.Visible := False;
              iMove := 1;
              arrPlayerCardOnFieldAtk[3] := strToint(pnlCardVal6.Caption);
            end
            else
            begin
              ShowMessage('No open spaces are avalible');
            end;
            // end of if iCard = 6
          end;

        end // end of if iMove = 0
        else
        begin
          ShowMessage('You can only play 1 card per turn');
        end;
      end // end of if bdraw = 1
      else
      begin
        ShowMessage('You have to draw first');
      end;
    end // end of if iTurn
    else
    begin
      ShowMessage('You cannot play first');
    end;
  end
  else
  begin
    ShowMessage('You can only play on your turn');
  end;
end;

procedure TfrmGame.battlePhase;
var
  iPlayerCard, iComCard, iDamage: integer;
begin
  // asks the player what card he/she wants to use
  iPlayerCard := strToint(InputBox('Battle Phase',
      'Which card do you want to attack with?(1-3)', ''));

  // makes sure the card exists and has not attacked yet
  if iPlayerCard = 1 then
  begin
    if imgFP1.Visible then
    begin
      if bCard1Atk = False then
      begin
        // asks what card the player wants to attack
        iComCard := strToint(InputBox('Battle Phase',
            'Which card do you want to attack?(1-3)', ''));

        if iComCard = 1 then
        begin
          if imgFE1.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[1];
            bCard1Atk := True;

            if iDamage = 0 then
            begin
              imgFP1.Visible := False;
              imgFE1.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE1.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;

            end
            else
            begin
              imgFP1.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;

            end;
          end // end of if imgFE1.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end // end of if iComCard = 1
        else if iComCard = 2 then
        begin
          if imgFE2.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[2];
            bCard1Atk := True;

            if iDamage = 0 then
            begin
              imgFP1.Visible := False;
              imgFE2.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE2.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;

            end
            else
            begin
              imgFP1.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;

            end;
          end // end of if imgFE2.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end // end of iComCard = 2
        else if iComCard = 3 then
        begin
          if imgFE3.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[3];
            bCard1Atk := True;

            if iDamage = 0 then
            begin
              imgFP1.Visible := False;
              imgFE3.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE3.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;

            end
            else
            begin
              imgFP1.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;

            end;
          end // end of if imgFE3.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end; // end of iComCard = 3
      end
      else // end of if bCard1Atk
      begin
        ShowMessage('You already attacked with this card');
      end;
    end; // end of if imgFP1.visible
  end; // end of if iPlayerCard = 1

  if iPlayerCard = 2 then
  begin
    if imgFP2.Visible then
    begin
      if bCard2Atk = False then
      begin
        iComCard := strToint(InputBox('Battle Phase',
            'Which card do you want to attack?(1-3)', ''));

        if iComCard = 1 then
        begin
          if imgFE1.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[1];
            bCard2Atk := True;

            if iDamage = 0 then
            begin
              imgFP2.Visible := False;
              imgFE1.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE1.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;

            end
            else
            begin
              imgFP2.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;

            end;
          end // end of if imgFE1.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end // end of if iComCard = 1
        else if iComCard = 2 then
        begin
          if imgFE2.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[2];
            bCard2Atk := True;

            if iDamage = 0 then
            begin
              imgFP2.Visible := False;
              imgFE2.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE2.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;

            end
            else
            begin
              imgFP2.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;

            end;
          end // end of if imgFE2.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end // end of iComCard = 2
        else if iComCard = 3 then
        begin
          if imgFE3.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[3];
            bCard2Atk := True;

            if iDamage = 0 then
            begin
              imgFP2.Visible := False;
              imgFE3.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');
            end
            else if iDamage > 0 then
            begin
              imgFE3.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;

            end
            else
            begin
              imgFP2.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;

            end;
          end // end of if imgFE3.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end; // end of iComCard = 3
      end
      else // end of if bCard1Atk
      begin
        ShowMessage('You already attacked with this card');
      end;
    end; // end of if imgFP2.visible
  end; // end of if iPlayerCard = 2

  if iPlayerCard = 3 then
  begin
    if imgFP3.Visible then
    begin
      if bCard3Atk = False then
      begin
        iComCard := strToint(InputBox('Battle Phase',
            'Which card do you want to attack?(1-3)', ''));

        if iComCard = 1 then
        begin
          if imgFE1.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[1];
            bCard3Atk := True;

            if iDamage = 0 then
            begin
              imgFP3.Visible := False;
              imgFE1.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');
            end
            else if iDamage > 0 then
            begin
              imgFE1.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;
            end
            else
            begin
              imgFP3.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;
            end;
          end // end of if imgFE1.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end // end of if iComCard = 1
        else if iComCard = 2 then
        begin
          if imgFE2.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[2];
            bCard3Atk := True;

            if iDamage = 0 then
            begin
              imgFP3.Visible := False;
              imgFE2.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE2.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;
            end
            else
            begin
              imgFP3.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;
            end;
          end // end of if imgFE2.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end // end of iComCard = 2
        else if iComCard = 3 then
        begin
          if imgFE3.Visible then
          begin
            iDamage := arrPlayerCardOnFieldAtk[iPlayerCard] -
              arrComCardOnFieldAtk[3];
            bCard3Atk := True;

            if iDamage = 0 then
            begin
              imgFP3.Visible := False;
              imgFE3.Visible := False;

              ShowMessage('The damage done was 0 - Both cards were destroyed');

            end
            else if iDamage > 0 then
            begin
              imgFE3.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - Computers card was destroyed');

              iComHP := iComHP - iDamage;
            end
            else
            begin
              imgFP3.Visible := False;

              ShowMessage('The damage done was ' + inttostr(iDamage)
                  + ' - your card was destroyed :(');

              iPlayerHP := iPlayerHP + iDamage;
            end;
          end // end of if imgFE3.visible
          else
          begin
            ShowMessage('That card is not on the field');
          end;
        end; // end of iComCard = 3
      end
      else // end of if bCard1Atk
      begin
        ShowMessage('You already attacked with this card');
      end;
    end // end of if imgFP3.visible
  end;
  HP;
end;

procedure TfrmGame.comComparePower;
begin
  // Here the computer compares the powers of the cards on both sides of the field
  if imgFE1.Visible then
  begin
    if (imgFP1.Visible) and (imgFP2.Visible) and (imgFP3.Visible) then
    begin
      // if the COMs card is stronger than the players card
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(1, 1);
      end
      else if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(1, 2);
      end
      else if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(1, 3);
      end;
    end
    else if (imgFP1.Visible) and (imgFP2.Visible) then
    begin
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(1, 1);
      end
      else if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(1, 2);
      end;
    end
    else if (imgFP1.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(1, 1);
      end
      else if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(1, 3);
      end;
    end
    else if (imgFP2.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(1, 2);
      end
      else if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(1, 3);
      end;
    end
    else if imgFP1.Visible then
    begin
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(1, 1);
      end;
    end
    else if imgFP2.Visible then
    begin
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(1, 2);
      end;
    end
    else if imgFP3.Visible then
    begin
      if arrComCardOnFieldAtk[1] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(1, 3);
      end;
    end;
  end;

  if imgFE2.Visible then
  begin
    if (imgFP1.Visible) and (imgFP2.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(2, 1);
      end
      else if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(2, 2);
      end
      else if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(2, 3);
      end;
    end
    else if (imgFP1.Visible) and (imgFP2.Visible) then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(2, 1);
      end
      else if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(2, 2);
      end;
    end
    else if (imgFP1.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(2, 1);
      end
      else if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(2, 3);
      end;
    end
    else if (imgFP2.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(2, 2);
      end
      else if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(2, 3);
      end;
    end
    else if imgFP1.Visible then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(2, 1);
      end;
    end
    else if imgFP2.Visible then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(2, 2);
      end;
    end
    else if imgFP3.Visible then
    begin
      if arrComCardOnFieldAtk[2] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(2, 3);
      end;
    end;
  end;

  if imgFE3.Visible then
  begin
    if (imgFP1.Visible) and (imgFP2.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(3, 1);
      end
      else if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(3, 2);
      end
      else if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(3, 3);
      end;
    end
    else if (imgFP1.Visible) and (imgFP2.Visible) then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(3, 1);
      end
      else if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(3, 2);
      end;
    end
    else if (imgFP1.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(3, 1);
      end
      else if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(3, 3);
      end;
    end
    else if (imgFP2.Visible) and (imgFP3.Visible) then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(3, 2);
      end
      else if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(3, 3);
      end;
    end
    else if imgFP1.Visible then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[1] then
      begin
        comAttack(3, 1);
      end;
    end
    else if imgFP2.Visible then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[2] then
      begin
        comAttack(3, 2);
      end;
    end
    else if imgFP3.Visible then
    begin
      if arrComCardOnFieldAtk[3] > arrPlayerCardOnFieldAtk[3] then
      begin
        comAttack(3, 3);
      end;
    end;
  end;
end;

procedure TfrmGame.comDraw;
begin
  Inc(iComDeckCard);
  {
    The computer can only have 1 card in it's hand, this makes it easier to play
    a card
    }
  arrComHand[1] := arrComCards[iComDeckCard];
  arrComHandAtk[1] := strToint(copy(arrComHand[1], Pos(';', arrComHand[1]) + 1,
      5));
end;

procedure TfrmGame.FormActivate(Sender: TObject);
begin
  // restarts the game
  newGame;
end;

procedure TfrmGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmEnter.Show;
  frmEnter.lblWonNum.Caption := dmCards.tblWinLose['won'];
end;

function TfrmGame.getWinner: boolean;
begin
  // see who has more than 0 hp left
  if (strToint(lblPP.Caption) <= 0) then
  begin
    ShowMessage('You have no more HP left. You lose :(');
    // player loses
    result := False;
  end
  else if (strToint(lblCP.Caption) <= 0) then
  begin
    ShowMessage('COM has no more HP left. You win! :D');
    // player wins
    result := True;
  end;

  // if the player/com draws their last card  (This has a VERY low chance of happening)
  if (arrPlayerCards[60] = arrPlayerHand[1]) or
    (arrPlayerCards[60] = arrPlayerHand[2]) or
    (arrPlayerCards[60] = arrPlayerHand[3]) or
    (arrPlayerCards[60] = arrPlayerHand[4]) or
    (arrPlayerCards[60] = arrPlayerHand[5]) or
    (arrPlayerCards[60] = arrPlayerHand[6]) then
  begin
    result := False;
    ShowMessage('You have no more cards left in your deck. You lose :(');
    imgPDeck.Visible := False;
  end
  else if (arrComCards[60] = arrComHand[1]) then
  begin
    result := True;
    ShowMessage('COM drew its last card from its deck. You win!');
    imgEDeck.Visible := False;
  end;

end;

procedure TfrmGame.HP;
begin
  // updates the text showing the amount of HP a player/com has left
  lblPP.Caption := inttostr(iPlayerHP);
  lblCP.Caption := inttostr(iComHP);

  // changes color depending on the amount of HP the player/com has left
  if strToint(lblPP.Caption) > 20000 then
  begin
    lblPP.Font.Color := clLime;
  end
  else if (strToint(lblPP.Caption) <= 20000) and
    (strToint(lblPP.Caption) > 10000) then
  begin
    lblPP.Font.Color := clYellow;
  end
  else
  begin
    lblPP.Font.Color := clRed;
  end;

  if strToint(lblCP.Caption) > 20000 then
  begin
    lblCP.Font.Color := clLime;
  end
  else if (strToint(lblCP.Caption) <= 20000) and
    (strToint(lblCP.Caption) > 10000) then
  begin
    lblCP.Font.Color := clYellow;
  end
  else
  begin
    lblCP.Font.Color := clRed;
  end;

  // trys to find a winner
  if ((strToint(lblPP.Caption) <= 0) or (strToint(lblCP.Caption) <= 0)) and
    (bCalledWinner = False) then
  begin
    bCalledWinner := True; // so this if statement does not get called 2 times in a row
    setWinStats;
  end;
end;

procedure TfrmGame.imgP1Click(Sender: TObject);
begin
  addCardToField(1);
end;

procedure TfrmGame.imgP2Click(Sender: TObject);
begin
  addCardToField(2);
end;

procedure TfrmGame.imgP3Click(Sender: TObject);
begin
  addCardToField(3);
end;

procedure TfrmGame.imgP4Click(Sender: TObject);
begin
  addCardToField(4);
end;

procedure TfrmGame.imgP5Click(Sender: TObject);
begin
  addCardToField(5);
end;

procedure TfrmGame.imgP6Click(Sender: TObject);
begin
  addCardToField(6);
end;

procedure TfrmGame.imgPDeckClick(Sender: TObject);
begin
  // if its the players very first turn
  if iTurn = 0 then
  begin
    draw;
    Inc(iTurn);
    Exit;
  end;

  // if the player has not drawn yet
  if bDraw = True then
  begin
    ShowMessage('You can only draw once per turn');
    Exit;
  end;

  // draws card
  draw;
  lblPP.Caption := inttostr(iPlayerHP);
  lblCP.Caption := inttostr(iComHP);
end;

function TfrmGame.isCardOnField: boolean;
begin
  // The player MUST have atleast 1 card on the field
  if (imgFP1.Visible = False) and (imgFP2.Visible = False) and
    (imgFP3.Visible = False) and (iMove = 0) then
  begin
    ShowMessage('You must have at least 1 card on the field');
    result := False;
  end
  else
  begin
    result := True;
  end;
end;

procedure TfrmGame.newGame;
begin
  // player and com starts with 30 000 health points
  iComHP := 30000;
  iPlayerHP := 30000;

  bCalledWinner := False; // fixes bug when getting the winner

  // player starts with 3 cards
  imgP1.Visible := True;
  imgP2.Visible := True;
  imgP3.Visible := True;
  imgP4.Visible := False;
  imgP5.Visible := False;
  imgP6.Visible := False;

  // cards on field is removed
  imgFP1.Visible := False;
  imgFP2.Visible := False;
  imgFP3.Visible := False;

  imgFE1.Visible := False;
  imgFE2.Visible := False;
  imgFE3.Visible := False;

  // sets everything at 1/0
  iDeckCard := 1;
  iComDeckCard := 1;
  iGameTurn := 1;
  iMove := 0;

  // makes their hp green
  lblPlayerHP.Font.Color := clLime;
  lblPP.Font.Color := clLime; // Player Points (PP)
  lblComHP.Font.Color := clLime;
  lblCP.Font.Color := clLime; // computer points (HP)

  // adds card to array
  addCardsToArray;

  // adds cards from the array to the player/coms deck
  while iDeckCard <= 3 do
  begin
    if iDeckCard = 1 then
    begin
      arrPlayerHand[iDeckCard] := copy(arrPlayerCards[iDeckCard], 1,
        Pos(';', arrPlayerCards[iDeckCard]) - 1);
      arrPlayerHandAtk[iDeckCard] := strToint(copy(arrPlayerCards[iDeckCard],
          Pos(';', arrPlayerCards[iDeckCard]) + 1, 5));

      // stores the cards attack value
      pnlCardVal1.Caption := inttostr(arrPlayerHandAtk[iDeckCard]);
      imgP1.Picture.LoadFromFile(arrPlayerHand[iDeckCard]);
    end
    else if iDeckCard = 2 then
    begin
      arrPlayerHand[iDeckCard] := copy(arrPlayerCards[iDeckCard], 1,
        Pos(';', arrPlayerCards[iDeckCard]) - 1);
      arrPlayerHandAtk[iDeckCard] := strToint(copy(arrPlayerCards[iDeckCard],
          Pos(';', arrPlayerCards[iDeckCard]) + 1, 5));

      pnlCardVal2.Caption := inttostr(arrPlayerHandAtk[iDeckCard]);
      imgP2.Picture.LoadFromFile(arrPlayerHand[iDeckCard]);
    end
    else if iDeckCard = 3 then
    begin
      arrPlayerHand[iDeckCard] := copy(arrPlayerCards[iDeckCard], 1,
        Pos(';', arrPlayerCards[iDeckCard]) - 1);
      arrPlayerHandAtk[iDeckCard] := strToint(copy(arrPlayerCards[iDeckCard],
          Pos(';', arrPlayerCards[iDeckCard]) + 1, 5));

      pnlCardVal3.Caption := inttostr(arrPlayerHandAtk[iDeckCard]);
      imgP3.Picture.LoadFromFile(arrPlayerHand[iDeckCard]);
    end;
    Inc(iDeckCard);
  end;

  iTurn := 0;
  // cant attack the defenceless COM
  btnBattlePhase.Enabled := False;

  // calls HP (just incase)
  HP;
end;

procedure TfrmGame.removeCard;
var
  iCard: integer;
begin
  iCard := strToint(InputBox('Remove Card',
      'Which card do you want to dispose of?', '1'));

  // removes a card, then draws
  if iCard = 1 then
  begin
    imgP1.Visible := False;
    draw;
  end
  else if iCard = 2 then
  begin
    imgP2.Visible := False;
    draw;
  end
  else if iCard = 3 then
  begin
    imgP3.Visible := False;
    draw;
  end
  else if iCard = 4 then
  begin
    imgP4.Visible := False;
    draw;
  end
  else if iCard = 5 then
  begin
    imgP5.Visible := False;
    draw;
  end
  else if iCard = 6 then
  begin
    imgP6.Visible := False;
    draw;
  end
  else
  begin
    ShowMessage('Only enter numbers from 1 to 6');
    removeCard;
  end;
end;

procedure TfrmGame.setWinStats;
var
  bWin: boolean;
begin
  bWin := getWinner;

  with dmCards do
  begin
    tblWinLose.Open;

    if bWin then
    begin
      // updates the win/lose stats
      bGameEndWinner := True;
      tblWinLose.Edit;
      tblWinLose['won'] := tblWinLose['won'] + 1;
      tblWinLose.Post;

      frmWinLose.Show;
      Self.hide;
    end
    else if bWin = False then
    begin
      bGameEndWinner := False;
      tblWinLose.Edit;
      tblWinLose['lost'] := tblWinLose['lost'] + 1;
      tblWinLose.Post;

      frmWinLose.Show;
      Self.hide;
    end;
  end;

end;

end.
