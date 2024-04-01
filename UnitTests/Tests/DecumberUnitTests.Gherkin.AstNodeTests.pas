unit DecumberUnitTests.Gherkin.AstNodeTests;

interface

uses
  DUnitX.TestFramework,
  Decumber.Gherkin.AstNode;

type
  [TestFixture]
  TAstNodeTests = class
  private
    FSut: TAstNode;
  public
    [TearDown]
    procedure TearDown;

    [Test]
    procedure FirstChild_NoChildren_ReturnsNil;

    [Test]
    procedure FirstChild_NoChildrenWithType_ReturnsNil;

    [Test]
    procedure FirstChild_SingleChildWithType_ReturnsChild;

    [Test]
    procedure FirstChild_MultipleChildrenWithType_ReturnsFirstAddedChild;

    [Test]
    procedure GetChildren_NoChildren_ReturnsNoChildren;

    [Test]
    procedure GetChildren_NoChildrenWithType_ReturnsNoChildren;

    [Test]
    procedure GetChildren_MultipleChildrenWithType_ReturnsOnlyChildrenWithType;

    [Test]
    procedure GetChildren_NonEmptyResultList_ReturnsWithOriginalNodesInResultList;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  Decumber.Gherkin.Token;

{ TAstNodeTests }

procedure TAstNodeTests.GetChildren_MultipleChildrenWithType_ReturnsOnlyChildrenWithType;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttGivenLine, '', 2));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 3));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 4));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 5));

  const Children = TList<TAstNode>.Create;
  try
    FSut.GetChildren(TGherkinTokenType.gttWhenLine, Children);

    Assert.AreEqual(3, Children.Count, 'Wrong number of children returned');
    Assert.AreEqual(3, Children[0].Token.Pos, 'Wrong child found at 0');
    Assert.AreEqual(4, Children[1].Token.Pos, 'Wrong child found at 0');
    Assert.AreEqual(5, Children[2].Token.Pos, 'Wrong child found at 0');
  finally
    Children.Free;
  end;
end;

procedure TAstNodeTests.GetChildren_NoChildrenWithType_ReturnsNoChildren;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttGivenLine, '', 2));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 3));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 4));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 5));

  const Children = TList<TAstNode>.Create;
  try
    FSut.GetChildren(TGherkinTokenType.gttThenLine, Children);

    Assert.IsNull(Children);
  finally
    Children.Free;
  end;
end;

procedure TAstNodeTests.GetChildren_NoChildren_ReturnsNoChildren;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));

  const Children = TList<TAstNode>.Create;
  try
    FSut.GetChildren(TGherkinTokenType.gttGivenLine, Children);

    Assert.IsNull(Children);
  finally
    Children.Free;
  end;
end;

procedure TAstNodeTests.GetChildren_NonEmptyResultList_ReturnsWithOriginalNodesInResultList;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttGivenLine, '', 2));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 3));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 4));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 5));

  const Children = TList<TAstNode>.Create;
  try
    FSut.GetChildren(TGherkinTokenType.gttGivenLine, Children);
    FSut.GetChildren(TGherkinTokenType.gttWhenLine, Children);

    Assert.AreEqual(4, Children.Count, 'Wrong number of children returned');
    Assert.AreEqual(0, Children[0].Token.Pos, 'Original AST node removed or moved');
  finally
    Children.Free;
  end;

end;

procedure TAstNodeTests.FirstChild_MultipleChildrenWithType_ReturnsFirstAddedChild;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttGivenLine, '', 2));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 3));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 4));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttWhenLine, '', 5));

  const Child = FSut.FirstChild(TGherkinTokenType.gttWhenLine);

  Assert.IsNotNull(Child, 'Child node not found');
  Assert.AreEqual(3, Child.Token.Pos, 'Wrong child node found');
end;

procedure TAstNodeTests.FirstChild_NoChildrenWithType_ReturnsNil;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttGivenLine, '', 2));

  const Child = FSut.FirstChild(TGherkinTokenType.gttWhenLine);

  Assert.IsNull(Child);
end;

procedure TAstNodeTests.FirstChild_NoChildren_ReturnsNil;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));

  const Child = FSut.FirstChild(TGherkinTokenType.gttGivenLine);

  Assert.IsNull(Child);
end;

procedure TAstNodeTests.FirstChild_SingleChildWithType_ReturnsChild;
begin
  Fsut := TAstNode.Create(TGherkinToken.Create(TGherkinTokenType.gttScenarioLine, '', 1));
  FSut.AddChild(TGherkinToken.Create(TGherkinTokenType.gttGivenLine, '', 2));

  const Child = FSut.FirstChild(TGherkinTokenType.gttGivenLine);

  Assert.IsNotNull(Child);
end;

procedure TAstNodeTests.TearDown;
begin
  FreeAndNil(FSut);
end;

end.
