unit Decumber.Gherkin.Lexer;

interface

uses
  System.Generics.Collections,
  Decumber.Gherkin.Token;

type
  IGherkinLexer = interface
    function Next: TGherkinToken;
  end;

  TGherkinLexer = class(TInterfacedObject, IGherkinLexer)
  private
    FSource: string;
    FPos: Integer;
    FKeywordTokens: TDictionary<string, TGherkinTokenType>;
    procedure Advance;
    function CurrentChar: Char;
    function IsEof: Boolean;
    function GetNextLine: string;
    procedure SkipWhitespaces;
  public
    constructor Create(const Source: string);
    destructor Destroy; override;

    function Next: TGherkinToken;
  end;

implementation

uses
  System.Character,
  System.StrUtils,
  System.SysUtils;

{ TGherkinLexer }

procedure TGherkinLexer.Advance;
begin
  Inc(FPos);
end;

constructor TGherkinLexer.Create(const Source: string);
begin
  FSource := Source;
  FPos := Low(Source);

  FKeywordTokens := TDictionary<string, TGherkinTokenType>.Create;
  FKeywordTokens.Add('Feature:', TGherkinTokenType.gttFeatureLine);
  FKeywordTokens.Add('Scenario:', TGherkinTokenType.gttScenarioLine);
  FKeywordTokens.Add('Given', TGherkinTokenType.gttGivenLine);
  FKeywordTokens.Add('When', TGherkinTokenType.gttWhenLine);
  FKeywordTokens.Add('Then', TGherkinTokenType.gttThenLine);
end;

function TGherkinLexer.CurrentChar: Char;
begin
  Result := #0;
  if FPos <= Length(FSource) then
    Result := FSource[FPos];
end;

destructor TGherkinLexer.Destroy;
begin
  FKeywordTokens.Free;
  inherited;
end;

function TGherkinLexer.GetNextLine: string;
begin
  const StartPos = FPos;
  while not IsEof and (CurrentChar <> #10) and (CurrentChar <> #13) do
    Advance;
  Result := Copy(FSource, StartPos, FPos - StartPos);
end;

function TGherkinLexer.IsEof: Boolean;
begin
  Result := FPos > Length(FSource);
end;

function TGherkinLexer.Next: TGherkinToken;
begin
  SkipWhitespaces;

  if IsEof then
    Exit(TGherkinToken.Create(TGherkinTokenType.gttEof, '', FPos));

  const StartPos = FPos;
  const Line = GetNextLine;
  const i = Pos(' ', Line + ' ');
  const FirstWord = LeftStr(Line, i - 1);

  if FKeywordTokens.ContainsKey(FirstWord) then
    Result := TGherkinToken.Create(FKeywordTokens[FirstWord], Line.TrimRight, StartPos)
  else
    Result := TGherkinToken.Create(TGherkinTokenType.gttUnknown, Line.TrimRight, StartPos);
end;

procedure TGherkinLexer.SkipWhitespaces;
begin
  while not IsEof and CurrentChar.IsInArray([#9, #10, #13, ' ']) do
    Advance;
end;

end.
