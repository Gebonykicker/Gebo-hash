unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,LCLIntf,
  Menus, ExtCtrls, md5;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  cancel:Boolean=False;
  working:Boolean=False;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  FS: TFileStream;
  Context: TMD5Context;
  Buffer: array[1..65536] of Byte; // حجم الجزء المقروء 64KB
  Count: Integer;
  Digest: TMD5Digest;
begin
  if OpenDialog1.Execute then
    begin
      if not FileExists(OpenDialog1.FileName) then Exit;
    end
  else
  begin
    ShowMessage('لم نستلم ملف');
    Exit;
  end;

  Button1.Enabled:=False;
  Edit1.Enabled:=False;
  Edit1.Text:='جاري حساب الملف';
  // تهيئة عملية الحساب
  MD5Init(Context);

  FS := TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareDenyWrite);
  try
    cancel:=False;
    working:=True;
    // قراءة الملف على أجزاء حتى النهاية
     repeat
      Count := FS.Read(Buffer, SizeOf(Buffer));
      if Count > 0 then
        MD5Update(Context, Buffer, Count);
      ProgressBar1.Position:=round((fs.Position/fs.Size)*100);
      Label3.Caption:='%'+IntToStr(ProgressBar1.Position);
      Application.ProcessMessages;
     until (Count = 0) or (cancel=True);
    FS.Free;
    if count=0 then
      begin
        Button1.Enabled:=True;
        MD5Final(Context, Digest); // إنهاء الحساب واستخراج النتيجة
        Edit1.Text := MD5Print(Digest);// تحويل النتيجة من Byte Array إلى نص Hex
        Edit1.Enabled:=True;
        if Trim(Edit1.Text)  = Trim(Edit2.Text) then ShowMessage('الهاش نفس القيمة')
        else ShowMessage('القيمة ليست متساوية');
        working:=False;
      end;
  except on e:exception do
  begin
     working:=False;
     ShowMessage(e.Message);
  end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if working=True then
    begin
      cancel:=True;
      Edit1.Text:='تم إلغاء العملية بواسطة المستخدم';
      Button1.Enabled:=True;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  cancel:=True;
  Close;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  OpenURL('https://www.facebook.com/gebony.kicker.2025');
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  OpenURL('https://www.linkedin.com/in/ahmed-jibril-6157b645/');
end;

end.

