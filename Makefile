.PHONY: all comp_rtl comp_tb elab run clean

all: comp_rtl comp_tb elab run

comp_rtl:
	@echo "--> Kompilacja RTL..."
	xvlog -work lib_rtl -sv -f rtl.f > comp_rtl.log 2>&1
comp_tb:
	@echo "--> Kompilacja TB..."
	xvlog -work lib_tb -sv -f tb.f > comp_tb.log 2>&1
elab:
	@echo "--> Elaboracja..."
	xelab -debug typical -L lib_rtl -L lib_tb lib_tb.top -s moja_symulacja > elab.log 2>&1
run:
	@echo "--> Symulacja (uruchamianie)..."
	xsim moja_symulacja -R > sim.log 2>&1
clean:
	@echo "--> Czyszczenie plikow tymczasowych..."
	rm -rf xsim.dir *.log *.jou *.pb .Xil
