program AdventofCode;

uses
  DateUtils,
  SysUtils,
  Day1, Day2;

var StartTime: TDateTime;

begin
  StartTime := Now;
  Day2.Run;
  writeln('Runtime ', MilliSecondsBetween(StartTime,Now), ' milliseconds.');
  readln;
end.

