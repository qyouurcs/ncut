/*
	最简单的求k近邻的方法，主要是考虑到Matlab在处理循环时效率可能会比较低
	输入：数据集A；
	       数据集B；
		   近邻数目k
    输出：近邻位置矩阵N
	从集合A中找出集合B中的元素的k近邻
	Ins. wisdom@dlut.edu.cn
	Date: 2010.5.13
*/
#include "mex.h"
#include "matrix.h"
#include <stdlib.h>

#define A prhs[0]
#define B prhs[1]
#define Output plhs[0]

int comp(const void* a,const void* b)
{
	return *((double*)a) - *((double*)b);
}
void mexFunction(int nlhs, mxArray*hlps[],int nrhs,const mxArray* prhs[])
{
	if ( nrhs < 3)
	{
		mexErrMsgTxt("At least three parameters should be provided");
		return;
	}
	if(mxIsSparse(A) || mxIsSparse(B))
	{
		mexErrMsgTxt("The matrix of A and B should not be a sparse one, it's not supported yet!");
		return;
	}
	const int* dimensionA = mxGetDimensions(A);
	const int* dimensionB = mxGetDimensions(B);
	int i,j,k;
	if( dimensionA[1] != dimensionB[1])
	{
		mexErrMsgTxt("The dimension of row vector of A and B must be equal");
	}
	double* dist = (double*)mxCalloc(dimensionB[0] * dimensionA[0],sizeof(double));
	double* ptrA = (double*)mxGetPr(A);
	double* ptrB = (double*)mxGetPr(B);
	/*Calc distance*/
	
	for(i = 0; i< dimensionB[0]; i++)
		for( j = 0; j< dimensionA[0]; j++)
		{
			for( k = 0; k < dimensionA[1]; k++)
				dist[i*dimensionA[0] + j] = (ptrA[k*dimensionA[0] + j] - ptrB[k*dimensionB[0] + j])*(ptrA[k*dimensionA[0] + j] - ptrB[k*dimensionB[0] + j]);
		}
	for( i = 0; i< dimensionB[0];i++)
	return ;
}
