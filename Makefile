WAVE ?= 0
COV  ?= 0
V    ?= UVM_LOW 

ifeq ($(COV), 1)
    XVLOG_COV_FLAG = -d COV_ENABLE
else
    XVLOG_COV_FLAG = 
endif

TEST ?= myprefix_base_test

XELAB_ARGS = -debug typical -timescale 1ns/ps -L uvm -L lib_rtl -L lib_tb lib_tb.top -s moja_symulacja

ifeq ($(COV), 1)
	XELAB_ARGS += -cc_type sbct -cov_db_name my_cov -cov_db_dir ./cov
endif

.PHONY: all comp_rtl comp_tb elab run clean cov_report

all: comp_rtl comp_tb elab run

comp_rtl:
	@echo "--> Kompilacja RTL..."
	xvlog -work lib_rtl -sv -f rtl.f > comp_rtl.log 2>&1

comp_tb:
	@echo "--> Kompilacja TB..."
	xvlog $(XVLOG_COV_FLAG) -work lib_tb -sv -L uvm -f tb.f > comp_tb.log 2>&1

elab:
	@echo "--> Elaboracja..."
	xelab $(XELAB_ARGS) > elab.log 2>&1

run:
	@echo "--> Symulacja (uruchamianie)..."
ifeq ($(WAVE), 1)
	xsim moja_symulacja -gui -testplusarg UVM_VERBOSITY=$(V) -testplusarg UVM_TESTNAME=$(TEST)
else
	xsim moja_symulacja -R -testplusarg UVM_VERBOSITY=$(V) -testplusarg UVM_TESTNAME=$(TEST) > sim.log 2>&1
endif

clean:
	@echo "--> Czyszczenie plikow tymczasowych..."
	rm -rf xsim.dir *.log *.jou *.pb .Xil *.wdb cov/
sanity_check:
	@echo "--> Uruchamianie Sanity Check..."
	@# Odczytujemy test z pliku i odpalamy go z COV=0 (wymóg 3.d)
	@TEST_NAME=$$(cat sanity.txt); make TEST=$$TEST_NAME COV=0
regression:
	@echo "--> Uruchamianie pelnej regresji..."
	@rm -rf merged_covdb cov_report
	@mkdir -p merged_covdb
	@while read -r test_name runs; do \
		if [ -z "$$test_name" ]; then continue; fi; \
		if [ -z "$$runs" ]; then runs=1; fi; \
		for i in $$(seq 1 $$runs); do \
			echo "========================================"; \
			echo ">>> Uruchamiam test: $$test_name (Iteracja $$i z $$runs) <<<"; \
			echo "========================================"; \
			make TEST=$$test_name COV=$(COV); \
			if [ "$(COV)" = "1" ]; then \
				cp -r cov/xsim.covdb merged_covdb/$${test_name}_run_$${i}; \
			fi; \
		done; \
	done < regression.txt

cov_report:
	@echo "--> Generowanie zmergowanego raportu HTML..."
	@xcrg_args=""; \
	for dir in merged_covdb/*; do \
		xcrg_args="$$xcrg_args -dir $$dir"; \
	done; \
	xcrg $$xcrg_args -report_dir cov_report -report_format html
