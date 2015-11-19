/*
	计算图像的x^2-distance.
	A 和 B分别是行和列对应的像素的坐标.
	输入：灰度值的图像的像素矩阵；
	       集合A;
		   集合B;
		   窗函数大小n；
		   调色板,颜色值须从小到大排顺序;
    输出：[dist] 
	       x^2-distance.
	date: 2010.4.30
	Ins. wisdom.dlut.edu.cn
	
*/

#include "mex.h"
#include "matrix.h"
#include "stdio.h"
//#define DEBUG
#define PRECISION 1E-10
/*some type definition*/
typedef unsigned char COLOR;
typedef unsigned char*PCOLOR;
typedef unsigned char**PPCOLOR;
typedef int POSTYPE;
typedef int*PPOSTYPE; 

int** boardx,**boardy,numofcolor;
PCOLOR colors;
PCOLOR pix;
/*
	calc histograms,
	if pixelsposA or pixelsposB  is NULL, means A is all the data points or B is all the data points, or both of them are.
*/
void calc_histograms(double**histograms,PPOSTYPE pixelspos,int numpixels,PCOLOR pixels,int n,int width,int height);
double* calc_tao_distance(double**histogramsA,double**histogramsB,int numpixelsA,int numpixelsB,int numofcolor);

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray*prhs[])
{
	int n;
	if(nlhs < 1)
	{
		mexErrMsgTxt("Too few output arguments.");
		return;
	}
	if( nrhs < 5)
	{
		mexErrMsgTxt("At least five parameters should be provided.");
		return ;
	}
	/*参数类型核对*/
	if(!mxIsUint8(prhs[0]))/*像素值必须是0-255之间*/
	{
		mexErrMsgTxt("The pixels must be a type of uint8");
		return;
	}
	if(!mxIsEmpty(prhs[1]) && !mxIsInt32(prhs[1]))
	{
		mexErrMsgTxt("The position type must be int32");
		return;
	}
	if(!mxIsEmpty(prhs[2]) && !mxIsInt32(prhs[2]))
	{
		mexErrMsgTxt("The position type must be int32");
		return;
	}
	if((!mxIsEmpty(prhs[1]) && mxGetDimensions(prhs[1])[1]!= 2) ||(!mxIsEmpty(prhs[2]) && mxGetDimensions(prhs[2])[1]!= 2))
	{
		mexErrMsgTxt("The position set must be a matrix of n times 2");
		return ;
	}
	if(!mxIsInt32(prhs[3]))
	{
		mexErrMsgTxt("The windows size must be int32");
		return ;
	}
	if(!mxIsUint8(prhs[4]))
	{
		mexErrMsgTxt("The color board must be a type of uint8");
		return;
	}
	n =(int) mxGetScalar(prhs[3]);/*size of window*/
	if( n%2==0)
	{
		mexErrMsgTxt("The size of window must be an odd number.");
		return ;
	}

	/*对于稀疏矩阵，暂且不予考虑*/
	if(!mxIsSparse(prhs[0]))
	{
		const int*dims = mxGetDimensions(prhs[0]);

		int i,j,k,height,width;
		height = dims[0],width = dims[1];
		if( height <= n || width <= n)
		{
			mexErrMsgTxt("The size of image must be greater than the window size");
			return;
		}
		PCOLOR colorboard =(PCOLOR) mxGetPr(prhs[4]);
		int numpixelsA,numpixelsB;
		numofcolor = (int) mxGetNumberOfElements(prhs[4]);
		
		/*Note the max gray value is 255*/
		colors = (PCOLOR)mxCalloc(256,sizeof(COLOR));
		for( i = 0; i< numofcolor; i++)
			colors[(int)colorboard[i]] = i; 

		/*extract the pixels values*/
		pix = (PCOLOR)mxGetPr(prhs[0]);
	
		/*PPCOLOR pixels = (PPCOLOR) mxCalloc(height,sizeof(PCOLOR));
		for( i = 0; i < height; i++)
			pixels[i] = (PCOLOR)mxCalloc(width,sizeof(COLOR));*/

		boardx =(int**) mxCalloc(n,sizeof(int*));
		boardy = (int**) mxCalloc(n,sizeof(int*));
		for( i = 0; i < n; i++)
		{
			boardx[i] = (int*) mxCalloc(n,sizeof(int));
			boardy[i] = (int*) mxCalloc(n,sizeof(int));
		}

		k = n/2; 
		for( i = 0; i < n; i++)
			for( j = 0; j<n; j++)
			{
				boardx[i][j] = -k + i;
				boardy[i][j] = -k + j;
			}

		
		/*for( i = 0; i < height; i++)
			for(j = 0; j< width; j++)
			{
				pixels[i][j] = (COLOR)pix[i*width + j];
			}*/

	
		PPOSTYPE pixelsposA = NULL;
		if(!mxIsEmpty(prhs[1]))
		{
			pixelsposA = (PPOSTYPE)mxGetPr(prhs[1]);
			numpixelsA = mxGetDimensions(prhs[1])[0];/*sample size*/
		}
		else
			numpixelsA = height * width;
		PPOSTYPE pixelsposB = NULL;
		if(!mxIsEmpty(prhs[2]))
		{
			pixelsposB = (PPOSTYPE)mxGetPr(prhs[2]);
			numpixelsB = mxGetDimensions(prhs[2])[0];
		}
		else
			numpixelsB = height * width;
		
		/*Alloc memory for all the sample pixels to store their histograms*/
		double** histogramsA;
		double** histogramsB;
		if( pixelsposA == NULL && pixelsposB == NULL)
		{
			histogramsA =(double**) mxCalloc(numpixelsA,sizeof(double*));
			for( i = 0; i < numpixelsA; i++)	
				histogramsA[i] =(double*) mxCalloc(numofcolor,sizeof(double));
			histogramsB = histogramsA;
		}
		else
		{
			histogramsA =(double**) mxCalloc(numpixelsA,sizeof(double*));
			for( i = 0; i < numpixelsA; i++)
				histogramsA[i] =(double*) mxCalloc(numofcolor,sizeof(double));
			histogramsB = (double**) mxCalloc(numpixelsB, sizeof(double*));
			for( i = 0; i< numpixelsB; i++)
				histogramsB[i] = (double*) mxCalloc(numofcolor,sizeof(double));
		}
		if( pixelsposB== NULL && pixelsposA == NULL)
		{
			calc_histograms(histogramsA,pixelsposA,numpixelsA,pix,n,height,width);
		//	calc_histograms(histogramsB,pixelsposB,numpixelsB,pixels,n,height,width);
		}
		else
		{
			calc_histograms(histogramsA,pixelsposA,numpixelsA,pix,n,height,width);
			calc_histograms(histogramsB,pixelsposB,numpixelsB,pix,n,height,width);
#ifdef DEBUG
			{
				FILE* a = fopen("histogramA.txt","w+");
				FILE* b = fopen("histogramB.txt","w+");
				int i,j;
				for( i = 0;i<numpixelsA;i++)
				{
					for( j = 0; j<numofcolor; j++)
						fprintf(a,"%.10lf\t\t",histogramsA[i][j]);
					fprintf(a,"\n");
				}
				for( i = 0;i<numpixelsB;i++)
				{
					for( j = 0; j<numofcolor; j++)
						fprintf(b,"%.10lf\t\t",histogramsB[i][j]);
					fprintf(b,"\n");
				}
				fclose(a);
				fclose(b);
			}
#endif
		}

		/*Free Memory*/
		mxFree(colors);
		
		/*for( i = 0; i < height; i++)
			 mxFree(pixels[i]);
		mxFree(pixels);*/

		for( i = 0; i < n; i++)
		{
			mxFree(boardx[i]);
			mxFree(boardy[i]);
		}
		mxFree(boardx);
		mxFree(boardy);
		
		/*Now calc the x^2 distance.*/
		/*double* ptr = mxGetPr(plhs[0]);
		mxFree(ptr);*/
		plhs[0] = mxCreateDoubleMatrix(1, 2, mxREAL);
		mxFree(mxGetPr(plhs[0]));
		double* nptr = calc_tao_distance(histogramsA,histogramsB,numpixelsA,numpixelsB,numofcolor);
		/*Free mem*/

	
		for( i = 0; i< numpixelsA; i++)
			mxFree(histogramsA[i]);
		mxFree(histogramsA);
		if( !(pixelsposB== NULL && pixelsposA == NULL))
		{
			for( i = 0; i< numpixelsB; i++)
				mxFree(histogramsB[i]);
			mxFree(histogramsB);
		}
		
		mxSetPr(plhs[0],nptr);
		mxSetM(plhs[0],numpixelsA);
		mxSetN(plhs[0],numpixelsB);
		
	}
	else
	{
		mexErrMsgTxt("The color pixels matrix should not be a sparse one!");
	}
	return;
}
void calc_histograms(double**histograms,PPOSTYPE pixelspos,int numpixels,PCOLOR pixels,int n,int width,int height)
{
	/*Now calc the histograms*/
	int win_size = n*n;
	int i,j,k,nr,nc,r,c;
	if( pixelspos != NULL)
	{
		for( i = 0; i < numpixels; i++)
		{
			r = pixelspos[i];
			c = pixelspos[numpixels+i];

			for( j = 0; j < n; j++)
				for( k = 0; k<n; k++)
				{
					nr = r + boardx[j][k];
					nc = c + boardy[j][k];

					if( nr < 0 ) nr += n; else if( nr > height ) nr -= n;
					if( nc < 0 ) nc += n; else if( nc > width ) nc -= n;
					
					histograms[i][colors[pixels[nc*width+nr]]] += 1;

				}
			for( j = 0; j < numofcolor; j++)
			{
				histograms[i][j] = histograms[i][j] / win_size;
				if( histograms[i][j] == 0)
						histograms[i][j] = PRECISION;
			}
		}
	}
	else
	{
		i = 0;
		for( r = 0; r < height; r++)
		{
			for( c = 0; c < width; c++)
			{
				for( j = 0; j < n; j++)
					for( k = 0; k<n; k++)
					{
						nr = r + boardx[j][k];
						nc = c + boardy[j][k];

						if( nr < 0 ) nr += n; else if( nr > height ) nr -= n;
						if( nc < 0 ) nc += n; else if( nc > width ) nc -= n;
						
						histograms[i][colors[pixels[nc*width + nr]]] += 1;

					}
				for( j = 0; j < numofcolor; j++)
				{
					histograms[i][j] = histograms[i][j] / win_size;
					//#ifdef DEBUG
					if( histograms[i][j] == 0)
						histograms[i][j] = PRECISION;
					//#endif
				}
				i++;
			}
		}
	}
}
double* calc_tao_distance(double**histogramsA,double**histogramsB,int numpixelsA,int numpixelsB,int numofcolor)
{
	int i,j,k;
	double* nptr = (double*)mxCalloc(numpixelsA*numpixelsB,sizeof(double));	
	for( i = 0; i< numpixelsA; i++)
		for( j = 0; j< numpixelsB; j++)
		{
			for( k = 0; k< numofcolor; k++)
				nptr[j*numpixelsA+i] += (histogramsA[i][k] - histogramsB[j][k]) * (histogramsA[i][k] - histogramsB[j][k])/(histogramsA[i][k] + histogramsB[j][k]);
			nptr[j*numpixelsA + i] *= 0.5;
		}
	return nptr;
}