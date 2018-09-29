{*******************************************************}
{                                                       }
{               HCView V1.1  ���ߣ���ͨ                 }
{                                                       }
{      ��������ѭBSDЭ�飬����Լ���QQȺ 649023932      }
{            ����ȡ����ļ������� 2018-5-4              }
{                                                       }
{                 �ĵ����ݰ�ҳ���ֿؼ�                  }
{                                                       }
{*******************************************************}

unit HCView;

interface

uses
  Windows, Classes, Controls, Graphics, Messages, HCStyle, HCCustomData, SynPdf,
  Generics.Collections, HCCommon, HCRichData, HCCustomRichData, HCDrawItem,
  HCSection, HCScrollBar, HCRichScrollBar, HCParaStyle, HCTextStyle, HCRectItem,
  HCTextItem, HCItem, HCFloatItem, HCUndo;

type
  TPageScrollModel = (psmVertical, psmHorizontal);

  TLoadSectionProc = reference to procedure(const AFileVersion: Word);

  TAnnotate = class(TObject)  // ��ע
  private
    FDrawItemRect, FPaintRect: TRect;
    FText: string;
  public
    property DrawItemRect: TRect read FDrawItemRect write FDrawItemRect;
    property PaintRect: TRect read FPaintRect write FPaintRect;
    property Text: string read FText write FText;
  end;

  TAnnotates = class(TObjectList<TAnnotate>)  // ��עs
  strict private
    FIndex: Integer;
  public
    constructor Create;
    procedure PaintTo(const ACanvas: TCanvas; const ARect: TRect;
      const APaintInfo: TSectionPaintInfo);
    procedure AddAnnotation(const ADrawItemRect: TRect; const AText: string);
    procedure MouseDown(const X, Y: Integer);
  end;

  TPaintEvent = procedure (const ACanvas: TCanvas) of object;

  THCView = class(TCustomControl)
  private
    { Private declarations }
    FFileName: string;
    FStyle: THCStyle;
    FSections: TObjectList<THCSection>;
    FUndoList: THCUndoList;
    FHScrollBar: THCScrollBar;
    FVScrollBar: THCRichScrollBar;
    FDataBmp: TBitmap;  // ������ʾλͼ
    FActiveSectionIndex,
    FDisplayFirstSection, FDisplayLastSection,
    FUpdateCount: Integer;
    FZoom: Single;
    FAutoZoom,  // �Զ�����
    FShowAnnotation: Boolean;  // ��ʾ��ע
    FIsChanged: Boolean;  // �Ƿ����˸ı�
    FAnnotates: TAnnotates;  // ��ע

    FViewModel: TViewModel;  // ������ʾģʽ��ҳ�桢Web
    FPageScrollModel: TPageScrollModel;  // ҳ�������ʾģʽ�����򡢺���
    FCaret: TCaret;
    FOnMouseDown, FOnMouseUp: TMouseEvent;
    FOnCaretChange, FOnVerScroll, FOnSectionCreateItem, FOnSectionReadOnlySwitch: TNotifyEvent;
    FOnSectionCreateStyleItem: TStyleItemEvent;
    FOnSectionInsertItem: TItemNotifyEvent;
    FOnSectionItemPaintAfter, FOnSectionItemPaintBefor: TItemPaintEvent;

    FOnSectionPaintHeader, FOnSectionPaintFooter, FOnSectionPaintPage,
      FOnSectionPaintWholePage: TSectionPagePaintEvent;
    FOnUpdateViewBefor, FOnUpdateViewAfter: TPaintEvent;

    FOnChange, FOnChangedSwitch: TNotifyEvent;
    FOnSectionDrawItemPaintAfter: TDrawItemPaintEvent;

    /// <summary> ���ݽ�ҳ��������ô�ӡ�� </summary>
    /// <param name="ASectionIndex"></param>
    procedure SetPrintBySectionInfo(const ASectionIndex: Integer);
    //
    function GetDisplayWidth: Integer;
    function GetDisplayHeight: Integer;
    //
    function GetSymmetryMargin: Boolean;
    procedure SetSymmetryMargin(const Value: Boolean);
    procedure DoVScrollChange(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    function DoSectionCreateStyleItem(const AData: THCCustomData; const AStyleNo: Integer): THCCustomItem;
    //
    function NewDefaultSection: THCSection;

    function GetDisplayRect: TRect;

    /// <summary> ���»�ȡ���λ�� </summary>
    procedure ReBuildCaret;
    procedure GetSectionByCrood(const X, Y: Integer; var ASectionIndex: Integer);
    procedure SetZoom(const Value: Single);

    /// <summary> ɾ����ʹ�õ��ı���ʽ </summary>
    procedure _DeleteUnUsedStyle(const AParts: TSaveParts = [saHeader, saPage, saFooter]);

    function GetHScrollValue: Integer;
    function GetVScrollValue: Integer;

    function GetShowLineActiveMark: Boolean;
    procedure SetShowLineActiveMark(const Value: Boolean);

    function GetShowLineNo: Boolean;
    procedure SetShowLineNo(const Value: Boolean);

    function GetShowUnderLine: Boolean;
    procedure SetShowUnderLine(const Value: Boolean);

    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
    // Imm
    procedure UpdateImmPosition;
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure DoCaretChange;
    procedure DoSectionDataChanged(Sender: TObject);

    // ���ػ���ؽ���꣬������Change�¼�
    procedure DoSectionDataCheckUpdateInfo(Sender: TObject);
    procedure DoLoadFromStream(const AStream: TStream; const AStyle: THCStyle;
      const ALoadSectionProc: TLoadSectionProc);

    procedure DoNewUndo(const Sender: THCUndo);
    procedure DoUndo(const Sender: THCUndo);
    procedure DoRedo(const Sender: THCUndo);

    /// <summary> �ĵ�"����"�䶯(�����ޱ仯����ԳƱ߾࣬������ͼ) </summary>
    procedure DoMapChanged;
    procedure DoChange; virtual;
    procedure DoSectionCreateItem(Sender: TObject);
    procedure DoSectionReadOnlySwitch(Sender: TObject);
    function DoSectionGetScreenCoord(const X, Y: Integer): TPoint;
    procedure DoSectionInsertItem(const AItem: THCCustomItem);
    procedure DoSectionItemPaintBefor(const AData: THCCustomData;
      const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
      ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
      const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
    procedure DoSectionItemPaintAfter(const AData: THCCustomData;
      const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
      ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
      const ACanvas: TCanvas; const APaintInfo: TPaintInfo); virtual;

    procedure DoSectionPaintHeader(Sender: TObject; const APageIndex: Integer;
      const ARect: TRect; const ACanvas: TCanvas; const APaintInfo: TSectionPaintInfo);
    procedure DoSectionPaintFooter(Sender: TObject; const APageIndex: Integer;
      const ARect: TRect; const ACanvas: TCanvas; const APaintInfo: TSectionPaintInfo);
    procedure DoSectionPaintPage(Sender: TObject; const APageIndex: Integer;
      const ARect: TRect; const ACanvas: TCanvas; const APaintInfo: TSectionPaintInfo);
    procedure DoSectionPaintWholePage(Sender: TObject; const APageIndex: Integer;
      const ARect: TRect; const ACanvas: TCanvas; const APaintInfo: TSectionPaintInfo);
    procedure DoSectionDrawItemPaintAfter(const AData: THCCustomData;
      const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
      ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
      const ACanvas: TCanvas; const APaintInfo: TPaintInfo);

    function DoSectionGetUndoList: THCUndoList;

    procedure DoStyleInvalidateRect(const ARect: TRect);

    /// <summary> �Ƿ��������뷨����Ĵ���������ID�ʹ��� </summary>
    function DoProcessIMECandi(const ACandi: string): Boolean; virtual;

    /// <summary> ʵ�ֲ����ı� </summary>
    function DoInsertText(const AText: string): Boolean; virtual;

    /// <summary> ����ǰ�����ڶ�������������������Դ </summary>
    procedure DoCopyDataBefor(const AStream: TStream); virtual;

    /// <summary> ճ��ǰ������ȷ�϶�������������������Դ </summary>
    procedure DoPasteDataBefor(const AStream: TStream; const AVersion: Word); virtual;

    /// <summary> �����ĵ�ǰ�����¼������ڶ����������� </summary>
    procedure DoSaveBefor(const AStream: TStream); virtual;

    /// <summary> �����ĵ��󴥷��¼������ڶ����������� </summary>
    procedure DoSaveAfter(const AStream: TStream); virtual;

    /// <summary> ��ȡ�ĵ�ǰ�����¼�������ȷ�϶����������� </summary>
    procedure DoLoadBefor(const AStream: TStream; const AFileVersion: Word); virtual;

    /// <summary> ��ȡ�ĵ��󴥷��¼�������ȷ�϶����������� </summary>
    procedure DoLoadAfter(const AStream: TStream; const AFileVersion: Word); virtual;
    //
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    // ��Ϣ
    /// <summary> ��ӦTab���ͷ���� </summary>
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMERASEBKGND(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;

    // �������뷨���������
    procedure WMImeComposition(var Message: TMessage); message WM_IME_COMPOSITION;
    procedure WndProc(var Message: TMessage); override;
    //
    procedure CalcScrollRang;

    /// <summary> �Ƿ��ɹ�����λ�ñ仯����ĸ��� </summary>
    procedure CheckUpdateInfo;
    //
    procedure SetPageScrollModel(const Value: TPageScrollModel);
    procedure SetViewModel(const Value: TViewModel);
    procedure SetShowAnnotation(const Value: Boolean);
    procedure SetActiveSectionIndex(const Value: Integer);
    //
    procedure SetIsChanged(const Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// <summary> ���赱ǰ��ֽ�ű߾� </summary>
    procedure ResetActiveSectionMargin;

    /// <summary> ȫ�����(�������ҳü��ҳ�š�ҳ���Item��DrawItem) </summary>
    procedure Clear;

    /// <summary> ȡ��ѡ�� </summary>
    procedure DisSelect;

    /// <summary> ɾ��ѡ������ </summary>
    procedure DeleteSelected;

    /// <summary> ɾ����ǰ�� </summary>
    procedure DeleteActiveSection;

    /// <summary> �������¼����Ű� </summary>
    procedure FormatData;

    /// <summary> ������ </summary>
    function InsertStream(const AStream: TStream): Boolean;

    /// <summary> �����ı�(�ɰ���#13#10) </summary>
    function InsertText(const AText: string): Boolean;

    /// <summary> ����ָ�����еı��� </summary>
    function InsertTable(const ARowCount, AColCount: Integer): Boolean;

    /// <summary> ����ˮƽ�� </summary>
    function InsertLine(const ALineHeight: Integer): Boolean;

    /// <summary> ����һ��Item </summary>
    function InsertItem(const AItem: THCCustomItem): Boolean; overload;

    /// <summary> ��ָ����λ�ò���һ��Item </summary>
    function InsertItem(const AIndex: Integer; const AItem: THCCustomItem): Boolean; overload;

    /// <summary> ���븡��Item </summary>
    function InsertFloatItem(const AFloatItem: THCFloatItem): Boolean;

    /// <summary> ������ע(��δʵ��) </summary>
    function InsertAnnotate(const AText: string): Boolean;

    /// <summary> �ӵ�ǰλ�ú��� </summary>
    function InsertBreak: Boolean;

    /// <summary> �ӵ�ǰλ�ú��ҳ </summary>
    function InsertPageBreak: Boolean;

    /// <summary> �ӵ�ǰλ�ú�ֽ� </summary>
    function InsertSectionBreak: Boolean;

    /// <summary> ��ǰ����ѡ������������� </summary>
    function ActiveTableInsertRowAfter(const ARowCount: Byte): Boolean;

    /// <summary> ��ǰ����ѡ������������� </summary>
    function ActiveTableInsertRowBefor(const ARowCount: Byte): Boolean;

    /// <summary> ��ǰ����ɾ��ѡ�е��� </summary>
    function ActiveTableDeleteCurRow: Boolean;

    function ActiveTableSplitCurRow: Boolean;
    function ActiveTableSplitCurCol: Boolean;

    /// <summary> ��ǰ����ѡ������������ </summary>
    function ActiveTableInsertColBefor(const AColCount: Byte): Boolean;

    /// <summary> ��ǰ����ѡ�����Ҳ������ </summary>
    function ActiveTableInsertColAfter(const AColCount: Byte): Boolean;

    /// <summary> ��ǰ����ɾ��ѡ�е��� </summary>
    function ActiveTableDeleteCurCol: Boolean;

    /// <summary> �޸ĵ�ǰ������ڶ�ˮƽ���뷽ʽ </summary>
    procedure ApplyParaAlignHorz(const AAlign: TParaAlignHorz);

    /// <summary> �޸ĵ�ǰ������ڶδ�ֱ���뷽ʽ </summary>
    procedure ApplyParaAlignVert(const AAlign: TParaAlignVert);

    /// <summary> �޸ĵ�ǰ������ڶα���ɫ </summary>
    procedure ApplyParaBackColor(const AColor: TColor);

    /// <summary> �޸ĵ�ǰ������ڶ��м�� </summary>
    procedure ApplyParaLineSpace(const ASpaceMode: TParaLineSpaceMode);

    /// <summary> �޸ĵ�ǰѡ���ı�����ʽ </summary>
    procedure ApplyTextStyle(const AFontStyle: THCFontStyle);

    /// <summary> �޸ĵ�ǰѡ���ı������� </summary>
    procedure ApplyTextFontName(const AFontName: TFontName);

    /// <summary> �޸ĵ�ǰѡ���ı����ֺ� </summary>
    procedure ApplyTextFontSize(const AFontSize: Single);

    /// <summary> �޸ĵ�ǰѡ���ı�����ɫ </summary>
    procedure ApplyTextColor(const AColor: TColor);

    /// <summary> �޸ĵ�ǰѡ���ı��ı�����ɫ </summary>
    procedure ApplyTextBackColor(const AColor: TColor);

    /// <summary> ȫѡ(���н�����) </summary>
    procedure SelectAll;

    /// <summary> ����ѡ������ </summary>
    procedure Cut;

    /// <summary> ����ѡ������(tcf��ʽ) </summary>
    procedure Copy;

    /// <summary> ����ѡ������Ϊ�ı� </summary>
    procedure CopyAsText;

    /// <summary> ճ���������е����� </summary>
    procedure Paste;

    /// <summary> �Ŵ���ͼ </summary>
    function ZoomIn(const Value: Integer): Integer;

    /// <summary> ��С��ͼ </summary>
    function ZoomOut(const Value: Integer): Integer;

    /// <summary> �ػ�ͻ����� </summary>
    procedure UpdateView; overload;

    /// <summary> �ػ�ͻ���ָ������ </summary>
    procedure UpdateView(const ARect: TRect); overload;

    /// <summary> ��ʼ�����ػ� </summary>
    procedure BeginUpdate;

    /// <summary> ���������ػ� </summary>
    procedure EndUpdate;
    //
    /// <summary> ���ص�ǰ�ڵ�ǰItem </summary>
    function GetCurItem: THCCustomItem;

    /// <summary> ���ص�ǰ�ڶ���Item </summary>
    function GetTopLevelItem: THCCustomItem;

    /// <summary> ���ص�ǰ�ڶ���DrawItem </summary>
    function GetTopLevelDrawItem: THCCustomDrawItem;

    /// <summary> ���ص�ǰ�������ҳ��� </summary>
    function GetActivePageIndex: Integer;

    /// <summary> ���ص�ǰԤ����ʼҳ��� </summary>
    function GetPagePreviewFirst: Integer;

    /// <summary> ������ҳ�� </summary>
    function GetPageCount: Integer;

    /// <summary> ����ָ����ҳ�����ʱLeftλ�� </summary>
    function GetSectionDrawLeft(const ASectionIndex: Integer): Integer;

    /// <summary> ���ع�괦DrawItem��Ե�ǰҳ��ʾ�Ĵ������� </summary>
    /// <returns>����</returns>
    function GetActiveDrawItemClientCoord: TPoint;

    /// <summary> ��ʽ��ָ���ڵ����� </summary>
    procedure FormatSection(const ASectionIndex: Integer);

    /// <summary> ��ȡ��ǰ�ڶ��� </summary>
    function ActiveSection: THCSection;

    /// <summary> ��ȡ��ǰ�ڶ���Data </summary>
    function ActiveSectionTopLevelData: THCCustomRichData;

    /// <summary> ָ���������������е�Topλ�� </summary>
    function GetSectionTopFilm(const ASectionIndex: Integer): Integer;

    // �����ĵ�
    /// <summary> �ĵ�����Ϊxml��ʽ </summary>
    procedure SaveAsXML(const AFileName: string);

    /// <summary> �ĵ�����Ϊhcf��ʽ </summary>
    procedure SaveToFile(const AFileName: string);

    /// <summary> �ĵ�����ΪPDF��ʽ </summary>
    procedure SaveAsPDF(const AFileName: string);

    /// <summary> �ĵ�����ΪPDF��ʽ </summary>
    procedure SaveAsText(const AFileName: string);

    /// <summary> �ĵ����浽�� </summary>
    procedure SaveToStream(const AStream: TStream;
      const ASaveParts: TSaveParts = [saHeader, saPage, saFooter]); virtual;

    // ��ȡ�ĵ�
    /// <summary> ��ȡTxt�ļ� </summary>
    procedure LoadFromText(const AFileName: string);

    /// <summary> ��ȡhcf�ļ� </summary>
    procedure LoadFromFile(const AFileName: string);

    /// <summary> ��ȡ�ļ��� </summary>
    procedure LoadFromStream(const AStream: TStream); virtual;

    /// <summary> ��ȡָ��ҳ���ڵĽں���Դ˽ڵ�ҳ��� </summary>
    /// <param name="APageIndex">ҳ���</param>
    /// <param name="ASectionPageIndex">����������ڽڵ����</param>
    /// <returns>����ҳ������ڵĽ����</returns>
    function GetSectionPageIndexByPageIndex(const APageIndex: Integer; var ASectionPageIndex: Integer): Integer;

    // ��ӡ
    /// <summary> ʹ��Ĭ�ϴ�ӡ����ӡ����ҳ </summary>
    /// <returns>��ӡ���</returns>
    function Print: TPrintResult; overload;

    /// <summary> ʹ��ָ���Ĵ�ӡ����ӡ����ҳ </summary>
    /// <param name="APrinter">ָ����ӡ��</param>
    /// <param name="ACopies">��ӡ����</param>
    /// <returns>��ӡ���</returns>
    function Print(const APrinter: string; const ACopies: Integer = 1): TPrintResult; overload;

    /// <summary> ʹ��ָ���Ĵ�ӡ����ӡָ��ҳ��ŷ�Χ�ڵ�ҳ </summary>
    /// <param name="APrinter">ָ����ӡ��</param>
    /// <param name="AStartPageIndex">��ʼҳ���</param>
    /// <param name="AEndPageIndex">����ҳ���</param>
    /// <param name="ACopies">��ӡ����</param>
    /// <returns></returns>
    function Print(const APrinter: string; const AStartPageIndex, AEndPageIndex, ACopies: Integer): TPrintResult; overload;

    /// <summary> ʹ��ָ���Ĵ�ӡ����ӡָ��ҳ </summary>
    /// <param name="APrinter">ָ����ӡ��</param>
    /// <param name="ACopies">��ӡ����</param>
    /// <param name="APages">Ҫ��ӡ��ҳ�������</param>
    /// <returns>��ӡ���</returns>
    function Print(const APrinter: string; const ACopies: Integer;
      const APages: array of Integer): TPrintResult; overload;

    /// <summary> �ӵ�ǰ�д�ӡ��ǰҳ(��������) </summary>
    /// <param name="APrintHeader"> �Ƿ��ӡҳü </param>
    /// <param name="APrintFooter"> �Ƿ��ӡҳ�� </param>
    function PrintCurPageByActiveLine(const APrintHeader, APrintFooter: Boolean): TPrintResult;

    /// <summary> ��ӡ��ǰҳָ������ʼ������Item(��������) </summary>
    /// <param name="APrintHeader"> �Ƿ��ӡҳü </param>
    /// <param name="APrintFooter"> �Ƿ��ӡҳ�� </param>
    function PrintCurPageByItemRange(const APrintHeader, APrintFooter: Boolean;
      const AStartItemNo, AStartOffset, AEndItemNo, AEndOffset: Integer): TPrintResult;

    /// <summary> ��ӡ��ǰҳѡ�е���ʼ������Item(��������) </summary>
    /// <param name="APrintHeader"> �Ƿ��ӡҳü </param>
    /// <param name="APrintFooter"> �Ƿ��ӡҳ�� </param>
    function PrintCurPageSelected(const APrintHeader, APrintFooter: Boolean): TPrintResult;

    /// <summary> �ϲ�����ѡ�еĵ�Ԫ�� </summary>
    function MergeTableSelectCells: Boolean;

    /// <summary> ���� </summary>
    procedure Undo;

    /// <summary> ���� </summary>
    procedure Redo;

    /// <summary> ��ǰλ�ÿ�ʼ����ָ�������� </summary>
    /// <param name="AKeyword">Ҫ���ҵĹؼ���</param>
    /// <param name="AForward">True����ǰ��False�����</param>
    /// <param name="AMatchCase">True�����ִ�Сд��False�������ִ�Сд</param>
    /// <returns>True���ҵ�</returns>
    function Search(const AKeyword: string; const AForward: Boolean = False;
      const AMatchCase: Boolean = False): Boolean;

    // ���Բ���
    /// <summary> ��ǰ�ĵ����� </summary>
    property FileName: string read FFileName write FFileName;

    /// <summary> ��ǰ�ĵ���ʽ�� </summary>
    property Style: THCStyle read FStyle;

    /// <summary> �Ƿ�ԳƱ߾� </summary>
    property SymmetryMargin: Boolean read GetSymmetryMargin write SetSymmetryMargin;

    /// <summary> ��ǰ�������ҳ����� </summary>
    property ActivePageIndex: Integer read GetActivePageIndex;

    /// <summary> ��ǰԤ����ҳ��� </summary>
    property PagePreviewFirst: Integer read GetPagePreviewFirst;

    /// <summary> ��ҳ�� </summary>
    property PageCount: Integer read GetPageCount;

    /// <summary> ��ǰ������ڽڵ���� </summary>
    property ActiveSectionIndex: Integer read FActiveSectionIndex write SetActiveSectionIndex;

    /// <summary> ˮƽ��������ֵ </summary>
    property HScrollValue: Integer read GetHScrollValue;

    /// <summary> ��ֱ��������ֵ </summary>
    property VScrollValue: Integer read GetVScrollValue;

    /// <summary> ����ֵ </summary>
    property Zoom: Single read FZoom write SetZoom;

    /// <summary> ��ǰ�ĵ����н� </summary>
    property Sections: TObjectList<THCSection> read FSections;

    /// <summary> �Ƿ���ʾ��ǰ��ָʾ�� </summary>
    property ShowLineActiveMark: Boolean read GetShowLineActiveMark write SetShowLineActiveMark;

    /// <summary> �Ƿ���ʾ�к� </summary>
    property ShowLineNo: Boolean read GetShowLineNo write SetShowLineNo;

    /// <summary> �Ƿ���ʾ�»��� </summary>
    property ShowUnderLine: Boolean read GetShowUnderLine write SetShowUnderLine;

    /// <summary> ��ǰ�ĵ��Ƿ��б仯 </summary>
    property IsChanged: Boolean read FIsChanged write SetIsChanged;

    /// <summary> ��ǰ�ĵ�������ע </summary>
    property Annotates: TAnnotates read FAnnotates;
  published
    { Published declarations }

    /// <summary> �����µ�Item����ʱ���� </summary>
    property OnSectionCreateItem: TNotifyEvent read FOnSectionCreateItem write FOnSectionCreateItem;

    /// <summary> �����µ�Item����ʱ���� </summary>
    property OnSectionItemInsert: TItemNotifyEvent read FOnSectionInsertItem write FOnSectionInsertItem;

    /// <summary> Item���ƿ�ʼǰ���� </summary>
    property OnSectionItemPaintBefor: TItemPaintEvent read FOnSectionItemPaintBefor write FOnSectionItemPaintBefor;

    /// <summary> Item������ɺ󴥷� </summary>
    property OnSectionItemPaintAfter: TItemPaintEvent read FOnSectionItemPaintAfter write FOnSectionItemPaintAfter;

    /// <summary> ��ҳü����ʱ���� </summary>
    property OnSectionPaintHeader: TSectionPagePaintEvent read FOnSectionPaintHeader write FOnSectionPaintHeader;

    /// <summary> ��ҳ�Ż���ʱ���� </summary>
    property OnSectionPaintFooter: TSectionPagePaintEvent read FOnSectionPaintFooter write FOnSectionPaintFooter;

    /// <summary> ��ҳ�����ʱ���� </summary>
    property OnSectionPaintPage: TSectionPagePaintEvent read FOnSectionPaintPage write FOnSectionPaintPage;

    /// <summary> ����ҳ����ʱ���� </summary>
    property OnSectionPaintWholePage: TSectionPagePaintEvent read FOnSectionPaintWholePage write FOnSectionPaintWholePage;

    /// <summary> ��ֻ�������б仯ʱ���� </summary>
    property OnSectionReadOnlySwitch: TNotifyEvent read FOnSectionReadOnlySwitch write FOnSectionReadOnlySwitch;

    /// <summary> DrawItem������ɺ󴥷� </summary>
    property OnSectionDrawItemPaintAfter: TDrawItemPaintEvent read FOnSectionDrawItemPaintAfter write FOnSectionDrawItemPaintAfter;

    /// <summary> ҳ�������ʾģʽ�����򡢺��� </summary>
    property PageScrollModel: TPageScrollModel read FPageScrollModel write SetPageScrollModel;

    /// <summary> ������ʾģʽ��ҳ�桢Web </summary>
    property ViewModel: TViewModel read FViewModel write SetViewModel;

    /// <summary> �Ƿ���ʾ��ע </summary>
    property ShowAnnotation: Boolean read FShowAnnotation write SetShowAnnotation;

    /// <summary> �Ƿ���ݿ����Զ��������ű��� </summary>
    property AutoZoom: Boolean read FAutoZoom write FAutoZoom;

    /// <summary> ����Section�Ƿ�ֻ�� </summary>
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;

    /// <summary> ��갴��ʱ���� </summary>
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;

    /// <summary> ��굯��ʱ���� </summary>
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;

    /// <summary> ���λ�øı�ʱ���� </summary>
    property OnCaretChange: TNotifyEvent read FOnCaretChange write FOnCaretChange;

    /// <summary> ��ֱ����������ʱ���� </summary>
    property OnVerScroll: TNotifyEvent read FOnVerScroll write FOnVerScroll;

    /// <summary> �ĵ����ݱ仯ʱ���� </summary>
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    /// <summary> �ĵ�Change״̬�л�ʱ���� </summary>
    property OnChangedSwitch: TNotifyEvent read FOnChangedSwitch write FOnChangedSwitch;

    /// <summary> �����ػ濪ʼʱ���� </summary>
    property OnUpdateViewBefor: TPaintEvent read FOnUpdateViewBefor write FOnUpdateViewBefor;

    /// <summary> �����ػ�����󴥷� </summary>
    property OnUpdateViewAfter: TPaintEvent read FOnUpdateViewAfter write FOnUpdateViewAfter;

    property OnSectionCreateStyleItem: TStyleItemEvent read FOnSectionCreateStyleItem write FOnSectionCreateStyleItem;

    property PopupMenu;
  end;

//procedure Register;

implementation

uses
  Printers, Imm, SysUtils, Forms, Math, Clipbrd, HCImageItem, Xml.XMLDoc, Xml.XMLIntf;

const
  IMN_UPDATECURSTRING = $F000;  // �����뷨��������ǰ��괦���ַ���

{procedure Register;
begin
  RegisterComponents('HCControl', [THCView]);
end;  }

function GetPDFPaperSize(const APaperSize: Integer): TPDFPaperSize;
begin
  case APaperSize of
    DMPAPER_A3: Result := TPDFPaperSize.psA3;
    DMPAPER_A4: Result := TPDFPaperSize.psA4;
    DMPAPER_A5: Result := TPDFPaperSize.psA5;
    //DMPAPER_B5: Result := TPDFPaperSize.psB5;
  else
    Result := TPDFPaperSize.psUserDefined;
  end;
end;

procedure StyleSaveToXML(const AStyle: THCStyle; const ANode: IXMLNode);
begin

end;

procedure SectionSaveToXML(const ASections: TObjectList<THCSection>;
  const ANode: IXMLNode);
begin

end;

{ THCView }

procedure THCView.ApplyTextStyle(const AFontStyle: THCFontStyle);
begin
  ActiveSection.ApplyTextStyle(AFontStyle);
end;

procedure THCView.ApplyTextBackColor(const AColor: TColor);
begin
  ActiveSection.ApplyTextBackColor(AColor);
end;

procedure THCView.ApplyTextColor(const AColor: TColor);
begin
  ActiveSection.ApplyTextColor(AColor);
end;

procedure THCView.ApplyTextFontName(const AFontName: TFontName);
begin
  ActiveSection.ApplyTextFontName(AFontName);
end;

procedure THCView.ApplyTextFontSize(const AFontSize: Single);
begin
  ActiveSection.ApplyTextFontSize(AFontSize);
end;

procedure THCView.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure THCView.CalcScrollRang;
var
  i, vWidth, vVMax, vHMax: Integer;
begin
  vVMax := 0;
  vHMax := FSections[0].PageWidthPix;
  for i := 0 to FSections.Count - 1 do  //  ����ڴ�ֱ�ܺͣ��Լ����������ҳ����
  begin
    vVMax := vVMax + FSections[i].GetFilmHeight;

    vWidth := FSections[i].PageWidthPix;

    if vWidth > vHMax then
      vHMax := vWidth;
  end;

  if FShowAnnotation then
    vHMax := vHMax + AnnotationWidth;

  vVMax := ZoomIn(vVMax + PagePadding);  // �������һҳ�����PagePadding
  vHMax := ZoomIn(vHMax + PagePadding + PagePadding);

  FVScrollBar.Max := vVMax;
  FHScrollBar.Max := vHMax;
end;

procedure THCView.CheckUpdateInfo;
begin
  if (FCaret <> nil) and FStyle.UpdateInfo.ReCaret then  // �ȴ�����꣬��Ϊ���ܹ�괦��Щ��Ҫ�����ػ�
  begin
    FStyle.UpdateInfo.ReCaret := False;
    ReBuildCaret;
    FStyle.UpdateInfo.ReStyle := False;
    FStyle.UpdateInfo.ReScroll := False;
    UpdateImmPosition;
  end;

  if FStyle.UpdateInfo.RePaint then
  begin
    FStyle.UpdateInfo.RePaint := False;
    UpdateView;
  end;
end;

procedure THCView.Clear;
begin
  FStyle.Initialize;  // ������ʽ����ֹData��ʼ��ΪEmptyDataʱ��Item��ʽ��ֵΪCurStyleNo
  FSections.DeleteRange(1, FSections.Count - 1);
  FSections[0].Clear;
  FUndoList.Clear;
  FHScrollBar.Position := 0;
  FVScrollBar.Position := 0;
  FActiveSectionIndex := 0;
  FStyle.UpdateInfoRePaint;
  FStyle.UpdateInfoReCaret;
  DoMapChanged;
end;

procedure THCView.Copy;
var
  vStream: TMemoryStream;
  vMem: Cardinal;
  vPtr: Pointer;
begin
  if ActiveSection.SelectExists then
  begin
    vStream := TMemoryStream.Create;
    try
      _SaveFileFormatAndVersion(vStream);  // �����ļ���ʽ�Ͱ汾
      DoCopyDataBefor(vStream);  // ֪ͨ�����¼�
      _DeleteUnUsedStyle;  // ������ʹ�õ���ʽ
      FStyle.SaveToStream(vStream);
      Self.ActiveSectionTopLevelData.SaveSelectToStream(vStream);
      vMem := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, vStream.Size);
      if vMem = 0 then
        raise Exception.Create(HCS_EXCEPTION_MEMORYLESS);
      vPtr := GlobalLock(vMem);
      Move(vStream.Memory^, vPtr^, vStream.Size);
      GlobalUnlock(vMem);
    finally
      vStream.Free;
    end;
    
    Clipboard.Clear;
    Clipboard.Open;
    try
      Clipboard.SetAsHandle(HC_FILEFORMAT, vMem);  // HC��ʽ
      Clipboard.AsText := Self.ActiveSectionTopLevelData.SaveSelectToText;  // �ı���ʽ
    finally
      Clipboard.Close;
    end;
  end;
end;

procedure THCView.CopyAsText;
begin
  Clipboard.AsText := Self.ActiveSectionTopLevelData.SaveSelectToText;
end;

constructor THCView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //
  Self.Color := RGB(82, 89, 107);

  FUndoList := THCUndoList.Create;
  FUndoList.OnUndo := DoUndo;
  FUndoList.OnRedo := DoRedo;
  FUndoList.OnNewUndo := DoNewUndo;

  FFileName := '';
  FIsChanged := False;
  FZoom := 1;
  FShowAnnotation := False;
  FAutoZoom := False;
  FViewModel := vmPage;
  FPageScrollModel := psmVertical;  //psmHorizontal;

  FDataBmp := TBitmap.Create;
  FStyle := THCStyle.CreateEx(True, True);
  FStyle.OnInvalidateRect := DoStyleInvalidateRect;
  FSections := TObjectList<THCSection>.Create;
  FSections.Add(NewDefaultSection);
  FActiveSectionIndex := 0;
  FDisplayFirstSection := 0;
  FDisplayLastSection := 0;
  // ��ֱ����������Χ��Resize������
  FVScrollBar := THCRichScrollBar.Create(Self);
  FVScrollBar.Orientation := TOrientation.oriVertical;
  FVScrollBar.OnScroll := DoVScrollChange;
  // ˮƽ����������Χ��Resize������
  FHScrollBar := THCScrollBar.Create(Self);
  FHScrollBar.Orientation := TOrientation.oriHorizontal;
  FHScrollBar.OnScroll := DoVScrollChange;

  FHScrollBar.Parent := Self;
  FVScrollBar.Parent := Self;

  CalcScrollRang;
end;

procedure THCView.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then
    FCaret := TCaret.Create(Handle);
end;

procedure THCView.Cut;
begin
  Copy;
  ActiveSection.DeleteSelected;
end;

function THCView.ActiveSection: THCSection;
begin
  Result := FSections[FActiveSectionIndex];
end;

procedure THCView.DeleteActiveSection;
begin
  if FActiveSectionIndex > 0 then
  begin
    FSections.Delete(FActiveSectionIndex);
    FActiveSectionIndex := FActiveSectionIndex - 1;
    FDisplayFirstSection := -1;
    FDisplayLastSection := -1;
    FStyle.UpdateInfoRePaint;
    FStyle.UpdateInfoReCaret;

    DoChange;
  end;
end;

procedure THCView.DeleteSelected;
begin
  ActiveSection.DeleteSelected;
end;

destructor THCView.Destroy;
begin
  if Assigned(FAnnotates) then
    FreeAndNil(FAnnotates);

  FreeAndNil(FSections);
  FreeAndNil(FCaret);
  FreeAndNil(FHScrollBar);
  FreeAndNil(FVScrollBar);
  FreeAndNil(FDataBmp);
  FreeAndNil(FStyle);
  FreeAndNil(FUndoList);
  inherited Destroy;
end;

procedure THCView.DisSelect;
begin
  ActiveSection.DisSelect;
  //DoMapChanged;
  DoSectionDataCheckUpdateInfo(Self);
end;

function THCView.GetDisplayHeight: Integer;
begin
  if FHScrollBar.Visible then
    Result := Height - FHScrollBar.Height
  else
    Result := Height;
end;

function THCView.GetDisplayRect: TRect;
begin
  Result := Bounds(0, 0, GetDisplayWidth, GetDisplayHeight);
end;

function THCView.GetDisplayWidth: Integer;
begin
  if FVScrollBar.Visible then
    Result := Width - FVScrollBar.Width
  else
    Result := Width;
end;

function THCView.GetHScrollValue: Integer;
begin
  Result := FHScrollBar.Position;
end;

procedure THCView.DoMapChanged;
begin
  if FUpdateCount = 0 then
  begin
    CalcScrollRang;
    CheckUpdateInfo;
  end;
end;

function THCView.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if FPageScrollModel = psmVertical then
    FVScrollBar.Position := FVScrollBar.Position - WheelDelta div 1
  else
    FHScrollBar.Position := FHScrollBar.Position - WheelDelta div 1;
  Result := True;
end;

procedure THCView.DoNewUndo(const Sender: THCUndo);
begin
  Sender.SectionIndex := FActiveSectionIndex;
  Sender.Data := ActiveSection.ActiveData;
end;

procedure THCView.DoSectionPaintPage(Sender: TObject;
  const APageIndex: Integer; const ARect: TRect; const ACanvas: TCanvas;
  const APaintInfo: TSectionPaintInfo);
begin
  if Assigned(FOnSectionPaintPage) then
    FOnSectionPaintPage(Sender, APageIndex, ARect, ACanvas, APaintInfo);
end;

procedure THCView.DoSectionPaintFooter(Sender: TObject;
  const APageIndex: Integer; const ARect: TRect; const ACanvas: TCanvas;
  const APaintInfo: TSectionPaintInfo);
var
  i, vSectionStartPageIndex, vSectionIndex, vAllPageCount: Integer;
  vS: string;
  vSection: THCSection;
begin
  vSection := Sender as THCSection;

  if vSection.PageNoVisible then  // ��ʾҳ��
  begin
    vSectionIndex := FSections.IndexOf(vSection);
    vSectionStartPageIndex := 0;
    vAllPageCount := 0;
    for i := 0 to FSections.Count - 1 do
    begin
      if i = vSectionIndex then
        vSectionStartPageIndex := vAllPageCount;

      vAllPageCount := vAllPageCount + FSections[i].PageCount;
    end;
    vS := Format('%d/%d', [vSectionStartPageIndex + vSection.PageNoFrom + APageIndex, vAllPageCount]);
    ACanvas.Brush.Style := bsClear;
    ACanvas.Font.Size := 10;
    ACanvas.Font.Name := '����';
    ACanvas.TextOut(ARect.Left + (ARect.Width - ACanvas.TextWidth(vS)) div 2, ARect.Top + 20, vS);
  end;

  if Assigned(FOnSectionPaintFooter) then
    FOnSectionPaintFooter(vSection, APageIndex, ARect, ACanvas, APaintInfo);
end;

procedure THCView.DoSectionPaintHeader(Sender: TObject;
  const APageIndex: Integer; const ARect: TRect; const ACanvas: TCanvas;
  const APaintInfo: TSectionPaintInfo);
begin
  if Assigned(FOnSectionPaintHeader) then
    FOnSectionPaintHeader(Sender, APageIndex, ARect, ACanvas, APaintInfo);
end;

procedure THCView.DoSectionPaintWholePage(Sender: TObject; const APageIndex: Integer;
  const ARect: TRect; const ACanvas: TCanvas; const APaintInfo: TSectionPaintInfo);
begin
  if FShowAnnotation then  // ������ע
    FAnnotates.PaintTo(ACanvas, ARect, APaintInfo);

  if Assigned(FOnSectionPaintWholePage) then
    FOnSectionPaintWholePage(Sender, APageIndex, ARect, ACanvas, APaintInfo);
end;

procedure THCView.DoSectionReadOnlySwitch(Sender: TObject);
begin
  if Assigned(FOnSectionReadOnlySwitch) then
    FOnSectionReadOnlySwitch(Sender);
end;

function THCView.DoSectionGetScreenCoord(const X, Y: Integer): TPoint;
begin
  Result := ClientToScreen(Point(X, Y));
end;

function THCView.DoSectionGetUndoList: THCUndoList;
begin
  Result := FUndoList;// THCUndo.Create;
end;

procedure THCView.DoPasteDataBefor(const AStream: TStream; const AVersion: Word);
begin
end;

function THCView.DoProcessIMECandi(const ACandi: string): Boolean;
begin
  Result := True;
end;

procedure THCView.DoRedo(const Sender: THCUndo);
begin
  if FActiveSectionIndex <> Sender.SectionIndex then
    SetActiveSectionIndex(Sender.SectionIndex);

  ActiveSection.Redo(Sender);
end;

procedure THCView.DoSaveAfter(const AStream: TStream);
begin
  SetIsChanged(False);
end;

procedure THCView.DoSaveBefor(const AStream: TStream);
begin
  // �����ⲿ����洢�Զ������ݣ����ϴ����λ�õ�
end;

procedure THCView.DoSectionCreateItem(Sender: TObject);
begin
  if Assigned(FOnSectionCreateItem) then
    FOnSectionCreateItem(Sender);
end;

function THCView.DoSectionCreateStyleItem(const AData: THCCustomData; const AStyleNo: Integer): THCCustomItem;
begin
  if Assigned(FOnSectionCreateStyleItem) then
    Result := FOnSectionCreateStyleItem(AData, AStyleNo)
  else
    Result := nil;
end;

procedure THCView.DoSectionDataChanged(Sender: TObject);
begin
  DoChange;
end;

procedure THCView.DoSectionDataCheckUpdateInfo(Sender: TObject);
begin
  if FUpdateCount = 0 then
    CheckUpdateInfo;
end;

procedure THCView.DoCaretChange;
begin
  if Assigned(FOnCaretChange) then
    FOnCaretChange(Self);
end;

procedure THCView.DoChange;
begin
  SetIsChanged(True);
  DoMapChanged;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure THCView.DoCopyDataBefor(const AStream: TStream);
begin
end;

function THCView.DoInsertText(const AText: string): Boolean;
begin
  Result := ActiveSection.InsertText(AText);
end;

procedure THCView.DoSectionDrawItemPaintAfter(const AData: THCCustomData;
  const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
  ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
  const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
begin
  if Assigned(FOnSectionDrawItemPaintAfter) then
    FOnSectionDrawItemPaintAfter(AData, ADrawItemNo, ADrawRect, ADataDrawLeft,
      ADataDrawBottom, ADataScreenTop, ADataScreenBottom, ACanvas, APaintInfo);
end;

procedure THCView.DoLoadFromStream(const AStream: TStream;
  const AStyle: THCStyle; const ALoadSectionProc: TLoadSectionProc);
var
  vFileExt, vFileVersion: string;
  viVersion: Word;
begin
  AStream.Position := 0;
  _LoadFileFormatAndVersion(AStream, vFileExt, vFileVersion);  // �ļ���ʽ�Ͱ汾
  if (vFileExt <> HC_EXT) and (vFileExt <> 'cff.') then
    raise Exception.Create('����ʧ�ܣ�����' + HC_EXT + '�ļ���');

  viVersion := GetVersionAsInteger(vFileVersion);

  DoLoadBefor(AStream, viVersion);  // ��������ǰ�¼�
  AStyle.LoadFromStream(AStream, viVersion);  // ������ʽ��
  ALoadSectionProc(viVersion);  // ���ؽ�������������
  DoMapChanged;
end;

procedure THCView.DoSectionInsertItem(const AItem: THCCustomItem);
begin
  if Assigned(FOnSectionInsertItem) then
    FOnSectionInsertItem(AItem);
end;

procedure THCView.DoSectionItemPaintAfter(const AData: THCCustomData;
  const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
  ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
  const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
begin
  if Assigned(FOnSectionItemPaintAfter) then
  begin
    FOnSectionItemPaintAfter(AData, ADrawItemNo, ADrawRect, ADataDrawLeft,
      ADataDrawBottom, ADataScreenTop, ADataScreenBottom, ACanvas, APaintInfo);
  end;
end;

procedure THCView.DoSectionItemPaintBefor(const AData: THCCustomData;
  const ADrawItemNo: Integer; const ADrawRect: TRect; const ADataDrawLeft,
  ADataDrawBottom, ADataScreenTop, ADataScreenBottom: Integer;
  const ACanvas: TCanvas; const APaintInfo: TPaintInfo);
begin
  if Assigned(FOnSectionItemPaintBefor) then
  begin
    FOnSectionItemPaintBefor(AData, ADrawItemNo, ADrawRect, ADataDrawLeft,
      ADataDrawBottom, ADataScreenTop, ADataScreenBottom, ACanvas, APaintInfo);
  end;
end;

procedure THCView.DoStyleInvalidateRect(const ARect: TRect);
begin
  UpdateView(ARect);
end;

procedure THCView.DoUndo(const Sender: THCUndo);
begin
  if FActiveSectionIndex <> Sender.SectionIndex then
    SetActiveSectionIndex(Sender.SectionIndex);

  ActiveSection.Undo(Sender);
end;

procedure THCView.DoLoadAfter(const AStream: TStream; const AFileVersion: Word);
begin
end;

procedure THCView.DoLoadBefor(const AStream: TStream; const AFileVersion: Word);
begin
end;

procedure THCView.EndUpdate;
begin
  Dec(FUpdateCount);
  DoMapChanged;
end;

procedure THCView.FormatData;
var
  i: Integer;
begin
  for i := 0 to Sections.Count - 1 do
    Sections[i].FormatData;

  FStyle.UpdateInfoRePaint;
  FStyle.UpdateInfoReCaret;
  DoMapChanged;
end;

function THCView.GetTopLevelDrawItem: THCCustomDrawItem;
begin
  Result := ActiveSection.GetTopLevelDrawItem;
end;

function THCView.GetTopLevelItem: THCCustomItem;
begin
  Result := ActiveSection.GetTopLevelItem;
end;

function THCView.GetActiveDrawItemClientCoord: TPoint;
var
  vPageIndex: Integer;
begin
  Result := ActiveSection.GetActiveDrawItemCoord;  // ��ѡ��ʱ����ѡ�н���λ�õ�DrawItem��ʽ������
  vPageIndex := ActiveSection.GetPageIndexByFormat(Result.Y);

  // ӳ�䵽��ҳ��(��ɫ����)
  Result.X := ZoomIn(GetSectionDrawLeft(Self.ActiveSectionIndex)
    + (ActiveSection.GetPageMarginLeft(vPageIndex) + Result.X)) - Self.HScrollValue;

  if ActiveSection.ActiveData = ActiveSection.Header then
    Result.Y := ZoomIn(GetSectionTopFilm(Self.ActiveSectionIndex)
      + ActiveSection.GetPageTopFilm(vPageIndex)  // 20
      + ActiveSection.GetHeaderPageDrawTop
      + Result.Y
      - ActiveSection.GetPageDataFmtTop(vPageIndex))  // 0
      - Self.VScrollValue
  else
  if ActiveSection.ActiveData = ActiveSection.Footer then
    Result.Y := ZoomIn(GetSectionTopFilm(Self.ActiveSectionIndex)
      + ActiveSection.GetPageTopFilm(vPageIndex)  // 20
      + ActiveSection.PageHeightPix - ActiveSection.PageMarginBottomPix
      + Result.Y
      - ActiveSection.GetPageDataFmtTop(vPageIndex))  // 0
      - Self.VScrollValue
  else
    Result.Y := ZoomIn(GetSectionTopFilm(Self.ActiveSectionIndex)
      + ActiveSection.GetPageTopFilm(vPageIndex)  // 20
      + ActiveSection.GetHeaderAreaHeight // 94
      + Result.Y
      - ActiveSection.GetPageDataFmtTop(vPageIndex))  // 0
      - Self.VScrollValue;
end;

function THCView.GetActivePageIndex: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FActiveSectionIndex - 1 do
    Result := Result + FSections[i].PageCount;

  Result := Result + ActiveSection.ActivePageIndex;
end;

function THCView.GetCurItem: THCCustomItem;
begin
  Result := ActiveSection.GetCurItem;
end;

procedure THCView.GetSectionByCrood(const X, Y: Integer;
  var ASectionIndex: Integer);
var
  i, vY: Integer;
begin
  ASectionIndex := -1;
  vY := 0;
  for i := 0 to FSections.Count - 1 do
  begin
    vY := vY + FSections[i].GetFilmHeight;
    if vY > Y then
    begin
      ASectionIndex := i;
      Break;
    end;
  end;
  if (ASectionIndex < 0) and (vY + PagePadding >= Y) then  // ���һҳ�����Padding
    ASectionIndex := FSections.Count - 1;

  Assert(ASectionIndex >= 0, 'û�л�ȡ����ȷ�Ľ���ţ�');
end;

function THCView.GetSectionDrawLeft(const ASectionIndex: Integer): Integer;
begin
  if FShowAnnotation then  // ��ʾ��ע
    Result := Max((GetDisplayWidth - ZoomIn(FSections[ASectionIndex].PageWidthPix + AnnotationWidth)) div 2, ZoomIn(PagePadding))
  else
    Result := Max((GetDisplayWidth - ZoomIn(FSections[ASectionIndex].PageWidthPix)) div 2, ZoomIn(PagePadding));
  Result := ZoomOut(Result);
end;

function THCView.GetSectionPageIndexByPageIndex(const APageIndex: Integer;
  var ASectionPageIndex: Integer): Integer;
var
  i, vPageCount: Integer;
begin
  vPageCount := 0;
  for i := 0 to FSections.Count - 1 do
  begin
    if vPageCount + FSections[i].PageCount > APageIndex then
    begin
      Result := i;  // �ҵ������
      ASectionPageIndex := APageIndex - vPageCount;  // FSections[i].PageCount;
      Break;
    end
    else
      vPageCount := vPageCount + FSections[i].PageCount;
  end;
end;

function THCView.GetSectionTopFilm(const ASectionIndex: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to ASectionIndex - 1 do
    Result := Result + FSections[i].GetFilmHeight;
end;

function THCView.GetShowLineActiveMark: Boolean;
begin
  Result := FSections[0].PageData.ShowLineActiveMark;
end;

function THCView.GetShowLineNo: Boolean;
begin
  Result := FSections[0].PageData.ShowLineNo;
end;

function THCView.GetShowUnderLine: Boolean;
begin
  Result := FSections[0].PageData.ShowUnderLine;
end;

function THCView.GetSymmetryMargin: Boolean;
begin
  Result := ActiveSection.SymmetryMargin;
end;

function THCView.GetVScrollValue: Integer;
begin
  Result := FVScrollBar.Position;
end;

function THCView.InsertAnnotate(const AText: string): Boolean;
begin
  Result := ActiveSection.InsertAnnotate(AText);
end;

function THCView.InsertBreak: Boolean;
begin
  Result := Self.ActiveSection.InsertBreak;
end;

function THCView.InsertFloatItem(const AFloatItem: THCFloatItem): Boolean;
begin
  Result := ActiveSection.InsertFloatItem(AFloatItem);
end;

function THCView.InsertItem(const AIndex: Integer;
  const AItem: THCCustomItem): Boolean;
begin
  Result := ActiveSection.InsertItem(AIndex, AItem);
end;

function THCView.InsertItem(const AItem: THCCustomItem): Boolean;
begin
  Result := ActiveSection.InsertItem(AItem);
end;

function THCView.InsertLine(const ALineHeight: Integer): Boolean;
begin
  Result := ActiveSection.InsertLine(ALineHeight);
end;

function THCView.InsertPageBreak: Boolean;
begin
  Result := Self.ActiveSection.InsertPageBreak;
end;

function THCView.InsertSectionBreak: Boolean;
var
  vSection: THCSection;
begin
  Result := False;
  vSection := NewDefaultSection;
  FSections.Insert(FActiveSectionIndex + 1, vSection);
  FActiveSectionIndex := FActiveSectionIndex + 1;
  Result := True;
  FStyle.UpdateInfoRePaint;
  FStyle.UpdateInfoReCaret;
  DoChange;
end;

function THCView.InsertStream(const AStream: TStream): Boolean;
var
  vStyle: THCStyle;
  vResult: Boolean;
begin
  Result := False;
  vResult := False;

  Self.BeginUpdate;
  try
    vStyle := THCStyle.Create;
    try
      DoLoadFromStream(AStream, vStyle, procedure(const AFileVersion: Word)
        var
          vByte: Byte;
          vSection: THCSection;
          vShowUnderLine: Boolean;  // �»���
          vDataStream: TMemoryStream;
        begin
          AStream.ReadBuffer(vByte, 1);  // ������

          vDataStream := TMemoryStream.Create;
          try
            vSection := THCSection.Create(vStyle);
            try
              // ��ѭ����ֻ�����һ�ڵ�����
              vSection.LoadFromStream(AStream, vStyle, AFileVersion);
              vDataStream.Clear;
              vSection.PageData.SaveToStream(vDataStream);
              vDataStream.Position := 0;
              vDataStream.ReadBuffer(vShowUnderLine, SizeOf(vShowUnderLine));
              vResult := ActiveSection.InsertStream(vDataStream, vStyle, AFileVersion);  // ֻ�����һ�ڵ�����
            finally
              FreeAndNil(vSection);
            end;
          finally
            FreeAndNil(vDataStream);
          end;
        end);
    finally
      FreeAndNil(vStyle);
    end;
  finally
    Self.EndUpdate;
  end;

  Result := vResult;
end;

function THCView.ActiveTableDeleteCurCol: Boolean;
begin
  Result := ActiveSection.ActiveTableDeleteCurCol;
end;

function THCView.ActiveTableDeleteCurRow: Boolean;
begin
  Result := ActiveSection.ActiveTableDeleteCurRow;
end;

function THCView.ActiveTableInsertColAfter(const AColCount: Byte): Boolean;
begin
  Result := ActiveSection.ActiveTableInsertColAfter(AColCount);
end;

function THCView.ActiveTableInsertColBefor(const AColCount: Byte): Boolean;
begin
  Result := ActiveSection.ActiveTableInsertColBefor(AColCount);
end;

function THCView.ActiveTableInsertRowAfter(const ARowCount: Byte): Boolean;
begin
  Result := ActiveSection.ActiveTableInsertRowAfter(ARowCount);
end;

function THCView.ActiveTableInsertRowBefor(const ARowCount: Byte): Boolean;
begin
  Result := ActiveSection.ActiveTableInsertRowBefor(ARowCount);
end;

function THCView.ActiveTableSplitCurCol: Boolean;
begin
  Result := ActiveSection.ActiveTableSplitCurCol;
end;

function THCView.ActiveTableSplitCurRow: Boolean;
begin
  Result := ActiveSection.ActiveTableSplitCurRow;
end;

function THCView.ActiveSectionTopLevelData: THCCustomRichData;
begin
  Result := ActiveSection.ActiveData.GetTopLevelData;
end;

function THCView.InsertTable(const ARowCount, AColCount: Integer): Boolean;
begin
  Self.BeginUpdate;
  try
    Result := ActiveSection.InsertTable(ARowCount, AColCount);
  finally
    Self.EndUpdate
  end;
end;

function THCView.InsertText(const AText: string): Boolean;
begin
  Self.BeginUpdate;
  try
    Result := DoInsertText(AText);
  finally
    Self.EndUpdate;
  end;
end;

procedure THCView.KeyDown(var Key: Word; Shift: TShiftState);

  {$REGION '��ݼ�'}
  function IsCopyShortKey: Boolean;
  begin
    Result := (Shift = [ssCtrl]) and (Key = ord('C'));
  end;

  function IsCopyTextShortKey: Boolean;
  begin
    Result := (Shift = [ssCtrl, ssShift]) and (Key = ord('C'));
  end;

  function IsCutShortKey: Boolean;
  begin
    Result := (Shift = [ssCtrl]) and (Key = ord('X'));
  end;

  function IsPasteShortKey: Boolean;
  begin
    Result := (Shift = [ssCtrl]) and (Key = ord('V'));
  end;

  function IsSelectAllShortKey: Boolean;
  begin
    Result := (Shift = [ssCtrl]) and (Key = ord('A'));
  end;

  function IsUndoKey: Boolean;
  begin
    Result := (Shift = [ssCtrl]) and (Key = ord('Z'));
  end;

  function IsRedoKey: Boolean;
  begin
    Result := (Shift = [ssCtrl]) and (Key = ord('Y'));
  end;
  {$ENDREGION}

begin
  inherited;
  if IsCopyTextShortKey then
    Self.CopyAsText
  else
  if IsCopyShortKey then
    Self.Copy
  else
  if IsCutShortKey then
    Self.Cut
  else
  if IsPasteShortKey then
    Self.Paste
  else
  if IsSelectAllShortKey then
    Self.SelectAll
  else
  if IsUndoKey then
    Self.Undo
  else
  if IsRedoKey then
    Self.Redo
  else
    ActiveSection.KeyDown(Key, Shift);
end;

procedure THCView.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  ActiveSection.KeyPress(Key);
end;

procedure THCView.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  ActiveSection.KeyUp(Key, Shift);
end;

procedure THCView.LoadFromFile(const AFileName: string);
var
  vStream: TStream;
begin
  FFileName := AFileName;
  vStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(vStream);
  finally
    FreeAndNil(vStream);
  end;
end;

procedure THCView.LoadFromStream(const AStream: TStream);
var
  vByte: Byte;
  vSection: THCSection;
begin
  Self.BeginUpdate;
  try
    Self.Clear;
    AStream.Position := 0;
    DoLoadFromStream(AStream, FStyle, procedure(const AFileVersion: Word)
      var
        i: Integer;
      begin
        AStream.ReadBuffer(vByte, 1);  // ������
        // ��������
        FSections[0].LoadFromStream(AStream, FStyle, AFileVersion);
        for i := 1 to vByte - 1 do
        begin
          vSection := NewDefaultSection;
          vSection.LoadFromStream(AStream, FStyle, AFileVersion);
          FSections.Add(vSection);
        end;
      end);
  finally
    Self.EndUpdate;
  end;
end;

procedure THCView.LoadFromText(const AFileName: string);
begin
  Self.Clear;
  FStyle.Initialize;
  ActiveSection.LoadFromText(AFileName, TEncoding.ASCII);
end;

function THCView.MergeTableSelectCells: Boolean;
begin
  Result := ActiveSection.MergeTableSelectCells;
end;

procedure THCView.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  vSectionIndex, vSectionDrawLeft: Integer;
  vPt: TPoint;
begin
  inherited;
  GetSectionByCrood(ZoomOut(FHScrollBar.Position + X), ZoomOut(FVScrollBar.Position + Y), vSectionIndex);
  if vSectionIndex <> FActiveSectionIndex then
    SetActiveSectionIndex(vSectionIndex);
  if FActiveSectionIndex < 0 then Exit;

  vSectionDrawLeft := GetSectionDrawLeft(FActiveSectionIndex);

  if FShowAnnotation then  // ��ע����ʾ
  begin
    if (X > vSectionDrawLeft + FSections[FActiveSectionIndex].PageWidthPix)
      and (X < vSectionDrawLeft + FSections[FActiveSectionIndex].PageWidthPix + AnnotationWidth)
    then  // ������ע������
    begin
      FAnnotates.MouseDown(X, Y);
      FStyle.UpdateInfoRePaint;
      DoSectionDataCheckUpdateInfo(Self);
      Exit;
    end;
  end;

  // ӳ�䵽��ҳ��(��ɫ����)
  vPt.X := ZoomOut(FHScrollBar.Position + X) - vSectionDrawLeft;
  vPt.Y := ZoomOut(FVScrollBar.Position + Y) - GetSectionTopFilm(FActiveSectionIndex);
  //vPageIndex := FSections[FActiveSectionIndex].GetPageByFilm(vPt.Y);
  FSections[FActiveSectionIndex].MouseDown(Button, Shift, vPt.X, vPt.Y);

  CheckUpdateInfo;  // ����ꡢ�л�����Item
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
end;

procedure THCView.MouseMove(Shift: TShiftState; X, Y: Integer);

  {$REGION 'ProcessHint'}
  procedure ProcessHint;
  var
    //vPt: Tpoint;
    vHint: string;
  begin
    vHint := ActiveSection.GetHint;
    if vHint <> Hint then
    begin
//      {if CustomHint <> nil then
//        CustomHint.HideHint;}
      Hint := vHint;
      Application.CancelHint;
    end
//    else
//    begin
//      {if CustomHint <> nil then
//        CustomHint.ShowHint(Self)
//      else
//      begin }
//        GetCursorPos(vPt);
//        Application.ActivateHint(vPt);
//     // end;
//    end;
  end;
  {$ENDREGION}

begin
  inherited;
  //GetSectionByCrood(FHScrollBar.Value + X, FVScrollBar.Value + Y, vSectionIndex);
  if FActiveSectionIndex >= 0 then  // ����ʱ�ڽ���
  begin
    FSections[FActiveSectionIndex].MouseMove(Shift,
      ZoomOut(FHScrollBar.Position + X) - GetSectionDrawLeft(FActiveSectionIndex),
      ZoomOut(FVScrollBar.Position + Y) - GetSectionTopFilm(FActiveSectionIndex));
    if ShowHint then
      ProcessHint;
  end;

  CheckUpdateInfo;  // ������Ҫ������괦Item

  if FStyle.UpdateInfo.Draging then
    Screen.Cursor := GCursor
  else
    Cursor := GCursor;
end;

procedure THCView.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if Button = mbRight then Exit;  // �Ҽ������˵�
  //GetSectionByCrood(FHScrollBar.Value + X, FVScrollBar.Value + Y, vSectionIndex);
  if FActiveSectionIndex >= 0 then  // ����ʱ�ڽ���
    FSections[FActiveSectionIndex].MouseUp(Button, Shift,
      ZoomOut(FHScrollBar.Position + X) - GetSectionDrawLeft(FActiveSectionIndex),
      ZoomOut(FVScrollBar.Position + Y) - GetSectionTopFilm(FActiveSectionIndex));

  if FStyle.UpdateInfo.Draging then
    Screen.Cursor := crDefault;

  Cursor := GCursor;

  CheckUpdateInfo;  // ��ѡ�������а��²��ƶ��������ʱ��Ҫ����

  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);

  FStyle.UpdateInfo.Selecting := False;
  FStyle.UpdateInfo.Draging := False;
end;

function THCView.NewDefaultSection: THCSection;
begin
  Result := THCSection.Create(FStyle);
  // �����ں����ϸ�ֵ�¼�����֤��������������Ҫ��Щ�¼��Ĳ����ɻ�ȡ���¼���
  Result.OnDataChanged := DoSectionDataChanged;
  Result.OnCheckUpdateInfo := DoSectionDataCheckUpdateInfo;
  Result.OnCreateItem := DoSectionCreateItem;
  Result.OnCreateItemByStyle := DoSectionCreateStyleItem;
  Result.OnInsertItem := DoSectionInsertItem;
  Result.OnReadOnlySwitch := DoSectionReadOnlySwitch;
  Result.OnGetScreenCoord := DoSectionGetScreenCoord;
  Result.OnItemPaintAfter := DoSectionItemPaintAfter;
  Result.OnItemPaintBefor := DoSectionItemPaintBefor;
  Result.OnPaintHeader := DoSectionPaintHeader;
  Result.OnPaintFooter := DoSectionPaintFooter;
  Result.OnPaintPage := DoSectionPaintPage;
  Result.OnPaintWholePage := DoSectionPaintWholePage;
  Result.OnDrawItemPaintAfter := DoSectionDrawItemPaintAfter;
  Result.OnGetUndoList := DoSectionGetUndoList;
end;

procedure THCView.DoVScrollChange(Sender: TObject; ScrollCode: TScrollCode;
    var ScrollPos: Integer);
begin
  FStyle.UpdateInfoRePaint;
  FStyle.UpdateInfoReCaret(False);
  CheckUpdateInfo;
  if Assigned(FOnVerScroll) then
    FOnVerScroll(Self);
end;

function THCView.GetPageCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FSections.Count - 1 do
    Result := Result + FSections[i].PageCount;
end;

function THCView.GetPagePreviewFirst: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FActiveSectionIndex - 1 do
    Result := Result + FSections[i].PageCount;
  Result := Result + FSections[FActiveSectionIndex].DisplayFirstPageIndex;
end;

function THCView.GetReadOnly: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to FSections.Count - 1 do
  begin
    if not FSections[i].ReadOnly then
    begin
      Result := False;
      Break;
    end;
  end;
end;

procedure THCView.Paint;
begin
  //Canvas.Draw(0, 0, FDataBmp);
  BitBlt(Canvas.Handle, 0, 0, GetDisplayWidth, GetDisplayHeight,
      FDataBmp.Canvas.Handle, 0, 0, SRCCOPY);
  Canvas.Brush.Color := Self.Color;
  Canvas.FillRect(Bounds(FVScrollBar.Left, FHScrollBar.Top, FVScrollBar.Width, FHScrollBar.Height));
end;

procedure THCView.Paste;

  procedure PasteImage;
  var
    vImageItem: THCImageItem;

    procedure RestrainImageSize;
    var
      vContentWidth, vContentHeight: Integer;
    begin
      with ActiveSection do
      begin
        vContentWidth := PageWidthPix - PageMarginLeftPix - PageMarginRightPix;
        vContentHeight := PageHeightPix - GetHeaderAreaHeight - PageMarginBottomPix;
      end;

      vImageItem.RestrainSize(vContentWidth, vContentHeight);
    end;

  begin
    vImageItem := THCImageItem.Create(Self.ActiveSectionTopLevelData);
    vImageItem.Image.Assign(Clipboard);
    vImageItem.Width := vImageItem.Image.Width;
    vImageItem.Height := vImageItem.Image.Height;

    RestrainImageSize;
    Self.InsertItem(vImageItem);
  end;

var
  vStream: TMemoryStream;
  vMem: Cardinal;
  vPtr: Pointer;
  vSize, viVersion: Integer;
  vFileFormat, vFileVersion: string;
  vStyle: THCStyle;
begin
  if Clipboard.HasFormat(HC_FILEFORMAT) then
  begin
    vStream := TMemoryStream.Create;
    try
      Clipboard.Open;
      try
        vMem := Clipboard.GetAsHandle(HC_FILEFORMAT);
        vSize := GlobalSize(vMem);
        vStream.SetSize(vSize);
        vPtr := GlobalLock(vMem);
        Move(vPtr^, vStream.Memory^, vSize);
        GlobalUnlock(vMem);
      finally
        Clipboard.Close;
      end;
      //
      vStream.Position := 0;
      _LoadFileFormatAndVersion(vStream, vFileFormat, vFileVersion);  // �ļ���ʽ�Ͱ汾
      viVersion := GetVersionAsInteger(vFileVersion);
      DoPasteDataBefor(vStream, viVersion);
      vStyle := THCStyle.Create;
      try
        vStyle.LoadFromStream(vStream, viVersion);
        Self.BeginUpdate;
        try
          ActiveSection.InsertStream(vStream, vStyle, viVersion);
        finally
          Self.EndUpdate;
        end;
      finally
        FreeAndNil(vStyle);
      end;
    finally
      vStream.Free;
    end;
  end
  else
  if Clipboard.HasFormat(CF_TEXT) then
    InsertText(Clipboard.AsText)
  else
  if Clipboard.HasFormat(CF_BITMAP) then
    PasteImage;
end;

function THCView.Print(const APrinter: string; const ACopies: Integer = 1): TPrintResult;
begin
  Result := Print(APrinter, 0, PageCount - 1, ACopies);
end;

function THCView.Print: TPrintResult;
begin
  Result := Print('');
end;

function THCView.Print(const APrinter: string; const ACopies: Integer;
  const APages: array of Integer): TPrintResult;
var
  i, vPageIndex, vSectionIndex, vPrintWidth, vPrintHeight,
  vPrintOffsetX, vPrintOffsetY: Integer;
  vPrintCanvas: TCanvas;
  vPaintInfo: TSectionPaintInfo;
  vScaleInfo: TScaleInfo;
begin
  Result := prError;

  if APrinter <> '' then
    Printer.PrinterIndex := Printer.Printers.IndexOf(APrinter);

  if Printer.PrinterIndex < 0 then Exit;

  Printer.Title := FFileName;

  // ȡ��ӡ����ӡ������ز���
  vPrintOffsetX := -GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);  // 73
  vPrintOffsetY := -GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);  // 37

  Printer.Copies := ACopies;

  vPaintInfo := TSectionPaintInfo.Create;
  try
    vPaintInfo.Print := True;

    Printer.BeginDoc;
    try
      vPrintCanvas := TCanvas.Create;
      try
        vPrintCanvas.Handle := Printer.Canvas.Handle;  // Ϊʲô����vPrintCanvas�н��ӡ�Ͳ����أ�

        for i := Low(APages) to High(APages) do
        begin
          // ����ҳ���ȡ��ʼ�ںͽ�����
          vSectionIndex := GetSectionPageIndexByPageIndex(APages[i], vPageIndex);
          if vPaintInfo.SectionIndex <> vSectionIndex then
          begin
            vPaintInfo.SectionIndex := vSectionIndex;
            SetPrintBySectionInfo(vSectionIndex);

            vPrintWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);  // 4961
            vPrintHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);  // 7016

            vPaintInfo.ScaleX := vPrintWidth / FSections[vSectionIndex].PageWidthPix;  // GetDeviceCaps(Printer.Handle, LOGPIXELSX) / GetDeviceCaps(FStyle.DefCanvas.Handle, LOGPIXELSX);
            vPaintInfo.ScaleY := vPrintHeight / FSections[vSectionIndex].PageHeightPix;  // GetDeviceCaps(Printer.Handle, LOGPIXELSY) / GetDeviceCaps(FStyle.DefCanvas.Handle, LOGPIXELSY);
            vPaintInfo.WindowWidth := vPrintWidth;  // FSections[vStartSection].PageWidthPix;
            vPaintInfo.WindowHeight := vPrintHeight;  // FSections[vStartSection].PageHeightPix;

            vPrintOffsetX := Round(vPrintOffsetX / vPaintInfo.ScaleX);
            vPrintOffsetY := Round(vPrintOffsetY / vPaintInfo.ScaleY);
          end;

          vScaleInfo := vPaintInfo.ScaleCanvas(vPrintCanvas);
          try
            vPaintInfo.PageIndex := APages[i];

            FSections[vSectionIndex].PaintPage(APages[i], vPrintOffsetX, vPrintOffsetY,
              vPrintCanvas, vPaintInfo);

            if i < High(APages) then
              Printer.NewPage;
          finally
            vPaintInfo.RestoreCanvasScale(vPrintCanvas, vScaleInfo);
          end;
        end;
      finally
        vPrintCanvas.Handle := 0;
        vPrintCanvas.Free;
      end;
    finally
      Printer.EndDoc;
    end;
  finally
    vPaintInfo.Free;
  end;

  Result := prOk;
end;

function THCView.Print(const APrinter: string; const AStartPageIndex,
  AEndPageIndex, ACopies: Integer): TPrintResult;
var
  i: Integer;
  vPages: array of Integer;
begin
  SetLength(vPages, AEndPageIndex - AEndPageIndex + 1);
  for i := AStartPageIndex to AEndPageIndex do
    vPages[i] := i;

  Result := Print(APrinter, ACopies, vPages);
end;

function THCView.PrintCurPageByActiveLine(const APrintHeader,
  APrintFooter: Boolean): TPrintResult;
var
  vPt: TPoint;
  vPrintCanvas: TCanvas;
  vPrintWidth, vPrintHeight, vPrintOffsetX, vPrintOffsetY: Integer;
  vMarginLeft, vMarginRight: Integer;
  vRect: TRect;
  vPaintInfo: TSectionPaintInfo;
  vScaleInfo: TScaleInfo;
begin
  Result := TPrintResult.prError;

  vPrintOffsetX := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);  // 90
  vPrintOffsetY := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);  // 99

  vPaintInfo := TSectionPaintInfo.Create;
  try
    vPaintInfo.Print := True;
    vPaintInfo.SectionIndex := Self.ActiveSectionIndex;
    vPaintInfo.PageIndex := Self.ActiveSection.ActivePageIndex;

    SetPrintBySectionInfo(Self.ActiveSectionIndex);

    vPrintWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
    vPrintHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);

    vPaintInfo.ScaleX := vPrintWidth / Self.ActiveSection.PageWidthPix;  // GetDeviceCaps(Printer.Handle, LOGPIXELSX) / GetDeviceCaps(FStyle.DefCanvas.Handle, LOGPIXELSX);
    vPaintInfo.ScaleY := vPrintHeight / Self.ActiveSection.PageHeightPix;  // GetDeviceCaps(Printer.Handle, LOGPIXELSY) / GetDeviceCaps(FStyle.DefCanvas.Handle, LOGPIXELSY);
    vPaintInfo.WindowWidth := vPrintWidth;  // FSections[vStartSection].PageWidthPix;
    vPaintInfo.WindowHeight := vPrintHeight;  // FSections[vStartSection].PageHeightPix;

    vPrintOffsetX := Round(vPrintOffsetX / vPaintInfo.ScaleX);
    vPrintOffsetY := Round(vPrintOffsetY / vPaintInfo.ScaleY);

    Printer.BeginDoc;
    try
      vPrintCanvas := TCanvas.Create;
      try
        vPrintCanvas.Handle := Printer.Canvas.Handle;  // Ϊʲô����vPageCanvas�н��ӡ�Ͳ����أ�

        vScaleInfo := vPaintInfo.ScaleCanvas(vPrintCanvas);
        try
          Self.ActiveSection.PaintPage(Self.ActiveSection.ActivePageIndex,
            vPrintOffsetX, vPrintOffsetY, vPrintCanvas, vPaintInfo);

          if Self.ActiveSection.ActiveData = Self.ActiveSection.PageData then
          begin
            vPt := Self.ActiveSection.GetActiveDrawItemCoord;
            vPt.Y := vPt.Y - ActiveSection.GetPageDataFmtTop(Self.ActiveSection.ActivePageIndex);
          end
          else
          begin
            Result := TPrintResult.prNoSupport;
            Exit;
          end;

          Self.ActiveSection.GetPageMarginLeftAndRight(Self.ActiveSection.ActivePageIndex,
            vMarginLeft, vMarginRight);

          // "Ĩ"������Ҫ��ʾ�ĵط�
          vPrintCanvas.Brush.Style := bsSolid;
          vPrintCanvas.Brush.Color := clWhite;

          if APrintHeader then  // ��ӡҳü
            vRect := Bounds(vPrintOffsetX + vMarginLeft,
              vPrintOffsetY + Self.ActiveSection.GetHeaderAreaHeight,  // ҳü�±�
              Self.ActiveSection.PageWidthPix - vMarginLeft - vMarginRight, vPt.Y)
          else  // ����ӡҳü
            vRect := Bounds(vPrintOffsetX + vMarginLeft, vPrintOffsetY,
              Self.ActiveSection.PageWidthPix - vMarginLeft - vMarginRight,
              Self.ActiveSection.GetHeaderAreaHeight + vPt.Y);
          vPrintCanvas.FillRect(vRect);

          if not APrintFooter then  // ����ӡҳ��
          begin
            vRect := Bounds(vPrintOffsetX + vMarginLeft,
              vPrintOffsetY + Self.ActiveSection.PageHeightPix - Self.ActiveSection.PageMarginBottomPix,
              Self.ActiveSection.PageWidthPix - vMarginLeft - vMarginRight,
              Self.ActiveSection.PageMarginBottomPix);

            vPrintCanvas.FillRect(vRect);
          end;
        finally
          vPaintInfo.RestoreCanvasScale(vPrintCanvas, vScaleInfo);
        end;
      finally
        vPrintCanvas.Handle := 0;
        vPrintCanvas.Free;
      end;
    finally
      Printer.EndDoc;
    end;
  finally
    vPaintInfo.Free;
  end;

  Result := TPrintResult.prOk;
