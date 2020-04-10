--1: имена всех таблиц, созданных назначенным пользователем базы данных
SELECT name
FROM sysobjects  --cодержит одну строку для каждого объекта, созданного внутри базы данных, такого, как ограничение, значение по умолчанию, журнал, правило и хранимая процедура
WHERE xtype = 'U' --тип; в данном случае пользовательская таблица
AND uid = (SELECT uid FROM sysusers WHERE name = 'dbo') --uid - идентификатор схемы владыльца; sysusers содержит по одной строке для каждого Microsoft пользователя Windows, группа Windows, Microsoft SQL Server пользователя, или SQL Server роли в базе данных; dbo - схема по умолчанию, и пользователь соответсвенно
														--dbo, guest, sys, INFORMATION_SCHEMA <--- на выбор. последние две зарезервированы для системных обхектов, в этих схемах нельзя создавать и удалять объекты
AND sysobjects.id NOT IN (SELECT major_id FROM sys.extended_properties 
where name = 'microsoft_database_tools_support') --идентификатор элемента, для которого определено расширенное свойство, интерпретируемый в соответствии с его классом; собрание расширенных свойств
																		--классы: база данных - 0; индекс - 7; объект или столбец - 1; параметр - 2
 

--2: имя таблицы, имя столбца таблицы, признак того, допускает ли данный столбец NULL-значения, название типа данных столбца таблицы, размер этого типа данных - для всех таблиц, созданных назначенным пользователем базы данных и всех их столбцов
SELECT tabl.name AS [table], col.name AS [column], isnullable, type.name AS [type], type.length AS [length]  
FROM sysobjects tabl, syscolumns col, systypes [type] --возвращает по одной строке на каждый из столбцов всех таблиц и представлений и по одной строке на каждый из параметров хранимых процедур в базе данных; Содержит по одной строке для каждого файла базы данных
WHERE tabl.id = col.id
AND col.xtype = type.xtype
AND tabl.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')
AND tabl.xtype = 'U'
AND tabl.id NOT IN (SELECT major_id FROM sys.extended_properties)

	 	
--3: название ограничения целостности (первичные и внешние ключи), имя таблицы, в которой оно находится, признак того, что это за ограничение ('PK' для первичного ключа и 'F' для внешнего) - для всех ограничений целостности, созданных назначенным пользователем базы данных
SELECT keys.name AS key_name, keys.xtype AS key_type, key_table.name AS key_table
FROM sysobjects keys, sysobjects key_table
WHERE keys.xtype in ('F','PK') --внешний ключ и первичный
AND keys.parent_obj = key_table.id
AND key_table.xtype = 'U'
AND keys.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')


--4: название внешнего ключа, имя таблицы, содержащей внешний ключ, имя таблицы, содержащей его родительский ключ - для всех внешних ключей, созданных назначенным пользователем базы данных
SELECT fkey.name AS foreign_key, ftab.name AS foreign_key_table, ptab.name AS primary_key_table
FROM sysobjects fkey, sysobjects ftab, sysobjects ptab, sysreferences ref --содержит сопоставления определений FOREIGN KEY со столбцами, являющимися объектами ссылок внутри базы данных
WHERE fkey.xtype = 'F' --внешний ключ
AND ftab.xtype = 'U' --пользовательская таблица
AND ptab.xtype = 'U'
AND fkey.id = ref.constid --идентификатор ограничения FOREIGN KEY
AND ftab.id = ref.fkeyid --ссылающаяся
AND ptab.id = ref.rkeyid --ссылаемая
AND fkey.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')


--5: название представления, SQL-запрос, создающий это представление - для всех представлений, созданных назначенным пользователем базы данных
SELECT obj.name AS [view], com.text AS [query]
FROM sysobjects obj, syscomments com
WHERE obj.xtype = 'V' --представление
AND obj.id = com.id
AND obj.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')


--6: название триггера, имя таблицы, для которой определен триггер - для всех триггеров, созданных назначенным пользователем базы данных
SELECT obj1.name AS trigger_name, obj2.name AS table_name
FROM sysobjects obj1, sysobjects obj2
WHERE obj1.xtype = 'TR' --триггер
AND obj1.parent_obj = obj2.id --идентификатор родительского объекта. Например, идентификатор таблицы, если это триггер или ограничение
AND obj1.uid = (SELECT uid FROM sysusers WHERE name = 'dbo')



--исправить sys.extended_properties
--вывести роли
--вывести логины и юзеров
