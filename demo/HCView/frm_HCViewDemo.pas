unit frm_HCViewDemo;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ComCtrls, Menus, ImgList, ToolWin, XPMan, HCCommon, HCCustomRichData, HCItem,
  HCCustomData, HCView, HCParaStyle, HCTextStyle, ExtCtrls, ActnList,
  Actions, ImageList, Printers, Clipbrd;

type
  TfrmHCViewDemo = class(TForm)
    il1: TImageList;
    tlbFontSize: TToolBar;
    btnOpen: TToolButton;
    btnSymmetryMargin: TToolButton;
    btnAnnotation: TToolButton;
    btnAlignLeft: TToolButton;
    btnAlignCenter: TToolButton;
    btnAlignRight: TToolButton;
    btnAlignJustify: TToolButton;
    btnAlignScatter: TToolButton;
    mm1: TMainMenu;
    mniN1: TMenuItem;
    mniOpen: TMenuItem;
    mniSave: TMenuItem;
    mniSaveAs: TMenuItem;
    ToolButton1: TToolButton;
    btnBold: TToolButton;
    btn2: TToolButton;
    xpmnfst: TXPManifest;
    btnSave: TToolButton;
    btn3: TToolButton;
    btnItalic: TToolButton;
    btnUnderLine: TToolButton;
    btnStrikeOut: TToolButton;
    btnSuperScript: TToolButton;
    btnSubScript: TToolButton;
    cbbFont: TComboBox;
    btn1: TToolButton;
    cbbFontColor: TColorBox;
    cbbBackColor: TColorBox;
    btnprint: TToolButton;
    cbbFontSize: TComboBox;
    mniN3: TMenuItem;
    mniCopy: TMenuItem;
    mniPaste: TMenuItem;
    mniCut: TMenuItem;
    mniN5: TMenuItem;
    pmRichEdit: TPopupMenu;
    mniN6: TMenuItem;
    mniN7: TMenuItem;
    mniN8: TMenuItem;
    mniTable: TMenuItem;
    cbbZoom: TComboBox;
    mniN9: TMenuItem;
    statbar: TStatusBar;
    mniN12: TMenuItem;
    mniN13: TMenuItem;
    mniN14: TMenuItem;
    mniN15: TMenuItem;
    mniC1: TMenuItem;
    btnLineSpace: TToolButton;
    pmLineSpace: TPopupMenu;
    mniLineSpace: TMenuItem;
    mniN17: TMenuItem;
    mniN21: TMenuItem;
    mniDisBorder: TMenuItem;
    mniInsertRowTop: TMenuItem;
    mniInsertRowBottom: TMenuItem;
    mniInsertColLeft: TMenuItem;
    mniInsertColRight: TMenuItem;
    mniDeleteCurRow: TMenuItem;
    mniDeleteCurCol: TMenuItem;
    mniN25: TMenuItem;
    mniN26: TMenuItem;
    mniN27: TMenuItem;
    mniN28: TMenuItem;
    mniN29: TMenuItem;
    mniN30: TMenuItem;
    mniN31: TMenuItem;
    mniN32: TMenuItem;
    actlst: TActionList;
    btnNew: TToolButton;
    mnigif1: TMenuItem;
    mniN4: TMenuItem;
    mniMerge: TMenuItem;
    mniN10: TMenuItem;
    mniN11: TMenuItem;
    mniN16: TMenuItem;
    mniInsertTable: TMenuItem;
    btn4: TToolButton;
    btn5: TToolButton;
    mniEdit1: TMenuItem;
    mniN2: TMenuItem;
    mniN18: TMenuItem;
    mniN19: TMenuItem;
    mniCombobox1: TMenuItem;
    mniN20: TMenuItem;
    mniN22: TMenuItem;
    mniN23: TMenuItem;
    mniN24: TMenuItem;
    mniN33: TMenuItem;
    mniN34: TMenuItem;
    mniN35: TMenuItem;
    mniN36: TMenuItem;
    mniN37: TMenuItem;
    mniTableProperty: TMenuItem;
    mniN38: TMenuItem;
    mniN39: TMenuItem;
    mniN40: TMenuItem;
    mniN41: TMenuItem;
    actSearch: TAction;
    mniN42: TMenuItem;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    mniControlItem: TMenuItem;
    mniN43: TMenuItem;
    mniN1151: TMenuItem;
    mniN44: TMenuItem;
    mniRadioButton1: TMenuItem;
    mniSplitRow: TMenuItem;
    mniSplitCol: TMenuItem;
    mniN47: TMenuItem;
    mniN45: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAnnotationClick(Sender: TObject);
    procedure btnAlignLeftClick(Sender: TObject);
    procedure btnSymmetryMarginClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbFontChange(Sender: TObject);
    procedure cbbFontColorChange(Sender: TObject);
    procedure cbbBackColorChange(Sender: TObject);
    procedure cbbFontSizeChange(Sender: TObject);
    procedure mniN5Click(Sender: TObject);
    procedure pmRichEditPopup(Sender: TObject);
    procedure btnprintClick(Sender: TObject);
    procedure cbbZoomChange(Sender: TObject);
    procedure mniN9Click(Sender: TObject);
    procedure mniN14Click(Sender: TObject);
    procedure mniC1Click(Sender: TObject);
    procedure mniLineSpaceClick(Sender: TObject);
    procedure mniDisBorderClick(Sender: TObject);
    procedure mniInsertRowTopClick(Sender: TObject);
    procedure mniInsertRowBottomClick(Sender: TObject);
    procedure mniInsertColLeftClick(Sender: TObject);
    procedure mniInsertColRightClick(Sender: TObject);
    procedure mniDeleteCurRowClick(Sender: TObject);
    procedure mniDeleteCurColClick(Sender: TObject);
    procedure mniN26Click(Sender: TObject);
    procedure mniSaveAsClick(Sender: TObject);
    procedure mniSaveClick(Sender: TObject);
    procedure mniOpenClick(Sender: TObject);
    procedure mniN27Click(Sender: TObject);
    procedure mniN28Click(Sender: TObject);
    procedure mniN30Click(Sender: TObject);
    procedure mniN31Click(Sender: TObject);
    procedure mniN32Click(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure mnigif1Click(Sender: TObject);
    procedure mniN4Click(Sender: TObject);
    procedure mniMergeClick(Sender: TObject);
    procedure mniInsertTableClick(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure mniEdit1Click(Sender: TObject);
    procedure mniN2Click(Sender: TObject);
    procedure mniN18Click(Sender: TObject);
    procedure mniN19Click(Sender: TObject);
    procedure mniCombobox1Click(Sender: TObject);
    procedure mniN20Click(Sender: TObject);
    procedure mniN22Click(Sender: TObject);
    procedure mniN23Click(Sender: TObject);
    procedure mniN33Click(Sender: TObject);
    procedure mniN34Click(Sender: TObject);
    procedure mniN35Click(Sender: TObject);
    procedure mniN36Click(Sender: TObject);
    procedure mniN37Click(Sender: TObject);
    procedure mniTablePropertyClick(Sender: TObject);
    procedure mniN39Click(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure mniN42Click(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure mniControlItemClick(Sender: TObject);
    procedure mniN43Click(Sender: TObject);
    procedure mniN44Click(Sender: TObject);
    procedure mniRadioButton1Click(Sender: TObject);
    procedure mniSplitRowClick(Sender: TObject);
    procedure mniSplitColClick(Sender: TObject);
    procedure mniN45Click(Sender: TObject);
  private
    { Private declarations }
    FHCView: THCView;
    procedure SetFileName(const AFileName: string);
    procedure DrawItemClick(Shift: TShiftState; X, Y, AItemNo, ADItemNo: Integer;
      ADrawRect: TRect);
    procedure GetPagesAndActive;
    procedure DoCaretChange(Sender: TObject);
    procedure DoVerScroll(Sender: TObject);
    procedure CurTextStyleChange(const ANewStyleNo: Integer);
    procedure CurParaStyleChange(const ANewStyleNo: Integer);
    procedure DoCanDelete(const Sender: THCCustomRichData; const AItemNo,
      AItemOffs: Integer; var ACanDelete: Boolean);
    procedure DoItemLoaded(const AItem: THCCustomItem);
    procedure DoComboboxPopupItem(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmHCViewDemo: TfrmHCViewDemo;

implementation

uses
  frm_InsertTable, frm_PageSet, HCStyle, HCRectItem, HCTableItem, HCTextItem,
  HCDrawItem, HCExpressItem, HCLineItem, HCCheckBoxItem, HCEditItem, HCImageItem,
  HCGifItem, HCComboboxItem, HCQRCodeItem, HCBarCodeItem, HCFractionItem, HCFloatLineItem,
  HCDateTimePicker, HCSupSubScript, HCRadioGroup, EmrToothItem, EmrFangJiaoItem,
  frm_Paragraph, frm_TableProperty, frm_SearchAndReplace, frm_PrintView,
  frm_ControlItemProperty, frm_TableBorderBackColor;

{$R *.dfm}

function GetVersionInfo: string;
const
  SNotAvailable = 'Value Not Available';
var
  vFilePath: string;
  vLanguageID: string;
  vCodePage: string;
  vTranslationLength: Cardinal;
  vTranslationTable: Pointer;
  vInfoSize, vTemp, vLen: DWord;
  vInfoBuf: Pointer;
  vCompanyName, vFileDescription, vFileVersion, vInternalName, vLegalCopyright: string;
  vLegalTradeMarks, vOriginalFilename, vProductName, vProductVersion, vComments: string;
  vValue: PChar;
  vLookupString: string;
  vPathStz: array[ 0..MAX_PATH ] of Char;
begin
  Result := '';
  GetModuleFileName(HInstance, vPathStz, SizeOf( vPathStz ) );
  vFilePath := vPathStz;

  vInfoSize := GetFileVersionInfoSize( PChar( vFilePath ), vTemp );

  if vInfoSize > 0 then
  begin
    vInfoBuf := AllocMem( vInfoSize );
    try
      GetFileVersionInfo( PChar( vFilePath ), 0, vInfoSize, vInfoBuf );


      if VerQueryValue( vInfoBuf, '\VarFileInfo\Translation', vTranslationTable, vTranslationLength ) then
      begin
        vCodePage := Format( '%.4x', [ HiWord( PLongInt( vTranslationTable )^ ) ] );
        vLanguageID := Format( '%.4x', [ LoWord( PLongInt( vTranslationTable )^ ) ] );
      end;

      vLookupString := 'StringFileInfo\' + vLanguageID + vCodePage + '\';

      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'CompanyName' ), Pointer( vValue ), vLen ) then
        vCompanyName := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'FileDescription' ), Pointer( vValue ), vLen ) then
        vFileDescription := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'FileVersion' ), Pointer( vValue ), vLen ) then
        vFileVersion := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'InternalName' ), Pointer( vValue ), vLen ) then
        vInternalName := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'LegalCopyright' ), Pointer( vValue ), vLen ) then
        vLegalCopyright := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'LegalTrademarks' ), Pointer( vValue ), vLen ) then
        vLegalTradeMarks := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'OriginalFilename' ), Pointer( vValue ), vLen ) then
        vOriginalFilename := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'ProductName' ), Pointer( vValue ), vLen ) then
        vProductName := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'ProductVersion' ), Pointer( vValue ), vLen ) then
        vProductVersion := vValue;
      if VerQueryValue( vInfoBuf, PChar( vLookupString + 'Comments' ), Pointer( vValue ), vLen ) then
        vComments := vValue;
    finally
      FreeMem( vInfoBuf, vInfoSize );
    end;
  end
  else
  begin
    vCompanyName := SNotAvailable;
    vFileDescription := SNotAvailable;
    vFileVersion := SNotAvailable;
    vInternalName := SNotAvailable;
    vLegalCopyright := SNotAvailable;
    vLegalTrademarks := SNotAvailable;
    vOriginalFilename := SNotAvailable;
    vProductName := SNotAvailable;
    vProductVersion := SNotAvailable;
    vComments := SNotAvailable;
  end;
  Result := vFileVersion;
