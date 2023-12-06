package com.wavealg;

public class PairSumCalculator implements Runnable {
  private int[] array;
  private int startIndex;
  private int endIndex;
  private int[] result;
  private int wave;

  public PairSumCalculator(int[] array, int startIndex, int endIndex, int[] result, int wave) {
    this.array = array;
    this.startIndex = startIndex;
    this.endIndex = endIndex;
    this.result = result;
    this.wave = wave;
  }

  @Override
  public void run() {
    while (startIndex < endIndex) {
      int sum = array[startIndex] + array[endIndex];
      result[startIndex] = sum;
      startIndex++;
      endIndex--;
    }
  }
}