end;

function THCView.PrintCurPageByItemRange(const APrintHeader, APrintFooter: Boolean;
  const AStartItemNo, AStartOffset, AEndItemNo, AEndOffset: Integer): TPrintResult;
var
  vData: THCCustomRichData;
  vPt: TPoint;
  vPrintCanvas: TCanvas;
  vPrintWidth, vPrintHeight, vPrintOffsetX, vPrintOffsetY: Integer;
  vMarginLeft, vMarginRight, vDrawItemNo: Integer;
  vRect: TRect;
  vPaintInfo: TSectionPaintInfo;
  vScaleInfo: TScaleInfo;
begin
  // ע�⣺�˷�����Ҫ��ʼItem��ʽ����һ��DrawItem�ͽ���ItemNo��ʽ�����һ��DrawItem��ͬһҳ
  Result := TPrintResult.prError;

  vPrintOffsetX := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);  // 90
  vPrintOffsetY := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);  // 99

  vPaintInfo := TSectionPaintInfo.Create;
  try
    vPaintInfo.Print := True;
    vPaintInfo.SectionIndex := Self.ActiveSectionIndex;
    vPaintInfo.PageIndex := Self.ActiveSection.ActivePageIndex;

    SetPrintBySectionInfo(Self.ActiveSectionIndex);

    vPrintWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
    vPrintHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);

    vPaintInfo.ScaleX := vPrintWidth / Self.ActiveSection.PageWidthPix;  // GetDeviceCaps(Printer.Handle, LOGPIXELSX) / GetDeviceCaps(FStyle.DefCanvas.Handle, LOGPIXELSX);
    vPaintInfo.ScaleY := vPrintHeight / Self.ActiveSection.PageHeightPix;  // GetDeviceCaps(Printer.Handle, LOGPIXELSY) / GetDeviceCaps(FStyle.DefCanvas.Handle, LOGPIXELSY);
    vPaintInfo.WindowWidth := vPrintWidth;  // FSections[vStartSection].PageWidthPix;
    vPaintInfo.WindowHeight := vPrintHeight;  // FSections[vStartSection].PageHeightPix;

    vPrintOffsetX := Round(vPrintOffsetX / vPaintInfo.ScaleX);
    vPrintOffsetY := Round(vPrintOffsetY / vPaintInfo.ScaleY);

    Printer.BeginDoc;
    try
      vPrintCanvas := TCanvas.Create;
      try
        vPrintCanvas.Handle := Printer.Canvas.Handle;  // Ϊʲô����vPageCanvas�н��ӡ�Ͳ����أ�

        vScaleInfo := vPaintInfo.ScaleCanvas(vPrintCanvas);
        try
          Self.ActiveSection.PaintPage(Self.ActiveSection.ActivePageIndex,
            vPrintOffsetX, vPrintOffsetY, vPrintCanvas, vPaintInfo);

          if Self.ActiveSection.ActiveData = Self.ActiveSection.PageData then
          begin
            vData := Self.ActiveSection.ActiveData;
            vDrawItemNo := vData.GetDrawItemNoByOffset(AStartItemNo, AStartOffset);
            vPt := vData.DrawItems[vDrawItemNo].Rect.TopLeft;
            vPt.Y := vPt.Y - ActiveSection.GetPageDataFmtTop(Self.ActiveSection.ActivePageIndex);
          end
          else
          begin
            Result := TPrintResult.prNoSupport;
            Exit;
          end;

          Self.ActiveSection.GetPageMarginLeftAndRight(Self.ActiveSection.ActivePageIndex,
            vMarginLeft, vMarginRight);

          // "Ĩ"������Ҫ��ʾ�ĵط�
          vPrintCanvas.Brush.Style := bsSolid;
          vPrintCanvas.Brush.Color := clWhite;

          if APrintHeader then  // ��ӡҳü
            vRect := Bounds(vPrintOffsetX + vMarginLeft,
              vPrintOffsetY + Self.ActiveSection.GetHeaderAreaHeight,  // ҳü�±�
              Self.ActiveSection.PageWidthPix - vMarginLeft - vMarginRight, vPt.Y)
          else  // ����ӡҳü
            vRect := Bounds(vPrintOffsetX + vMarginLeft, vPrintOffsetY,
              Self.ActiveSection.PageWidthPix - vMarginLeft - vMarginRight,
              Self.ActiveSection.GetHeaderAreaHeight + vPt.Y);
          vPrintCanvas.FillRect(vRect);

          vRect := Bounds(vPrintOffsetX + vMarginLeft,
            vPrintOffsetY + Self.ActiveSection.GetHeaderAreaHeight + vPt.Y,
            vData.GetDrawItemOffsetWidth(vDrawItemNo, AStartOffset - vData.DrawItems[vDrawItemNo].CharOffs + 1),
            vData.DrawItems[vDrawItemNo].Rect.Height);
          vPrintCanvas.FillRect(vRect);

          //
          vDrawItemNo := vData.GetDrawItemNoByOffset(AEndItemNo, AEndOffset);
          vPt := vData.DrawItems[vDrawItemNo].Rect.TopLeft;
          vPt.Y := vPt.Y - ActiveSection.GetPageDataFmtTop(Self.ActiveSection.ActivePageIndex);

          vRect := Rect(
            vPrintOffsetX + vMarginLeft +
              vData.GetDrawItemOffsetWidth(vDrawItemNo, AEndOffset - vData.DrawItems[vDrawItemNo].CharOffs + 1),
            vPrintOffsetY + Self.ActiveSection.GetHeaderAreaHeight + vPt.Y,
            vPrintOffsetX + Self.ActiveSection.PageWidthPix - vMarginRight,
            vPrintOffsetY + Self.ActiveSection.GetHeaderAreaHeight + vPt.Y + vData.DrawItems[vDrawItemNo].Rect.Height);
          vPrintCanvas.FillRect(vRect);

          if not APrintFooter then  // ����ӡҳ��
          begin
            vRect := Rect(vPrintOffsetX + vMarginLeft,
              vPrintOffsetY + + Self.ActiveSection.GetHeaderAreaHeight + vPt.Y + vData.DrawItems[vDrawItemNo].Rect.Height,
              vPrintOffsetX + Self.ActiveSection.PageWidthPix - vMarginRight,
              vPrintOffsetY + Self.ActiveSection.PageHeightPix);

            vPrintCanvas.FillRect(vRect);
          end
          else  // ��ӡҳ��
          begin
            vRect := Rect(vPrintOffsetX + vMarginLeft,
              vPrintOffsetY + + Self.ActiveSection.GetHeaderAreaHeight + vPt.Y + vData.DrawItems[vDrawItemNo].Rect.Height,
              vPrintOffsetX + Self.ActiveSection.PageWidthPix - vMarginRight,
              vPrintOffsetY + Self.ActiveSection.PageHeightPix - Self.ActiveSection.PageMarginBottomPix);
          end;
        finally
          vPaintInfo.RestoreCanvasScale(vPrintCanvas, vScaleInfo);
        end;
      finally
        vPrintCanvas.Handle := 0;
        vPrintCanvas.Free;
      end;
    finally
      Printer.EndDoc;
    end;
  finally
    vPaintInfo.Free;
  end;

  Result := TPrintResult.prOk;
