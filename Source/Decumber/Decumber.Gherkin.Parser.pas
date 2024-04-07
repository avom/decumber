unit Decumber.Gherkin.Parser;

interface

uses
  Decumber.Gherkin.AstNode,
  Decumber.Gherkin.Lexer,
  Decumber.Gherkin.Token;

type
  TGherkinParser = class
  private
    FLexer: IGherkinLexer;
    FCurrentToken: TGherkinToken;
    procedure Eat(TokenType: TGherkinTokenType);
  public
    constructor Create(const Lexer: IGherkinLexer);

    function Parse: TAstNode;
  end;

implementation

uses
  System.SysUtils,
  Decumber.Gherkin.Exceptions;

{ TGherkinParser }

constructor TGherkinParser.Create(const Lexer: IGherkinLexer);
begin
  if Lexer = nil then
    raise EArgumentNilException.Create('Lexer');
  FLexer := Lexer;
end;

procedure TGherkinParser.Eat(TokenType: TGherkinTokenType);
begin
  if FCurrentToken.Type_ <> TokenType then
    raise EParserException.CreateFmt('Unexpected "%s"', [FCurrentToken.Value], FCurrentToken.Pos);
  FCurrentToken := FLexer.Next;
end;

function TGherkinParser.Parse: TAstNode;
begin
  FCurrentToken := FLexer.Next;
  Result := TAstNode.Create(FCurrentToken);
  try
    Eat(TGherkinTokenType.gttFeatureLine);

    const Scenario = Result.AddChild(FCurrentToken);
    Eat(TGherkinTokenType.gttScenarioLine);

    repeat
      Scenario.AddChild(FCurrentToken);
      Eat(TGherkinTokenType.gttStepLine);
    until FCurrentToken.Type_ <> TGherkinTokenType.gttStepLine;
  except
    Result.Free;
    raise;
  end;
  Eat(TGherkinTokenType.gttEof);
end;

end.
