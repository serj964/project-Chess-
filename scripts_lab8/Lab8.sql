--1: ����� ���� ������, ��������� ����������� ������������� ���� ������
SELECT name
FROM sysobjects  --c������� ���� ������ ��� ������� �������, ���������� ������ ���� ������, ������, ��� �����������, �������� �� ���������, ������, ������� � �������� ���������
WHERE xtype = 'U' --���; � ������ ������ ���������������� �������
AND uid = (SELECT uid FROM sysusers WHERE name = 'dbo') --uid - ������������� ����� ���������; sysusers �������� �� ����� ������ ��� ������� Microsoft ������������ Windows, ������ Windows, Microsoft SQL Server ������������, ��� SQL Server ���� � ���� ������; dbo - ����� �� ���������, � ������������ �������������
														--dbo, guest, sys, INFORMATION_SCHEMA <--- �� �����. ��������� ��� ��������������� ��� ��������� ��������, � ���� ������ ������ ��������� � ������� �������
AND sysobjects.id NOT IN (SELECT major_id FROM sys.extended_properties 
where name = 'microsoft_database_tools_support') --������������� ��������, ��� �������� ���������� ����������� ��������, ���������������� � ������������ � ��� �������; �������� ����������� �������
																		--������: ���� ������ - 0; ������ - 7; ������ ��� ������� - 1; �������� - 2
 

--2: ��� �������, ��� ������� �������, ������� ����, ��������� �� ������ ������� NULL-��������, �������� ���� ������ ������� �������, ������ ����� ���� ������ - ��� ���� ������, ��������� ����������� ������������� ���� ������ � ���� �� ��������
SELECT tabl.name AS [table], col.name AS [column], isnullable, type.name AS [type], type.length AS [length]  
FROM sysobjects tabl, syscolumns col, systypes [type] --���������� �� ����� ������ �� ������ �� �������� ���� ������ � ������������� � �� ����� ������ �� ������ �� ���������� �������� �������� � ���� ������; �������� �� ����� ������ ��� ������� ����� ���� ������
WHERE tabl.id = col.id
AND col.xtype = type.xtype
AND tabl.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')
AND tabl.xtype = 'U'
AND tabl.id NOT IN (SELECT major_id FROM sys.extended_properties)

	 	
--3: �������� ����������� ����������� (��������� � ������� �����), ��� �������, � ������� ��� ���������, ������� ����, ��� ��� �� ����������� ('PK' ��� ���������� ����� � 'F' ��� ��������) - ��� ���� ����������� �����������, ��������� ����������� ������������� ���� ������
SELECT keys.name AS key_name, keys.xtype AS key_type, key_table.name AS key_table
FROM sysobjects keys, sysobjects key_table
WHERE keys.xtype in ('F','PK') --������� ���� � ���������
AND keys.parent_obj = key_table.id
AND key_table.xtype = 'U'
AND keys.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')


--4: �������� �������� �����, ��� �������, ���������� ������� ����, ��� �������, ���������� ��� ������������ ���� - ��� ���� ������� ������, ��������� ����������� ������������� ���� ������
SELECT fkey.name AS foreign_key, ftab.name AS foreign_key_table, ptab.name AS primary_key_table
FROM sysobjects fkey, sysobjects ftab, sysobjects ptab, sysreferences ref --�������� ������������� ����������� FOREIGN KEY �� ���������, ����������� ��������� ������ ������ ���� ������
WHERE fkey.xtype = 'F' --������� ����
AND ftab.xtype = 'U' --���������������� �������
AND ptab.xtype = 'U'
AND fkey.id = ref.constid --������������� ����������� FOREIGN KEY
AND ftab.id = ref.fkeyid --�����������
AND ptab.id = ref.rkeyid --���������
AND fkey.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')


--5: �������� �������������, SQL-������, ��������� ��� ������������� - ��� ���� �������������, ��������� ����������� ������������� ���� ������
SELECT obj.name AS [view], com.text AS [query]
FROM sysobjects obj, syscomments com
WHERE obj.xtype = 'V' --�������������
AND obj.id = com.id
AND obj.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')


--6: �������� ��������, ��� �������, ��� ������� ��������� ������� - ��� ���� ���������, ��������� ����������� ������������� ���� ������
SELECT obj1.name AS trigger_name, obj2.name AS table_name
FROM sysobjects obj1, sysobjects obj2
WHERE obj1.xtype = 'TR' --�������
AND obj1.parent_obj = obj2.id --������������� ������������� �������. ��������, ������������� �������, ���� ��� ������� ��� �����������
AND obj1.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')



--��������� sys.extended_properties
--������� ����
--������� ������ � ������
