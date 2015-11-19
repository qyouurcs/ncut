/*
���ݸ��ܶ�����ĳ������������Ӧ�õĵ��ܶ�����ĳ�����
��������Ϊ��
    ��������ĳ���������ݼ������ܶȣ�
	�ӳ������������ҵ���Ӧ�����ݼ��еĵ㣬ͬʱ�˳��ظ��ĵ㣬Ȼ��
	��������ֵ����һ��Ϊ�������������ݵ㣨���������ݼ��ĵ��ŵ����棩
	�ڶ���Ϊ�����ݼ����˳��ظ���֮������ݵ�
	������Ϊ�����ݼ��ж�Ӧ���Ǹ�permutation
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

	/*����ϡ��������Ҳ��迼��*/
	if(!mxIsSparse(prhs[0]) && !mxIsSparse(prhs[1]))
	{
		const int*dims_sample = mxGetDimensions(prhs[0]);//�õ�����������ά�� 
		const int*dims_data = mxGetDimensions(prhs[1]);//�õ����ݼ������ά��
		int i,j,k=0,height_sample,width_sample,height_data,width_data;
		height_sample = dims_sample[0],width_sample = dims_sample[1];
		height_data = dims_data[0], width_data = dims_data[1];
		if(width_sample != width_data)
		{
			mexErrMsgTxt("The dimension of the sample points and the dataset must be the same");
			return;
		}
		//�����������ݼ�����double�͵ģ���������,�õ�����ָ��
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
					//����Ƚ���������
					for(k = 1; k<width_sample; k++)
					{
						if(!positive(ptr_sample[k*height_sample + i]-ptr_data[k*height_data+j]))
							break;
					}
				}
				if (k == width_sample)//�����ظ�
				{
					flag[j] = true;
					ptr_perm[perm++] = j+1;
					dup++;
					break;
				}
			}	
			if(j==height_data)//û�г����ظ�
			{
				for(k = 0; k<width_sample; k++)
					ptr_sample_o[height_sample*k + count] = ptr_sample[height_sample*k + i];
				count++;
			}
		}
		//���ظ��ĸ��Ƶ������
		plhs[1] = mxCreateDoubleMatrix(height_data-dup,width_data,mxREAL);
		double* ptr_data_o = mxGetPr(plhs[1]);
		j = 0;
		for(i = 0; i< height_data; i++)
		{
			if(flag[i])//���ظ�������
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