end;

function THCView.PrintCurPageSelected(const APrintHeader,
  APrintFooter: Boolean): TPrintResult;
begin
  if Self.ActiveSection.ActiveData.SelectExists(False) then
  begin
    Result := PrintCurPageByItemRange(APrintHeader, APrintFooter,
      Self.ActiveSection.ActiveData.SelectInfo.StartItemNo,
      Self.ActiveSection.ActiveData.SelectInfo.StartItemOffset,
      Self.ActiveSection.ActiveData.SelectInfo.EndItemNo,
      Self.ActiveSection.ActiveData.SelectInfo.EndItemOffset);
  end
  else
    Result := TPrintResult.prNoSupport;
end;

procedure THCView.ReBuildCaret;
var
  vCaretInfo: TCaretInfo;
  vDisplayHeight: Integer;
begin
  if FCaret = nil then Exit;

  if (not Self.Focused) or ((not Style.UpdateInfo.Draging) and ActiveSection.SelectExists) then
  begin
    FCaret.Hide;
    Exit;
  end;

  { ��ʼ�������Ϣ��Ϊ�������������������ֻ�ܷ������� }
  vCaretInfo.X := 0;
  vCaretInfo.Y := 0;
  vCaretInfo.Height := 0;
  vCaretInfo.Visible := True;

  ActiveSection.GetPageCaretInfo(vCaretInfo);

  if not vCaretInfo.Visible then
  begin
    FCaret.Hide;
    Exit;
  end;
  FCaret.X := ZoomIn(GetSectionDrawLeft(FActiveSectionIndex) + vCaretInfo.X) - FHScrollBar.Position;
  FCaret.Y := ZoomIn(GetSectionTopFilm(FActiveSectionIndex) + vCaretInfo.Y) - FVScrollBar.Position;
  FCaret.Height := ZoomIn(vCaretInfo.Height);

  vDisplayHeight := GetDisplayHeight;
  if not FStyle.UpdateInfo.ReScroll then // ������ƽ������ʱ�����ܽ�������������
  begin
    if (FCaret.X < 0) or (FCaret.X > GetDisplayWidth) then
    begin
      FCaret.Hide;
      Exit;
    end;

    if (FCaret.Y + FCaret.Height < 0) or (FCaret.Y > vDisplayHeight) then
    begin
      FCaret.Hide;
      Exit;
    end;
  end
  else  // �ǹ�����(������������)����Ĺ��λ�ñ仯
  begin
    if FCaret.Height < vDisplayHeight then
    begin
      if FCaret.Y < 0 then
        FVScrollBar.Position := FVScrollBar.Position + FCaret.Y - PagePadding
      else
      if FCaret.Y + FCaret.Height + PagePadding > vDisplayHeight then
        FVScrollBar.Position := FVScrollBar.Position + FCaret.Y + FCaret.Height + PagePadding - vDisplayHeight;

      if FCaret.X < 0 then
        FHScrollBar.Position := FHScrollBar.Position + FCaret.X - PagePadding
      else
      if FCaret.X + PagePadding > GetDisplayWidth then
        FHScrollBar.Position := FHScrollBar.Position + FCaret.X + PagePadding - GetDisplayWidth;
    end;
  end;

  if FCaret.Y + FCaret.Height > vDisplayHeight then
    FCaret.Height := vDisplayHeight - FCaret.Y;

  FCaret.Show;
  DoCaretChange;