end;

procedure TfrmHCViewDemo.btnSymmetryMarginClick(Sender: TObject);
begin
  FHCView.SymmetryMargin := not FHCView.SymmetryMargin;
end;

procedure TfrmHCViewDemo.cbbFontSizeChange(Sender: TObject);
begin
  FHCView.ApplyTextFontSize(GetFontSize(cbbFontSize.Text));
  if not FHCView.Focused then
    FHCView.SetFocus;
end;

procedure TfrmHCViewDemo.cbbZoomChange(Sender: TObject);
begin
  FHCView.Zoom := (StrToInt(cbbZoom.Text) / 100);
end;

procedure TfrmHCViewDemo.cbbBackColorChange(Sender: TObject);
begin
  FHCView.ApplyTextBackColor(cbbBackColor.Selected);
end;

procedure TfrmHCViewDemo.cbbFontChange(Sender: TObject);
begin
  FHCView.ApplyTextFontName(cbbFont.Text);
  if not FHCView.Focused then
    FHCView.SetFocus;
end;

procedure TfrmHCViewDemo.cbbFontColorChange(Sender: TObject);
begin
  FHCView.ApplyTextColor(cbbFontColor.Selected);
  if not FHCView.Focused then
    FHCView.SetFocus;
end;

procedure TfrmHCViewDemo.DoCanDelete(const Sender: THCCustomRichData;
  const AItemNo, AItemOffs: Integer; var ACanDelete: Boolean);
