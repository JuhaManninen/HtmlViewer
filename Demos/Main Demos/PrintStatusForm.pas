unit PrintStatusForm;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$ifdef LCL}
  LclIntf, LclType,
{$else}
  Windows,
  MetaFilePrinter,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  HtmlView;

type
  TPrnStatusForm = class(TForm)
    StatusLabel: TLabel;
    CancelButton: TBitBtn;
    procedure CancelButtonClick(Sender: TObject);
  private
    Viewer: ThtmlViewer;
    Canceled: boolean;
{$ifndef LCL}
    MFPrinter: TMetaFilePrinter;
{$endif}
    FromPage, ToPage: integer;
    procedure PageEvent(Sender: TObject; PageNum: integer; var Stop: boolean);
  public
{$ifndef LCL}
  procedure DoPreview(AViewer: ThtmlViewer; AMFPrinter: TMetaFilePrinter;
              var Abort: boolean);
{$endif}
  procedure DoPrint(AViewer: ThtmlViewer; FromPg, ToPg: integer;
              var Abort: boolean);
  end;

var
  PrnStatusForm: TPrnStatusForm;

implementation

{$R *.dfm}

{$ifndef LCL}
procedure TPrnStatusForm.DoPreview(AViewer: ThtmlViewer; AMFPrinter: TMetaFilePrinter;
              var Abort: boolean);
begin
  Viewer := AViewer;
  MFPrinter := AMFPrinter;
  Viewer.OnPageEvent := PageEvent;
  try
    Show;
    Viewer.PrintPreview(MFPrinter);
    Hide;
    Abort := Canceled;
  finally
    Viewer.OnPageEvent := Nil;
  end;
end;
{$endif}

procedure TPrnStatusForm.DoPrint(AViewer: ThtmlViewer; FromPg, ToPg: integer;
              var Abort: boolean);
begin
  Viewer := AViewer;
  FromPage := FromPg;
  ToPage := ToPg;
  Viewer.OnPageEvent := PageEvent;
try
  Show;
{$ifndef LCL}
  Viewer.Print(FromPage, ToPage);
{$endif}
  Hide;
  Abort := Canceled;
finally
  Viewer.OnPageEvent := Nil;      
  end;
end;

procedure TPrnStatusForm.PageEvent(Sender: TObject; PageNum: integer; var Stop: boolean);
begin   
if Canceled then
  Stop := True
else
  if PageNum = 0 then
    StatusLabel.Caption := 'Formating'
  else
    StatusLabel.Caption := 'Page Number '+ IntToStr(PageNum);
Update;
end;

procedure TPrnStatusForm.CancelButtonClick(Sender: TObject);
begin
Canceled := True;
end;

end.
