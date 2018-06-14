load phasemat;
fid=fopen('A110.HIFU','wb+') ;  %以二进制数据写入方式打开文件
z=zeros(1024,1);
fwrite(fid,z);
fwrite(fid,phasemat');
fclose(fid);