begin

end;

procedure TfrmHCViewDemo.DoCaretChange(Sender: TObject);
begin
  GetPagesAndActive;

  CurTextStyleChange(FHCView.Style.CurStyleNo);
  CurParaStyleChange(FHCView.Style.CurParaNo);
end;

procedure TfrmHCViewDemo.DoComboboxPopupItem(Sender: TObject);
begin
  if (Sender as TStrings).Count > 20 then
    (Sender as TStrings).Clear;

  (Sender as TStrings).Add('选项' + IntToStr((Sender as TStrings).Count - 1));
end;

procedure TfrmHCViewDemo.DoItemLoaded(const AItem: THCCustomItem);
begin
  if AItem.StyleNo < THCStyle.Null then

  else
  if AItem.Text = '姓名' then
    AItem.Text := '张三';
end;

procedure TfrmHCViewDemo.CurParaStyleChange(const ANewStyleNo: Integer);
var
  vAlignHorz: TParaAlignHorz;
begin
  if ANewStyleNo >= 0 then
  begin
    vAlignHorz := FHCView.Style.ParaStyles[ANewStyleNo].AlignHorz;

    btnAlignLeft.Down := vAlignHorz = TParaAlignHorz.pahLeft;
    btnAlignRight.Down := vAlignHorz = TParaAlignHorz.pahRight;
    btnAlignCenter.Down := vAlignHorz = TParaAlignHorz.pahCenter;
    btnAlignJustify.Down := vAlignHorz = TParaAlignHorz.pahJustify;
    btnAlignScatter.Down := vAlignHorz = TParaAlignHorz.pahScatter;
  end;
end;

