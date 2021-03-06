unit StockTakeDetailUFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxDBTLCl, dxGrClms, dxDBCtrl, dxDBGrid, dxTL, dxCntner,
  ExtCtrls, DBCtrls, dxEditor, dxExEdtr, dxEdLib, dxDBELib,
  wwdbdatetimepicker, wwdblook, Mask, RzBmpBtn, DB, Menus, ElPopBtn,
  ActnList, RzDBEdit, RzTabs, RzCmboBx, RzDBCmbo, ComCtrls, DateUtils;

type
  TStockTakeDetailFrm = class(TForm)
    Panel1: TPanel;
    btnPrint: TRzBmpButton;
    pnlStockTakeHeaderBackground: TPanel;
    Label13: TLabel;
    Label24: TLabel;
    Label41: TLabel;
    Label25: TLabel;
    Label31: TLabel;
    Label18: TLabel;
    Label79: TLabel;
    lblDate: TDBText;
    dbtCountOfItems: TDBText;
    Label11: TLabel;
    cmbVerifiedBy_str: TwwDBLookupCombo;
    cmbStockCapturedBy_str: TwwDBLookupCombo;
    cmbStockCaptured_dat: TwwDBDateTimePicker;
    Panel2: TPanel;
    lblPosted: TLabel;
    btnPostClose: TButton;
    dxDBCurrencyEdit5: TdxDBCurrencyEdit;
    Panel3: TPanel;
    ElSpeedButton17: TElSpeedButton;
    ElSpeedButton11: TElSpeedButton;
    ElSpeedButton5: TElSpeedButton;
    ElSpeedButton6: TElSpeedButton;
    ElSpeedButton2: TElSpeedButton;
    ElSpeedButton9: TElSpeedButton;
    ElSpeedButton8: TElSpeedButton;
    ElSpeedButton3: TElSpeedButton;
    ElSpeedButton13: TElSpeedButton;
    ElSpeedButton16: TElSpeedButton;
    PopupMenu1: TPopupMenu;
    AddSingleItem1: TMenuItem;
    Panel4: TPanel;
    btnClose: TButton;
    ActionList1: TActionList;
    atnColSelect: TAction;
    PageControlStockTakeItems: TRzPageControl;
    tbsStockTakeItems: TRzTabSheet;
    tbsStockTake_Remarks: TRzTabSheet;
    dbgStockTakeItems: TdxDBGrid;
    dbgStockTakeItemICN_str: TdxDBGridColumn;
    dbgStockTakeItemECN_str: TdxDBGridColumn;
    dbgStockTakeItemNSN_str: TdxDBGridColumn;
    dbgStockTakeItemNewQty_int: TdxDBGridMaskColumn;
    dbgStockTakeItemPackCost_mon: TdxDBGridCurrencyColumn;
    RzDBNotesField: TRzDBMemo;
    dbgStockTakeItemsExtendedCost_mon: TdxDBGridCurrencyColumn;
    PopMenuPrint: TPopupMenu;
    PrintStocktake1: TMenuItem;
    AddEDLproducts1: TMenuItem;
    Deleteallitems1: TMenuItem;
    dbgStockTakeItemsDescription_str: TdxDBGridColumn;
    dbgStockTakeItemsBatchNumber_str: TdxDBGridColumn;
    tbsStocktakeHistory: TRzTabSheet;
    dxDBStocktakeHistory: TdxDBGrid;
    AddproductsbyGroup11: TMenuItem;
    AddproductsbyGroup21: TMenuItem;
    Label2: TLabel;
    cmbReason_str: TRzDBComboBox;
    PrintDeficitReport1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    cmbVerifiedDate_Dat: TwwDBDateTimePicker;
    dxDBStocktakeHistoryStockTakeHistory_ID: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryStockTake_ID: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryDescription_str: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryUser_ID: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryDate_dat: TdxDBGridDateColumn;
    dxDBStocktakeHistoryStockTakeItem_ID: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryType_str: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryUserName_str: TdxDBGridMaskColumn;
    dxDBStocktakeHistoryItem_ID: TdxDBGridMaskColumn;
    AddAnotherBatch1: TMenuItem;
    PrintAnomaliesReport1: TMenuItem;
    atnRefreshStocktakeList1: TMenuItem;
    Button2: TButton;
    PrintSurplusReport1: TMenuItem;
    dbgStockTakeItemsBin_str: TdxDBGridPickColumn;
    dbgStockTakeItemsExpiryDate_dat: TdxDBGridDateColumn;
    lblLocked: TLabel;
    RzBmpButton1: TRzBmpButton;
    lblStockTake_str: TDBText;
    lblBrowseOnly: TLabel;
    N3: TMenuItem;
    CheckItemsOnHold1: TMenuItem;
    procedure atnColSelectExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetDisplayProperties;
    procedure LoadBinLocations;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StockTakeDetailFrm: TStockTakeDetailFrm;

