GEOLYTIX=http://geolytix.co.uk/images/

# Area codes are documented here: http://geolytix.co.uk/images/PDFs/GeoData-Census2011UG.pdf
#                                 http://geolytix.co.uk/images/PDFs/GD2011CensusUG_UK.pdf
AREACODES = LSOACode MSOACode LADCode WardCode PCOCode SHACode RegionCode
#SecLGCode FmCntyCode ConstCode


all: $(addprefix data/Census11_by_, $(addsuffix .csv, $(AREACODES)))

clean:
	rm -rf data log

data/%.zip:
	mkdir -p $(dir $@) && wget $(GEOLYTIX)/$(notdir $@) -O $@.download && mv $@.download $@
	touch $@

data/%.txt: data/%.zip
	unzip -u $< -d $(dir $@)
	touch $@

# Currently 583 seconds, 35643 LSOAs; 124 seconds, 7202 MSOAs; 20 seconds, 374 LADCode
data/Census11_by_%.csv: data/OA11Lookup.txt data/CensusUK11Data.txt
	mkdir -p $(dir $@)
	mkdir -p log
	time python census_to_lsoa.py $* $^