procedure TfrmHCViewDemo.CurTextStyleChange(const ANewStyleNo: Integer);
begin
  if ANewStyleNo >= 0 then
  begin
    cbbFont.ItemIndex := cbbFont.Items.IndexOf(FHCView.Style.TextStyles[ANewStyleNo].Family);
    cbbFontSize.ItemIndex := cbbFontSize.Items.IndexOf(GetFontSizeStr(FHCView.Style.TextStyles[ANewStyleNo].Size));
    btnBold.Down := tsBold in FHCView.Style.TextStyles[ANewStyleNo].FontStyles;
    btnItalic.Down := tsItalic in FHCView.Style.TextStyles[ANewStyleNo].FontStyles;
    btnUnderline.Down := tsUnderline in FHCView.Style.TextStyles[ANewStyleNo].FontStyles;
    btnStrikeOut.Down := tsStrikeOut in FHCView.Style.TextStyles[ANewStyleNo].FontStyles;
    btnSuperscript.Down := tsSuperscript in FHCView.Style.TextStyles[ANewStyleNo].FontStyles;
    btnSubscript.Down := tsSubscript in FHCView.Style.TextStyles[ANewStyleNo].FontStyles;
  end
  else
  begin
    btnBold.Down := False;
    btnItalic.Down := False;
    btnUnderline.Down := False;
    btnStrikeOut.Down := False;
    btnSuperscript.Down := False;
    btnSubscript.Down := False;
  end;
end;

procedure TfrmHCViewDemo.DoVerScroll(Sender: TObject);
begin
  GetPagesAndActive;
end;

procedure TfrmHCViewDemo.DrawItemClick(Shift: TShiftState; X, Y, AItemNo,
  ADItemNo: Integer; ADrawRect: TRect);
begin
//  Caption := 'X:' + IntToStr(X) + ' Y:' + IntToStr(Y)
//    + ' DItemNo:' + IntToStr(ADItemNo)
//    + ' DrawRect:' + IntToStr(ADrawRect.Left) + ','
//    + IntToStr(ADrawRect.Top) + ','
//    + IntToStr(ADrawRect.Right) + ','
//    + IntToStr(ADrawRect.Bottom);
end;

procedure TfrmHCViewDemo.btnAnnotationClick(Sender: TObject);
begin
  FHCView.ShowAnnotation := not FHCView.ShowAnnotation;
end;

procedure TfrmHCViewDemo.btnBoldClick(Sender: TObject);
begin
  case (Sender as TToolButton).Tag of
    0: FHCView.ApplyTextStyle(THCFontStyle.tsBold);
    1: FHCView.ApplyTextStyle(THCFontStyle.tsItalic);
    2: FHCView.ApplyTextStyle(THCFontStyle.tsUnderline);
    3: FHCView.ApplyTextStyle(THCFontStyle.tsStrikeOut);
    4: FHCView.ApplyTextStyle(THCFontStyle.tsSuperscript);
    5: FHCView.ApplyTextStyle(THCFontStyle.tsSubscript);
  end;
end;

procedure TfrmHCViewDemo.btnNewClick(Sender: TObject);
begin
  FHCView.FileName := '';
  FHCView.Clear;
end;

procedure TfrmHCViewDemo.btnprintClick(Sender: TObject);
var
  vDlgPrint: TPrintDialog;
begin
  vDlgPrint := TPrintDialog.Create(nil);
  try
    vDlgPrint.MaxPage := FHCView.PageCount;
    if vDlgPrint.Execute then
      FHCView.Print(Printer.Printers[Printer.PrinterIndex]);
  finally
    FreeAndNil(vDlgPrint);
  end;
end;

procedure TfrmHCViewDemo.actCopyExecute(Sender: TObject);
begin
  FHCView.Copy;
end;

procedure TfrmHCViewDemo.actCutExecute(Sender: TObject);
begin
  FHCView.Cut;
end;

procedure TfrmHCViewDemo.actPasteExecute(Sender: TObject);
begin
  FHCView.Paste;
end;

procedure TfrmHCViewDemo.actSearchExecute(Sender: TObject);
begin
  if not Assigned(frmSearchAndReplace) then
  begin
    frmSearchAndReplace := TfrmSearchAndReplace.Create(Self);
    frmSearchAndReplace.SetHCView(FHCView)
  end;
  frmSearchAndReplace.ShowSearch;
end;

procedure TfrmHCViewDemo.btn4Click(Sender: TObject);
begin
  FHCView.Undo;
end;

procedure TfrmHCViewDemo.btn5Click(Sender: TObject);
begin
  FHCView.Redo;
end;

procedure TfrmHCViewDemo.btnAlignLeftClick(Sender: TObject);
begin
  case (Sender as TToolButton).Tag of
    0: FHCView.ApplyParaAlignHorz(TParaAlignHorz.pahLeft);
    1: FHCView.ApplyParaAlignHorz(TParaAlignHorz.pahCenter);
    2: FHCView.ApplyParaAlignHorz(TParaAlignHorz.pahRight);
    3: FHCView.ApplyParaAlignHorz(TParaAlignHorz.pahJustify);  // 两端
    4: FHCView.ApplyParaAlignHorz(TParaAlignHorz.pahScatter);  // 分散
  end;
end;

procedure TfrmHCViewDemo.FormCreate(Sender: TObject);
begin
  Caption := 'HCViewDemo ' + GetVersionInfo;
  FHCView := THCView.Create(Self);
  FHCView.OnCaretChange := DoCaretChange;
  FHCView.OnVerScroll := DoVerScroll;
  FHCView.Parent := Self;
  FHCView.Align := alClient;
  FHCView.PopupMenu := pmRichEdit;
