unit Day25;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

type TOpCode = (opCopy, opInc, opDec, opJnz, opTgl, opOut);
  TParameter = record
    case isRegister: boolean of
      true: (RegValue: char);
      false: (Value: integer);
  end;
  TInstruction = record
    OpCode: TOpCode;
    Parameters: array[1..2] of TParameter;
  end;
  TRegisters = array['a'..'d'] of integer;

var Instructions: array[1..64] of TInstruction;
  NumInstructions: integer = 0;

procedure LoadInstructions;
var F: text;
  Line: string;
begin
  assign(F, 'day25.dat');
  reset(F);
  NumInstructions := 0;
  while not eof(F) do
  begin
    readln(F, Line);
    inc(NumInstructions);
    case copy(Line,1,3) of
      'cpy': Instructions[NumInstructions].OpCode := opCopy;
      'inc': Instructions[NumInstructions].OpCode := opInc;
      'dec': Instructions[NumInstructions].OpCode := opDec;
      'jnz': Instructions[NumInstructions].OpCode := opJnz;
      'tgl': Instructions[NumInstructions].OpCode := opTgl;
      'out': Instructions[NumInstructions].OpCode := opOut;
    end;
    delete(Line, 1, 4);
    case Instructions[NumInstructions].OpCode of
      opInc, opDec: begin
        Instructions[NumInstructions].Parameters[1].isRegister := true;
        Instructions[NumInstructions].Parameters[1].RegValue := Line[1];
      end;
      opTgl,opOut: begin
        if (Line[1] in ['a'..'d']) then
        begin
          Instructions[NumInstructions].Parameters[1].isRegister := true;
          Instructions[NumInstructions].Parameters[1].RegValue := Line[1];
        end
        else
        begin
          Instructions[NumInstructions].Parameters[1].isRegister := false;
          Instructions[NumInstructions].Parameters[1].Value := strtoint(Line);
        end;
      end;
      opCopy, opJnz: begin
        if (Line[1] in ['a'..'d']) then
        begin
          Instructions[NumInstructions].Parameters[1].isRegister := true;
          Instructions[NumInstructions].Parameters[1].RegValue := Line[1];
          delete(Line, 1, 2);
        end
        else
        begin
          Instructions[NumInstructions].Parameters[1].isRegister := false;
          Instructions[NumInstructions].Parameters[1].Value := strtoint(copy(Line,1,pred(pos(' ', Line))));
          delete(Line, 1, pos(' ', Line));
        end;
        if (Line[1] in ['a'..'d']) then
        begin
          Instructions[NumInstructions].Parameters[2].isRegister := true;
          Instructions[NumInstructions].Parameters[2].RegValue := Line[1];
        end
        else
        begin
          Instructions[NumInstructions].Parameters[2].isRegister := false;
          Instructions[NumInstructions].Parameters[2].Value := strtoint(Line);
        end;
      end;
    end;
  end;
  close(F);
end;

procedure Execute(var Registers: TRegisters);
var Instruction: integer;
  Hold: integer;
  Output: string;
