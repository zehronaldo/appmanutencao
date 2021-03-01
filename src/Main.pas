unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.AppEvnts;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses
  DatasetLoop, ClienteServidor, GerenciadorDeExcecoes;

{$R *.dfm}

procedure TfMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
var
  GerenciadorDeExcecoes: TGerenciadorDeExcecoes;
begin
  GerenciadorDeExcecoes := TGerenciadorDeExcecoes.Create;
  try
    GerenciadorDeExcecoes.PegarExcecao(Sender, E);

  finally
    GerenciadorDeExcecoes.Free;
  end;
end;


procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  fClienteServidor.Show;
end;

end.
