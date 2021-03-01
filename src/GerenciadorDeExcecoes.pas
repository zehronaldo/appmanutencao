unit GerenciadorDeExcecoes;

interface

uses
  System.SysUtils, Vcl.Forms;

type
  TGerenciadorDeExcecoes = class
  public
    procedure PegarExcecao(Sender: TObject; E: Exception);
  end;

implementation

uses
  Winapi.Windows, Win.Registry, System.UITypes,
  Vcl.Dialogs, Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.ClipBrd,
  Vcl.ComCtrls;

{ TGerenciadorDeExcecoes }

procedure TGerenciadorDeExcecoes.PegarExcecao(Sender: TObject; E: Exception);
var
  CaminhoArquivoLog: string;
  ArquivoLog: TextFile;
  StringBuilder: TStringBuilder;
  DataHora: string;
begin
  CaminhoArquivoLog := GetCurrentDir + '\LogExcecoes.txt';
  AssignFile(ArquivoLog, CaminhoArquivoLog);

  if FileExists(CaminhoArquivoLog) then
    Append(ArquivoLog)
  else
    ReWrite(ArquivoLog);

  DataHora := FormatDateTime('dd-mm-yyyy_hh-nn-ss', Now);
  WriteLn(ArquivoLog, 'Data/Hora.......: ' + DateTimeToStr(Now));
  WriteLn(ArquivoLog, 'Mensagem........: ' + E.Message);
  WriteLn(ArquivoLog, 'Classe Exceção..: ' + E.ClassName);
  WriteLn(ArquivoLog, StringOfChar('-', 70));

  CloseFile(ArquivoLog);

  StringBuilder := TStringBuilder.Create;
  try
    StringBuilder.AppendLine('Ocorreu um erro na aplicação.')
      .AppendLine('O problema será analisado pelos desenvolvedores.')
      .AppendLine(EmptyStr)
      .AppendLine('Descrição técnica:')
      .AppendLine(E.Message);

    MessageDlg(StringBuilder.ToString, mtWarning, [mbOK], 0);
  finally
    StringBuilder.Free;
  end;
end;


end.
