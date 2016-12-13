program AdventofCode;

uses
  DateUtils, SysUtils, Day1, Day2, Day3, Day4, Day5, Day6, Day7, Day8, Day9,
  Day10, Day11, Day12, Day13;

var StartTime: TDateTime;

begin
  StartTime := Now;
  Day13.Run;
  writeln('Runtime ', MilliSecondsBetween(StartTime,Now), ' milliseconds.');
  readln;
end.

