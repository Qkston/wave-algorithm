package com.wavealg;

import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class App {
  public static void main(String[] args) {
    int[] initialArray = { 1, 2, 3, 4, 5, 6 };
    int[] workingArray = initialArray.clone();
    int wave = 1;

    System.out.println("Initial array:");
    System.out.println(Arrays.toString(initialArray));

    while (workingArray.length > 1) {
      int[] resultArray = new int[(workingArray.length + 1) / 2];
      int mid = workingArray.length / 2;

      System.out.println("The " + wave + " wave:");
      System.out.println("Pairs:");

      ExecutorService executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
      boolean oddElement = workingArray.length % 2 != 0; // Check if there's an odd element left after pairs
      for (int i = 0; i < mid; i++) {
        int startIndex = i;
        int endIndex = workingArray.length - 1 - i;
        System.out.println(workingArray[startIndex] + " + " + workingArray[endIndex] + ";");
        executor.execute(new PairSumCalculator(workingArray, startIndex, endIndex, resultArray, wave));
      }

      // Handle an odd element if present
      if (oddElement) {
        resultArray[mid] = workingArray[mid]; // Copy the remaining element to the result array
      }

      executor.shutdown();
      try {
        executor.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }

      System.out.println("The result.");
      System.out.println(Arrays.toString(resultArray) + " - the actual part, ");

      // Prepare the next working array
      workingArray = resultArray;
      wave++;
    }

    System.out.println("Final sum: " + workingArray[0] + " is the sum of the array elements.");
  }
}
