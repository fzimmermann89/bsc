#ifdef wip
__global__ void conv_col(const int N, const double *data, double *out)
{
    //über y=1:n bei festem x aus 1..2N
    
    
    int x = (blockIdx.x * blockDim.x) + threadIdx.x;
    int y = (blockIdx.y * blockDim.y) + threadIdx.y;
    int inpos=x*N + 2*y;
    int sharepos=threadIdx.y*2+1;
//     const int size = blockDim.y*2+1;
    if (x<2*N&&y<N) {
#ifdef shared
        extern  __shared__ double in[];
        if (y==0)in[0]=((blockIdx.y>0)?data[inpos-1]:0);
        in[sharepos]=data[ inpos];
        in[sharepos+1]=data[ inpos+1];
        __syncthreads();
        
        double prev=in[sharepos-1];
        double center=in[sharepos];
        double next=in[sharepos+1];
        
#else
        double prev= y>0?data[x*N + 2 * y-1]:0;
        double center = data[ x*N + 2*y];
        double next = data[x*N + 2 * y];
#endif
        
        
        
        out[x*N + y] =(prev+2*center+next) /((y>0)+3);
        
    }
}


__global__ void conv_row(const int N, const double *data, double *out)
{
    
    //über x=1:n bei festem y aus 1..n
    
    
    int x = (blockIdx.x * blockDim.x) + threadIdx.x;
    int y = (blockIdx.y * blockDim.y) + threadIdx.y;
    
    
    
// 	if (x<N&&y<N) {
    double prev= x>0?data[(x*2-1)*N + y]:0;
    double center = data[x*2*N + y];
    double next = data[(x*2-1)*N +  y];
    out[x*N + y] = (prev+2*center+next)/((x>0)+3);
//         out[x*N + y]=center;
// 	}
}
#endif
__global__ void halfimage(const int N, const double *data, double *out)
{
    const int x = (blockIdx.x * blockDim.x) + threadIdx.x;
    const int y = (blockIdx.y * blockDim.y) + threadIdx.y;
    if (x<N&&y<N) {
        const int N2=2*N;
        const int x2=x*2;
        const int y2=y*2;
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
        
        out[x*N + y]=(left+2*center+right)/((x>0)?4:3);
    }
}