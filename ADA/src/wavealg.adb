with Ada.Text_IO;
with Ada.Containers.Vectors;

procedure wavealg is
   Wave_Count : Integer := 1;
   Number_Count : Integer := 6;
   Size_Value : Float := Float(Number_Count);
   Count_Val : Integer := 0;

   procedure Calculate (Data: Integer);

   procedure Calculate (Data: Integer) is

      package Data_Vectors is new Ada.Containers.Vectors (Index_Type => Natural, Element_Type => Integer);
      use Data_Vectors;
      Array_Data : Data_Vectors.Vector;

      task type Wave_Task is
         entry Task_Start;
      end Wave_Task;

      type Task_Ptr is access all Wave_Task;
      type Task_Array is array (1..Data) of Task_Ptr;

      Tasks : Task_Array;

      task body Wave_Task is
         function Add_Sum (Num1, Num2 : Integer) return Integer is
         begin
            Ada.Text_IO.Put_Line (Integer'Image(Num1) & " + " & Integer'Image(Num2));
            return Num1 + Num2;
         end Add_Sum;
         Result : Data_Vectors.Vector;
         sum1 : Integer;

      begin
         accept Task_Start do
            Ada.Text_IO.Put("Початковий масив: [");
            for I in Array_Data.First_Index .. Array_Data.Last_Index loop
               Ada.Text_IO.Put(Integer'Image(Array_Data(I)));
               if I /= Array_Data.Last_Index then
                  Ada.Text_IO.Put(", ");
               else
                  Ada.Text_IO.Put_Line("].");
               end if;
            end loop;

            Ada.Text_IO.Put_Line("Хвиля #" & Integer'Image(Wave_Count) & ":");
            Ada.Text_IO.Put_Line("Пари -");
            Wave_Count := Wave_Count + 1;

            for I in 1 .. (Integer(Array_Data.Length) + 1) / 2 loop
               if Integer(Array_Data.Length) = 1 then
                  Result.Append(Array_Data.First_Element);
                  Array_Data.Delete_First;
               else
                  sum1 := Add_Sum(Array_Data.First_Element, Array_Data.Last_Element);
                  Result.Append(sum1);
                  Array_Data.Delete_First;
                  Array_Data.Delete_Last;
               end if;
            end loop;

            Array_Data := Result;

            Ada.Text_IO.Put("Результат: [");

            for I in Array_Data.First_Index .. Array_Data.Last_Index loop
               Ada.Text_IO.Put(Integer'Image(Array_Data(I)));
               if I /= Array_Data.Last_Index then
                  Ada.Text_IO.Put(", ");
               else
                  Ada.Text_IO.Put_Line("] - актуальна частина");
               end if;
            end loop;

            Ada.Text_IO.New_Line;

            Result.Clear;
         end Task_Start;
      end Wave_Task;

   begin
      for I in 1 .. Number_Count loop
         Array_Data.Append(I);
      end loop;

      for I in Tasks'Range loop
         Tasks(I) := new Wave_Task;
         Tasks(I).Task_Start;
      end loop;
   end Calculate;

begin
   while Size_Value >= 1.0 loop
      Size_Value := Size_Value / 2.0;
      Count_Val := Count_Val + 1;
   end loop;

   Calculate(Count_Val);

end wavealg;