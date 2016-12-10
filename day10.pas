unit Day10;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

type TBotInstruction = record
    LowBot: integer;
    HighBot: integer;
  end;
  TBot = record
    LeftChip: integer;
    RightChip: integer;
    Instruction: TBotInstruction;
  end;

var Bots: array[0..255] of TBot;
  BotCount: integer;

procedure GiveChip(Bot: integer; Chip: integer);
begin
  if Bots[Bot].LeftChip=-1 then
    Bots[Bot].LeftChip := Chip
  else if Bots[Bot].LeftChip<Chip then
    Bots[Bot].RightChip := Chip
  else
  begin
    Bots[Bot].RightChip := Bots[Bot].LeftChip;
    Bots[Bot].LeftChip := Chip;
  end;
end;

procedure LoadInstructions;
var F: text;
  Line: string;
  Bot: integer;
  Value: integer;
  output: boolean;
begin
  for Bot:=0 to 255 do
  begin
    Bots[Bot].LeftChip := -1;
    Bots[Bot].RightChip := -1;
  end;
  assign(F, 'day10.dat');
  reset(F);
  BotCount := 0;
  while not eof(F) do
  begin
    readln(F, Line);
    inc(BotCount);
    if Line[1]='v' then
    begin
      delete(Line,1,6);
      Value := strtoint(copy(Line,1,pred(pos(' ',Line))));
      delete(Line,1,pos('t ',Line)+1);
      Bot := strtoint(Line);
      GiveChip(Bot, Value);
    end
    else
    begin
      delete(Line,1,4);
      Bot := strtoint(copy(Line,1,pred(pos(' ',Line))));
      delete(Line,1,pos('to ',Line)+2);
      if Line[1]='o' then
        output := true
      else
        output := false;
      delete(Line,1,pos(' ',Line));
      Value := strtoint(copy(Line,1,pred(pos(' ',Line))));
      if output then
      begin
        Value := Value + 220;
      end;
      Bots[Bot].Instruction.LowBot := Value;
      delete(Line,1,pos('to ',Line)+2);
      if Line[1]='o' then
        output := true
      else
        output := false;
      delete(Line,1,pos(' ',Line));
      Value := strtoint(Line);
      if output then
      begin
        Value := Value + 220;
      end;
      Bots[Bot].Instruction.HighBot := Value;
    end;
  end;
  close(F);
end;

procedure Run;
var Idx: integer;
  Part1: integer;
  Part2: integer;
  Pass: integer;
begin
  LoadInstructions;
  Part1 := 0;
  Pass := 1;
  while Part1=0 do
  begin
    writeln('Pass ', Pass);
    inc(Pass);
    for Idx:=0 to BotCount do
    begin
      if (Bots[Idx].LeftChip<>-1) and (Bots[Idx].RightChip<>-1) then
      begin
        if (Bots[Idx].LeftChip=17) and (Bots[Idx].RightChip=61) then
        begin
          Part1 := Idx;
          break;
        end;
        GiveChip(Bots[Idx].Instruction.LowBot, Bots[Idx].LeftChip);
        GiveChip(Bots[Idx].Instruction.HighBot, Bots[Idx].RightChip);
        Bots[Idx].LeftChip := -1;
        Bots[Idx].RightChip := -1;
      end;
    end;
  end;
  writeln('Part 1 = ', Part1);
  while true do
  begin
    writeln('Pass ', Pass);
    inc(Pass);
    for Idx:=0 to BotCount do
    begin
      if (Bots[Idx].LeftChip<>-1) and (Bots[Idx].RightChip<>-1) then
      begin
        GiveChip(Bots[Idx].Instruction.LowBot, Bots[Idx].LeftChip);
        GiveChip(Bots[Idx].Instruction.HighBot, Bots[Idx].RightChip);
        Bots[Idx].LeftChip := -1;
        Bots[Idx].RightChip := -1;
      end;
    end;
    Part2 := Bots[220].LeftChip * Bots[221].LeftChip * Bots[222].LeftChip;
    if (Bots[220].LeftChip<>-1) and (Bots[221].LeftChip<>-1) and (Bots[222].LeftChip<>-1) then
      break;
  end;
  writeln('Part 2 = ',Part2);
end;

end.

--- Day 10: Balance Bots ---

You come upon a factory in which many robots are zooming around handing small microchips to each other.

Upon closer examination, you notice that each bot only proceeds when it has two microchips, and once it does, it gives each one to a different bot or puts it in a marked "output" bin. Sometimes, bots take microchips from "input" bins, too.

Inspecting one of the microchips, it seems like they each contain a single number; the bots must use some logic to decide what to do with each chip. You access the local control computer and download the bots' instructions (your puzzle input).

Some of the instructions specify that a specific-valued microchip should be given to a specific bot; the rest of the instructions indicate what a given bot should do with its lower-value or higher-value chip.

For example, consider the following instructions:

value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip.
Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0.
Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0.
Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0.
In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a value-2 microchip, and output bin 2 contains a value-3 microchip. In this configuration, bot number 2 is responsible for comparing value-5 microchips with value-2 microchips.

Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips?

--- Part Two ---

What do you get if you multiply together the values of one chip in each of outputs 0, 1, and 2?
