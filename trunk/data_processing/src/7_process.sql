use roy;

/*
update utah_by_zip_final set aprn = (select utah_by_zip.freq from utah_by_zip where utah_by_zip_final.zip=utah_by_zip.zip and utah_by_zip_final.year=utah_by_zip.year and type='APRN');

update utah_by_zip_final set pa = (select utah_by_zip.freq from utah_by_zip where utah_by_zip_final.zip=utah_by_zip.zip and utah_by_zip_final.year=utah_by_zip.year and type='PA');

update utah_by_zip_final set ph = (select utah_by_zip.freq from utah_by_zip where utah_by_zip_final.zip=utah_by_zip.zip and utah_by_zip_final.year=utah_by_zip.year and type='PH');
*/

select * from utah_by_zip_final where year=1998 into outfile '~/Documents/Adobe Flash Builder 4/west/data/utah_by_zip_1998.csv' fields terminated by ',';

select * from utah_by_zip_final where year=2003 into outfile '~/Documents/Adobe Flash Builder 4/west/data/utah_by_zip_2003.csv' fields terminated by ',';

