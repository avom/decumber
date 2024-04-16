unit Utils.DateTimeProvider;

interface

type
  IDateTimeProvider = interface
    function Now: TDateTime;
    function Date: TDate;
    function Time: TTime;
  end;

implementation

end.
