unit Day6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

procedure Run;
var F: Text;
  Line: string;
  Idx: integer;
  CharIdx: char;
  LetterFrequency: array[1..8,'a'..'z'] of integer;
  Letter1: char;
  Code1: string;
  Letter2: char;
  Code2: string;
begin
  {$HINTS OFF}FillChar(LetterFrequency, sizeof(LetterFrequency), 0);{$HINTS ON}
  assignfile(F, 'day6.dat');
  reset(F);
  while not eof(F) do
  begin
    ReadLn(F, Line);
    for Idx:=1 to 8 do
      inc(LetterFrequency[Idx,Line[Idx]]);
  end;
  for Idx:=1 to 8 do
  begin
    Letter1 := 'a';
    Letter2 := 'a';
    for CharIdx:='b' to 'z' do
    begin
      if LetterFrequency[Idx,CharIdx]>LetterFrequency[Idx,Letter1] then
        Letter1 := CharIdx;
      if (LetterFrequency[Idx,CharIdx]<LetterFrequency[Idx,Letter2]) then
        Letter2 := CharIdx;
    end;
    Code1 := Code1 + Letter1;
    Code2 := Code2 + Letter2;
  end;
  writeln('Part 1 = ', Code1);
  writeln('Part 2 = ', Code2);
end;

end.

--- Day 6: Signals and Noise ---

Something is jamming your communications with Santa. Fortunately, your signal is only partially jammed, and protocol in situations like this is to switch to a simple repetition code to get the message through.

In this model, the same message is sent repeatedly. You've recorded the repeating message signal (your puzzle input), but the data seems quite corrupted - almost too badly to recover. Almost.

All you need to do is figure out which character is most frequent for each position. For example, suppose you had recorded the following messages:

eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.

Given the recording in your puzzle input, what is the error-corrected version of the message being sent?

--- Part Two ---

Of course, that would be the message - if you hadn't agreed to use a modified repetition code instead.

In this modified code, the sender instead transmits what looks like random data, but for each character, the character they actually want to send is slightly less likely than the others. Even after signal-jamming noise, you can look at the letter distributions in each column and choose the least common letter to reconstruct the original message.

In the above example, the least common character in the first column is a; in the second, d, and so on. Repeating this process for the remaining characters produces the original message, advent.

Given the recording in your puzzle input and this new decoding methodology, what is the original message that Santa is trying to send?
