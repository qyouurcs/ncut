/*
	根据一个permutation将原始的数据复原，其中列顺序被打乱了，行顺序不变
	例子：
	如果 A = B(perm,:);
	     现在是已知 B和perm，回过来求A
	输入：要复原的数据 B ，一个permutation perm
	输出：B
	date: 2010.5.6
	Ins. wisdom @ dlut.edu.cn
*/
#include "mex.h"
#include "matrix.h"
#include<stdio.h>
#include<stdlib.h>
void mexFunction(int nlhs,mxArray*plhs[],int nrhs,mxArray*prhs[])
{
	if(nrhs != 2)
	{
		mexErrMsgTxt("two input parameters are required");
		return;
	}
	
	if( !mxIsInt32(prhs[1]))	
	{
		mexErrMsgTxt("The second parameter must be a type of int32");
		return;
	}
	if( mxGetDimensions(prhs[0])[0] != mxGetM(prhs[1])*mxGetN(prhs[1]))
	{
		mexErrMsgTxt("The number of elements in parameter 2 must equals the rows of parameter 1");
		return;
	}
	if( nlhs != 1)
	{
		mexErrMsgTxt("At most and at least one output parameter is needed");
		return;
	}
	const int* dimensions = (int*) mxGetDimensions(prhs[0]);
	
	int rows,columns,i,j;
	rows = dimensions[0];
	columns = dimensions[1];
	plhs[0] = mxDuplicateArray(prhs[0]);
	bool* visited = (bool*) mxCalloc(rows,sizeof(bool));
	double* ptr = (double*) mxGetPr(plhs[0]);
	double* optr = (double*) mxGetPr(prhs[0]);
	int* perm = (int*) mxGetPr(prhs[1]);
	/*Copy data*/
	for( i = 0; i < rows; i++)
	{
		if( visited[i] )
		{
			mexErrMsgTxt("there are duplicate values in the permutation!");
			return;
		}
		visited[i] = true;
		/*将prhs[0]的第i 行copy到 plhs[0]的第perm[i]-1行*/
		for( j = 0; j < columns; j++)
		{	
			ptr[j*rows+perm[i]-1] = optr[j*rows + i];
		}
	}
	mxFree(visited);
	return;
}