end;

procedure THCView.Redo;
begin
  BeginUpdate;
  try
    FUndoList.Redo;
  finally
    EndUpdate;
  end;
end;

procedure THCView.FormatSection(const ASectionIndex: Integer);
begin
  // FSections[ASectionIndex].PageData.ReFormat(0);
  FSections[ASectionIndex].FormatData;
  FSections[ASectionIndex].BuildSectionPages(0);
  FStyle.UpdateInfoRePaint;
  FStyle.UpdateInfoReCaret;

  DoChange;
end;

procedure THCView.ResetActiveSectionMargin;
begin
  ActiveSection.ResetMargin;
end;

procedure THCView.Resize;
var
  vDisplayWidth, vDisplayHeight: Integer;
begin
  inherited;

  vDisplayWidth := GetDisplayWidth;
  vDisplayHeight := GetDisplayHeight;

  if (vDisplayWidth > 0) and (vDisplayHeight > 0) then
    FDataBmp.SetSize(vDisplayWidth, vDisplayHeight);  // ����Ϊ����������Ĵ�С

  if FAutoZoom then
  begin
    if FShowAnnotation then  // ��ʾ��ע
      FZoom := (vDisplayWidth - PagePadding * 2) / (ActiveSection.PageWidthPix + AnnotationWidth)
    else
      FZoom := (vDisplayWidth - PagePadding * 2) / ActiveSection.PageWidthPix;
  end;

  CalcScrollRang;

  FStyle.UpdateInfoRePaint;
  if FCaret <> nil then
    FStyle.UpdateInfoReCaret(False);
  CheckUpdateInfo;
