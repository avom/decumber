unit Decumber.Assertions.Assert;

interface

uses
  Decumber.Assertions.Exceptions;

type
  Assert = class
  private
    type
      IAssert<T> = interface
        procedure IsEqualTo(const Value: T);
      end;

      TAssert<T> = class(TInterfacedObject, IAssert<T>)
      private
        FActual: T;
        function VarToStr(const Value: T): string;
      public
        constructor Create(const Actual: T);

        procedure IsEqualTo(const Value: T);
      end;
  public
    class function That<T>(const Actual: T): IAssert<T>;
  end;

implementation

uses
  System.Generics.Defaults,
  System.Rtti,
  System.SysUtils,
  System.TypInfo;

{ Assert.TAssert<T> }

constructor Assert.TAssert<T>.Create(const Actual: T);
begin
  FActual := Actual;
end;

procedure Assert.TAssert<T>.IsEqualTo(const Value: T);
begin
  const Comparer = TEqualityComparer<T>.Default;
  if not Comparer.Equals(Value, FActual) then
    raise EAssertError.Create(VarToStr(Value), VarToStr(FActual)) at ReturnAddress;
end;

function Assert.TAssert<T>.VarToStr(const Value: T): string;
begin
  var FormatSettings := TFormatSettings.Create;
  FormatSettings.DecimalSeparator := '.';

  const Val = TValue.From<T>(Value);
  case Val.Kind of
    tkFloat:
      begin
        if Val.TypeInfo = TypeInfo(Currency) then
          Result := CurrToStr(Val.AsCurrency, FormatSettings);
      end;
    tkEnumeration:
      Result := GetEnumName(Val.TypeInfo, Val.AsOrdinal);
    else
    begin
      raise ENotImplemented.CreateFmt('%s not supported yet for printing in test report',
        [Val.TypeData.NameList]);
    end;
  end;
end;

{ Assert }

class function Assert.That<T>(const Actual: T): IAssert<T>;
begin
  Result := TAssert<T>.Create(Actual);
end;

end.
