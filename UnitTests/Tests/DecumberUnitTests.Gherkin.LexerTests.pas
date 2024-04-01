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
    procedure Next_Given;

    [Test]
    procedure Next_When;

    [Test]
    procedure Next_Then;

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

  Assert.AreEqual(TGherkinTokenType.gttScenarioLine, Token.&Type);
end;

procedure TGherkinLexerTests.Next_EmptySource_ReturnsEofToken;
begin
  FSut := TGherkinLexer.Create('');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttEof, Token.&Type, 'Wrong type');
  Assert.AreEqual('', Token.Value, 'Wrong token value');
  Assert.AreEqual(1, Token.Pos, 'Wrong line number');
end;

procedure TGherkinLexerTests.Next_FeatureLine;
begin
  FSut := TGherkinLexer.Create('Feature: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttFeatureLine, Token.&Type, 'Wrong token type');
  Assert.AreEqual('Feature: Lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_Given;
begin
  FSut := TGherkinLexer.Create('Given lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttGivenLine, Token.&Type, 'Wrong token type');
  Assert.AreEqual('Given lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_ScenarioLine;
begin
  FSut := TGherkinLexer.Create('Scenario: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttScenarioLine, Token.&Type, 'Wrong token type');
  Assert.AreEqual('Scenario: Lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_LineWithIndent_ReturnTokenWithoutIndent;
begin
  FSut := TGherkinLexer.Create(#9'  Scenario: Lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttScenarioLine, Token.&Type, 'Wrong token type');
  Assert.AreEqual('Scenario: Lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_Then;
begin
  FSut := TGherkinLexer.Create('Then lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttThenLine, Token.&Type, 'Wrong token type');
  Assert.AreEqual('Then lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.Next_When;
begin
  FSut := TGherkinLexer.Create('When lorem ipsum');

  const Token = FSut.Next;

  Assert.AreEqual(TGherkinTokenType.gttWhenLine, Token.&Type, 'Wrong token type');
  Assert.AreEqual('When lorem ipsum', Token.Value, 'Wrong token value');
end;

procedure TGherkinLexerTests.TearDown;
begin
  FSut.Free;
  FSut := nil;
end;

end.
