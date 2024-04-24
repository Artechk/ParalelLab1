using System;
using System.Threading;


namespace Lab1c_
{
    class Program
    {
        static void Main(string[] args)
        {
            (new Program()).Start();
        }

        private const int SequencesCount = 150; // Кiлькiсть потокiв для обчислення послiдовностей
        private const int SequenceStep = 1; // Крок послiдовностi

        private bool[] threadsFinished = new bool[SequencesCount]; // Масив для вiдстеження завершення потокiв

        void Start()
        {
            for (int i = 0; i < SequencesCount; i++)
            {
                int threadIndex = i; // Зберiгаємо iндекс потока для використання в замиканнi
                (new Thread(() => Work(threadIndex))).Start();
            }

            (new Thread(Stoper)).Start();
        }

        void Work(int threadIndex)
        {
            long sum = 0;
            int currentValue = 0;

            do
            {
                sum += currentValue;
                currentValue += SequenceStep;
                Thread.Sleep(100);
            } while (!threadsFinished[threadIndex]);

            Console.WriteLine($"Потiк {threadIndex + 1}: сума = {sum}, кiлькiсть елементiв = {(sum / SequenceStep) + 1}");
        }

        public void Stoper()
        {
            //Thread.Sleep(2 * 1000); // Затримка перед завершенням
            for (int i = 0; i < SequencesCount; i++)
            {
                Thread.Sleep(100);
                threadsFinished[i] = true; // Позначаємо, що потiк завершив роботу
            }
        }
    }
}
