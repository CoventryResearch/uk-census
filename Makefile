GEOLYTIX=http://geolytix.co.uk/images/

data/Census11Data.zip:
	mkdir -p $(dir $@) && wget $(GEOLYTIX)/$(notdir $@) -O $@.download && mv $@.download $@
	touch $@

data/Census11Data.txt: data/Census11Data.zip
	unzip $< -d $(dir $@)
	touch $@