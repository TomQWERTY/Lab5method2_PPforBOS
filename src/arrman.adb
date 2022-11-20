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

   protected task_manager is
      procedure set_res (sum : in Integer; index : in integer);
      entry next_step (new_needed_thread_count : in Integer);
   private
      needed_thread_count : Integer      := 0;
      arrived_thread_count : Integer      := 0;
   end task_manager;

   protected body task_manager is

      procedure set_res (sum : in Integer; index : in integer) is
      begin
         a(index) := sum;
         arrived_thread_count := arrived_thread_count + 1;
      end set_res;

      entry next_step (new_needed_thread_count : in Integer)
        when arrived_thread_count = needed_thread_count is
      begin
         needed_thread_count := new_needed_thread_count;
         arrived_thread_count := 0;
      end next_step;

   end task_manager;

   task type my_task is
      entry start(left, RigHt, index, s : in Integer);
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
         task_manager.set_res(sum, index);
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

   task_manager.next_step(thread_count);

   while array_size > 1 loop
      for i in 1..thread_count loop
         task1(i).start(a(i), a(array_size - i + 1), i, array_size);
      end loop;
      array_size := array_size / 2 + array_size mod 2;
      thread_count := array_size / 2;
      task_manager.next_step(thread_count);
   end loop;

   Put_Line("Multi-thread result: " & a(1)'img);

end arrman;