implementation

uses StockTakeUDM, DialogGridColumnSelectorUFrm, RxSolutionUFrm,
  RxSolutionSecurityClass, StockTakeBatchSelectUfrm;

{$R *.dfm}

procedure TStockTakeDetailFrm.atnColSelectExecute(Sender: TObject);
var
  SelectColumns : TColumnSelector;
  GridCols      : TDxDBGrid;
begin
  SelectColumns := TColumnSelector.Create;
  try
   GridCols := dbgStockTakeItems;
  if assigned(GridCols) then
    SelectColumns.SelectColumns(GridCols);
  finally
    SelectColumns.Free;
  end;
end;

procedure TStockTakeDetailFrm.SetDisplayProperties;
var
 CheckPosted, atnBrowse, prvIsRepLocked, prvIsRepPosted, vDisable : boolean;
begin
 //
 with RxSolutionFrm.Security do
  atnBrowse := (GetUserAccessLevel(MODULE_STOCKTAKING) = USER_BROWSER);

 with StockTakeDM.qryStockTakeCatalog do
  begin
  prvIsRepLocked  := (FieldByName('CheckedOut_bol').Asboolean and not StockTakeDM.IsLockedBySameUser);
  prvIsRepPosted  := FieldByName('Completed_bol').Asboolean;
  end;

 vDisable := not (prvIsRepPosted or prvIsRepLocked or atnBrowse);

 lblPosted.Visible := prvIsRepPosted;
 lblLocked.Visible := prvIsRepLocked;
 lblBrowseOnly.Visible := atnBrowse and (not prvIsRepPosted);

 pnlStockTakeHeaderBackground.Enabled := vDisable;

 RzDBNotesField.Enabled          := vDisable;

 dbgStockTakeItems.ColumnByName('dbgStockTakeItemNewQty_int').DisableEditor     := not vDisable;
 dbgStockTakeItems.ColumnByName('dbgStockTakeItemPackCost_mon').DisableEditor   := not vDisable;
 dbgStockTakeItems.ColumnByName('dbgStockTakeItemsBatchNumber_str').DisableEditor := not vDisable;
 dbgStockTakeItems.ColumnByName('dbgStockTakeItemsExpiryDate_dat').DisableEditor:= not vDisable;
 dbgStockTakeItems.ColumnByName('dbgStockTakeItemsBin_str').DisableEditor       := not vDisable;

 //ACTIONS
 StockTakeDM.atnAddSingleItem.Enabled   := vDisable;
 StockTakeDM.atnAddBatchItem.Enabled    := vDisable;
 StockTakeDM.atnAddAllEDLItems.Enabled  := vDisable;
 StockTakeDM.atnAddGroup1Items.Enabled  := vDisable;
 StockTakeDM.atnAddGroup2Items.Enabled  := vDisable;
 StockTakeDM.atnAddBinLocationProducts.Enabled  := vDisable;
 StockTakeDM.atnDeleteItem.Enabled      := vDisable;  

 if not prvIsRepPosted then  //Only load bin locations if necessary
  LoadBinLocations;                    
end;

procedure TStockTakeDetailFrm.FormShow(Sender: TObject);
begin
//Set Display properties
 SetDisplayProperties;
 StockTakeDetailFrm.WindowState := wsMaximized;
 PageControlStockTakeItems.ActivePage := tbsStockTakeItems;
end;

procedure TStockTakeDetailFrm.LoadBinLocations;
begin
 with StockTakeDM.tblBinLocations do
  begin
  Close;
  Open;
  First;
  While not Eof do
   begin
   dbgStockTakeItemsBin_str.Items.Add(FieldByName('Code_str').AsString);
   Next;
   end;
  Close;
  end;
end;

procedure TStockTakeDetailFrm.FormCreate(Sender: TObject);
const
  cbuf = 1;
var
  vDetFormSize  :TRect;
begin
  vDetFormSize := Screen.WorkAreaRect;
  Left    := vDetFormSize.Left + cbuf;
  Top     := vDetFormSize.Top + cBuf;
  Height  := (vDetFormSize.Bottom - vDetFormSize.Top) - ( cbuf * 2);
  Width   := (vDetFormSize.Right - vDetFormSize.Left) - ( cbuf * 2);

  PageControlStockTakeItems.Height := Height - ( Panel1.Height  + Panel3.Height + Panel4.Height * 2 + 5);

end;

end.