begin
  Instruction := 1;
  Output := '';
  while Instruction<=NumInstructions do
  begin
    case Instructions[Instruction].OpCode of
      opCopy: begin
          if Instructions[Instruction].Parameters[2].isRegister then
          begin
            if Instructions[Instruction].Parameters[1].isRegister then
            begin
              Registers[Instructions[Instruction].Parameters[2].RegValue] := Registers[Instructions[Instruction].Parameters[1].RegValue];
            end
            else
            begin
              Registers[Instructions[Instruction].Parameters[2].RegValue] := Instructions[Instruction].Parameters[1].Value;
            end;
          end;
          inc(Instruction);
        end;
      opInc: begin
          if Instructions[Instruction].Parameters[1].isRegister then
          begin
            inc(Registers[Instructions[Instruction].Parameters[1].RegValue]);
          end;
          inc(Instruction);
        end;
      opDec: begin
          if Instructions[Instruction].Parameters[1].isRegister then
          begin
            dec(Registers[Instructions[Instruction].Parameters[1].RegValue]);
          end;
          inc(Instruction);
        end;
      opJnz: begin
          if Instructions[Instruction].Parameters[1].isRegister then
          begin
            Hold := Registers[Instructions[Instruction].Parameters[1].RegValue];
          end
          else
          begin
            Hold := Instructions[Instruction].Parameters[1].Value;
          end;
          if Hold<>0 then
          begin
            if Instructions[Instruction].Parameters[2].isRegister then
            begin
              Instruction := Instruction + Registers[Instructions[Instruction].Parameters[2].RegValue];
            end
            else
            begin
              Instruction := Instruction + Instructions[Instruction].Parameters[2].Value;
            end;
          end
          else
          begin
            inc(Instruction);
          end;
        end;
      opTgl: begin
          if Instructions[Instruction].Parameters[1].isRegister then
          begin
            Hold := Instruction + Registers[Instructions[Instruction].Parameters[1].RegValue];
            write(Instructions[Instruction].Parameters[1].RegValue);
          end
          else
          begin
            Hold := Instruction + Instructions[Instruction].Parameters[1].Value;
          end;
          case Instructions[Hold].opCode of
            opInc: Instructions[Hold].opCode := opDec;
            opDec, opTgl: Instructions[Hold].opCode := opInc;
            opJnz: Instructions[Hold].opCode := opCopy;
            opCopy: Instructions[Hold].opCode := opJnz;
          end;
          inc(Instruction);
        end;
      opOut: begin
          if Instructions[Instruction].Parameters[1].isRegister then
          begin
            Hold := Registers[Instructions[Instruction].Parameters[1].RegValue];
          end
          else
          begin
            Hold := Instructions[Instruction].Parameters[1].Value;
          end;
          Output := Output + inttostr(Hold);
          if length(Output)=10 then
          begin
            if Output='0101010101' then
              Registers['a'] := 1
            else
              Registers['a'] := 0;
            exit;
          end;
          inc(Instruction);
        end;
    end;
  end;
end;

procedure Run;
var Registers: TRegisters;
  Idx: integer;
begin
  LoadInstructions;
  Idx := 0;
  while true do
  begin
    Registers['a'] := Idx;
    Registers['b'] := 0;
    Registers['c'] := 0;
    Registers['d'] := 0;
    Execute(Registers);
    if Registers['a']=1 then
      break;
    inc(Idx);
  end;
  writeln('Part 1 = ', Idx);
end;

end.

--- Day 25: Clock Signal ---

You open the door and find yourself on the roof. The city sprawls away from you for miles and miles.

There's not much time now - it's already Christmas, but you're nowhere near the North Pole, much too far to deliver these stars to the sleigh in time.

However, maybe the huge antenna up here can offer a solution. After all, the sleigh doesn't need the stars, exactly; it needs the timing data they provide, and you happen to have a massive signal generator right here.

You connect the stars you have to your prototype computer, connect that to the antenna, and begin the transmission.

Nothing happens.

You call the service number printed on the side of the antenna and quickly explain the situation. "I'm not sure what kind of equipment you have connected over there," he says, "but you need a clock signal." You try to explain that this is a signal for a clock.

"No, no, a clock signal - timing information so the antenna computer knows how to read the data you're sending it. An endless, alternating pattern of 0, 1, 0, 1, 0, 1, 0, 1, 0, 1...." He trails off.

You ask if the antenna can handle a clock signal at the frequency you would need to use for the data from the stars. "There's no way it can! The only antenna we've installed capable of that is on top of a top-secret Easter Bunny installation, and you're definitely not-" You hang up the phone.

You've extracted the antenna's clock signal generation assembunny code (your puzzle input); it looks mostly compatible with code you worked on just recently.

This antenna code, being a signal generator, uses one extra instruction:

out x transmits x (either an integer or the value of a register) as the next value for the clock signal.
The code takes a value (via register a) that describes the signal to generate, but you're not sure how it's used. You'll have to find the input to produce the right signal through experimentation.

What is the lowest positive integer that can be used to initialize register a and cause the code to output a clock signal of 0, 1, 0, 1... repeating forever?
