A65binname = 'A65NR.PHASE'
fid=fopen(A65binname,'wb+') ;  %�Զ���������д�뷽ʽ���ļ�
z=zeros(1024,1);
fwrite(fid,z);
fwrite(fid,phasemat');
fclose(fid);