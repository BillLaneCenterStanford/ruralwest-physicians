use roy;

select * from physician_by_county1909 into outfile '~/Dropbox/west/data/physician_by_county1909.csv';
select * from physician_by_county1980 into outfile '~/Dropbox/west/data/physician_by_county1980.csv';
select * from physician_by_county2000 into outfile '~/Dropbox/west/data/physician_by_county2000.csv';
select * from physician_by_county2009 into outfile '~/Dropbox/west/data/physician_by_county2009.csv';
