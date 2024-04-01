unit Decumber.Gherkin.AstNode;

interface

uses
  System.Generics.Collections,
  Decumber.Gherkin.Token;

type
  TAstNode = class
  private
    FChildren: TObjectList<TAstNode>;
    FToken: TGherkinToken;
  public
    constructor Create(const Token: TGherkinToken);
    destructor Destroy; override;

    function AddChild(Token: TGherkinToken): TAstNode;

    function FirstChild(Type_: TGherkinTokenType): TAstNode;
    procedure GetChildren(Type_: TGherkinTokenType; Result: TList<TAstNode>);

    property Token: TGherkinToken read FToken;
  end;

implementation

uses
  System.SysUtils;

{ TAstNode }

function TAstNode.AddChild(Token: TGherkinToken): TAstNode;
begin
  Result := TAstNode.Create(Token);
  FChildren.Add(Result);
end;

constructor TAstNode.Create(const Token: TGherkinToken);
begin
  FToken := Token;
  FChildren := TObjectList<TAstNode>.Create;
end;

destructor TAstNode.Destroy;
begin
  FChildren.Free;
  inherited;
end;

function TAstNode.FirstChild(Type_: TGherkinTokenType): TAstNode;
begin
  for var Child in FChildren do
  begin
    if Child.Token.Type_ = Type_ then
      Exit(Child);
  end;
  Result := nil;
end;

procedure TAstNode.GetChildren(Type_: TGherkinTokenType; Result: TList<TAstNode>);
begin
  if Result = nil then
    raise EArgumentNilException.Create('Result');

  for var Child in FChildren do
  begin
    if Child.Token.Type_ = Type_ then
      Result.Add(Child);
  end;
end;

end.
