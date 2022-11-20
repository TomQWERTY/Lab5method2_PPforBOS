with Ada.Text_IO;
use Ada.Text_IO;

procedure arrman is

   array_size : Integer := 800;

   type my_array is array (1 .. array_size) of Integer;

   a : my_array;

   procedure create_array is
   begin
      for i in a'Range loop
         a (i) := i;
      end loop;
   end create_array;

   task type my_task is
      entry start(left, RigHt, index, s : in Integer);
      entry finish(sum1 : out Integer);
   end my_task;



   task body my_task is
      left, RigHt : Integer;
      sum : Integer := 0;
      index : integer;
      s : integer;

   begin
      loop
         accept start(left, RigHt, index, s : in Integer) do
            my_task.left := left;
            my_task.right := Right;
            my_task.index := index;
            my_task.s := s;
         end start;
         sum := left + right;
         accept finish (sum1 : out Integer) do
            sum1 := sum;
         end finish;
         exit when index > (s / 2 + s mod 2) / 2;
      end loop;
   end my_task;

   thread_count : Integer := array_size / 2;
   task1 : array(1..thread_count) of my_task;

   sum00 : integer;
begin
   create_array;
   sum00 := 0;
   for i in a'Range loop
      sum00 := sum00 + a(i);
   end loop;

   Put_Line("Single-thread result: " & sum00'img);

   while array_size > 1 loop
      for i in 1..thread_count loop
         task1(i).start(a(i), a(array_size - i + 1), i, array_size);
      end loop;
      for i in 1..thread_count loop
         task1(i).finish(a(i));
      end loop;
      array_size := array_size / 2 + array_size mod 2;
      thread_count := array_size / 2;
   end loop;

   Put_Line("Multi-thread result: " & a(1)'img);

end arrman;
