with Ada.Text_IO;

procedure Main is
   Can_Stop : Boolean := False; -- Variable to control stopping condition
   pragma Atomic (Can_Stop); -- Making assignment atomic for safe concurrent access
   Step : Long_Long_Integer := 1; -- Step value for each addition

   task type Stop_Thread;
   task type Sum_Thread(ID:Integer);

   task body Stop_Thread is
   begin
      delay 3.0; -- Delay to stop the process after 3 seconds
      Can_Stop := True; -- Set the stopping flag to True
   end Stop_Thread;

   task body Sum_Thread is
      Additions : Long_Long_Integer := 0; -- Counter for the number of additions
      Sum : Long_Long_Integer := 0; -- Accumulator for the sum
   begin
      loop
         exit when Can_Stop; -- Exit loop if Can_Stop is True
         Sum := Sum + (Additions * Step); -- Calculate the sum
         Additions := Additions + 1; -- Increment the counter
      end loop;

      -- Print the result of the thread
      Ada.Text_IO.Put_Line("Thread " & ID'Img & " - Sum: " & Sum'Img & " - Additions: " & Additions'Img);
   end Sum_Thread;

   B1 : Stop_Thread; -- Instantiate the stopping thread

   Threads : array(1..6) of access Sum_Thread; -- Array to hold references to Sum_Thread tasks
begin
   -- Create six Sum_Thread tasks
   for I in 1..6 loop
      Threads(I) := new Sum_Thread(I);
   end loop;
end Main;
