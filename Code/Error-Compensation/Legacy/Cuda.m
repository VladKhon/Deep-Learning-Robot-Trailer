cfg = coder.gpuConfig('mex');
cfg.TargetLang = 'C++';
cfg.GenerateReport = true;

copyfile(fullfile(pwd, 'codegen', 'dll',  'neuralnetas', 'neuralnetas.so'), pwd);