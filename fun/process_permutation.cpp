/*
根据高密度区域的抽样点来计算对应该的低密度区域的抽样点
基本功能为：
    根据输入的抽样点和数据集（低密度）
	从抽样点数据中找到相应的数据集中的点，同时滤除重复的点，然后
	返回三个值，第一个为重新排序后的数据点（将属于数据集的点排到后面）
	第二个为，数据集中滤除重复点之后的数据点
	第三个为，数据集中对应的那个permutation
	Date. 2010.7.15
	Ins. wisdom.dlut.edu.cn
*/

#include "mex.h"
#include "matrix.h"
#include "stdio.h"
#define DEBUG
#define PRECISION 1E-30
bool positive(double a)
{
	if( a < PRECISION && a > -PRECISION)
		return true;
	return false;
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray*prhs[])
{
	int n;
	if(nlhs < 3)
	{
		mexErrMsgTxt("Too few output arguments.");
		return;
	}
	if( nrhs != 2)
	{
		mexErrMsgTxt("Two parameters should be provided.");
		return ;
	}

	/*对于稀疏矩阵，暂且不予考虑*/
	if(!mxIsSparse(prhs[0]) && !mxIsSparse(prhs[1]))
	{
		const int*dims_sample = mxGetDimensions(prhs[0]);//得到抽样点的相关维度 
		const int*dims_data = mxGetDimensions(prhs[1]);//得到数据集的相关维度
		int i,j,k=0,height_sample,width_sample,height_data,width_data;
		height_sample = dims_sample[0],width_sample = dims_sample[1];
		height_data = dims_data[0], width_data = dims_data[1];
		if(width_sample != width_data)
		{
			mexErrMsgTxt("The dimension of the sample points and the dataset must be the same");
			return;
		}
		//假设输入数据集都是double型的，否则会出错,得到数据指针
		double* ptr_sample = (double*)mxGetPr(prhs[0]);
		double* ptr_data = (double*) mxGetPr(prhs[1]);
		
		bool*flag = (bool*) mxCalloc(height_data,sizeof(bool));
		plhs[0] = mxCreateDoubleMatrix(height_sample,width_sample,mxREAL);
		plhs[2] = mxCreateDoubleMatrix(height_data,1,mxREAL);
		double* ptr_sample_o = mxGetPr(plhs[0]);
		double* ptr_perm = mxGetPr(plhs[2]);
		int count= 0,dup = 0,perm= 0;
		for(i = 0; i<height_sample; i++)
		{
			for(j = 0; j<height_data; j++)
			{
				k = 0;
				if(flag[j] == true)
					continue;
				if(positive(ptr_sample[i] - ptr_data[j]))
				{
					//下面比较其他属性
					for(k = 1; k<width_sample; k++)
					{
						if(!positive(ptr_sample[k*height_sample + i]-ptr_data[k*height_data+j]))
							break;
					}
				}
				if (k == width_sample)//出现重复
				{
					flag[j] = true;
					ptr_perm[perm++] = j+1;
					dup++;
					break;
				}
			}	
			if(j==height_data)//没有出现重复
			{
				for(k = 0; k<width_sample; k++)
					ptr_sample_o[height_sample*k + count] = ptr_sample[height_sample*k + i];
				count++;
			}
		}
		//将重复的复制到输出中
		plhs[1] = mxCreateDoubleMatrix(height_data-dup,width_data,mxREAL);
		double* ptr_data_o = mxGetPr(plhs[1]);
		j = 0;
		for(i = 0; i< height_data; i++)
		{
			if(flag[i])//是重复的数据
			{
				for( k = 0; k<width_sample;k++)
					ptr_sample_o[height_sample*k + count] = ptr_data[height_data*k+i];
				count++;
			}
			else
			{
				for( k = 0; k<width_sample;k++)
					ptr_data_o[(height_data-dup)*k + j] = ptr_data[height_data*k+i];
				j++;
				ptr_perm[perm++] = i+1;
			}
		}
		return;
	}
	else
	{
		mexErrMsgTxt("Sparse matrix is not considered now, the work will be implemented later");
		return;
	}
}