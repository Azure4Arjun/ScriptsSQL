/*
Script:			Kill Connections.SQL
Description:	How to a Kill many connections in a specified database
Reference:		https://stackoverflow.com/questions/7197574/script-to-kill-all-connections-to-a-database-more-than-restricted-user-rollback?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
Author:			Unknow
*/


With VAS_Summary As (
     Select Size = VAS_Dump.Size,
            Reserved = SUM( Case(Convert(int, VAS_Dump.Base) ^ 0)
                                When 0
                                Then 1
                                Else 0
                            End),
            Free = Sum( Case(Convert(int, VAS_Dump.Base) ^ 0)
                            When 0
                            Then 1
                            Else 0
                        End)
     From (Select   Convert(varbinary, Sum(region_size_in_bytes)) [Size],
                    region_allocation_base_address [Base]
           From     sys.dm_os_virtual_address_dump
           Where    region_allocation_base_address <> 0x0
           Group By region_allocation_base_address
           Union
           Select   CONVERT(varbinary, region_size_in_bytes) [Size],
                    region_allocation_base_address [Base]
           From     sys.dm_os_virtual_address_dump
           Where    region_allocation_base_address = 0x0) As VAS_Dump
           Group By Size)
Select     SUM(convert(bigint, Size)*Free)/1024 As [Memory: Total Avail (KB)],
           CAST(max(size) as bigint)/1024 As [Memory: Max Free (KB)]
From       VAS_Summary
Where      Free <> 0