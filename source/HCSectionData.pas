{*******************************************************}
{                                                       }
{               HCView V1.1  ���ߣ���ͨ                 }
{                                                       }
{      ��������ѭBSDЭ�飬����Լ���QQȺ 649023932      }
{            ����ȡ����ļ������� 2018-5-4              }
{                                                       }
{                �ĵ��ڶ���߼�������Ԫ                 }
{                                                       }
{*******************************************************}

unit HCSectionData;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, Generics.Collections, HCCustomRichData,
  HCCustomData, HCPage, HCItem, HCDrawItem, HCCommon, HCStyle, HCParaStyle, HCTextStyle,
  HCRichData, HCFloatItem;

type
  TGetScreenCoordEvent = function (const X, Y: Integer): TPoint of object;

  // �����ĵ�ҳü��ҳ�š�ҳ��Data���࣬��Ҫ���ڴ����ĵ���Data�仯ʱ���е����Ի��¼�
  // ��ֻ��״̬�л���ҳü��ҳ�š�ҳ���л�ʱ��Ҫ֪ͨ�ⲿ�ؼ���������ؼ�״̬�仯��
  // ����Ԫ��ֻ���л�ʱ����Ҫ
  THCSectionData = class(THCRichData)
  private
    FOnReadOnlySwitch: TNotifyEvent;
    FOnGetScreenCoord: TGetScreenCoordEvent;

    FFloatItems: TObjectList<THCFloatItem>;  // THCItems֧��Addʱ������ʱ����
    FFloatItemIndex, FMouseDownIndex, FMouseMoveIndex,
    FMouseX, FMouseY
      : Integer;

    function CreateFloatItemByStyle(const AStyleNo: Integer): THCFloatItem;
    function GetFloatItemAt(const X, Y: Integer): Integer;
    function GetActiveFloatItem: THCFloatItem;
  protected
    function GetScreenCoord(const X, Y: Integer): TPoint; override;
    procedure SetReadOnly(const Value: Boolean); override;
  public
    constructor Create(const AStyle: THCStyle); override;
    destructor Destroy; override;

    function MouseDownFloatItem(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseMoveFloatItem(Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseUpFloatItem(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function KeyDownFloatItem(var Key: Word; Shift: TShiftState): Boolean;

    procedure Clear; override;
    procedure GetCaretInfo(const AItemNo, AOffset: Integer; var ACaretInfo: TCaretInfo); override;

    /// <summary> ���븡��Item </summary>
    function InsertFloatItem(const AFloatItem: THCFloatItem): Boolean;

    procedure SaveToStream(const AStream: TStream; const AStartItemNo, AStartOffset,
      AEndItemNo, AEndOffset: Integer); override;
    procedure LoadFromStream(const AStream: TStream; const AStyle: THCStyle;
      const AFileVersion: Word); override;

    procedure PaintFloatItems(const APageIndex, ADataDrawLeft, ADataDrawTop,
      AVOffset: Integer; const ACanvas: TCanvas; const APaintInfo: TPaintInfo); virtual;

    property FloatItemIndex: Integer read FFloatItemIndex;
    property ActiveFloatItem: THCFloatItem read GetActiveFloatItem;
    property FloatItems: TObjectList<THCFloatItem> read FFloatItems;
    property OnReadOnlySwitch: TNotifyEvent read FOnReadOnlySwitch write FOnReadOnlySwitch;
    property OnGetScreenCoord: TGetScreenCoordEvent read FOnGetScreenCoord write FOnGetScreenCoord;
  end;

  THCHeaderData = class(THCSectionData);

  THCFooterData = class(THCSectionData);

  THCPageData = class(THCSectionData)  // ��������Ҫ��������Ԫ��Data����Ҫ��������Ҫ�����Ի��¼�
  private
    FShowLineActiveMark: Boolean;  // ��ǰ�������ǰ��ʾ��ʶ
    FShowUnderLine: Boolean;  // �»���
    FShowLineNo: Boolean;  // �к�
    FReFormatStartItemNo: Integer;
    function GetPageDataFmtTop(const APageIndex: Integer): Integer;
  protected
    procedure ReFormatData_(const AStartItemNo: Integer; const ALastItemNo: Integer = -1;
      const AExtraItemCount: Integer = 0); override;
    procedure DoDrawItemPaintBefor(const AData: THCCustomData; const ADrawItemNo: Integer;
      const ADrawRect: TRect; const ADataDrawLeft, ADataDrawBottom, ADataScreenTop,
      ADataScreenBottom: Integer; const ACanvas: TCanvas; const APaintInfo: TPaintInfo); override;
    {$IFDEF DEBUG}
    procedure DoDrawItemPaintAfter(const AData: THCCustomData; const ADrawItemNo: Integer;
      const ADrawRect: TRect; const ADataDrawLeft, ADataDrawBottom, ADataScreenTop,
      ADataScreenBottom: Integer; const ACanvas: TCanvas; const APaintInfo: TPaintInfo); override;
    {$ENDIF}
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SaveToStream(const AStream: TStream); override;
    procedure LoadFromStream(const AStream: TStream; const AStyle: THCStyle;
      const AFileVersion: Word); override;
    function InsertStream(const AStream: TStream; const AStyle: THCStyle;
      const AFileVersion: Word): Boolean; override;
  public
    constructor Create(const AStyle: THCStyle); override;

    procedure PaintFloatItems(const APageIndex, ADataDrawLeft, ADataDrawTop,
      AVOffset: Integer; const ACanvas: TCanvas; const APaintInfo: TPaintInfo); override;

    /// <summary> �ӵ�ǰλ�ú��ҳ </summary>
    function InsertPageBreak: Boolean;

    /// <summary> ������ע </summary>
    function InsertAnnotate(const AText: string): Boolean;
    //
    // ����
    function GetTextStr: string;
    procedure SaveToText(const AFileName: string; const AEncoding: TEncoding);
    procedure SaveToTextStream(const AStream: TStream; const AEncoding: TEncoding);
    // ��ȡ
    procedure LoadFromText(const AFileName: string; const AEncoding: TEncoding);
    procedure LoadFromTextStream(AStream: TStream; AEncoding: TEncoding);
    //
    property ShowLineActiveMark: Boolean read FShowLineActiveMark write FShowLineActiveMark;
    property ShowLineNo: Boolean read FShowLineNo write FShowLineNo;
    property ShowUnderLine: Boolean read FShowUnderLine write FShowUnderLine;
    property ReFormatStartItemNo: Integer read FReFormatStartItemNo;
  end;

implementation

{$I HCView.inc}

uses
  Math, HCTextItem, HCRectItem, HCImageItem, HCTableItem, HCPageBreakItem,
  HCFloatLineItem;

{ THCPageData }

constructor THCPageData.Create(const AStyle: THCStyle);
begin
  inherited Create(AStyle);
  FShowLineActiveMark := False;
  FShowUnderLine := False;
  FShowLineNo := False;
end;

procedure THCPageData.SaveToStream(const AStream: TStream);
begin
  AStream.WriteBuffer(FShowUnderLine, SizeOf(FShowUnderLine));
  inherited SaveToStream(AStream);
end;

procedure THCPageData.SaveToText(const AFileName: string; const AEncoding: TEncoding);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToTextStream(Stream, AEncoding);
  finally
    Stream.Free;
  end;
end;

procedure THCPageData.SaveToTextStream(const AStream: TStream; const AEncoding: TEncoding);
var
  Buffer, Preamble: TBytes;
begin
  Buffer := AEncoding.GetBytes(GetTextStr);
  Preamble := AEncoding.GetPreamble;
  if Length(Preamble) > 0 then
    AStream.WriteBuffer(Preamble[0], Length(Preamble));
  AStream.WriteBuffer(Buffer[0], Length(Buffer));
end;

{$IFDEF DEBUG}
procedure THCPageData.DoDrawItemPaintAfter(const AData: THCCustomData;
  const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
  ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
  const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
begin
  inherited;
  {$IFDEF SHOWITEMNO}
  if ADrawItemNo = Items[DrawItems[ADrawItemNo].ItemNo].FirstDItemNo then  //
  {$ENDIF}
  begin
    {$IFDEF SHOWITEMNO}
    DrawDebugInfo(ACanvas, ADrawRect.Left, ADrawRect.Top - 12, IntToStr(DrawItems[ADrawItemNo].ItemNo));
    {$ENDIF}

    {$IFDEF SHOWDRAWITEMNO}
    DrawDebugInfo(ACanvas, ADrawRect.Left, ADrawRect.Top - 12, IntToStr(ADrawItemNo));
    {$ENDIF}
  end;
end;
{$ENDIF}

procedure THCPageData.DoDrawItemPaintBefor(const AData: THCCustomData;
  const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
  ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
  const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
var
  vTop: Integer;
  vFont: TFont;
  i, vLineNo: Integer;
begin
  inherited DoDrawItemPaintBefor(AData, ADrawItemNo, ADrawRect, ADataDrawLeft,
    ADataDrawBottom, ADataScreenTop, ADataScreenBottom, ACanvas, APaintInfo);
  if not APaintInfo.Print then
  begin
    if FShowLineActiveMark then  // ������ָʾ��
    begin
      if ADrawItemNo = GetSelectStartDrawItemNo then  // ��ѡ�е���ʼDrawItem
      begin
        ACanvas.Pen.Color := clBlue;
        ACanvas.Pen.Style := psSolid;
        vTop := ADrawRect.Top + DrawItems[ADrawItemNo].Height div 2;

        ACanvas.MoveTo(ADataDrawLeft - 10, vTop);
        ACanvas.LineTo(ADataDrawLeft - 11, vTop);

        ACanvas.MoveTo(ADataDrawLeft - 11, vTop - 1);
        ACanvas.LineTo(ADataDrawLeft - 11, vTop + 2);
        ACanvas.MoveTo(ADataDrawLeft - 12, vTop - 2);
        ACanvas.LineTo(ADataDrawLeft - 12, vTop + 3);
        ACanvas.MoveTo(ADataDrawLeft - 13, vTop - 3);
        ACanvas.LineTo(ADataDrawLeft - 13, vTop + 4);
        ACanvas.MoveTo(ADataDrawLeft - 14, vTop - 4);
        ACanvas.LineTo(ADataDrawLeft - 14, vTop + 5);
        ACanvas.MoveTo(ADataDrawLeft - 15, vTop - 2);
        ACanvas.LineTo(ADataDrawLeft - 15, vTop + 3);
        ACanvas.MoveTo(ADataDrawLeft - 16, vTop - 2);
        ACanvas.LineTo(ADataDrawLeft - 16, vTop + 3);
      end;
    end;

    if FShowUnderLine then  // �»���
    begin
      if DrawItems[ADrawItemNo].LineFirst then
      begin
        ACanvas.Pen.Color := clBlack;
        ACanvas.Pen.Style := psSolid;
        ACanvas.MoveTo(ADataDrawLeft, ADrawRect.Bottom);
        ACanvas.LineTo(ADataDrawLeft + Self.Width, ADrawRect.Bottom);
      end;
    end;

    if FShowLineNo then  // �к�
    begin
      if DrawItems[ADrawItemNo].LineFirst then
      begin
        vLineNo := 0;
        for i := 0 to ADrawItemNo do
        begin
          if DrawItems[i].LineFirst then
            Inc(vLineNo);
        end;

        vFont := TFont.Create;
        try
          vFont.Assign(ACanvas.Font);
          ACanvas.Font.Color := RGB(180, 180, 180);
          ACanvas.Font.Size := 10;
          ACanvas.Font.Style := [];
          ACanvas.Font.Name := 'Courier New';
          //SetTextColor(ACanvas.Handle, RGB(180, 180, 180));
          ACanvas.Brush.Style := bsClear;
          vTop := ADrawRect.Top + (ADrawRect.Bottom - ADrawRect.Top - 16) div 2;
          ACanvas.TextOut(ADataDrawLeft - 50, vTop, IntToStr(vLineNo));
        finally
          ACanvas.Font.Assign(vFont);
          FreeAndNil(vFont);
        end;
      end;
    end;
  end;
end;

function THCPageData.GetTextStr: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Items.Count - 1 do
    Result := Result + Items[i].Text;
end;

function THCPageData.InsertAnnotate(const AText: string): Boolean;
//var
//  vAnnotaeItem: TAnnotaeItem;
begin
  Result := False;
  // ��ǰѡ�е�����������ע����ʱδ���
//  Self.InsertItem(vAnnotaeItem);
end;

function THCPageData.InsertPageBreak: Boolean;
var
  vPageBreak: TPageBreakItem;
  vKey: Word;
begin
  Result := False;

  vPageBreak := TPageBreakItem.Create(Self);
  vPageBreak.ParaFirst := True;
  // ��һ��Item�ֵ���һҳ��ǰһҳû���κ�Item���Ա༭����಻����������ǰһҳ����һ����Item
  if (SelectInfo.StartItemNo = 0) and (SelectInfo.StartItemOffset = 0) then
  begin
    vKey := VK_RETURN;
    KeyDown(vKey, []);
  end;

  Result := Self.InsertItem(vPageBreak);
end;

function THCPageData.InsertStream(const AStream: TStream;
  const AStyle: THCStyle; const AFileVersion: Word): Boolean;
begin
  // ��Ϊ����ճ��ʱ������ҪFShowUnderLine��Ϊ����ճ������FShowUnderLine��LoadFromStremʱ����
  //AStream.ReadBuffer(FShowUnderLine, SizeOf(FShowUnderLine));
  inherited InsertStream(AStream, AStyle, AFileVersion);
end;

procedure THCPageData.LoadFromStream(const AStream: TStream;
  const AStyle: THCStyle; const AFileVersion: Word);
begin
  AStream.ReadBuffer(FShowUnderLine, SizeOf(FShowUnderLine));
  inherited LoadFromStream(AStream, AStyle, AFileVersion);
end;

function THCPageData.GetPageDataFmtTop(const APageIndex: Integer): Integer;
//var
//  i, vContentHeight: Integer;
begin
//  Result := 0;
//  if APageIndex > 0 then
//  begin
//    vContentHeight := FPageSize.PageHeightPix  // ��ҳ����������߶ȣ���ҳ���ҳü��ҳ�ź󾻸�
//      - FPageSize.PageMarginBottomPix - GetHeaderAreaHeight;
//
//    for i := 0 to APageIndex - 1 do
//      Result := Result + vContentHeight;
//  end;
end;

procedure THCPageData.LoadFromText(const AFileName: string; const AEncoding: TEncoding);
var
  vStream: TStream;
  vFileFormat: string;
begin
  vStream := TFileStream.Create(AFileName, fmOpenRead or fmShareExclusive);  // ֻ���򿪡������������������κη�ʽ��
  try
    vFileFormat := ExtractFileExt(AFileName);
    vFileFormat := LowerCase(vFileFormat);
    if vFileFormat = '.txt' then
      LoadFromTextStream(vStream, AEncoding);
  finally
    vStream.Free;
  end;
end;

procedure THCPageData.LoadFromTextStream(AStream: TStream; AEncoding: TEncoding);
var
  vSize: Integer;
  vBuffer: TBytes;
  vS: string;
begin
  Clear;
  vSize := AStream.Size - AStream.Position;
  SetLength(vBuffer, vSize);
  AStream.Read(vBuffer[0], vSize);
  vSize := TEncoding.GetBufferEncoding(vBuffer, AEncoding);
  vS := AEncoding.GetString(vBuffer, vSize, Length(vBuffer) - vSize);
  if vS <> '' then
    InsertText(vS);
end;

procedure THCPageData.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  vMouseDownItemNo, vMouseDownItemOffset: Integer;
begin
  if FShowLineActiveMark then  // ��ʾ��ǰ�༭��
  begin
    vMouseDownItemNo := Self.MouseDownItemNo;
    vMouseDownItemOffset := Self.MouseDownItemOffset;
    inherited MouseDown(Button, Shift, X, Y);
    if (vMouseDownItemNo <> Self.MouseDownItemNo) or (vMouseDownItemOffset <> Self.MouseDownItemOffset) then
      Style.UpdateInfoRePaint;
  end
  else
    inherited MouseDown(Button, Shift, X, Y);
end;

procedure THCPageData.PaintFloatItems(const APageIndex, ADataDrawLeft,
  ADataDrawTop, AVOffset: Integer; const ACanvas: TCanvas;
  const APaintInfo: TPaintInfo);
var
  i: Integer;
  vFloatItem: THCFloatItem;
begin
  for i := 0 to FFloatItems.Count - 1 do
  begin
    vFloatItem := FFloatItems[i];

    if vFloatItem.PageIndex = APageIndex then
    begin
      vFloatItem.DrawRect := Bounds(vFloatItem.Left, vFloatItem.Top, vFloatItem.Width, vFloatItem.Height);
      vFloatItem.DrawRect.Offset(ADataDrawLeft, ADataDrawTop - AVOffset);  // ��������ʼλ��ӳ�䵽����λ��
      //APaintInfo.TopItems.Add(vFloatItem);
      //vFloatItem.PaintTop(ACanvas);
      vFloatItem.PaintTo(Self.Style, vFloatItem.DrawRect, ADataDrawTop, 0,
        0, 0, ACanvas, APaintInfo);
    end;
  end;
end;

procedure THCPageData.ReFormatData_(const AStartItemNo, ALastItemNo,
  AExtraItemCount: Integer);
begin
  FReFormatStartItemNo := AStartItemNo;
  inherited ReFormatData_(AStartItemNo, ALastItemNo, AExtraItemCount);
end;

{ THCSectionData }

procedure THCSectionData.Clear;
begin
  FFloatItemIndex := -1;
  FMouseDownIndex := -1;
  FMouseMoveIndex := -1;
  FFloatItems.Clear;

  inherited Clear;
end;

constructor THCSectionData.Create(const AStyle: THCStyle);
begin
  FFloatItems := TObjectList<THCFloatItem>.Create;
  FFloatItemIndex := -1;
  FMouseDownIndex := -1;
  FMouseMoveIndex := -1;

  inherited Create(AStyle);
end;

function THCSectionData.CreateFloatItemByStyle(
  const AStyleNo: Integer): THCFloatItem;
begin
  Result := nil;
  case AStyleNo of
    THCFloatStyle.Line: Result := THCFloatLineItem.Create(Self);
  else
    raise Exception.Create('δ�ҵ����� ' + IntToStr(AStyleNo) + ' ��Ӧ�Ĵ���FloatItem���룡');
  end;
end;

destructor THCSectionData.Destroy;
begin
  FFloatItems.Free;
  inherited Destroy;
end;

function THCSectionData.GetActiveFloatItem: THCFloatItem;
begin
  if FFloatItemIndex < 0 then
    Result := nil
  else
    Result := FFloatItems[FFloatItemIndex];
end;

procedure THCSectionData.GetCaretInfo(const AItemNo, AOffset: Integer;
  var ACaretInfo: TCaretInfo);
begin
  if FFloatItemIndex >= 0 then
  begin
    ACaretInfo.Visible := False;
    Exit;
  end;

  inherited GetCaretInfo(AItemNo, AOffset, ACaretInfo);
end;

function THCSectionData.GetFloatItemAt(const X, Y: Integer): Integer;
var
  i: Integer;
  vFloatItem: THCFloatItem;
begin
  Result := -1;
  for i := 0 to FFloatItems.Count - 1 do
  begin
    vFloatItem := FFloatItems[i];

    if vFloatItem.PtInClient(X - vFloatItem.Left, Y - vFloatItem.Top) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function THCSectionData.GetScreenCoord(const X, Y: Integer): TPoint;
begin
  if Assigned(FOnGetScreenCoord) then
    Result := FOnGetScreenCoord(X, Y);
end;

function THCSectionData.InsertFloatItem(
  const AFloatItem: THCFloatItem): Boolean;
var
  vStartNo, vStartOffset, vDrawNo: Integer;
begin
  // ��¼ѡ����ʼλ��
  vStartNo := Self.SelectInfo.StartItemNo;
  vStartOffset := Self.SelectInfo.StartItemOffset;

  // ȡѡ����ʼ����DrawItem
  vDrawNo := Self.GetDrawItemNoByOffset(vStartNo, vStartOffset);

  AFloatItem.Left := Self.DrawItems[vDrawNo].Rect.Left
    + Self.GetDrawItemOffsetWidth(vDrawNo, Self.SelectInfo.StartItemOffset - Self.DrawItems[vDrawNo].CharOffs + 1);
  AFloatItem.Top := Self.DrawItems[vDrawNo].Rect.Top;

  FFloatItemIndex := Self.FloatItems.Add(AFloatItem);
  AFloatItem.Active := True;

  Result := True;

  if not Self.DisSelect then
    Style.UpdateInfoRePaint;
end;

function THCSectionData.KeyDownFloatItem(var Key: Word;
  Shift: TShiftState): Boolean;
begin
  Result := True;

  if FFloatItemIndex >= 0 then
  begin
    case Key of
      VK_BACK, VK_DELETE:
        begin
          FFloatItems.Delete(FFloatItemIndex);
          FFloatItemIndex := -1;
        end;

      VK_LEFT: FFloatItems[FFloatItemIndex].Left := FFloatItems[FFloatItemIndex].Left - 1;

      VK_RIGHT: FFloatItems[FFloatItemIndex].Left := FFloatItems[FFloatItemIndex].Left + 1;

      VK_UP: FFloatItems[FFloatItemIndex].Top := FFloatItems[FFloatItemIndex].Top - 1;

      VK_DOWN: FFloatItems[FFloatItemIndex].Top := FFloatItems[FFloatItemIndex].Top + 1;
    else
      Result := False;
    end;
  end
  else
    Result := False;

  if Result then
    Style.UpdateInfoRePaint;
end;

procedure THCSectionData.LoadFromStream(const AStream: TStream;
  const AStyle: THCStyle; const AFileVersion: Word);
var
  vFloatCount, vStyleNo: Integer;
  vFloatItem: THCFloatItem;
begin
  inherited LoadFromStream(AStream, AStyle, AFileVersion);
  if AFileVersion > 12 then
  begin
    AStream.ReadBuffer(vFloatCount, SizeOf(vFloatCount));
    while vFloatCount > 0 do
    begin
      AStream.ReadBuffer(vStyleNo, SizeOf(vStyleNo));
      vFloatItem := CreateFloatItemByStyle(vStyleNo);
      vFloatItem.LoadFromStream(AStream, AStyle, AFileVersion);
      FFloatItems.Add(vFloatItem);

      Dec(vFloatCount);
    end;
  end;
end;

function THCSectionData.MouseDownFloatItem(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  vOldIndex: Integer;
begin
  Result := True;

  FMouseDownIndex := GetFloatItemAt(X, Y);

  vOldIndex := FFloatItemIndex;
  if FFloatItemIndex <> FMouseDownIndex then
  begin
    if FFloatItemIndex >= 0 then
      FFloatItems[FFloatItemIndex].Active := False;

    FFloatItemIndex := FMouseDownIndex;

    Style.UpdateInfoRePaint;
    Style.UpdateInfoReCaret;
  end;

  if FFloatItemIndex >= 0 then
  begin
    FFloatItems[FFloatItemIndex].MouseDown(Button, Shift,
      X - FFloatItems[FFloatItemIndex].Left, Y - FFloatItems[FFloatItemIndex].Top);
  end;

  if (FMouseDownIndex < 0) and (vOldIndex < 0) then
    Result := False
  else
  begin
    FMouseX := X;
    FMouseY := Y;
  end;
end;

function THCSectionData.MouseMoveFloatItem(Shift: TShiftState; X, Y: Integer): Boolean;
var
  vItemIndex: Integer;
  vFloatItem: THCFloatItem;
begin
  Result := True;

  if (Shift = [ssLeft]) and (FMouseDownIndex >= 0) then  // ������ק
  begin
    vFloatItem := FFloatItems[FMouseDownIndex];
    vFloatItem.MouseMove(Shift, X - vFloatItem.Left, Y - vFloatItem.Top);

    if not vFloatItem.Resizing then
    begin
      vFloatItem.Left := vFloatItem.Left + X - FMouseX;
      vFloatItem.Top := vFloatItem.Top + Y - FMouseY;

      FMouseX := X;
      FMouseY := Y;
    end;

    Style.UpdateInfoRePaint;
  end
  else  // ��ͨ����ƶ�
  begin
    vItemIndex := GetFloatItemAt(X, Y);
    if FMouseMoveIndex <> vItemIndex then
    begin
      if FMouseMoveIndex >= 0 then  // �ɵ��Ƴ�
        FFloatItems[FMouseMoveIndex].MouseLeave;

      FMouseMoveIndex := vItemIndex;
      if FMouseMoveIndex >= 0 then  // �µ�����
        FFloatItems[FMouseMoveIndex].MouseEnter;
    end;

    if vItemIndex >= 0 then
    begin
      vFloatItem := FFloatItems[vItemIndex];
      vFloatItem.MouseMove(Shift, X - vFloatItem.Left, Y - vFloatItem.Top);
    end
    else
      Result := False;
  end;
end;

function THCSectionData.MouseUpFloatItem(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  vFloatItem: THCFloatItem;
begin
  Result := True;

  if FMouseDownIndex >= 0 then
  begin
    vFloatItem := FFloatItems[FMouseDownIndex];
    {if vFloatItem.Resizing then
      Self.Style.UpdateInfoRePaint;}
    vFloatItem.MouseUp(Button, Shift, X - vFloatItem.Left, Y - vFloatItem.Top);
  end
  else
    Result := False;
end;

procedure THCSectionData.PaintFloatItems(const APageIndex, ADataDrawLeft,
  ADataDrawTop, AVOffset: Integer; const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
var
  i: Integer;
  vFloatItem: THCFloatItem;
begin
  for i := 0 to FFloatItems.Count - 1 do
  begin
    vFloatItem := FFloatItems[i];

    //if vFloatItem.PageIndex = APageIndex then
    begin
      vFloatItem.DrawRect := Bounds(vFloatItem.Left, vFloatItem.Top, vFloatItem.Width, vFloatItem.Height);
      vFloatItem.DrawRect.Offset(ADataDrawLeft, ADataDrawTop - AVOffset);  // ��������ʼλ��ӳ�䵽����λ��
      //APaintInfo.TopItems.Add(vFloatItem);
      //vFloatItem.PaintTop(ACanvas, APaintInfo);
      vFloatItem.PaintTo(Self.Style, vFloatItem.DrawRect, ADataDrawTop, 0,
        0, 0, ACanvas, APaintInfo);
    end;
  end;
end;

procedure THCSectionData.SaveToStream(const AStream: TStream;
  const AStartItemNo, AStartOffset, AEndItemNo, AEndOffset: Integer);
var
  i, vFloatCount: Integer;
begin
  inherited SaveToStream(AStream, AStartItemNo, AStartOffset, AEndItemNo, AEndOffset);

  vFloatCount := FFloatItems.Count;
  AStream.WriteBuffer(vFloatCount, SizeOf(vFloatCount));
  for i := 0 to FFloatItems.Count - 1 do
    FFloatItems[i].SaveToStream(AStream, 0, OffsetAfter);
end;

procedure THCSectionData.SetReadOnly(const Value: Boolean);
begin
  if Self.ReadOnly <> Value then
  begin
    inherited SetReadOnly(Value);

    if Assigned(FOnReadOnlySwitch) then
      FOnReadOnlySwitch(Self);
  end;
end;

end.