end;

procedure TfrmHCViewDemo.FormDestroy(Sender: TObject);
begin
  FHCView.Free;
  if Assigned(frmSearchAndReplace) then
    FreeAndNil(frmSearchAndReplace);
end;

procedure TfrmHCViewDemo.FormShow(Sender: TObject);
begin
  cbbFont.Items := Screen.Fonts;
  cbbFont.ItemIndex := cbbFont.Items.IndexOf('宋体');
  FHCView.SetFocus;
end;

procedure TfrmHCViewDemo.GetPagesAndActive;
begin
  statbar.Panels[0].Text := '预览' + IntToStr(FHCView.PagePreviewFirst + 1)
    + '页 光标' + IntToStr(FHCView.ActivePageIndex + 1)
    + '页 共' + IntToStr(FHCView.PageCount) + '页';
end;

procedure TfrmHCViewDemo.mniC1Click(Sender: TObject);
var
  vCheckBox: THCCheckBoxItem;
  vS: string;
begin
  vS := '勾选框';
  if InputQuery('勾选框', '文本', vS) then
  begin
    vCheckBox := THCCheckBoxItem.Create(FHCView.ActiveSectionTopLevelData, vS, False);
    FHCView.InsertItem(vCheckBox);
  end;
end;

procedure TfrmHCViewDemo.mniCombobox1Click(Sender: TObject);
var
  vCombobox: THCComboboxItem;
  vS: string;
begin
  vS := '默认值';
  if InputQuery('下拉框', '文本内容', vS) then
  begin
    vCombobox := THCComboboxItem.Create(FHCView.ActiveSectionTopLevelData, vS);
    vCombobox.Items.Add('选项1');
    vCombobox.Items.Add('选项2');
    vCombobox.Items.Add('选项3');
    vCombobox.OnPopupItem := DoComboboxPopupItem;
    //vCombobox.ItemIndex := 0;
    FHCView.InsertItem(vCombobox);
  end;
end;

procedure TfrmHCViewDemo.mniLineSpaceClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    case (Sender as TMenuItem).Tag of
      0: FHCView.ApplyParaLineSpace(TParaLineSpaceMode.pls100);   // 单倍
      1: FHCView.ApplyParaLineSpace(TParaLineSpaceMode.pls115);  // 1.15倍
      2: FHCView.ApplyParaLineSpace(TParaLineSpaceMode.pls150);  // 1.5倍
      3: FHCView.ApplyParaLineSpace(TParaLineSpaceMode.pls200);  // 双倍
    end;
  end;
end;

procedure TfrmHCViewDemo.mniMergeClick(Sender: TObject);
begin
  FHCView.MergeTableSelectCells;
end;

procedure TfrmHCViewDemo.mniN14Click(Sender: TObject);
begin
  FHCView.InsertLine(1);
end;

procedure TfrmHCViewDemo.mniN18Click(Sender: TObject);
begin
  if FHCView.ActiveSection.ActiveData.SelectExists then
    FHCView.InsertAnnotate('aaaa')
end;

procedure TfrmHCViewDemo.mniN19Click(Sender: TObject);
var
  vExpressItem: THCExpressItem;
begin
  vExpressItem := THCExpressItem.Create(FHCView.ActiveSectionTopLevelData,
    '12', '5-6', '2017-6-3', '28-30');
  FHCView.InsertItem(vExpressItem);
end;

procedure TfrmHCViewDemo.mniDisBorderClick(Sender: TObject);
var
  vTable: THCTableItem;
begin
  if FHCView.ActiveSection.ActiveData.GetCurItem is THCTableItem then
  begin
    vTable := FHCView.ActiveSection.ActiveData.GetCurItem as THCTableItem;
    vTable.BorderVisible := not vTable.BorderVisible;
    FHCView.UpdateView;
  end;
end;

procedure TfrmHCViewDemo.mniEdit1Click(Sender: TObject);
var
  vEdit: THCEditItem;
  vS: string;
begin
  vS := '文本';
  if InputQuery('文本框', '文本内容', vS) then
  begin
    vEdit := THCEditItem.Create(FHCView.ActiveSectionTopLevelData, vS);
    FHCView.InsertItem(vEdit);
  end;
end;

procedure TfrmHCViewDemo.mnigif1Click(Sender: TObject);
var
  vOpenDlg: TOpenDialog;
  vGifItem: THCGifItem;
begin
  vOpenDlg := TOpenDialog.Create(Self);
  try
    vOpenDlg.Filter := '图像文件|*.gif';
    if vOpenDlg.Execute then
    begin
      if vOpenDlg.FileName <> '' then
      begin
        vGifItem := THCGifItem.Create(FHCView.ActiveSectionTopLevelData);
        vGifItem.LoadFromFile(vOpenDlg.FileName);
        Application.ProcessMessages;  // 解决双击打开文件后，触发下层控件的Mousemove，Mouseup事件
        FHCView.InsertItem(vGifItem);
      end;
    end;
  finally
    FreeAndNil(vOpenDlg);
  end;
end;

procedure TfrmHCViewDemo.mniInsertRowTopClick(Sender: TObject);
begin
  FHCView.ActiveTableInsertRowBefor(1);
end;

