unit Decumber;

interface

uses
  System.Rtti,
  Decumber.StepDefinitions.Attributes;

type
  GivenAttribute = Decumber.StepDefinitions.Attributes.GivenAttribute;
  WhenAttribute = Decumber.StepDefinitions.Attributes.WhenAttribute;
  ThenAttribute = Decumber.StepDefinitions.Attributes.ThenAttribute;
  Then_Attribute = ThenAttribute;
  AndAttribute = Decumber.StepDefinitions.Attributes.AndAttribute;
  And_Attribute = AndAttribute;
  ButAttribute = Decumber.StepDefinitions.Attributes.ButAttribute;

  TDecumber = class sealed
  private
    class var FRttiContext: TRttiContext;
    class constructor CreateClass;
    class destructor DestroyClass;
  public
    class procedure RunTest(const FeatureFileName: string);
  end;

implementation

uses
  System.Generics.Collections,
  System.IOUtils,
  System.SysUtils,
  Decumber.Gherkin.AstNode,
  Decumber.Gherkin.Lexer,
  Decumber.Gherkin.Parser,
  Decumber.Gherkin.Token,
  Decumber.StepDefinitions.Container,
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

class procedure TDecumber.RunTest(const FeatureFileName: string);

  procedure FindStepDefinitions(StepDefinitions: TList<IStepDefinitionsContainer>);
  begin
    const Finder = TStepDefinitionsFinder.Create(FRttiContext);
    try
      Finder.FindAll(StepDefinitions);
    finally
      Finder.Free;
    end;
  end;

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
  const StepDefinitions = TList<IStepDefinitionsContainer>.Create;
  try
    FindStepDefinitions(StepDefinitions);
    TestRunner := TScenarioTestRunner.Create(StepDefinitions);
    Ast := ParseFile(FeatureFileName);
    Writeln(Ast.Token.Value);
    const ScenarioAst = Ast.FirstChild(TGherkinTokenType.gttScenarioLine);
    TestRunner.TestScenario(ScenarioAst);
  finally
    StepDefinitions.Free;
    TestRunner.Free;
    Ast.Free;
  end;
end;

end.
