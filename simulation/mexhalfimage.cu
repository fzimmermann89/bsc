#include "mex.h"
#include "gpu/mxGPUArray.h"

/*
 * Device code
 */

__global__ void halfimage( int const N2, double const * const data, double * const out)
{
    const int x = (blockIdx.x * blockDim.x) + threadIdx.x;
    const int y = (blockIdx.y * blockDim.y) + threadIdx.y;
    const int x2=x*2;
    const int y2=y*2;
    
    if (x2<N2&&y2<N2) {
        double left=0;
        if (x>0){
            left=(2*data[(x2-1)*N2+y2]+data[(x2-1)*N2+y2+1]);
            if (y>0)left+=data[(x2-1)*N2+y2-1];
        }
        if (y>0)left=left/4;else left=left/3;
        
        double   center=(2*data[x2*N2+y2]+data[x2*N2+y2+1]);
        if (y>0) center+=data[x2*N2+y2-1];
        if (y>0) center=center/4; else center=center/3;
        
        double   right=(2*data[(x2+1)*N2+y2]+data[(x2+1)*N2+y2+1]);
        if (y>0) right+=data[(x2+1)*N2+y2-1];
        if (y>0) right=right/4;else right=right/3;
        
        out[x*N2/2 + y]=(left+2*center+right)/((x>0)?4:3);
    }
}

/*
 * Host code
 */
void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, mxArray const *prhs[])
{
    mxGPUArray const *A;
    mxGPUArray *B;
    double const *d_A;
    double *d_B;
    
    mxInitGPU();
    
    if ((nrhs!=1) || (nlhs!=1)) {
        mexErrMsgTxt("%d Expected one input and one output");
    }
    
    A = mxGPUCreateFromMxArray(prhs[0]);
    
    if (mxGPUGetClassID(A) != mxDOUBLE_CLASS) {
        mexErrMsgTxt("input must be double");
    }
    
    d_A = (double const *)(mxGPUGetDataReadOnly(A));
    int N = (int)(mxGPUGetNumberOfElements(A));
    
    int  ndims=mxGPUGetNumberOfDimensions(A);
    mwSize dimso[2]={0,0};
    switch (ndims) {
        case 1:
            dimso[0] = N/2;
            break;
        case 2:
            dimso[0]=mxGPUGetDimensions(A)[0]/2;
            dimso[1]=mxGPUGetDimensions(A)[1]/2;
            break;
        default:
            mexErrMsgTxt("input be 2d");
    }
    
    B = mxGPUCreateGPUArray(ndims,
            dimso,
            mxGPUGetClassID(A),
            mxGPUGetComplexity(A),
            MX_GPU_DO_NOT_INITIALIZE);
    d_B = (double *)(mxGPUGetData(B));
    
    int dimN=(int)floor(sqrt((double)N));
    dim3 threadsPerBlock(8, 8);
    dim3 numBlocks((int)ceil((double)(dimN/2)/ threadsPerBlock.x), (int)ceil((double)(dimN/2) / threadsPerBlock.y));
    
    halfimage<<<numBlocks, threadsPerBlock>>>(dimN,d_A, d_B);
    
    plhs[0] = mxGPUCreateMxArrayOnGPU(B);
    
    mxGPUDestroyGPUArray(A);
    mxGPUDestroyGPUArray(B);
}