procedure TfrmHCViewDemo.mniInsertRowBottomClick(Sender: TObject);
begin
  FHCView.ActiveTableInsertRowAfter(1);
end;

procedure TfrmHCViewDemo.mniInsertColLeftClick(Sender: TObject);
begin
  FHCView.ActiveTableInsertColBefor(1);
end;

procedure TfrmHCViewDemo.mniInsertColRightClick(Sender: TObject);
begin
  FHCView.ActiveTableInsertColAfter(1);
end;

procedure TfrmHCViewDemo.mniDeleteCurRowClick(Sender: TObject);
begin
  FHCView.ActiveTableDeleteCurRow;
end;

procedure TfrmHCViewDemo.mniDeleteCurColClick(Sender: TObject);
begin
  FHCView.ActiveTableDeleteCurCol;
end;

procedure TfrmHCViewDemo.mniN20Click(Sender: TObject);
var
  vToothItem: TEmrToothItem;
begin
  vToothItem := TEmrToothItem.Create(FHCView.ActiveSectionTopLevelData, '', '', '', '');
  FHCView.InsertItem(vToothItem);
end;

procedure TfrmHCViewDemo.mniN22Click(Sender: TObject);
var
  vFangJiaoItem: TEmrFangJiaoItem;
begin
  vFangJiaoItem := TEmrFangJiaoItem.Create(FHCView.ActiveSectionTopLevelData, '', '', '', '');
  FHCView.InsertItem(vFangJiaoItem);
end;

procedure TfrmHCViewDemo.mniN23Click(Sender: TObject);
var
  vQRCode: THCQRCodeItem;
  vS: string;
begin
  vS := InputBox('文本框', '文本', 'HCView使用了DelphiZXingQRCode二维码控件');
  vQRCode := THCQRCodeItem.Create(FHCView.ActiveSectionTopLevelData, vS);
  FHCView.InsertItem(vQRCode);
end;

procedure TfrmHCViewDemo.mniN26Click(Sender: TObject);
var
  vFrmParagraph: TfrmParagraph;
begin
  vFrmParagraph := TfrmParagraph.Create(Self);
  try
    vFrmParagraph.SetHCView(FHCView);
  finally
    FreeAndNil(vFrmParagraph);
  end;
end;

procedure TfrmHCViewDemo.mniN27Click(Sender: TObject);
begin
  FHCView.InsertPageBreak;
end;

procedure TfrmHCViewDemo.mniN28Click(Sender: TObject);
begin
  FHCView.InsertSectionBreak;
end;

procedure TfrmHCViewDemo.mniN2Click(Sender: TObject);
var
  vsLineSpace: string;
  vSpace: Integer;
begin
  vsLineSpace := InputBox('行间距', '固定值(>5)', '20');
  if TryStrToInt(vsLineSpace, vSpace) then
  begin
    if vSpace >= 5 then
      FHCView.ApplyParaLineSpace(TParaLineSpaceMode.plsFix);  // 固定值
  end;
end;

procedure TfrmHCViewDemo.mniInsertTableClick(Sender: TObject);
var
  vFrmInsertTable: TfrmInsertTable;
begin
  vFrmInsertTable := TfrmInsertTable.Create(Self);
  try
    vFrmInsertTable.ShowModal;
    if vFrmInsertTable.ModalResult = mrOk then
    begin
      FHCView.InsertTable(StrToInt(vFrmInsertTable.edtRows.Text),
        StrToInt(vFrmInsertTable.edtCols.Text));
    end;
  finally
    FreeAndNil(vFrmInsertTable);
  end;
end;

procedure TfrmHCViewDemo.mniN30Click(Sender: TObject);
begin
  FHCView.DeleteSelected;
end;

procedure TfrmHCViewDemo.mniN31Click(Sender: TObject);
begin
  FHCView.DeleteActiveSection;
end;

procedure TfrmHCViewDemo.mniN32Click(Sender: TObject);
var
  vMemory: TMemoryStream;
  vOpenDlg: TOpenDialog;
begin
  vOpenDlg := TOpenDialog.Create(Self);
  try
    vOpenDlg.Filter := '文件|*' + HC_EXT;
    if vOpenDlg.Execute then
    begin
      if vOpenDlg.FileName <> '' then
      begin
        vMemory := TMemoryStream.Create;
        try
          vMemory.LoadFromFile(vOpenDlg.FileName);
          FHCView.InsertStream(vMemory);
        finally
          FreeAndNil(vMemory);
        end;
      end;
    end;
  finally
    FreeAndNil(vOpenDlg);
  end;
end;

procedure TfrmHCViewDemo.mniN33Click(Sender: TObject);
var
  vHCBarCode: THCBarCodeItem;
  vS: string;
begin
  vS := InputBox('文本框', '文本', 'HC-' + FormatDateTime('YYYYMMDD', Now));
  vHCBarCode := THCBarCodeItem.Create(FHCView.ActiveSectionTopLevelData, vS);
  FHCView.InsertItem(vHCBarCode);
end;

procedure TfrmHCViewDemo.mniN34Click(Sender: TObject);
var
  vFractionItem: THCFractionItem;
begin
  vFractionItem := THCFractionItem.Create(FHCView.ActiveSectionTopLevelData, '12', '2018');
  //vFractionItem.LineHide := True;
  FHCView.InsertItem(vFractionItem);