end;

procedure THCView._DeleteUnUsedStyle(const AParts: TSaveParts = [saHeader, saPage, saFooter]);
var
  i, vUnCount: Integer;
begin
  for i := 0 to FStyle.TextStyles.Count - 1 do
  begin
    FStyle.TextStyles[i].CheckSaveUsed := False;
    FStyle.TextStyles[i].TempNo := THCStyle.Null;
  end;
  for i := 0 to FStyle.ParaStyles.Count - 1 do
  begin
    FStyle.ParaStyles[i].CheckSaveUsed := False;
    FStyle.ParaStyles[i].TempNo := THCStyle.Null;
  end;

  for i := 0 to FSections.Count - 1 do
    FSections[i].MarkStyleUsed(True, AParts);

  vUnCount := 0;
  for i := 0 to FStyle.TextStyles.Count - 1 do
  begin
    if FStyle.TextStyles[i].CheckSaveUsed then
      FStyle.TextStyles[i].TempNo := i - vUnCount
    else
      Inc(vUnCount);
  end;

  vUnCount := 0;
  for i := 0 to FStyle.ParaStyles.Count - 1 do
  begin
    if FStyle.ParaStyles[i].CheckSaveUsed then
      FStyle.ParaStyles[i].TempNo := i - vUnCount
    else
      Inc(vUnCount);
  end;

  for i := 0 to FSections.Count - 1 do
    FSections[i].MarkStyleUsed(False);

  for i := FStyle.TextStyles.Count - 1 downto 0 do
  begin
    if not FStyle.TextStyles[i].CheckSaveUsed then
      FStyle.TextStyles.Delete(i);
  end;

  for i := FStyle.ParaStyles.Count - 1 downto 0 do
  begin
    if not FStyle.ParaStyles[i].CheckSaveUsed then
      FStyle.ParaStyles.Delete(i);
  end;
