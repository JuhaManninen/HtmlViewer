unit PrintStatusForm;

interface

uses
{$ifdef LCL}
  LclIntf, LclType,
{$else}
  Windows,
{$endif}
{$ifdef Windows}
  MetaFilePrinter,
{$endif}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  HTMLView;

type
  TPrnStatusForm = class(TForm)
    StatusLabel: TLabel;
    CancelButton: TBitBtn;
    procedure CancelButtonClick(Sender: TObject);
  private
    Viewer: ThtmlViewer;
    Canceled: boolean;
{$ifdef Windows}
    MFPrinter: TMetaFilePrinter;
{$endif}
    FromPage, ToPage: integer;
    procedure PageEvent(Sender: TObject; PageNum: integer; var Stop: boolean);
  public
{$ifdef Windows}
  procedure DoPreview(AViewer: ThtmlViewer; AMFPrinter: TMetaFilePrinter;
              var Abort: boolean);
  procedure DoPrint(AViewer: ThtmlViewer; FromPg, ToPg: integer;
              var Abort: boolean);
{$endif}
  end;

var
  PrnStatusForm: TPrnStatusForm;

implementation

{$R *.dfm}

{$ifdef Windows}
procedure TPrnStatusForm.DoPreview(AViewer: ThtmlViewer; AMFPrinter: TMetaFilePrinter;
              var Abort: boolean);
begin
  Viewer := AViewer;
  MFPrinter := AMFPrinter;
{$ifdef FPC}
  Viewer.OnPageEvent := @PageEvent;
{$else}
  Viewer.OnPageEvent := PageEvent;
{$endif}
  try
    Show;
    Viewer.PrintPreview(MFPrinter);
    Hide;
    Abort := Canceled;
  finally
    Viewer.OnPageEvent := Nil;
  end;
end;

procedure TPrnStatusForm.DoPrint(AViewer: ThtmlViewer; FromPg, ToPg: integer;
              var Abort: boolean);
begin
Viewer := AViewer;
FromPage := FromPg;
ToPage := ToPg;
{$ifdef FPC}
  Viewer.OnPageEvent := @PageEvent;
{$else}
  Viewer.OnPageEvent := PageEvent;
{$endif}
try
  Show;
  Viewer.Print(FromPage, ToPage);          
  Hide;
  Abort := Canceled;
finally
  Viewer.OnPageEvent := Nil;      
  end;
end;
{$endif}

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