unit Decumber;

interface

uses
  System.Rtti,
  System.Generics.Collections,
  Decumber.Assertions.Assert,
  Decumber.StepDefinitions.Attributes,
  Decumber.StepDefinitions.Container;

type
  GivenAttribute = Decumber.StepDefinitions.Attributes.GivenAttribute;
  WhenAttribute = Decumber.StepDefinitions.Attributes.WhenAttribute;
  ThenAttribute = Decumber.StepDefinitions.Attributes.ThenAttribute;
  Then_Attribute = ThenAttribute;
  AndAttribute = Decumber.StepDefinitions.Attributes.AndAttribute;
  And_Attribute = AndAttribute;
  ButAttribute = Decumber.StepDefinitions.Attributes.ButAttribute;

  Assert = Decumber.Assertions.Assert.Assert;

  TDecumber = class sealed
  private
    class var FRttiContext: TRttiContext;
    class constructor CreateClass;
    class destructor DestroyClass;

    class procedure FindStepDefinitions(StepDefinitions: TList<IStepDefinitionsContainer>);

    class procedure RunTest(const FeatureFileName: string;
      StepDefinitions: TList<IStepDefinitionsContainer>); overload;
  public
    class procedure RunTests(const Dir: string);
  end;

implementation

uses
  System.IOUtils,
  System.SysUtils,
  Decumber.Gherkin.AstNode,
  Decumber.Gherkin.Lexer,
  Decumber.Gherkin.Parser,
  Decumber.Gherkin.Token,
  Decumber.StepDefinitions.Finder,
  Decumber.TestRunner.Scenario;

{ TDecumber }

class constructor TDecumber.CreateClass;
begin
  FRttiContext := TRttiContext.Create;
end;

class destructor TDecumber.DestroyClass;
begin
  FRttiContext.Free;
end;

class procedure TDecumber.FindStepDefinitions(StepDefinitions: TList<IStepDefinitionsContainer>);
begin
  const Finder = TStepDefinitionsFinder.Create(FRttiContext);
  try
    Finder.FindAll(StepDefinitions);
  finally
    Finder.Free;
  end;
end;

class procedure TDecumber.RunTest(const FeatureFileName: string;
  StepDefinitions: TList<IStepDefinitionsContainer>);

  function ParseFile(const FileName: string): TAstNode;
  begin
    Result := nil;
    try
      const Gherkin = TFile.ReadAllText(FileName);
      const Lexer: IGherkinLexer = TGherkinLexer.Create(Gherkin);
      const Parser = TGherkinParser.Create(Lexer);
      try
        Result := Parser.Parse;
      finally
        Parser.Free;
      end;
    except
      Result.Free;
      raise;
    end;
  end;

begin
  var Ast: TAstNode := nil;
  var TestRunner: TScenarioTestRunner := nil;
  try
    TestRunner := TScenarioTestRunner.Create(StepDefinitions);
    Ast := ParseFile(FeatureFileName);
    Writeln(Ast.Token.Value);

    const Scenarios = TList<TAstNode>.Create;
    try
      Ast.GetChildren(TGherkinTokenType.gttScenarioLine, Scenarios);
      for var Scenario in Scenarios do
      begin
        Writeln;
        TestRunner.TestScenario(Scenario);
      end;
    finally
      Scenarios.Free;
    end;
  finally
    TestRunner.Free;
    Ast.Free;
  end;
end;

class procedure TDecumber.RunTests(const Dir: string);
begin
  const StepDefinitions = TList<IStepDefinitionsContainer>.Create;
  try
    FindStepDefinitions(StepDefinitions);
    const FeatureFiles = TDirectory.GetFiles(Dir, '*.feature');
    for var FileName in FeatureFiles do
    begin
      RunTest(FileName, StepDefinitions);
      Writeln;
    end;
  finally
    StepDefinitions.Free;
  end;
end;

end.