end;

procedure THCView.SaveToFile(const AFileName: string);
var
  vStream: TStream;
begin
  vStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(vStream);
  finally
    FreeAndNil(vStream);
  end;
end;

procedure THCView.SaveAsPDF(const AFileName: string);
var
  i, j, vDPI: Integer;
  vPDF: TPdfDocumentGDI;
  vPage: TPdfPage;
  vPaintInfo: TSectionPaintInfo;
begin
  vPDF := TPdfDocumentGDI.Create;
  try
    {vPDF.ScreenLogPixels := 96;
    vPDF.DefaultPaperSize := TPDFPaperSize.psA4;
    vPDF.AddPage;
    vPDF.VCLCanvas.Brush.Style := bsClear;
    vPDF.VCLCanvas.Font.Name := '����'; // ����
    vPDF.VCLCanvas.TextOut( 20, 20, '����˫���Ų���ȷ�����⡱' );
    vPDF.SaveToFile('c:\Syntest.pdf');

    Exit;}


    vPDF.Info.Author := 'HCView';
    vPDF.Info.CreationDate := Now;
    vPDF.Info.Creator := 'HCView';  // jt
    vPDF.Info.Keywords := '';  // ��Ժ��¼
    vPDF.Info.ModDate := Now;
    vPDF.Info.Subject := '';  // HIT ���Ӳ���
    vPDF.Info.Title := '';  // ������1��

    //vPDF.UseUniscribe := True;

    vDPI := Screen.PixelsPerInch;
    vPDF.ScreenLogPixels := vDPI;

    vPaintInfo := TSectionPaintInfo.Create;
    try
      vPaintInfo.Print := True;

      for i := 0 to FSections.Count - 1 do
      begin
        vPaintInfo.SectionIndex := i;
        vPaintInfo.ScaleX := vPDF.ScreenLogPixels / vDPI;
        vPaintInfo.ScaleY := vPDF.ScreenLogPixels / vDPI;

        for j := 0 to FSections[i].PageCount - 1 do
        begin
          vPage := vPDF.AddPage;

          vPage.PageLandscape := False;
          vPDF.DefaultPaperSize := GetPDFPaperSize(FSections[i].PaperSize);
          if vPDF.DefaultPaperSize = TPDFPaperSize.psUserDefined then
          begin  // Ӣ�絥λ���ܹ���������
            vPage.PageWidth := Round(FSections[i].PaperWidth / 25.4 * 72);
            vPage.PageHeight := Round(FSections[i].PaperHeight / 25.4 * 72);
          end;

          vPaintInfo.PageIndex := j;
          vPaintInfo.WindowWidth := FSections[i].PageWidthPix;
          vPaintInfo.WindowHeight := FSections[i].PageHeightPix;

          FSections[i].PaintPage(j, 0, 0, vPDF.VCLCanvas, vPaintInfo);
        end;
      end;
    finally
      vPaintInfo.Free;
    end;

    vPDF.SaveToFile(AFileName);
  finally
    vPDF.Free;
  end;
