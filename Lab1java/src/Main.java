public class Main {
    private static final int SequencesCount = 150; // Кількість потоків для обчислення послідовностей
    private static final int SequenceStep = 1; // Крок послідовності

    private boolean[] threadsFinished = new boolean[SequencesCount]; // Масив для відстеження завершення потоків

    public static void main(String[] args) {
        new Main().start();
    }

    private void start() {
        for (int i = 0; i < SequencesCount; i++) {
            final int threadIndex = i; // Зберігаємо індекс потока для використання в замиканні
            new Thread(() -> work(threadIndex)).start();
        }

        new Thread(this::stopper).start();
    }

    private void work(int threadIndex) {
        long sum = 0;
        int currentValue = 0;

        do {
            sum += currentValue;
            currentValue += SequenceStep;
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        } while (!threadsFinished[threadIndex]);

        System.out.println("Потік " + (threadIndex + 1) + ": сума = " + sum + ", кількість елементів = " + ((sum / SequenceStep) + 1));
    }

    private void stopper() {

        for (int i = 0; i < SequencesCount; i++) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            threadsFinished[i] = true; // Позначаємо, що потік завершив роботу
        }
    }
}
