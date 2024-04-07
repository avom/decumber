unit Decumber.TestRunner.Scenario;

interface

uses
  System.Generics.Collections,
  Decumber.Gherkin.AstNode,
  Decumber.StepDefinitions.Container;

type
  TScenarioTestRunner = class
  private
    FStepDefinitions: TList<IStepDefinitionsContainer>;
    function AreStepsMatching(const Container: IStepDefinitionsContainer;
      const Steps: TList<TAstNode>): Boolean;
    function GetStepWithoutKeyword(const Step: string): string;
    procedure RunSteps(const Container: IStepDefinitionsContainer; Steps: TList<TAstNode>);
  public
    constructor Create(StepDefinitions: TList<IStepDefinitionsContainer>);

    procedure TestScenario(Ast: TAstNode);
  end;

implementation

uses
  System.SysUtils,
  Decumber.Gherkin.Token;

{ TScenarioTestRunner }

function TScenarioTestRunner.AreStepsMatching(const Container: IStepDefinitionsContainer;
  const Steps: TList<TAstNode>): Boolean;
begin
  Result := Container.StepCount = Steps.Count;
  for var Step in Steps do
    Result := Result and Container.HasStep(GetStepWithoutKeyword(Step.Token.Value));
end;

constructor TScenarioTestRunner.Create(StepDefinitions: TList<IStepDefinitionsContainer>);
begin
  if StepDefinitions = nil then
    raise EArgumentNilException.Create('StepDefinitions');
  FStepDefinitions := StepDefinitions;
end;

function TScenarioTestRunner.GetStepWithoutKeyword(const Step: string): string;
begin
  Result := '';
  const i = Pos(' ', Step.Trim);
  if i > 0 then
    Result := Copy(Step.Trim, i + 1);
end;

procedure TScenarioTestRunner.TestScenario(Ast: TAstNode);
begin
  if Ast = nil then
    raise EArgumentNilException.Create('Ast');
  if Ast.Token.Type_ <> TGherkinTokenType.gttScenarioLine then
    raise EArgumentException.Create('Ast should be a scenario node');

  Writeln(Ast.Token.Value);
  const Steps = TList<TAstNode>.Create;
  try
    Ast.GetChildren(TGherkinTokenType.gttStepLine, Steps);

    for var Container in FStepDefinitions do
    begin
      if AreStepsMatching(Container, Steps) then
        RunSteps(Container, Steps);
    end;
  finally
    Steps.Free;
  end;
end;

procedure TScenarioTestRunner.RunSteps(const Container: IStepDefinitionsContainer;
  Steps: TList<TAstNode>);
begin
  const Obj = Container.CreateInstance;
  try
    for var Step in Steps do
    begin
      try
        Write(Step.Token.Value, ' ... ');
        Container.InvokeStep(Obj, GetStepWithoutKeyword(Step.Token.Value));
        Writeln('OK');
      except
        on Ex: EAssertionFailed do
        begin
          Writeln('Fail');
          Writeln(Ex.Message);
        end;
        else
        begin
          Writeln('Error');
          raise;
        end;
      end;
    end;
  finally
    Obj.Free;
  end;
end;

end.
