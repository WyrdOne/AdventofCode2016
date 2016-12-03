unit Day3;

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

function isValidTriangle(Side1,Side2,Side3: integer): boolean;
begin
  if ((Side1+Side2)>Side3) and ((Side2+Side3)>Side1) and ((Side1+Side3)>Side2) then
    isValidTriangle := true
  else
    isValidTriangle := false;
end;

procedure Run;
var F: Text;
  Line: string;
  Sides: array[1..3,1..3] of integer;
  Idx: integer;
const ValidCount: integer = 0;
  ValidCount2: integer = 0;
  ReadCount: integer = 0;
begin
  assignfile(F, 'day3.dat');
  reset(F);
  while not eof(F) do
  begin
    ReadLn(F, Line);
    inc(ReadCount);
    if (ReadCount>3) then
      ReadCount := 1;
    SScanf(Line, '%d %d %d', [@Sides[ReadCount,1],@Sides[ReadCount,2],@Sides[ReadCount,3]]);
    if isValidTriangle(Sides[ReadCount,1],Sides[ReadCount,2],Sides[ReadCount,3]) then
      inc(ValidCount);
    if ReadCount=3 then
    begin
      for Idx:=1 to 3 do
      begin
        if isValidTriangle(Sides[1,Idx],Sides[2,Idx],Sides[3,Idx]) then
          inc(ValidCount2);
      end;
    end;
  end;
  close(F);
  writeln('Part 1 = ', ValidCount);
  writeln('Part 2 = ', ValidCount2);
end;

end.

--- Day 3: Squares With Three Sides ---

Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.

Or are they?

The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.

In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.

In your puzzle input, how many of the listed triangles are possible?

--- Part Two ---

Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.

For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:

101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603
In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?
