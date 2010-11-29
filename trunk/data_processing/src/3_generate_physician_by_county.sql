use roy;

/*create table physician_by_county1980 (fips varchar(5), county varchar(50), numphys int, numpop int, state varchar(20));*/

delete from physician_by_county1980;
/* the numpop right now is fake */
insert into physician_by_county1980 (fips, county, numphys, numpop, state) select processed_1980.fips, us_fips.county, processed_1980.numphys, 100000, us_fips.state from processed_1980, us_fips where processed_1980.fips=us_fips.fips;


/*create table physician_by_county2000 (fips varchar(5), county varchar(50), numphys int, numpop int, state varchar(20));*/

delete from physician_by_county2000;
/* the numpop right now is fake */
insert into physician_by_county2000 (fips, county, numphys, numpop, state) select processed_2000.fips, us_fips.county, processed_2000.numphys, 100000, us_fips.state from processed_2000, us_fips where processed_2000.fips=us_fips.fips;


/*create table physician_by_county2009 (fips varchar(5), county varchar(50), numphys int, numpop int, state varchar(20));*/

delete from physician_by_county2009;
/* the numpop right now is fake */
insert into physician_by_county2009 (fips, county, numphys, numpop, state) select processed_2009.fips, us_fips.county, processed_2009.numphys, 100000, us_fips.state from processed_2009, us_fips where processed_2009.fips=us_fips.fips;

