use roy;

update physician_by_county1909 set numpop=(select census_1909.totalpop from census_1909 where census_1909.fips=physician_by_county1909.fips);
update physician_by_county1980 set numpop=(select census_1980.totalpop from census_1980 where census_1980.fips=physician_by_county1980.fips);
update physician_by_county2000 set numpop=(select census_2000.totalpop from census_2000 where census_2000.fips=physician_by_county2000.fips);
update physician_by_county2009 set numpop=(select census_2009.totalpop from census_2009 where census_2009.fips=physician_by_county2009.fips);