end;

procedure THCView.SaveAsText(const AFileName: string);
var
  i: Integer;
begin
  // ��������
  for i := 0 to FSections.Count - 1 do
    FSections[i].SaveToText(AFileName);
end;

procedure THCView.SaveToStream(const AStream: TStream;
  const ASaveParts: TSaveParts = [saHeader, saPage, saFooter]);
var
  vByte: Byte;
  i: Integer;
begin
  _SaveFileFormatAndVersion(AStream);  // �ļ���ʽ�Ͱ汾
  DoSaveBefor(AStream);
  _DeleteUnUsedStyle(ASaveParts);  // ɾ����ʹ�õ���ʽ(�ɷ��Ϊ�����õĴ��ˣ�����ʱItem��StyleNoȡ����)
  FStyle.SaveToStream(AStream);
  // ������
  vByte := FSections.Count;
  AStream.WriteBuffer(vByte, 1);
  // ��������
  for i := 0 to FSections.Count - 1 do
    FSections[i].SaveToStream(AStream, ASaveParts);
  DoSaveAfter(AStream);
end;

procedure THCView.SaveAsXML(const AFileName: string);
var
  vXml: IXMLDocument;
begin
  _DeleteUnUsedStyle([saHeader, saPage, saFooter]);

  vXml := TXMLDocument.Create(nil);
  vXml.Active := True;
  vXml.Version := '1.0';
  vXml.DocumentElement := vXml.CreateNode('HCView', ntElement, '');
  vXml.DocumentElement.Attributes['Version'] := HC_FileVersion;

  StyleSaveToXML(FStyle, vXml.DocumentElement);  // ��ʽ��

  SectionSaveToXML(FSections, vXml.DocumentElement);  // ������

  vXml.SaveToFile(AFileName);
end;

function THCView.ZoomIn(const Value: Integer): Integer;
begin
  Result := Round(Value * FZoom);
end;

function THCView.ZoomOut(const Value: Integer): Integer;
begin
  Result := Round(Value / FZoom);
end;

function THCView.Search(const AKeyword: string; const AForward: Boolean = False;
  const AMatchCase: Boolean = False): Boolean;
var
  vTopData: THCCustomRichData;
  vStartDrawItemNo, vEndDrawItemNo: Integer;
  vPt: TPoint;
  vStartDrawRect, vEndDrawRect: TRect;
begin
  Result := Self.ActiveSection.Search(AKeyword, AForward, AMatchCase);
  if Result then
  begin
    vPt := GetActiveDrawItemClientCoord;  // ���ع�괦DrawItem��Ե�ǰҳ��ʾ�Ĵ������꣬��ѡ��ʱ����ѡ�н���λ�õ�DrawItem��ʽ������

    vTopData := ActiveSectionTopLevelData;
    with vTopData do
    begin
      vStartDrawItemNo := GetDrawItemNoByOffset(SelectInfo.StartItemNo, SelectInfo.StartItemOffset);
      vEndDrawItemNo := GetDrawItemNoByOffset(SelectInfo.EndItemNo, SelectInfo.EndItemOffset);

      if vStartDrawItemNo = vEndDrawItemNo then  // ѡ����ͬһ��DrawItem
      begin
        vStartDrawRect.Left := vPt.X + ZoomIn(GetDrawItemOffsetWidth(vStartDrawItemNo,
          SelectInfo.StartItemOffset - DrawItems[vStartDrawItemNo].CharOffs + 1));
        vStartDrawRect.Top := vPt.Y;
        vStartDrawRect.Right := vPt.X + ZoomIn(GetDrawItemOffsetWidth(vEndDrawItemNo,
          SelectInfo.EndItemOffset - DrawItems[vEndDrawItemNo].CharOffs + 1));
        vStartDrawRect.Bottom := vPt.Y + ZoomIn(DrawItems[vEndDrawItemNo].Rect.Height);

        vEndDrawRect := vStartDrawRect;
      end
      else  // ѡ�в���ͬһ��DrawItem
      begin
        vStartDrawRect.Left := vPt.X + ZoomIn(DrawItems[vStartDrawItemNo].Rect.Left - DrawItems[vEndDrawItemNo].Rect.Left
          + GetDrawItemOffsetWidth(vStartDrawItemNo, SelectInfo.StartItemOffset - DrawItems[vStartDrawItemNo].CharOffs + 1));
        vStartDrawRect.Top := vPt.Y + ZoomIn(DrawItems[vStartDrawItemNo].Rect.Top - DrawItems[vEndDrawItemNo].Rect.Top);
        vStartDrawRect.Right := vPt.X + ZoomIn(DrawItems[vStartDrawItemNo].Rect.Left - DrawItems[vEndDrawItemNo].Rect.Left
          + DrawItems[vStartDrawItemNo].Rect.Width);
        vStartDrawRect.Bottom := vStartDrawRect.Top + ZoomIn(DrawItems[vStartDrawItemNo].Rect.Height);

        vEndDrawRect.Left := vPt.X;
        vEndDrawRect.Top := vPt.Y;
        vEndDrawRect.Right := vPt.X + ZoomIn(GetDrawItemOffsetWidth(vEndDrawItemNo,
          SelectInfo.EndItemOffset - DrawItems[vEndDrawItemNo].CharOffs + 1));
        vEndDrawRect.Bottom := vPt.Y + ZoomIn(DrawItems[vEndDrawItemNo].Rect.Height);
      end;
    end;

    if vStartDrawRect.Top < 0 then
      Self.FVScrollBar.Position := Self.FVScrollBar.Position + vStartDrawRect.Top
    else
    if vStartDrawRect.Bottom > GetDisplayHeight then
      Self.FVScrollBar.Position := Self.FVScrollBar.Position + vStartDrawRect.Bottom - GetDisplayHeight;

    if vStartDrawRect.Left < 0 then
      Self.FHScrollBar.Position := Self.FHScrollBar.Position + vStartDrawRect.Left
    else
    if vStartDrawRect.Right > GetDisplayWidth then
      Self.FHScrollBar.Position := Self.FHScrollBar.Position + vStartDrawRect.Right - GetDisplayWidth;
  end;
end;

procedure THCView.SelectAll;
var
  i: Integer;
begin
  for i := 0 to FSections.Count - 1 do
    FSections[i].SelectAll;

  FStyle.UpdateInfoRePaint;
  CheckUpdateInfo;
end;

procedure THCView.SetActiveSectionIndex(const Value: Integer);
begin
  if FActiveSectionIndex <> Value then
  begin
    if FActiveSectionIndex >= 0 then
      FSections[FActiveSectionIndex].DisActive;
    FActiveSectionIndex := Value;
  end;
end;

procedure THCView.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  FVScrollBar.Left := Width - FVScrollBar.Width;
  FVScrollBar.Height := Height - FHScrollBar.Height;
  //
  FHScrollBar.Top := Height - FHScrollBar.Height;
  FHScrollBar.Width := Width - FVScrollBar.Width;
end;

procedure THCView.SetIsChanged(const Value: Boolean);
begin
  if FIsChanged <> Value then
  begin
    FIsChanged := Value;
    if Assigned(FOnChangedSwitch) then
      FOnChangedSwitch(Self);
  end;
end;

procedure THCView.SetPageScrollModel(const Value: TPageScrollModel);
begin
  if FViewModel = vmWeb then Exit;
  if FPageScrollModel <> Value then
    FPageScrollModel := Value;
end;

procedure THCView.SetPrintBySectionInfo(const ASectionIndex: Integer);
var
  vDevice: Array[0..(cchDeviceName - 1)] of Char;
  vDriver: Array[0..(MAX_PATH - 1)] of Char;
  vPort: Array[0..32] of Char;
  vHDMode: THandle;
  vPDMode: PDevMode;
begin
  Printer.GetPrinter(vDevice, vDriver, vPort, vHDMode);
  if vHDMode <> 0 then
  begin
    // ��ȡָ��DeviceMode��ָ��
    vPDMode := GlobalLock(vHDMode);
    if vPDMode <> nil then
    begin
      vPDMode^.dmPaperSize := FSections[ASectionIndex].PaperSize;
      if vPDMode^.dmPaperSize = DMPAPER_USER then
      begin
        vPDMode^.dmPaperSize := DMPAPER_USER;  // �Զ���ֽ��
        vPDMode^.dmPaperLength := Round(FSections[ASectionIndex].PaperHeight * 10); //ֽ������ñ������ֽ�ŵĳ�������
        vPDMode^.dmPaperWidth := Round(FSections[ASectionIndex].PaperWidth * 10);   //ֽ��
        vPDMode^.dmFields := vPDMode^.dmFields or DM_PAPERSIZE or DM_PAPERLENGTH or DM_PAPERWIDTH;
      end;

      if FSections[ASectionIndex].PageOrientation = TPageOrientation.cpoPortrait then
        vPDMode^.dmOrientation := DMORIENT_PORTRAIT
      else
        vPDMode^.dmOrientation := DMORIENT_LANDSCAPE;
    end;

    ResetDC(Printer.Handle, vPDMode^);
    GlobalUnlock(vHDMode);
    //Printer.SetPrinter(vDevice, vDriver, vPort, vHDMode);
  end;
end;

