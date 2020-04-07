srcPath = fullfile(pwd, 'dll', 'neuralnetas')

if ispc
    cuPath = gentenv('CUDA_PATH');
    cudaLibPath = fullfile(cuPath, 'lib', 'x64');
    cudaIncPath = fullfile(cuPath, 'include');
    
    cudnnPath = getenv('NVIDIA_CUDNN');
    cudnnIncPath = fullfile(cudnnPath, 'include');
    cudnnLibPath = fullfile(cudnnPath, 'lib');
    
    libs = {'cublas.lib', 'cudnn.lib'}
    
else
    cuPath = '/mathworks/hub/3rdparty/R2019b/2096789/glnx64/CUDA'
    cudaLibPath = fullfile(cuPath, 'lib', 'x64');
    cudaIncPath = fullfile(cuPath, 'include');
    
    cudnnPath =getenv('NVIDIA_CUDNN');
    cudnnIncPath = fullfile(cudnnPath, 'include');
    cudnnLibPath = fullfile(cudnnPath, 'lib');
    
    libs = {'cublas.lib', 'cudnn.lib'}
end

headerPath = {srcPath;cuddnIncPath;cudaIncPath};
libPath = {srcPath;cudnnLibPath;cudaLibPath};

def = legacy_code('initialize');
def.SFunctionName = 'neuralnetas';
def.OutputFcnSpec = 'void neuralnetas(double vQ[0.1], double wQ[0.1], double vref[0.1], double wref[0.1])'
def.IncPaths = headerPath;
def.HeaderFiles = {'neuralnetas.h'}
def.LibPaths = libPath;
def.HostLibFiles = libs;
def.Options.useTlcWithAccel = false;
def.Options.language = 'C++';

legacy_code('sfcn_cmex_generate', def);
legacy_code('compile', def);