end;

procedure TfrmHCViewDemo.mniN35Click(Sender: TObject);
begin
  btnprintClick(Sender);
end;

procedure TfrmHCViewDemo.mniN36Click(Sender: TObject);
begin
  FHCView.PrintCurPageByActiveLine(False, False);
end;

procedure TfrmHCViewDemo.mniN37Click(Sender: TObject);
begin
  FHCView.PrintCurPageSelected(False, False);
end;

procedure TfrmHCViewDemo.mniN39Click(Sender: TObject);
var
  vFloatLineItem: THCFloatLineItem;
begin
  vFloatLineItem := THCFloatLineItem.Create(FHCView.ActiveSection.ActiveData);
  FHCView.InsertFloatItem(vFloatLineItem);
end;

procedure TfrmHCViewDemo.mniN42Click(Sender: TObject);
var
  vFrmPrintView: TfrmPrintView;
begin
  vFrmPrintView := TfrmPrintView.Create(Self);
  try
    vFrmPrintView.SetHCView(FHCView);
  finally
    FreeAndNil(vFrmPrintView);
  end;
end;

procedure TfrmHCViewDemo.mniN43Click(Sender: TObject);
var
  vFrmBorderBackColor: TfrmBorderBackColor;
begin
  vFrmBorderBackColor := TfrmBorderBackColor.Create(Self);
  try
    vFrmBorderBackColor.SetHCView(FHCView);
  finally
    FreeAndNil(vFrmBorderBackColor);
  end;
end;

procedure TfrmHCViewDemo.mniN44Click(Sender: TObject);
var
  vHCDateTimePicker: THCDateTimePicker;
begin
  vHCDateTimePicker := THCDateTimePicker.Create(FHCView.ActiveSectionTopLevelData, Now);
  FHCView.InsertItem(vHCDateTimePicker);
end;

procedure TfrmHCViewDemo.mniN45Click(Sender: TObject);
var
  vSupSubScriptItem: THCSupSubScriptItem;
begin
  vSupSubScriptItem := THCSupSubScriptItem.Create(FHCView.ActiveSectionTopLevelData, '20g', '先煎');
  FHCView.InsertItem(vSupSubScriptItem);
end;

procedure TfrmHCViewDemo.mniSplitRowClick(Sender: TObject);
begin
  FHCView.ActiveTableSplitCurRow;
end;

procedure TfrmHCViewDemo.mniSplitColClick(Sender: TObject);
begin
  FHCView.ActiveTableSplitCurCol;
end;

procedure TfrmHCViewDemo.mniN4Click(Sender: TObject);
var
  vText: string;
begin
  vText := InputBox('插入文本', '', '');
  if vText <> '' then
    FHCView.InsertText(vText);
end;

procedure TfrmHCViewDemo.mniN5Click(Sender: TObject);
var
  vFrmPageSet: TFrmPageSet;
begin
  vFrmPageSet := TFrmPageSet.Create(Self);
  try
    vFrmPageSet.SetHCView(FHCView);
  finally
    FreeAndNil(vFrmPageSet);
  end;
end;

procedure TfrmHCViewDemo.mniN9Click(Sender: TObject);
var
  vOpenDlg: TOpenDialog;
  vImageItem: THCImageItem;
begin
  vOpenDlg := TOpenDialog.Create(Self);
  try
    vOpenDlg.Filter := '图像文件|*.bmp';//|*.jpg|*.jpge|*.png';
    if vOpenDlg.Execute then
    begin
      if vOpenDlg.FileName <> '' then
      begin
        vImageItem := THCImageItem.Create(FHCView.ActiveSectionTopLevelData);
        vImageItem.LoadFromBmpFile(vOpenDlg.FileName);
        Application.ProcessMessages;  // 解决双击打开文件后，触发下层控件的Mousemove，Mouseup事件
        FHCView.InsertItem(vImageItem);
      end;
    end;
  finally
    FreeAndNil(vOpenDlg);
  end;
end;

procedure TfrmHCViewDemo.mniOpenClick(Sender: TObject);
var
  vOpenDlg: TOpenDialog;
begin
  vOpenDlg := TOpenDialog.Create(Self);
  try
    vOpenDlg.Filter := '文件|*' + HC_EXT;
    if vOpenDlg.Execute then
    begin
      if vOpenDlg.FileName <> '' then
      begin
        Application.ProcessMessages;  // 解决双击打开文件后，触发下层控件的Mousemove，Mouseup事件
        FHCView.LoadFromFile(vOpenDlg.FileName);
      end;
    end;
  finally
    FreeAndNil(vOpenDlg);
  end;
end;

procedure TfrmHCViewDemo.mniControlItemClick(Sender: TObject);
var
  vFrmControlItemProperty: TfrmControlItemProperty;
begin
  vFrmControlItemProperty := TfrmControlItemProperty.Create(nil);
  try
    vFrmControlItemProperty.SetHCView(FHCView);
  finally
    FreeAndNil(vFrmControlItemProperty);
  end;
end;

procedure TfrmHCViewDemo.mniRadioButton1Click(Sender: TObject);
var
  vHCRadioGroup: THCRadioGroup;
