GEOLYTIX=http://geolytix.co.uk/images/

data/Census11Data.zip:
	mkdir -p $(dir $@) && wget $(GEOLYTIX)/$(notdir $@) -O $@.download && mv $@.download $@
	touch $@

data/OA11LookUp.zip:
	mkdir -p $(dir $@) && wget $(GEOLYTIX)/$(notdir $@) -O $@.download && mv $@.download $@
	touch $@

data/Census11Data.txt: data/Census11Data.zip
	unzip -u $< -d $(dir $@)
	touch $@

data/OA11LookUp.txt: data/OA11LookUp.zip
	unzip -u $< -d $(dir $@)
	touch $@