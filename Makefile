WAVE ?= 0
COV  ?= 0
V    ?= UVM_LOW 
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
	xvlog -work lib_tb -sv -L uvm -f tb.f > comp_tb.log 2>&1

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

cov_report:
	@echo "--> Generowanie raportu Code Coverage w cov/report..."
	xcrg -cov_db_dir ./cov -cov_db_name my_cov -report_dir ./cov/report

clean:
	@echo "--> Czyszczenie plikow tymczasowych..."
	rm -rf xsim.dir *.log *.jou *.pb .Xil *.wdb cov/
