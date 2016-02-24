__global__ void inpoly(const int N, const float *vertx, const float *verty,const int nv, bool *out )
{
    int x = (blockIdx.x * blockDim.x) + threadIdx.x;
    int y = (blockIdx.y * blockDim.y) + threadIdx.y;
    if (x<N&&y<N){
        bool inpoly=false;
        
        for (int i = 0, j = nv-1; i < nv; j = i++) {
            if ( ((verty[i]>y) != (verty[j]>y)) &&
                    //inside verty range
                    (x < (vertx[j]-vertx[i]) * (y-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
            {
                inpoly = !inpoly;
            }
        }
        out[x*N+y]=inpoly;
    }
}
