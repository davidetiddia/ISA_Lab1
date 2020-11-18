#include<stdio.h>
#include<stdlib.h>

#define N 1 /// order of the filter 
#define NB 14  /// number of bits

const int b0 = 3447; /// coefficient b0
const int b1=  3447; /// b array
const int a1= -1298; /// a array

/// Perform fixed point filtering assuming direct form II
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
  static long long int sw[N+1]; /// w shift register
  static int first_run = 0; /// for cleaning the shift register
  int i; /// index
  long long int w; /// intermediate value (w)
  long long int y; /// output sample
  long long int ff, ff1, ff2, fff; /// feed-back and feed-forward results
  long long  int fb ;
  /// clean the buffer
  if (first_run == 0)
  {
    first_run = 1;
        sw [1] = 0;
      sw[0] = 0;
  }

  /// compute feed-back and feed-forward
  ff1 = 0;
  ff = 0;
  ff2= 0;
  fff = 0;
  fb = 0;
   
    ff  +=  (sw[0]*b1) >> (NB-1);
    ff1 -= (sw[0]*a1*b0) >> (2*NB-2);
    ff2 -= (sw[1]*a1*b1) >> (2*NB-2);
    fb  += (sw[1]*a1*a1) >> (2*NB -2);
    //printf("fb=%d , ff=%d \n", fb,ff);
  
fff = ff + ff1 + ff2;
  /// compute intermediate value (w) and output sample
  w = x + fb;
  y = (w*b0) >> (NB-1) ;

  y += fff;

  /// update the shift register
  sw[1] = sw[0];
  sw[0] = w;
 
  return y;
}

int main (int argc, char **argv)
{
  FILE *fp_in;
  FILE *fp_out;

  int x;
  int y;

  /// check the command line
  if (argc != 3)
  {
    printf("Use: %s <input_file> <output_file>\n", argv[0]);
    exit(1);
  }

  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n",argv[1]);
    exit(2);
  }
  fp_out = fopen(argv[2], "w");

  /// get samples and apply filter
  fscanf(fp_in, "%d", &x);
  do{
    y = myfilter(x);
    fprintf(fp_out,"%d\n", y);
    fscanf(fp_in, "%d", &x);
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);

  return 0;

}
