unit DecumberUnitTests.Gherkin.ParserTests;

interface

uses
  DUnitX.TestFramework,
  Decumber.Gherkin.AstNode,
  Decumber.Gherkin.Parser;

type
  [TestFixture]
  TGherkinParserTests = class
  private
    FSut: TGherkinParser;
    FAst: TAstNode;
  public
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Parse_ScenarioWithGivenWhenThen;
  end;

implementation

uses
  System.SysUtils,
  Decumber.Gherkin.Lexer,
  Decumber.Gherkin.Token;

{ TGherkinParserTests }

procedure TGherkinParserTests.Parse_ScenarioWithGivenWhenThen;
begin
  const Source = [
    'Feature: VAT calculator',
    '',
    '  Scenario: Calculate VAT for a product',
    '    Given a VAT rate fo 22',
    '    When I want to earn 100 euros from seling a product',
    '    Then I have to sellit for 122 euros'];

  const Lexer = TGherkinLexer.Create(string.Join(#10, Source));
  FSut := TGherkinParser.Create(Lexer);

  FAst := FSut.Parse;

  Assert.AreEqual(TGherkinTokenType.gttFeatureLine, FAst.Token.&Type, 'Feature line expected');

  const ScenarioAst = FAst.FirstChild(TGherkinTokenType.gttScenarioLine);
  Assert.IsNotNull(ScenarioAst, 'Scenario line expected');
  Assert.IsNotNull(ScenarioAst.FirstChild(TGherkinTokenType.gttGivenLine), 'Given line expected');
  Assert.IsNotNull(ScenarioAst.FirstChild(TGherkinTokenType.gttWhenLine), 'When line expected');
  Assert.IsNotNull(ScenarioAst.FirstChild(TGherkinTokenType.gttThenLine), 'Then line expected');
end;

procedure TGherkinParserTests.TearDown;
begin
  FreeAndNil(FSut);
  FreeAndNil(FAst);
end;

end.