procedure THCView.SetReadOnly(const Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to FSections.Count - 1 do
    FSections[i].ReadOnly := Value;
end;

procedure THCView.SetShowAnnotation(const Value: Boolean);
begin
  if FShowAnnotation <> Value then
  begin
    if not Assigned(FAnnotates) then
      FAnnotates := TAnnotates.Create;

    FShowAnnotation := Value;
    FStyle.UpdateInfoRePaint;
    FStyle.UpdateInfoReCaret(False);
    DoMapChanged;
  end;
end;

procedure THCView.SetShowLineActiveMark(const Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to FSections.Count - 1 do
    FSections[i].PageData.ShowLineActiveMark := Value;

  UpdateView;
end;

procedure THCView.SetShowLineNo(const Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to FSections.Count - 1 do
    FSections[i].PageData.ShowLineNo := Value;

  UpdateView;
end;

procedure THCView.SetShowUnderLine(const Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to FSections.Count - 1 do
    FSections[i].PageData.ShowUnderLine := Value;

  UpdateView;
end;

procedure THCView.SetSymmetryMargin(const Value: Boolean);
begin
  if ActiveSection.SymmetryMargin <> Value then
  begin
    ActiveSection.SymmetryMargin := Value;
    FStyle.UpdateInfoRePaint;
    FStyle.UpdateInfoReCaret(False);
    DoMapChanged;
  end;
end;

procedure THCView.SetViewModel(const Value: TViewModel);
begin
  if FPageScrollModel = psmHorizontal then Exit; // ˮƽ���������л�ģʽ
  if FViewModel <> Value then
    FViewModel := Value;
end;

procedure THCView.SetZoom(const Value: Single);
begin
  if FZoom <> Value then
  begin
    Self.SetFocus;
    FZoom := Value;
    FStyle.UpdateInfoRePaint;
    FStyle.UpdateInfoReCaret(False);
    DoMapChanged;
  end;
end;

procedure THCView.ApplyParaAlignHorz(const AAlign: TParaAlignHorz);
begin
  ActiveSection.ApplyParaAlignHorz(AAlign);
end;

procedure THCView.ApplyParaAlignVert(const AAlign: TParaAlignVert);
begin
  ActiveSection.ApplyParaAlignVert(AAlign);
end;

procedure THCView.ApplyParaBackColor(const AColor: TColor);
begin
  ActiveSection.ApplyParaBackColor(AColor);
end;

procedure THCView.ApplyParaLineSpace(const ASpaceMode: TParaLineSpaceMode);
begin
  ActiveSection.ApplyParaLineSpace(ASpaceMode);
end;

procedure THCView.Undo;
begin
  BeginUpdate;
  try
    FUndoList.Undo;
  finally
    EndUpdate;
  end;
end;

procedure THCView.UpdateView(const ARect: TRect);

  {$REGION ' CalcDisplaySectionAndPage ��ȡ����ʾ����ʼ�ͽ����ڡ�ҳ��� '}
  procedure CalcDisplaySectionAndPage;
  var
    i, j, vPos, vY: Integer;
    vFirstPage, vLastPage: Integer;
  begin
    if FDisplayFirstSection >= 0 then
    begin
      FSections[FDisplayFirstSection].DisplayFirstPageIndex := -1;
      FSections[FDisplayFirstSection].DisplayLastPageIndex := -1;
      FDisplayFirstSection := -1;
    end;
    if FDisplayLastSection >= 0 then
    begin
      FSections[FDisplayLastSection].DisplayFirstPageIndex := -1;
      FSections[FDisplayLastSection].DisplayLastPageIndex := -1;
      FDisplayLastSection := -1;
    end;

    vFirstPage := -1;
    vLastPage := -1;
    vPos := 0;
    if FPageScrollModel = psmVertical then
    begin
      for i := 0 to FSections.Count - 1 do
      begin
        for j := 0 to FSections[i].PageCount - 1 do
        begin
          vPos := vPos + ZoomIn(PagePadding + FSections[i].PageHeightPix);
          if vPos > FVScrollBar.Position then
          begin
            vFirstPage := j;
            Break;
          end;
        end;
        if vFirstPage >= 0 then
        begin
          FDisplayFirstSection := i;
          FSections[FDisplayFirstSection].DisplayFirstPageIndex := j;
          Break;
        end;
      end;
      if FDisplayFirstSection >= 0 then
      begin
        vY := FVScrollBar.Position + GetDisplayHeight;
        for i := FDisplayFirstSection to FSections.Count - 1 do
        begin
          for j := vFirstPage to FSections[i].PageCount - 1 do
          begin
            if vPos < vY then
              vPos := vPos + ZoomIn(PagePadding + FSections[i].PageHeightPix)
            else
            begin
              vLastPage := j;
              Break;
            end;
          end;
          if vLastPage >= 0 then
          begin
            FDisplayLastSection := i;
            FSections[FDisplayLastSection].DisplayLastPageIndex := j;
            Break;
          end;
        end;
        if FDisplayLastSection < 0 then  // û���ҵ�����ҳ����ֵΪ���һ�����һҳ
        begin
          FDisplayLastSection := FSections.Count - 1;
          FSections[FDisplayLastSection].DisplayLastPageIndex := FSections[FDisplayLastSection].PageCount - 1;
        end;
      end;
    end;
    if (FDisplayFirstSection < 0) or (FDisplayLastSection < 0) then
      raise Exception.Create('�쳣����ȡ��ǰ��ʾ��ʼҳ�ͽ���ҳʧ�ܣ�')
    else
    begin
      if FDisplayFirstSection <> FDisplayLastSection then  // ��ʼ�ͽ�������ͬһ��
      begin
        FSections[FDisplayFirstSection].DisplayLastPageIndex := FSections[FDisplayFirstSection].PageCount - 1;
        FSections[FDisplayLastSection].DisplayFirstPageIndex := 0;
      end;
    end;
  end;
  {$ENDREGION}

var
  i, vOffsetY, vDisplayWidth, vDisplayHeight: Integer;
  vPaintInfo: TSectionPaintInfo;
  vScaleInfo: TScaleInfo;
begin
  if (FUpdateCount = 0) and HandleAllocated then
  begin
    FDataBmp.Canvas.Lock;
    try
      if FShowAnnotation then
        FAnnotates.Clear;

      // ����һ���µļ������򣬸������ǵ�ǰ���������һ���ض����εĽ���
      IntersectClipRect(FDataBmp.Canvas.Handle, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);

      // �ؼ�����
      FDataBmp.Canvas.Brush.Color := Self.Color;// $00E7BE9F;
      FDataBmp.Canvas.FillRect(Rect(0, 0, FDataBmp.Width, FDataBmp.Height));
      // ����ڴ˼��㵱ǰҳ��������ʼ���������Բ�����ARect����
      vDisplayWidth := GetDisplayWidth;
      vDisplayHeight := GetDisplayHeight;
      CalcDisplaySectionAndPage;  // ���㵱ǰ��Χ�ڿ���ʾ����ʼ�ڡ�ҳ�ͽ����ڡ�ҳ

      vPaintInfo := TSectionPaintInfo.Create;
      try
        vPaintInfo.ScaleX := FZoom;
        vPaintInfo.ScaleY := FZoom;
        vPaintInfo.Zoom := FZoom;
        vPaintInfo.WindowWidth := vDisplayWidth;
        vPaintInfo.WindowHeight := vDisplayHeight;

        vScaleInfo := vPaintInfo.ScaleCanvas(FDataBmp.Canvas);
        try
          if Assigned(FOnUpdateViewBefor) then  // �����ػ濪ʼ
            FOnUpdateViewBefor(FDataBmp.Canvas);

          for i := FDisplayFirstSection to FDisplayLastSection do
          begin
            vPaintInfo.SectionIndex := i;

            vOffsetY := ZoomOut(FVScrollBar.Position) - GetSectionTopFilm(i);  // תΪԭʼY��ƫ��
            FSections[i].PaintDisplayPage(GetSectionDrawLeft(i) - ZoomOut(FHScrollBar.Position),  // ԭʼX��ƫ��
              vOffsetY, FDataBmp.Canvas, vPaintInfo);
          end;

          for i := 0 to vPaintInfo.TopItems.Count - 1 do  // ���ƶ���Item
            vPaintInfo.TopItems[i].PaintTop(FDataBmp.Canvas);

          if Assigned(FOnUpdateViewAfter) then  // �����ػ����
            FOnUpdateViewAfter(FDataBmp.Canvas);
        finally
          vPaintInfo.RestoreCanvasScale(FDataBmp.Canvas, vScaleInfo);
        end;
      finally
        vPaintInfo.Free;
      end;
    finally
      FDataBmp.Canvas.Unlock;
    end;

    BitBlt(Canvas.Handle, ARect.Left, ARect.Top, ARect.Width, ARect.Height,
      FDataBmp.Canvas.Handle, ARect.Left, ARect.Top, SRCCOPY);

    InvalidateRect(Self.Handle, ARect, False);  // ֻ���±䶯���򣬷�ֹ��˸�����BitBlt�����������
  end;
end;

procedure THCView.UpdateView;
begin
  UpdateView(GetDisplayRect);
end;

procedure THCView.UpdateImmPosition;
var
  vhIMC: HIMC;
  vCF: TCompositionForm;
  vLogFont: TLogFont;
  //vIMEWnd: THandle;
  //vS: string;
  //vCandiID: Integer;
begin
  vhIMC := ImmGetContext(Handle);
  try
    // �������뷨��ǰ��괦������Ϣ
    ImmGetCompositionFont(vhIMC, @vLogFont);
    vLogFont.lfHeight := 22;
    ImmSetCompositionFont(vhIMC, @vLogFont);
    // �������뷨��ǰ���λ����Ϣ
    vCF.ptCurrentPos := Point(FCaret.X, FCaret.Y + 5);  // ���뷨��������λ��
    vCF.dwStyle := CFS_RECT;
    vCF.rcArea  := ClientRect;
    ImmSetCompositionWindow(vhIMC, @vCF);
  finally
    ImmReleaseContext(Handle, vhIMC);
  end;
  {if ActiveSection.SelectInfo.StartItemOffset > 1 then  // �������뷨���ݵ�ǰλ�ô������±�ѡ
  begin
    if GetCurItem.StyleNo < 0 then Exit;
    
    vS := GetCurItem.GetTextPart(ActiveSection.SelectInfo.StartItemOffset - 1, 2);  // ���ع��ǰ2���ַ�
    if vS <> '' then
    begin
      if vS = '����' then
        vCandiID := 4743
      else
      if vS = '����' then
        vCandiID := 10019
      else
      if vS = 'ʧȥ' then
        vCandiID := 10657
      else
        vCandiID := -1;
      if vCandiID > 0 then
      begin
        vIMEWnd := ImmGetDefaultIMEWnd(Handle);
        //SendMessage(vIMEWnd, WM_IME_CONTROL, IMC_SETCOMPOSITIONWINDOW, Integer(@vPt));
        SendMessage(vIMEWnd, WM_IME_NOTIFY, IMN_UPDATECURSTRING, vCandiID);
      end;
    end;
  end;}
end;

procedure THCView.WMERASEBKGND(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure THCView.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTTAB or DLGC_WANTARROWS;
end;

procedure THCView.WMImeComposition(var Message: TMessage);
var
  vhIMC: HIMC;
  vSize: Integer;
  vBuffer: TBytes;
  vS: string;
begin
  if (Message.LParam and GCS_RESULTSTR) <> 0 then  // ֪ͨ��������������ַ���
  begin
    // ���������ı�һ���Բ��룬����᲻ͣ�Ĵ���KeyPress�¼�
    vhIMC := ImmGetContext(Handle);
    if vhIMC <> 0 then
    begin
      try
        vSize := ImmGetCompositionString(vhIMC, GCS_RESULTSTR, nil, 0);  // ��ȡIME����ַ����Ĵ�С
        if vSize > 0 then  	// ���IME����ַ�����Ϊ�գ���û�д���
        begin
          // ȡ���ַ���
          SetLength(vBuffer, vSize);
          ImmGetCompositionString(vhIMC, GCS_RESULTSTR, vBuffer, vSize);
          SetLength(vBuffer, vSize);  // vSize - 2
          vS := WideStringOf(vBuffer);
          if vS <> '' then
          begin
            if DoProcessIMECandi(vS) then
              InsertText(vS);
          end;
        end;
      finally
        ImmReleaseContext(Handle, vhIMC);
      end;
      Message.Result := 0;
    end;
  end
  else
    inherited;
end;

procedure THCView.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  if Message.FocusedWnd <> Self.Handle then
    FCaret.Hide;
end;

procedure THCView.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  inherited;
  //ActiveSection.DblClick(Message.XPos, Message.YPos);  // ˫��Ҳ�ŵ�MouseDown����
end;

procedure THCView.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  ReBuildCaret;
end;

procedure THCView.WndProc(var Message: TMessage);
{var
  DC: HDC;
  PS: TPaintStruct;}
begin
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      begin
        if not (csDesigning in ComponentState) and not Focused then
        begin
          Windows.SetFocus(Handle);
          if not Focused then
            Exit;
        end;
      end;
    {WM_PAINT:
      begin
        DC := BeginPaint(Handle, PS);
        try
          BitBlt(DC,
            PS.rcPaint.Left, PS.rcPaint.Top,
            PS.rcPaint.Right - PS.rcPaint.Left - FVScrollBar.Width,
            PS.rcPaint.Bottom - PS.rcPaint.Top - FHScrollBar.Height,
            FSectionData.DataBmp.Canvas.Handle,
            PS.rcPaint.Left, PS.rcPaint.Top,
            SRCCOPY);
        finally
          EndPaint(Handle, PS);
        end;
      end; }
  end;
  inherited WndProc(Message);
end;

{ TAnnotates }

procedure TAnnotates.AddAnnotation(const ADrawItemRect: TRect; const AText: string);
var
  vAnnotation: TAnnotate;
begin
  vAnnotation := TAnnotate.Create;
  vAnnotation.DrawItemRect := ADrawItemRect;
  vAnnotation.Text := AText;
  Self.Add(vAnnotation);
end;

constructor TAnnotates.Create;
begin
  inherited Create(True);
  FIndex := -1;
end;

procedure TAnnotates.MouseDown(const X, Y: Integer);
var
  i: Integer;
  vPt: TPoint;
begin
  FIndex := -1;
  vPt := Point(X, Y);
  for i := 0 to Self.Count - 1 do
  begin
    if PtInRect(Self[i].PaintRect, vPt) then
    begin
      FIndex := i;
      Break;
    end;
  end;
end;

procedure TAnnotates.PaintTo(const ACanvas: TCanvas; const ARect: TRect;
  const APaintInfo: TSectionPaintInfo);
var
  i, vPos: Integer;
  vAnnotation: TAnnotate;
  vTextRect, vPaintRect: TRect;
begin
  if APaintInfo.Print then Exit;

  ACanvas.Brush.Color := $00F4F4F4;
  ACanvas.FillRect(Rect(ARect.Right, ARect.Top, ARect.Right + AnnotationWidth, ARect.Bottom));
  if Self.Count > 0 then
  begin
    vPos := 0;

    //ACanvas.Refresh;
    ACanvas.Font.Size := 8;
    //ACanvas.Pen.Mode := TPenMode.pmXor;
    for i := 0 to Self.Count - 1 do
    begin
      if i <> FIndex then
      begin
        ACanvas.Pen.Style := TPenStyle.psDot;
        ACanvas.Pen.Color := clRed;
      end
      else
      begin
        ACanvas.Pen.Style := TPenStyle.psSolid;
        ACanvas.Pen.Color := clMaroon;
      end;

      vAnnotation := Self.Items[i];
      if vPos < vAnnotation.DrawItemRect.Top then
        vPos := vAnnotation.DrawItemRect.Top
      else
      if vAnnotation.DrawItemRect.Top <= vPos then
        vPos := vPos + (vAnnotation.DrawItemRect.Bottom - vAnnotation.DrawItemRect.Top);

      // ������ע�ı���ʾ����
      vTextRect := Rect(ARect.Right + 30, vPos, ARect.Right + AnnotationWidth - 10,
        vAnnotation.DrawItemRect.Bottom);
      DrawTextEx(ACanvas.Handle, PChar(vAnnotation.Text), -1, vTextRect,
        DT_TOP or DT_LEFT or DT_WORDBREAK or DT_EDITCONTROL or DT_CALCRECT, nil);  // ��������

      // �����ע����
      ACanvas.Brush.Style := bsSolid;
      ACanvas.Brush.Color := clYellow;
      vPaintRect := vTextRect;
      InflateRect(vPaintRect, 5, 5);
      ACanvas.RoundRect(vPaintRect, 5, 5);

      vAnnotation.PaintRect := vPaintRect;  // ��¼ PaintRect

      // ����ָ����
      ACanvas.Brush.Style := bsClear;
      ACanvas.MoveTo(vAnnotation.DrawItemRect.Right, vAnnotation.DrawItemRect.Bottom + 2);
      ACanvas.LineTo(ARect.Right, vAnnotation.DrawItemRect.Bottom + 2);
      ACanvas.LineTo(ARect.Right + 30, vPos);

      // ������ע�ı�
      DrawTextEx(ACanvas.Handle, PChar(vAnnotation.Text), -1, vTextRect, DT_TOP or DT_LEFT or DT_WORDBREAK, nil);

      vPos := vTextRect.Bottom + 5;
    end;
  end;
end;

end.