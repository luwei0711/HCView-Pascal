{*******************************************************}
{                                                       }
{               HCView V1.1  ���ߣ���ͨ                 }
{                                                       }
{      ��������ѭBSDЭ�飬����Լ���QQȺ 649023932      }
{            ����ȡ����ļ������� 2018-5-4              }
{                                                       }
{                 �ĵ�Tab����ʵ�ֵ�Ԫ                   }
{                                                       }
{*******************************************************}

unit HCTabItem;

interface

uses
  Windows, Controls, Classes, Graphics, HCItem, HCRectItem, HCStyle, HCCommon,
  HCCustomData;

type
  TTabItem = class(THCTextRectItem)
  protected
    function JustifySplit: Boolean; override;
    function GetOffsetAt(const X: Integer): Integer; override;
    procedure DoPaint(const AStyle: THCStyle; const ADrawRect: TRect;
      const ADataDrawTop, ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
      const ACanvas: TCanvas; const APaintInfo: TPaintInfo); override;
  public
    constructor Create(const AOwnerData: THCCustomData); override;
  end;

implementation

{ TTabItem }

constructor TTabItem.Create(const AOwnerData: THCCustomData);
var
  vSize: TSize;
begin
  inherited Create(AOwnerData);
  StyleNo := THCStyle.Tab;
  AOwnerData.Style.TextStyles[TextStyleNo].ApplyStyle(AOwnerData.Style.DefCanvas);
  vSize := AOwnerData.Style.DefCanvas.TextExtent('����');  // Ĭ��2������
  Width := vSize.cx;
  Height := vSize.cy;
end;

procedure TTabItem.DoPaint(const AStyle: THCStyle; const ADrawRect: TRect;
  const ADataDrawTop, ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
  const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
begin
  inherited;
  {if SelectComplate then
  begin
    ACanvas.Brush.Color := GStyle.SelColor;
    ACanvas.FillRect(ADrawRect);
  end;}
end;

function TTabItem.GetOffsetAt(const X: Integer): Integer;
begin
  if X < Width div 2 then
    Result := OffsetBefor
  else
    Result := OffsetAfter;
end;

function TTabItem.JustifySplit: Boolean;
begin
  Result := False;
end;

end.