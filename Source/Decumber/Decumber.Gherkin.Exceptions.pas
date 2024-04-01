unit Decumber.Gherkin.Exceptions;

interface

uses
  System.SysUtils;

type
  EParserException = class(Exception)
  private
    FPos: Integer;
  public
    constructor CreateFmt(const Msg: string; const Args: array of const; Pos: Integer);

    property Pos: Integer read FPos;
  end;
implementation

{ EParserException }

constructor EParserException.CreateFmt(const Msg: string; const Args: array of const; Pos: Integer);
begin
  inherited CreateFmt(Msg, Args);
  FPos := Pos;
end;

end.
