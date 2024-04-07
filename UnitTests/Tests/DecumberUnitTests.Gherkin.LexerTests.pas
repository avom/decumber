unit DecumberUnitTests.Gherkin.LexerTests;

interface

uses
  DUnitX.TestFramework,
  Decumber.Gherkin.Lexer;

type
  [TestFixture]
  TGherkinLexerTests = class
  private
    FSut: TGherkinLexer;
  public
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Next_EmptySource_ReturnsEofToken;

    [Test]
    procedure Next_FeatureLine;

    [Test]
    procedure Next_ScenarioLine;

    [Test]
    [TestCase('Given', 'Given')]
    [TestCase('When', 'When')]
    [TestCase('Then', 'Then')]
    [TestCase('And', 'And')]
    [TestCase('But', 'But')]
    [TestCase('Asterisk', '*')]
    procedure Next_Step(const Keyword: string);

    [Test]
    procedure Next_LineWithIndent_ReturnTokenWithoutIndent;

    [Test]
    procedure Next_EmptyLinesBeforeScenario_ReturnScenarioLineToken;
  end;

implementation

uses
  Decumber.Gherkin.Token;

procedure TGherkinLexerTests.Next_EmptyLinesBeforeScenario_ReturnScenarioLineToken;
begin
  FSut := TGherkinLexer.Create(''#10''#10'  Scenario: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttScenarioLine, Token.Type_);
end;

procedure TGherkinLexerTests.Next_EmptySource_ReturnsEofToken;
begin
  FSut := TGherkinLexer.Create('');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttEof, Token.Type_, 'Wrong type');
  Assert.AreEqual('', Token.Value, 'Wrong token value');
  Assert.AreEqual(1, Token.Pos, 'Wrong line number');
end;

procedure TGherkinLexerTests.Next_FeatureLine;
begin
  FSut := TGherkinLexer.Create('Feature: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttFeatureLine, Token.Type_, 'Wrong token type');
  Assert.AreEqual('Feature: Lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_ScenarioLine;
begin
  FSut := TGherkinLexer.Create('Scenario: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttScenarioLine, Token.Type_, 'Wrong token type');
  Assert.AreEqual('Scenario: Lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_Step(const Keyword: string);
begin
  FSut := TGherkinLexer.Create(Keyword + ' lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttStepLine, Token.Type_, 'Wrong token type');
  Assert.AreEqual(Keyword + ' lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_LineWithIndent_ReturnTokenWithoutIndent;
begin
  FSut := TGherkinLexer.Create(#9'  Scenario: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttScenarioLine, Token.Type_, 'Wrong token type');
  Assert.AreEqual('Scenario: Lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.TearDown;
begin
  FSut.Free;
  FSut := nil;
end;

end.
