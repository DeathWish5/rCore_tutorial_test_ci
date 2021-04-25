RAND := $(shell awk 'BEGIN{srand();printf("%d", 65536*rand())}')

randomize:
	find user/src/bin -name "*.rs" | xargs sed -i 's/OK/OK$(RAND)/g'
	find check -name "*.py" | xargs sed -i 's/OK/OK$(RAND)/g'

test: randomize
	if [ $(CHAPTER) -ge 4 ]; \
	then cp overwrite/build-elf.rs ../os/build.rs; \
	else cp overwrite/build-bin.rs ../os/build.rs; \
	fi
	if [ $(CHAPTER) -le 2 ]; then \
		cp overwrite/Makefile-ch2 ../os/Makefile; \
	elif [ $(CHAPTER) -le 6 ]; then \
		cp overwrite/Makefile-ch3 ../os/Makefile; \
	else \
		cp overwrite/Makefile-ch7 ../os/Makefile; \
	fi
	if [ $(CHAPTER) -eq 7 ]; then \
		cp overwrite/easy-fs-fuse.rs ../easy-fs-fuse/src/main.rs; \
	fi
ifeq ($(CHAPTER), 3)
	make -C user all CHAPTER=3_0
	make -C ../os run | tee stdout-ch3_0
	if [ "$(PYTEST)" = "Y" ];  then  \
		pytest -sv --tb=no --junitxml=test_report_3_1.xml -c check/conftest.py  check/test_output.py  --ch ch3_0 < stdout-ch3_0; \
	else \
		python3 check/ch3_0.py < stdout-ch3_0; \
	fi	

	make -C user all CHAPTER=3_1
	make -C ../os run | tee stdout-ch3_1
	if [ "$(PYTEST)" = "Y" ];  then  \
		pytest -sv --tb=no --junitxml=test_report_3_1.xml -c check/conftest.py  check/test_output_str.py  --ch ch3_1 < stdout-ch3_1; \
	else \
		python3 check/ch3_1.py < stdout-ch3_1; \
	fi

	make -C user all CHAPTER=3_2
	make -C ../os run | tee stdout-ch3_2
	if [ "$(PYTEST)" = "Y" ];  then  \
		pytest -sv --tb=no --junitxml=test_report_3_2.xml -c check/conftest.py  check/test_output.py  --ch ch3_2 < stdout-ch3_2 \
	else \
		python3 check/ch3_2.py < stdout-ch3_2; \
	fi
	
else
	make -C user all CHAPTER=$(CHAPTER)
	make -C ../os run | tee stdout-ch$(CHAPTER)
	if [ "$(PYTEST)" = "Y" ];  then  \
		pytest -sv --tb=no --junitxml=test_report.xml -c check/conftest.py  check/test_output.py  --ch ch$(CHAPTER) < stdout-ch$(CHAPTER); \
	else \
		python3 check/ch$(CHAPTER).py < stdout-ch$(CHAPTER); \
	fi
endif

.PHONY: test randomize
