GEOLYTIX=http://geolytix.co.uk/images/

AREACODES = MSOACode LSOACode LADCode WardCode SecLGCode FmCntyCode PCOCode SHACode ConstCode RegionCode

all: $(addprefix data/Census11_by_, $(addsuffix .csv, $(AREACODES)))

# Look up table is missing MSOA codes for some Northern Ireland OAs
#
# [N00000001 N00000002 N00000003 ..., N00004535 N00004536 N00004537] /No MSOA codes

# What is ConstCode RegionCode

clean: rm -rf data log

data/%.zip:
	mkdir -p $(dir $@) && wget $(GEOLYTIX)/$(notdir $@) -O $@.download && mv $@.download $@
	touch $@

data/%.txt: data/%.zip
	unzip -u $< -d $(dir $@)
	touch $@

# Currently 583 seconds, 35643 LSOAs; 124 seconds, 7202 MSOAs; 20 seconds, 374 LADCode
data/Census11_by_%.csv: data/OA11LookUp.txt data/Census11Data.txt census_to_lsoa.py
	mkdir -p $(dir $@)
	mkdir -p log
	time python census_to_lsoa.py $*