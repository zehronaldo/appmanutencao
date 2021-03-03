unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB;

type
  TServidor = class
  private
    FPath: string;
  public
    constructor Create;
    //Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: string;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
    procedure InicializarProgressBar;
    procedure AtualizarProgressBar(Indice: Integer);
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.AtualizarProgressBar(Indice: Integer);
begin
  ProgressBar.Position:= Indice;
end;

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  InicializarProgressBar;

  cds := InitDataset;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
    cds.Post;
    AtualizarProgressBar(i);

    {$REGION Simulação de erro, não alterar}
    if i = (QTD_ARQUIVOS_ENVIAR/2) then
      FServidor.SalvarArquivos(NULL);
    {$ENDREGION}
  end;

  FServidor.SalvarArquivos(cds.Data);
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
begin
  InicializarProgressBar;

end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  InicializarProgressBar;
  cds := InitDataset;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
    cds.Post;
    AtualizarProgressBar(i);
  end;

  FServidor.SalvarArquivos(cds.Data);
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  {$WARN SYMBOL_PLATFORM OFF}
  FPath := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  {$WARN SYMBOL_PLATFORM ON}
  FServidor := TServidor.Create;
end;

procedure TfClienteServidor.InicializarProgressBar;
begin
  ProgressBar.Min:= 0;
  ProgressBar.Max:= QTD_ARQUIVOS_ENVIAR;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
  ListaArquivosSalvos: TStringList;
  i: integer;
begin
  Result := False;
  try
    cds := TClientDataset.Create(nil);
    cds.Data := AData;
    ListaArquivosSalvos:= TStringList.Create;

    {$REGION Simulação de erro, não alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;

    while not cds.Eof do
    begin
      FileName := FPath + cds.RecNo.ToString + '.pdf';
      ListaArquivosSalvos.Add(FileName);

      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      cds.Next;
    end;

    Result := True;
  except
    if Assigned(ListaArquivosSalvos) then
    begin
      for I := 0 to ListaArquivosSalvos.Count - 1 do
      begin
        TFile.Delete(ListaArquivosSalvos[i]);
      end;
    end;

    raise;
  end;
end;

end.
