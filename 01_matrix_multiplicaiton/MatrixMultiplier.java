//Author: Shuddhashil Ray
//Script : Java
//Description : Matrix Multiplication of two Matrices
//Date : 16-January-2015 01:00AM IST

import java.util.Scanner;
public class MatrixMultiplier {

  // Utility Method to return resultant Matrix from M1*M2
  public static double[][] compute_multiplication(double[][] matrix1, double[][] matrix2) {
    int row1 = matrix1.length;
    int column1 = matrix1[0].length;
    int row2 = matrix2.length;
    int column2 = matrix2[0].length;
    if (column1 != row2) throw new RuntimeException("The Matrices cannot be multiplied! Column Number of First Matrix should be equal to Row Number of Second Matrix.");
    double[][] result = new double[row1][column2];
    for (int i = 0; i < row1; i++)
    {
      for (int j = 0; j < column2; j++)
      {
        for (int k = 0; k < column1; k++)
        {
          result[i][j] += (matrix1[i][k] * matrix2[k][j]);
        }
      }
    }
    return result;
  }
  // Main Method
  public static void main(String args[])
  {
    int row=0,column=0,i=0,j=0;
    Scanner in = new Scanner(System.in);
    System.out.println("Enter Rows & Columns of Matrix 1: ");
    row = in.nextInt();
    column = in.nextInt();
    System.out.println("Enter values for Matrix 1: ");
    double[][] M1 = new double[row][column];
    for (i = 0; i < row; i++)
      for (j = 0; j < column; j++)
        M1[i][j] = in.nextDouble();

    System.out.println("Enter Rows & Columns of Matrix 2: ");
    row = in.nextInt();
    column = in.nextInt();
    System.out.println("Enter values for Matrix 2: ");
    double[][] M2 = new double[row][column];
    for (i = 0; i < row; i++)
      for (j = 0; j < column; j++)
        M2[i][j] = in.nextDouble();

    System.out.println("Computing Multiplication of Matrix 1 X Matrix 2 ...");
    double[][] result = MatrixMultiplier.compute_multiplication(M1,M2);
    System.out.println("Result:");
    for (i = 0; i < result.length; i++)
    {
      for (j = 0; j < result[0].length; j++)
      {
        System.out.print(result[i][j] + " ");
      }
      System.out.println();
    }
  }
}