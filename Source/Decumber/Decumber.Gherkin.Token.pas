unit Decumber.Gherkin.Token;

interface

type
  TGherkinTokenType = (
    gttEof,
    gttFeatureLine,
    gttScenarioLine,
    gttStepLine,
    gttUnknown);

  TGherkinToken = record
  private
    FPos: Integer;
    FValue: string;
    FType: TGherkinTokenType;
  public
    constructor Create(Type_: TGherkinTokenType; const Value: string; Pos: Integer);

    property Type_: TGherkinTokenType read FType;
    property Value: string read FValue;
    property Pos: Integer read FPos;
  end;

implementation

{ TGherkinToken }

constructor TGherkinToken.Create(Type_: TGherkinTokenType; const Value: string; Pos: Integer);
begin
  FType := Type_;
  FValue := Value;
  FPos := Pos;
end;

end.
