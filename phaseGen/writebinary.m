load phasemat;
fid=fopen('A110.HIFU','wb+') ;  %�Զ���������д�뷽ʽ���ļ�
z=zeros(1024,1);
fwrite(fid,z);
fwrite(fid,phasemat');
fclose(fid);

