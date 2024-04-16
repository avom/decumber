unit Helpers.DateTimeProvider;

interface

uses
  Utils.DateTimeProvider;

type
  TFixedDateTimeProvider = class(TInterfacedObject, IDateTimeProvider)
  private
    FNow: TDateTime;
  public
    constructor Create(Now: TDateTime);

    function Now: TDateTime;
    function Date: TDate;
    function Time: TTime;
  end;

implementation

uses
  System.DateUtils;

{ TFixedDateTimeProvider }

constructor TFixedDateTimeProvider.Create(Now: TDateTime);
begin
  FNow := Now;
end;

function TFixedDateTimeProvider.Date: TDate;
begin
  Result := FNow.GetDate;
end;

function TFixedDateTimeProvider.Now: TDateTime;
begin
  Result := FNow;
end;

function TFixedDateTimeProvider.Time: TTime;
begin
  Result := FNow.GetTime;
end;

end.