begin
  vHCRadioGroup := THCRadioGroup.Create(FHCView.ActiveSectionTopLevelData);
  vHCRadioGroup.AddItem('选项1');
  vHCRadioGroup.AddItem('选项2');
  vHCRadioGroup.AddItem('选项3');
  FHCView.InsertItem(vHCRadioGroup);
end;

procedure TfrmHCViewDemo.mniSaveAsClick(Sender: TObject);
var
  vDlg: TSaveDialog;
  vExt: string;
begin
  vDlg := TSaveDialog.Create(Self);
  try
    vDlg.Filter := 'hcf|*' + HC_EXT + '|pdf|*.pdf';
    vDlg.Execute;
    if vDlg.FileName <> '' then
    begin
      vExt := '';
      case vDlg.FilterIndex of
        1: vExt := HC_EXT;
        2: vExt := '.pdf';
      else
        Exit;
      end;

      if ExtractFileExt(vDlg.FileName) <> vExt then  // 避免重复后缀
        vDlg.FileName := vDlg.FileName + vExt;

      case vDlg.FilterIndex of
        1:  // .hcf
          begin
            FHCView.SaveToFile(vDlg.FileName);
            SetFileName(vDlg.FileName);
          end;

        2: FHCView.SaveAsPDF(vDlg.FileName);  // .pdf
      end;
    end;
  finally
    vDlg.Free;
  end;
end;

procedure TfrmHCViewDemo.mniSaveClick(Sender: TObject);
var
  vDlg: TSaveDialog;
begin
  if FHCView.FileName <> '' then
    FHCView.SaveToFile(FHCView.FileName)
  else
  begin
    vDlg := TSaveDialog.Create(Self);
    try
      vDlg.Filter := '文件|*' + HC_EXT;
      vDlg.Execute;
      if vDlg.FileName <> '' then
      begin
        if ExtractFileName(vDlg.FileName) <> HC_EXT then
          vDlg.FileName := vDlg.FileName + HC_EXT;
        FHCView.SaveToFile(vDlg.FileName);
      end;
    finally
      vDlg.Free;
    end;
  end;
end;

procedure TfrmHCViewDemo.mniTablePropertyClick(Sender: TObject);
var
  vFrmTableProperty: TFrmTableProperty;
begin
  vFrmTableProperty := TFrmTableProperty.Create(Self);
  try
    vFrmTableProperty.SetHCView(FHCView);
  finally
    FreeAndNil(vFrmTableProperty);
  end;
end;

procedure TfrmHCViewDemo.pmRichEditPopup(Sender: TObject);
var
  vActiveItem, vTopItem: THCCustomItem;
  vTableItem: THCTableItem;
  vActiveData, vTopData: THCCustomData;
begin
  vActiveData := FHCView.ActiveSection.ActiveData;
  vActiveItem := vActiveData.GetCurItem;

  //if vActiveItem = nil then Exit;

  vTopData := nil;
  vTopItem := vActiveItem;

  while vTopItem is THCCustomRectItem do
  begin
    if (vTopItem as THCCustomRectItem).GetActiveData <> nil then
    begin
      if vTopData <> nil then
      begin
        vActiveData := vTopData;
        vActiveItem := vTopItem;
      end;

      vTopData := (vTopItem as THCCustomRectItem).GetActiveData;
      vTopItem := vTopData.GetCurItem;
    end
    else
      Break;
  end;

  if vTopData = nil then
    vTopData := vActiveData;

  mniTable.Enabled := vActiveItem.StyleNo = THCStyle.Table;
  if mniTable.Enabled then
  begin
    vTableItem := vActiveItem as THCTableItem;
    mniInsertRowTop.Enabled := vTableItem.GetEditCell <> nil;
    mniInsertRowBottom.Enabled := mniInsertRowTop.Enabled;
    mniInsertColLeft.Enabled := mniInsertRowTop.Enabled;
    mniInsertColRight.Enabled := mniInsertRowTop.Enabled;
    mniSplitRow.Enabled := mniInsertRowTop.Enabled;
    mniSplitCol.Enabled := mniInsertRowTop.Enabled;

    mniDeleteCurRow.Enabled := vTableItem.CurRowCanDelete;
    mniDeleteCurCol.Enabled := vTableItem.CurColCanDelete;
    mniMerge.Enabled := vTableItem.SelectedCellCanMerge;
  end;
  actCut.Enabled := (not FHCView.ActiveSection.ReadOnly) and vTopData.SelectExists;
  actCopy.Enabled := actCut.Enabled;
  actPaste.Enabled := (not FHCView.ActiveSection.ReadOnly)  // 非只读
    and (Clipboard.HasFormat(HC_FILEFORMAT)
         or Clipboard.HasFormat(CF_TEXT)
         or Clipboard.HasFormat(CF_BITMAP));
  mniControlItem.Visible := (not FHCView.ActiveSection.ReadOnly) and (not vTopData.SelectExists)
    and (vTopItem is THCControlItem) and vTopItem.Active;
  if mniControlItem.Visible then
    mniControlItem.Caption := '属性(' + (vTopItem as THCControlItem).ClassName + ')';
end;

procedure TfrmHCViewDemo.SetFileName(const AFileName: string);
begin
  FHCView.FileName := AFileName;
  statbar.Panels[1].Text := FHCView.FileName;
end;

end.
