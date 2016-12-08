program AdventofCode;

uses
  DateUtils,
  SysUtils,
  Day1, Day2, Day3, Day4, Day5, Day6, Day7, Day8;

var StartTime: TDateTime;

begin
  StartTime := Now;
  Day8.Run;
  writeln('Runtime ', MilliSecondsBetween(StartTime,Now), ' milliseconds.');
  readln;
end.

